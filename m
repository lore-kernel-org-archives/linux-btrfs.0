Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:51512 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965004AbaDJRHk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Apr 2014 13:07:40 -0400
Date: Thu, 10 Apr 2014 10:07:34 -0700
From: Marc MERLIN <marc@merlins.org>
To: Martin <m_btrfs@ml1.co.uk>, Xavier Nicollet <nicollet@jeru.org>
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fb.com>,
        Chris Mason <clm@fb.com>
Subject: Re: How to debug very very slow file delete? (btrfs on md-raid5 with many files, 70GB metadata)
Message-ID: <20140410170734.GZ10789@merlins.org>
References: <20140325135756.GA14382@jeru.org> <lgrrtf$el3$1@ger.gmane.org> <20140325164142.GN12833@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20140325164142.GN12833@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So, since then I found out in the thread
Subject: Re: btrfs on 3.14rc5 stuck on "btrfs_tree_read_lock           sync"
that my btrfs filesystem has a clear problem, which Josef and Chris are
still looking into.

Basically, I've had btrfs near deadlocks on this filesystem:
INFO: task btrfs-transacti:3633 blocked for more than 120 seconds.
Not tainted 3.14.0-rc5-amd64-i915-preempt-20140216c #1
INFO: task btrfs-cleaner:3571 blocked for more than 120 seconds.
Not tainted 3.14.0-amd64-i915-preempt-20140216 #2

They are thinking it's due to a balancing issue that 3.15 might fix.

One interesting piece of information I found out since yesterday is that now
that I mounted the filesystem with -o ro,recovery , its speed as improved
very noticeably.
I'm currently copying my data off it about 10x faster.



What follows is for people interested in optimization.

I have swraid5 with dmcrypt on top, and then btrfs.
http://superuser.com/questions/305716/bad-performance-with-linux-software-raid5-and-luks-encryption
says:
"LUKS has a botleneck, that is it just spawns one thread per block device.

Are you placing the encryption on top of the RAID 5? Then from the point of
view of your OS you just have one device, then it is using just one thread
for all those disks, meaning disks are working in a serial way rather than
parallel."
but it was disputed in a reply.
Does someone know if this is still valid/correct in 3.14?


Since I'm going to recreate the filesystem considering the troubles I've had
with it, I might as well do it better this time :)
(but doing the copy back will take days, so I'd rather get it right the first time)

How would you recommend I create the array when I rebuild it?

This filesystem contains may backup with many files, most small, and ideally
identical stuff is hardlinked together (many files, many hardlinks)
gargamel:~# btrfs fi df /mnt/btrfs_pool2
Data, single: total=3.28TiB, used=2.29TiB
System, DUP: total=8.00MiB, used=384.00KiB
System, single: total=4.00MiB, used=0.00
Metadata, DUP: total=74.50GiB, used=70.11GiB  <<< muchos metadata
Metadata, single: total=8.00MiB, used=0.00

This is my current array:
gargamel:~# mdadm --detail /dev/md8
/dev/md8:
        Version : 1.2
  Creation Time : Thu Mar 25 20:15:00 2010
     Raid Level : raid5
     Array Size : 7814045696 (7452.05 GiB 8001.58 GB)
  Used Dev Size : 1953511424 (1863.01 GiB 2000.40 GB)
    Persistence : Superblock is persistent
  Intent Bitmap : Internal
         Layout : left-symmetric
     Chunk Size : 512K

#1 move the intent bitmap to another device. I have /boot on swraid1 with
   ext4, so I'll likely use this.
#2 change chunk size to something smaller? 128K better?
#3 anything else?

Then, I used this for dmcrypt:
cryptsetup luksFormat --align-payload=8192 -s 256 -c aes-xts-plain64  

The align-payload was good for my SSD, but probably not for a hard drive.
http://wiki.drewhess.com/wiki/Creating_an_encrypted_filesystem_on_a_partition
says
"To calculate this value, multiply your RAID chunk size in bytes by the
number of data disks in the array (N/2 for RAID 1, N-1 for RAID 5 and N-2
for RAID 6), and divide by 512 bytes per sector."

So 512K * 4 / 512 = 4K
In other words, I can do align-payload=4096 for a small reduction of write
amplification, or =1024 if I change my raid chunk size to 128K

Correct?

But from what I can see, those will only be small improvements compared to the 
btrfs performance I've seen which hopefully 3.15 will address in some way.

Other bits I found that can maybe help others:
http://superuser.com/questions/305716/bad-performance-with-linux-software-raid5-and-luks-encryption

This seems to help work around the write amplification a bit:
for i in /sys/block/md*/md/stripe_cache_size; do echo 16384 > $i; done

This looks like an easy thing, done.

If you have other suggestions/comments, please share :)

Thanks,
Marc


On Tue, Mar 25, 2014 at 09:41:42AM -0700, Marc MERLIN wrote:
> On Tue, Mar 25, 2014 at 12:13:50PM +0000, Martin wrote:
> > On 25/03/14 01:49, Marc MERLIN wrote:
> > > I had a tree with some amount of thousand files (less than 1 million)
> > > on top of md raid5.
> > > 
> > > It took 18H to rm it in 3 tries:
> 
> I ran another test after typing the original Email:
> gargamel:/mnt/dshelf2/backup/polgara# time du -sh 20140312-feisty/; time find 20140 312-feisty/ | wc -l
> 17G     20140312-feisty/
> real    245m19.491s
> user    0m2.108s
> sys     1m0.508s
> 
> 728507 <- number of files
> real    11m41.853s <- 11mn to restat them when they should all be in cache ideally
> user    0m1.040s
> sys     0m4.360s
> 
> 4 hours to stat 700K files. That's bad...
> Even 11mn to restat them just to count them looks bad too.
> 
> > > I checked that btrfs scrub is not running.
> > > What else can I check from here?
> > 
> > "noatime" set?
> 
> I have relatime
> gargamel:/mnt/dshelf2/backup/polgara# df .
> Filesystem           1K-blocks       Used  Available Use% Mounted on
> /dev/mapper/dshelf2 7814041600 3026472436 4760588292  39% /mnt/dshelf2/backup
> 
> gargamel:/mnt/dshelf2/backup/polgara# grep /mnt/dshelf2/backup /proc/mounts
> /dev/mapper/dshelf2 /mnt/dshelf2/backup btrfs rw,relatime,compress=lzo,space_cache 0 0
>  
> > What's your cpu hardware wait time?
>  
> Sorry, not sure how to get that.
>  
> > And is not *the 512kByte raid chunk* going to give you horrendous write
> > amplification?! For example, rm updates a few bytes in one 4kByte
> > metadata block and the system has to then do a read-modify-write on
> > 512kBytes...
> 
> That's probably not great, but
> 1) rm -rf should bunch a lot of writes together before they start
> hitting the block layer for writes, so I'm not sure that is too much a
> problem with the caching layer in between
> 
> 2) this does not explain 4H to just run du with relatime, which
> shouldn't generate any writing, correct?
> iostat seems to confirm:
> 
> gargamel:~# iostat /dev/md8 1 20
> Linux 3.14.0-rc5-amd64-i915-preempt-20140216c (gargamel.svh.merlins.org)        03/25/2014      _x86_64_        (4 CPU)
> avg-cpu:  %user   %nice %system %iowait  %steal   %idle  
>           75.19    0.00   10.13    8.61    0.00    6.08
> Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
> md8              98.00       392.00         0.00        392          0
> md8              96.00       384.00         0.00        384          0
> md8              83.00       332.00         0.00        332          0
> md8             153.00       612.00         0.00        612          0
> md8              82.00       328.00         0.00        328          0
> md8              55.00       220.00         0.00        220          0
> md8              69.00       276.00         0.00        276          0
> 
> > Also, the 64MByte chunk bit-intent map will add a lot of head seeks to
> > anything you do on that raid. (The map would be better on a separate SSD
> > or other separate drive.)
> 
> That's true for writing, but not reading, right?
>  
> > So... That sort of setup is fine for archived data that is effectively
> > read-only. You'll see poor performance for small writes/changes.
> 
> So I agree with you that the write case can be improved, especially since I also have a layer
> of dmcrypt in the middle
> gargamel:/mnt/dshelf2/backup/polgara# cryptsetup luksDump /dev/md8
> LUKS header information for /dev/md8
> Cipher name:    aes
> Cipher mode:    xts-plain64
> Hash spec:      sha1
> Payload offset: 8192
> 
> (I used cryptsetup luksFormat --align-payload=8192 -s 256 -c aes-xts-plain64)
> 
> I'm still not convinced that a lot of file IO don't get all collated in memory 
> before hitting disk in bigger blocks, but maybe not.
> 
> If I were to recreate this array entirely, what would you use for the raid creation
> and cryptsetup?
> 
> More generally, before I go through all that trouble (it will likely
> take 1 week of data copying back and forth), I'd like to debug why my reads are
> so slow first.
> 
> Thanks,
> Marc
> 
> On Tue, Mar 25, 2014 at 02:57:57PM +0100, Xavier Nicollet wrote:
> > Le 25 mars 2014 à 12:13, Martin a écrit:
> > > On 25/03/14 01:49, Marc MERLIN wrote:
> > > > It took 18H to rm it in 3 tries:
> > 
> > > And is not *the 512kByte raid chunk* going to give you horrendous write
> > > amplification?! For example, rm updates a few bytes in one 4kByte
> > > metadata block and the system has to then do a read-modify-write on
> > > 512kBytes...
> > 
> > My question would be naive, but would it be possible to have a syscall or something to do 
> > a fast "rm -rf" or du ?
> 
> Well, that wouldn't hurt either, even if it wouldn't address my underlying problem.
> 
> Marc
> -- 
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> Microsoft is to operating systems ....
>                                       .... what McDonalds is to gourmet cooking
> Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
