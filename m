From: David Sterba <dave@jikos.cz>
Subject: Re: Errors in rebalancing RAID1 array after disk failure.
Date: Wed, 2 May 2012 17:22:15 +0200
Message-ID: <20120502152215.GF6740@twin.jikos.cz>
References: <CADy=jfVRz5UuKcFkDXC9hwZnP8Z=E9NuF9p3hE6b0ZC06k7DWg@mail.gmail.com>
 <CADy=jfWC1vJs_TWt-EmvAN2Ybqw8kjN2tFV_vgAb-OKeGMpotg@mail.gmail.com>
 <CADy=jfV9pKJurcormuMK7KW54-DKSvYns-Ow-T_FEELGmFQ18Q@mail.gmail.com>
 <20120416134643.GA20982@twin.jikos.cz>
 <CADy=jfVh8ZvyyJTdBBFTVRSnBHka8sNrVUQcEx_ciROdB=pYhQ@mail.gmail.com>
 <CADy=jfW6rrSwPV6WvKVhcRYd67GMvB57ynSZOjPuDUnnssgZYg@mail.gmail.com>
 <CADy=jfV93jMa7DpN_tmQLQ9gOCjqOLgyDxv8=5tCMxr-b-m1QA@mail.gmail.com>
 <CADy=jfULQNamqJFqE_=KPGvdU8WqgQ0p1gk2_12Et9wUVmDn=A@mail.gmail.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dave@jikos.cz, linux-btrfs@vger.kernel.org
To: "Marco L. Crociani" <marco.crociani@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CADy=jfULQNamqJFqE_=KPGvdU8WqgQ0p1gk2_12Et9wUVmDn=A@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 30, 2012 at 03:01:04PM +0200, Marco L. Crociani wrote:
> ./btrfs device delete missing /mnt/sda3
> ERROR: error removing the device 'missing' - Input/output error
> 
> 
> Apr 30 13:17:57 evo kernel: [  108.866205] btrfs: allowing degraded mounts
> Apr 30 13:17:57 evo kernel: [  108.866214] btrfs: disk space caching is enabled
> Apr 30 13:18:32 evo kernel: [  143.274899] btrfs: relocating block
> group 1401002393600 flags 17
> Apr 30 13:19:25 evo kernel: [  196.888248] btrfs csum failed ino 257
> off 910946304 csum 432355644 private 175165154
> Apr 30 13:19:25 evo kernel: [  196.889900] btrfs csum failed ino 257
> off 910946304 csum 432355644 private 175165154
> Apr 30 13:19:25 evo kernel: [  196.890429] btrfs csum failed ino 257
> off 910946304 csum 432355644 private 175165154
> Apr 30 13:19:25 evo kernel: [  197.087419] btrfs csum failed ino 257
> off 910946304 csum 432355644 private 175165154
> Apr 30 13:19:25 evo kernel: [  197.087681] btrfs csum failed ino 257
> off 910946304 csum 432355644 private 175165154

the failed checksums prevent to remove the data from the device and then
removing fails with the above error.

> ./btrfs inspect-internal inode-resolve -v 257 /mnt/sda3/
> ioctl ret=-1, error: No such file or directory

So it's not a visible file, possibly a deleted yet uncleaned snapshot or
the space_cache (guessing from the inode number). But AFAICS the
checksums are turned off for the free space inode so ...

> ./btrfs scrub status /mnt/sda3/
> scrub status for c87975a0-a575-405e-9890-d3f7f25bbd96
> 	scrub started at Mon Apr 30 13:26:26 2012 and was aborted after 4367 seconds
> 	total bytes scrubbed: 406.64GB with 2 errors
> 	error details: csum=2
> 	corrected errors: 0, uncorrectable errors: 0, unverified errors: 0

Shouldn't the csum errors be included under uncorrectable?

> Apr 30 14:37:24 evo kernel: [ 4875.275776] btrfs: checksum error at
> logical 752871157760 on dev /dev/sda3, sector 873795352, root 259,
> inode 1580389, offset 612610048, length 4096, links 1 (path:
        ^^^^^^^

so the scrub catches different checksum errors than appeared during
balance (inode 257).

> Apr 30 14:37:24 evo kernel: [ 4875.275838] BUG: unable to handle kernel NULL pointer dereference at 0000000000000090
> Apr 30 14:37:24 evo kernel: [ 4875.275848] IP: [<ffffffff811ae841>]  bio_add_page+0x11/0x60
> Apr 30 14:37:24 evo kernel: [ 4875.276022] RIP:
> 0010:[<ffffffff811ae841>]  [<ffffffff811ae841>] bio_add_page+0x11/0x60

this looks like something disappeared under hands of scrub

1045                 BUG_ON(!page->page);
1046                 bio = bio_alloc(GFP_NOFS, 1);
1047                 if (!bio)
1048                         return -EIO;
1049                 bio->bi_bdev = page->bdev;
1050                 bio->bi_sector = page->physical >> 9;
1051                 bio->bi_end_io = scrub_complete_bio_end_io;
1052                 bio->bi_private = &complete;

1054                 ret = bio_add_page(bio, page->page, PAGE_SIZE, 0);
1055                 if (PAGE_SIZE != ret) {
1056                         bio_put(bio);
1057                         return -EIO;
1058                 }

everything is initialized before use here, so it's hidden behind the
pointers, my bet is at page->bdev->something . Thinking again how things
got here:

* unsuccesful device remove 'missing', due to csum errors in a
  non-regular file
* crashed scrub, after inidirect access of a null pointer

Is there anything I missed for steps to reproduce it?


david
