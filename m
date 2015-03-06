Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50969 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754737AbbCFPqS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 6 Mar 2015 10:46:18 -0500
Message-ID: <54F9CBBD.9080206@redhat.com>
Date: Fri, 06 Mar 2015 09:46:05 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Omar Sandoval <osandov@osandov.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.cz>
CC: bo.li.liu@oracle.com, Eryu Guan <guaneryu@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: btrfs oops while mounting fuzzed btrfs image
References: <20150305070933.GB17015@dhcp-13-216.nay.redhat.com> <20150305094611.GA4147@localhost.localdomain> <20150305101354.GC17015@dhcp-13-216.nay.redhat.com> <20150305102701.GE4147@localhost.localdomain> <54F90937.70309@cn.fujitsu.com> <20150306100113.GA26485@mew>
In-Reply-To: <20150306100113.GA26485@mew>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 3/6/15 4:01 AM, Omar Sandoval wrote:

> Hi, Qu,
> 
> I'm not seeing that in the code I'm looking at :( In fsfuzz:447, I see
> the mangle executable called with an offset starting at 0, which would
> mean that the superblock isn't safe. 

(Semi-wild guess follows):

He may be using a hacked version of mangle which I had been using for
btrfsck testing; I had neutered it a lot because if I let it hit the front
of the filesystem, there was no hope at all for the repair, ever.

Qu, if you're using it for fsck testing, I'd eventually make the mangling
more severe, and go back to the upstream version of mangle.c.

(I keep meaning to make mangle.c and fsfuzzer in general more flexible
and useful, but for now I just have local hacks, sorry).

-Eric

> (Btw, that line also indicates that
> we potentially write to the entire file system image, not just the
> beginning. My understanding from mangle.c is that up to 10% of the file
> contents are modified, not the first 10% of the file by length. Someone
> please correct me if I'm wrong!).
> 
> Indeed, Eryu's dmesg shows:
> 
> [  309.384037] BTRFS: super block crcs don't match, older mkfs detected
> 
> This commit is relevant:
> 
> ----
> commit 667e7d94a1683661cff5fe9a0fa0d7f8fdd2c007
> Author: Chris Mason <chris.mason@fusionio.com>
> Date:   Tue May 7 11:00:13 2013 -0400
> 
>     Btrfs: allow superblock mismatch from older mkfs
>     
>     We've added new checks to make sure the super block crc is correct
>     during mount.  A fresh filesystem from an older mkfs won't have the
>     crc set.  This adds a warning when it finds a newly created filesystem
>     but doesn't fail the mount.
>     
>     Signed-off-by: Chris Mason <chris.mason@fusionio.com>
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index bc423f7e..4e9ebe1 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -383,6 +383,11 @@ static int btrfs_check_super_csum(char *raw_disk_sb)
>  
>  		if (memcmp(raw_disk_sb, result, csum_size))
>  			ret = 1;
> +
> +		if (ret && btrfs_super_generation(disk_sb) < 10) {
> +			printk(KERN_WARNING "btrfs: super block crcs don't match, older mkfs detected\n");
> +			ret = 0;
> +		}
>  	}
>  
>  	if (csum_type >= ARRAY_SIZE(btrfs_csum_sizes)) {
> ----
> 
> So, it looks like the super block is corrupted, but we ignore it because
> this is a fresh filesystem. I can easily trigger a related panic with
> this:
> 
> ----
> while true; do
> 	dd if=/dev/urandom of=btrfs.img bs=1M count=16
> 	mkfs.btrfs btrfs.img
> 	dd if=/dev/urandom of=btrfs.img bs=1 seek=$((64 * 1024 + 88)) count=8 conv=notrunc
> 	mount -o loop btrfs.img /mnt && umount /mnt
> done
> ----
> 
> I'm not sure that this is exactly what's happening with Eryu's image,
> but it's definitely an issue. I also don't know whether it's safe to get
> rid of that special case. It looks like it's needed for btrfs-progs
> before v3.12 (November 2013). Chris? David?
> 
> Thanks!
> 

