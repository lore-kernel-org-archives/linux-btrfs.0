Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:42534 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbaCSGJE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Mar 2014 02:09:04 -0400
Date: Tue, 18 Mar 2014 23:09:02 -0700
From: Marc MERLIN <marc@merlins.org>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: How to handle a RAID5 arrawy with a failing drive? -> raid5 mostly works, just no rebuilds
Message-ID: <20140319060902.GM6143@merlins.org>
References: <1394983430-20440-1-git-send-email-fdmanana@gmail.com> <1395002246-3840-1-git-send-email-fdmanana@gmail.com> <20140316222026.GU16946@merlins.org> <pan$2239d$446ec5c7$d67506b7$f25a7c65@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$2239d$446ec5c7$d67506b7$f25a7c65@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 18, 2014 at 09:02:07AM +0000, Duncan wrote:
> First just a note that you hijacked Mr Manana's patch thread.  Replying 
(...)
I did, I use mutt, I know about in Reply-To, I was tired, I screwed up,
sorry, and there was no undo :)

> Since you don't have to worry about the data I'd suggest blowing it away 
> and starting over.  Btrfs raid5/6 code is known to be incomplete at this 
> point, to work in normal mode and write everything out, but with 
> incomplete recovery code.  So I'd treat it like the raid-0 mode it 
> effectively is, and consider it lost if a device drops.
>
> Which I haven't.  My use-case wouldn't be looking at raid5/6 (or raid0) 
> anyway, but even if it were, I'd not touch the current code unless it 
> /was/ just for something I'd consider risking on a raid0.  Other than 

Thank you for the warning, and yes I know the risk and the data I'm putting
on it is ok with that risk :)

So, I was bit quiet because I diagnosed problems with the underlying
hardware.
My disk array was creating disk faults due to insufficient power coming in.

Now that I fixed that and made sure the drives work with a full run of
hdrecover of all the drives in parallel (exercises the drives while making
sure all their blocks work), I did tests again:

Summary:
1) You can grow and shrink a raid5 volume while it's mounted => very cool
2) shrinking causes a rebalance
3) growing requires you to run rebalance
4) btrfs cannot replace a drive in raid5, whether it's there or not
   that's the biggest thing missing: just no rebuilds in any way
5) you can mount a raid5 with a missing device with -o degraded
6) adding a drive to a degraded arrays will grow the array, not rebuild
   the missing bits
7) you can remove a drive from an array, add files, and then if you plug
   the drive in, it apparently gets auto sucked in back in the array.
There is no rebuild that happens, you now have an inconsistent array where
one drive is not at the same level than the other ones (I lost all files I added 
after the drive was removed when I added the drive back).

In other words, everything seems to work except there is no rebuild that I could 
see anywhere.

Here are all the details:

Creation
> polgara:/dev/disk/by-id# mkfs.btrfs -f -d raid5 -m raid5 -L backupcopy /dev/mapper/crypt_sd[bdfghijkl]1
> 
> WARNING! - Btrfs v3.12 IS EXPERIMENTAL
> WARNING! - see http://btrfs.wiki.kernel.org before using
> 
> Turning ON incompat feature 'extref': increased hardlink limit per file to 65536
> Turning ON incompat feature 'raid56': raid56 extended format
> adding device /dev/mapper/crypt_sdd1 id 2
> adding device /dev/mapper/crypt_sdf1 id 3
> adding device /dev/mapper/crypt_sdg1 id 4
> adding device /dev/mapper/crypt_sdh1 id 5
> adding device /dev/mapper/crypt_sdi1 id 6
> adding device /dev/mapper/crypt_sdj1 id 7
> adding device /dev/mapper/crypt_sdk1 id 8
> adding device /dev/mapper/crypt_sdl1 id 9
> fs created label backupcopy on /dev/mapper/crypt_sdb1
>         nodesize 16384 leafsize 16384 sectorsize 4096 size 4.09TiB
> polgara:/dev/disk/by-id# mount -L backupcopy /mnt/btrfs_backupcopy/
> polgara:/mnt/btrfs_backupcopy# df -h .
> Filesystem              Size  Used Avail Use% Mounted on
> /dev/mapper/crypt_sdb1  4.1T  3.0M  4.1T   1% /mnt/btrfs_backupcopy

Let's add one drive
> polgara:/mnt/btrfs_backupcopy# btrfs device add -f /dev/mapper/crypt_sdm1 /mnt/btrfs_backupcopy/
> polgara:/mnt/btrfs_backupcopy# df -h .
> Filesystem              Size  Used Avail Use% Mounted on
> /dev/mapper/crypt_sdb1  4.6T  3.0M  4.6T   1% /mnt/btrfs_backupcopy

Oh look it's bigger now. We need to manual rebalance to use the new drive:
> polgara:/mnt/btrfs_backupcopy# btrfs balance start . 
> Done, had to relocate 6 out of 6 chunks
> 
> polgara:/mnt/btrfs_backupcopy#  btrfs device delete /dev/mapper/crypt_sdm1 .
> BTRFS info (device dm-9): relocating block group 23314563072 flags 130
> BTRFS info (device dm-9): relocating block group 22106603520 flags 132
> BTRFS info (device dm-9): found 6 extents
> BTRFS info (device dm-9): relocating block group 12442927104 flags 129
> BTRFS info (device dm-9): found 1 extents
> polgara:/mnt/btrfs_backupcopy# df -h .
> Filesystem              Size  Used Avail Use% Mounted on
> /dev/mapper/crypt_sdb1  4.1T  4.7M  4.1T   1% /mnt/btrfs_backupcopy

Ah, it's smaller again. Note that it's not degraded, you can just keep removing drives
and it'll do a force reblance to fit the data in the remaining drives.

Ok, I've unounted the filesystem, and will manually remove a device:
> polgara:~# dmsetup remove crypt_sdl1
> polgara:~# mount -L backupcopy /mnt/btrfs_backupcopy/
> mount: wrong fs type, bad option, bad superblock on /dev/mapper/crypt_sdk1,
>        missing codepage or helper program, or other error
>        In some cases useful info is found in syslog - try
>        dmesg | tail  or so
> BTRFS: open /dev/dm-9 failed
> BTRFS info (device dm-7): disk space caching is enabled
> BTRFS: failed to read chunk tree on dm-7
> BTRFS: open_ctree failed

So a normal mount fails. You have to mount with -o degraded to acknowledge this.
> polgara:~# mount -o degraded -L backupcopy /mnt/btrfs_backupcopy/
> BTRFS: device label backupcopy devid 8 transid 50 /dev/mapper/crypt_sdk1
> BTRFS: open /dev/dm-9 failed
> BTRFS info (device dm-7): allowing degraded mounts
> BTRFS info (device dm-7): disk space caching is enabled
 
Re-adding a device that was missing:
> polgara:/mnt/btrfs_backupcopy# cryptsetup luksOpen /dev/sdl1 crypt_sdl1
> Enter passphrase for /dev/sdl1: 
> polgara:/mnt/btrfs_backupcopy# df -h .
> Filesystem              Size  Used Avail Use% Mounted on
> /dev/mapper/crypt_sdb1  4.1T  2.5M  3.7T   1% /mnt/btrfs_backupcopy
> polgara:/mnt/btrfs_backupcopy# btrfs device add -f /dev/mapper/crypt_sdl1 /mnt/btrfs_backupcopy/
> /dev/mapper/crypt_sdl1 is mounted
> BTRFS: device label backupcopy devid 9 transid 50 /dev/dm-9
> BTRFS: device label backupcopy devid 9 transid 50 /dev/dm-9
=> waoh, btrfs noticed that the device came back and knew it was its own, so it slurped it right away
(I was not able to add the device because it already was auto-added)

Adding another device does grow the size which adding sdl1 did not:
> polgara:/mnt/btrfs_backupcopy# btrfs device add -f /dev/mapper/crypt_sdm1 /mnt/btrfs_backupcopy/
> polgara:/mnt/btrfs_backupcopy# df -h .
> Filesystem              Size  Used Avail Use% Mounted on
> /dev/mapper/crypt_sdb1  4.6T  2.5M  4.1T   1% /mnt/btrfs_backupcopy

Ok, harder, let's pull a drive now. Strangely btrfs doesn't notice right away but logs this eventually:
BTRFS: bdev /dev/dm-6 errs: wr 0, rd 0, flush 1, corrupt 0, gen 0
BTRFS: lost page write due to I/O error on /dev/dm-6
BTRFS: bdev /dev/dm-6 errs: wr 1, rd 0, flush 1, corrupt 0, gen 0
BTRFS: lost page write due to I/O error on /dev/dm-6
BTRFS: bdev /dev/dm-6 errs: wr 2, rd 0, flush 1, corrupt 0, gen 0
BTRFS: lost page write due to I/O error on /dev/dm-6
BTRFS: bdev /dev/dm-6 errs: wr 3, rd 0, flush 1, corrupt 0, gen 0

>From what I can tell, it buffers the writes to the missing drive and retries them in the background.
Technically it is in degraded mode, but it doesn't seem to think so.

This is where it now fails, I cannot remove the bad drive from the array:
polgara:/mnt/btrfs_backupcopy# btrfs device delete /dev/mapper/crypt_sdj1 .
ERROR: error removing the device '/dev/mapper/crypt_sdj1' - Invalid argument

Drive replace is not yet implemented:
> polgara:/mnt/btrfs_backupcopy# btrfs replace start -r /dev/mapper/crypt_sdj1 /dev/mapper/crypt_sde1  .
> quiet_error: 138 callbacks suppressed
> Buffer I/O error on device dm-6, logical block 122095344
> Buffer I/O error on device dm-6, logical block 122095364
> Buffer I/O error on device dm-6, logical block 0
> Buffer I/O error on device dm-6, logical block 1
> Buffer I/O error on device dm-6, logical block 122095365
> Buffer I/O error on device dm-6, logical block 122095365
> Buffer I/O error on device dm-6, logical block 122095365
> Buffer I/O error on device dm-6, logical block 122095365
> Buffer I/O error on device dm-6, logical block 122095365
> Buffer I/O error on device dm-6, logical block 122095365
> BTRFS warning (device dm-8): dev_replace cannot yet handle RAID5/RAID6

Adding a device at this point will not help because the filesystem is not in degraded mode, btrfs is still
kind of hoping that dm-6 (aka crypt_sdj1) will come back. So if I add a device, it would just grow the raid.

Let mount the array in degraded mode:
> polgara:~# mount -v -t btrfs -o compress=zlib,space_cache,noatime,degraded LABEL=backupcopy /mnt/btrfs_backupcopy 
> polgara:~# btrfs fi show
> Label: backupcopy  uuid: 5ccda389-748b-419c-bfa9-c14c4136e1c4
>         Total devices 10 FS bytes used 680.05MiB
>         devid    1 size 465.76GiB used 1.14GiB path /dev/mapper/crypt_sdb1
>         devid    2 size 465.76GiB used 1.14GiB path /dev/dm-1
>         devid    3 size 465.75GiB used 1.14GiB path /dev/dm-2
>         devid    4 size 465.76GiB used 1.14GiB path /dev/dm-3
>         devid    5 size 465.76GiB used 1.14GiB path /dev/dm-4
>         devid    6 size 465.76GiB used 1.14GiB path /dev/dm-5
>         devid    7 size 465.76GiB used 1.14GiB path /dev/dm-6
>         devid    8 size 465.76GiB used 1.14GiB path /dev/mapper/crypt_sdk1
>         devid    9 size 465.76GiB used 1.14GiB path /dev/mapper/crypt_sdl1
>         devid    10 size 465.76GiB used 1.14GiB path /dev/mapper/crypt_sdm1
>
> quiet_error: 250 callbacks suppressed
> Buffer I/O error on device dm-6, logical block 122095344
> Buffer I/O error on device dm-6, logical block 122095344
> Buffer I/O error on device dm-6, logical block 122095364
> Buffer I/O error on device dm-6, logical block 122095364
> Buffer I/O error on device dm-6, logical block 0
> Buffer I/O error on device dm-6, logical block 0
> Buffer I/O error on device dm-6, logical block 1
> Buffer I/O error on device dm-6, logical block 122095365
> Buffer I/O error on device dm-6, logical block 122095365
> Buffer I/O error on device dm-6, logical block 122095365

Even though it cannot access dm-6, it still included it in the mount because the device node still exists.

Adding a device does not help, it just grew the array in degraded mode:
polgara:/mnt/btrfs_backupcopy# btrfs device add /dev/mapper/crypt_sde1  .
polgara:/mnt/btrfs_backupcopy# df -h .
Filesystem              Size  Used Avail Use% Mounted on
/dev/mapper/crypt_sdb1  5.1T  681M  4.6T   1% /mnt/btrfs_backupcopy

Balance is not happy:
polgara:/mnt/btrfs_backupcopy# btrfs balance start . 
> BTRFS info (device dm-8): relocating block group 63026233344 flags 129
> BTRFS info (device dm-8): csum failed ino 257 off 917504 csum 1017609526 expected csum 4264281942
> BTRFS info (device dm-8): csum failed ino 257 off 966656 csum 389256117 expected csum 2901202041
> BTRFS info (device dm-8): csum failed ino 257 off 970752 csum 4107355973 expected csum 3954832285
> BTRFS info (device dm-8): csum failed ino 257 off 974848 csum 1121660380 expected csum 2872112983
> BTRFS info (device dm-8): csum failed ino 257 off 978944 csum 2032023730 expected csum 2250478230
> BTRFS info (device dm-8): csum failed ino 257 off 933888 csum 297434258 expected csum 3687027701
> BTRFS info (device dm-8): csum failed ino 257 off 937984 csum 1176910550 expected csum 3400460732
> BTRFS info (device dm-8): csum failed ino 257 off 942080 csum 366743485 expected csum 2321497660
> BTRFS info (device dm-8): csum failed ino 257 off 946176 csum 1849642521 expected csum 931611495
> BTRFS info (device dm-8): csum failed ino 257 off 921600 csum 1075941372 expected csum 2126420528
ERROR: error during balancing '.' - Input/output error

This looks bad, but my filesystem didn't look corrupted after that.

I am not allowed to remove the new device I just added:
polgara:~# btrfs device delete /dev/mapper/crypt_sde1  .
ERROR: error removing the device '/dev/mapper/crypt_sde1' - Inappropriate ioctl for device

Let's now remove the device node of that bad drive, unmount and remount the array:
polgara:~# dmsetup remove crypt_sdj1
polgara:~# btrfs fi show
Label: 'backupcopy'  uuid: 5ccda389-748b-419c-bfa9-c14c4136e1c4
        Total devices 11 FS bytes used 682.30MiB
        devid    1 size 465.76GiB used 2.14GiB path /dev/mapper/crypt_sdb1
        devid    2 size 465.76GiB used 2.14GiB path /dev/mapper/crypt_sdd1
        devid    3 size 465.75GiB used 2.14GiB path /dev/mapper/crypt_sdf1
        devid    4 size 465.76GiB used 2.14GiB path /dev/mapper/crypt_sdg1
        devid    5 size 465.76GiB used 2.14GiB path /dev/mapper/crypt_sdh1
        devid    6 size 465.76GiB used 2.14GiB path /dev/mapper/crypt_sdi1
        devid    8 size 465.76GiB used 2.14GiB path /dev/mapper/crypt_sdk1
        devid    9 size 465.76GiB used 2.14GiB path /dev/mapper/crypt_sdl1
        devid   10 size 465.76GiB used 2.14GiB path /dev/mapper/crypt_sdm1
        devid   11 size 465.76GiB used 1.00GiB path /dev/mapper/crypt_sde1
        *** Some devices missing
=> ok, that's good, one device is missing

Now when I mount the array, I see this:
polgara:~# mount -v -t btrfs -o compress=zlib,space_cache,noatime,degraded LABEL=backupcopy /mnt/btrfs_backupcopy 
> BTRFS: device label backupcopy devid 11 transid 150 /dev/mapper/crypt_sde1
> BTRFS: open /dev/dm-6 failed
> BTRFS info (device dm-10): allowing degraded mounts
> BTRFS info (device dm-10): disk space caching is enabled
> BTRFS: bdev /dev/dm-6 errs: wr 12, rd 0, flush 4, corrupt 0, gen 0
/dev/mapper/crypt_sde1 on /mnt/btrfs_backupcopy type btrfs (rw,noatime,compress=zlib,space_cache,degraded)
polgara:~# btrfs fi show
Label: backupcopy  uuid: 5ccda389-748b-419c-bfa9-c14c4136e1c4
        Total devices 11 FS bytes used 682.30MiB
        devid    1 size 465.76GiB used 2.14GiB path /dev/dm-0
        devid    2 size 465.76GiB used 2.14GiB path /dev/dm-1
        devid    3 size 465.75GiB used 2.14GiB path /dev/dm-2
        devid    4 size 465.76GiB used 2.14GiB path /dev/dm-3
        devid    5 size 465.76GiB used 2.14GiB path /dev/dm-4
        devid    6 size 465.76GiB used 2.14GiB path /dev/dm-5
        devid    7 size 465.76GiB used 1.14GiB path /dev/dm-6
        devid    8 size 465.76GiB used 2.14GiB path /dev/dm-7
        devid    9 size 465.76GiB used 2.14GiB path /dev/dm-9
        devid    10 size 465.76GiB used 2.14GiB path /dev/dm-8
        devid    11 size 465.76GiB used 1.00GiB path /dev/mapper/crypt_sde1

That's bad, it still shows me dm-6 even though it's gone now. I think
this means that you cannot get btrfs to show that it's in degraded mode.

Ok, let's re-add the device:
polgara:/mnt/btrfs_backupcopy# cryptsetup luksOpen /dev/sdj1 crypt_sdj1
Enter passphrase for /dev/sdj1: 
> BTRFS: device label backupcopy devid 7 transid 137 /dev/dm-6
polgara:/mnt/btrfs_backupcopy# Mar 18 22:30:55 polgara kernel: [49535.076071] BTRFS: device label backupcopy devid 7 transid 137 /dev/dm-6
> btrfs-rmw-2: page allocation failure: order:1, mode:0x8020
> CPU: 0 PID: 7511 Comm: btrfs-rmw-2 Tainted: G        W    3.14.0-rc5-amd64-i915-preempt-20140216c #1
> Hardware name: System manufacturer P5KC/P5KC, BIOS 0502    05/24/2007
>  0000000000000000 ffff880011173690 ffffffff816090b3 0000000000000000
>  ffff880011173718 ffffffff811037b0 00000001fffffffe 0000000000000001
>  ffff88006bb2a0d0 0000000200000000 0000003000000000 ffff88007ff7ce00
> Call Trace:
>  [<ffffffff816090b3>] dump_stack+0x4e/0x7a
>  [<ffffffff811037b0>] warn_alloc_failed+0x111/0x125
>  [<ffffffff81106cb2>] __alloc_pages_nodemask+0x707/0x854
>  [<ffffffff8110654e>] ? get_page_from_freelist+0x6c0/0x71d
>  [<ffffffff81014650>] dma_generic_alloc_coherent+0xa7/0x11c
>  [<ffffffff811354e8>] dma_pool_alloc+0x10a/0x1cb
>  [<ffffffffa00f2aa0>] mvs_task_prep+0x192/0xa42 [mvsas]
>  [<ffffffff81140d66>] ? ____cache_alloc_node+0xf1/0x134
>  [<ffffffffa00f33ad>] mvs_task_exec.isra.9+0x5d/0xc9 [mvsas]
>  [<ffffffffa00f3a76>] mvs_queue_command+0x3d/0x29b [mvsas]
>  [<ffffffff8114118d>] ? kmem_cache_alloc+0xe3/0x161
>  [<ffffffffa00e5d1c>] sas_ata_qc_issue+0x1cd/0x235 [libsas]
>  [<ffffffff814a9598>] ata_qc_issue+0x291/0x2f1
>  [<ffffffff814af413>] ? ata_scsiop_mode_sense+0x29c/0x29c
>  [<ffffffff814b049e>] __ata_scsi_queuecmd+0x184/0x1e0
>  [<ffffffff814b05a5>] ata_sas_queuecmd+0x31/0x4d
>  [<ffffffffa00e47ba>] sas_queuecommand+0x98/0x1fe [libsas]
>  [<ffffffff8148fdee>] scsi_dispatch_cmd+0x14f/0x22e
>  [<ffffffff814964da>] scsi_request_fn+0x4da/0x507
>  [<ffffffff812e01a3>] __blk_run_queue_uncond+0x22/0x2b
>  [<ffffffff812e01c5>] __blk_run_queue+0x19/0x1b
>  [<ffffffff812fc16d>] cfq_insert_request+0x391/0x3b5
>  [<ffffffff812e002f>] ? perf_trace_block_rq_with_error+0x45/0x14f
>  [<ffffffff812e512c>] ? blk_recount_segments+0x1e/0x2e
>  [<ffffffff812dc08c>] __elv_add_request+0x1fc/0x276
>  [<ffffffff812e1c6c>] blk_queue_bio+0x237/0x256
>  [<ffffffff812df92c>] generic_make_request+0x9c/0xdb
>  [<ffffffff812dfa7d>] submit_bio+0x112/0x131
>  [<ffffffff8128274c>] rmw_work+0x112/0x162
>  [<ffffffff8125073f>] worker_loop+0x168/0x4d8
>  [<ffffffff812505d7>] ? btrfs_queue_worker+0x283/0x283
>  [<ffffffff8106bc56>] kthread+0xae/0xb6
>  [<ffffffff8106bba8>] ? __kthread_parkme+0x61/0x61
>  [<ffffffff816153fc>] ret_from_fork+0x7c/0xb0
>  [<ffffffff8106bba8>] ? __kthread_parkme+0x61/0x61

My system hung soon after that, but it could have been due to issues
with my SATA driver too.

I rebooted, tried a mount:
polgara:~# mount -v -t btrfs -o compress=zlib,space_cache,noatime LABEL=backupcopy /mnt/btrfs_backupcopy
> BTRFS: device label backupcopy devid 11 transid 152 /dev/mapper/crypt_sde1
> BTRFS info (device dm-10): disk space caching is enabled
> BTRFS: bdev /dev/dm-6 errs: wr 12, rd 0, flush 4, corrupt 0, gen 0
/dev/mapper/crypt_sde1 on /mnt/btrfs_backupcopy type btrfs (rw,noatime,compress=zlib,space_cache)

Ok, there is a problem here, my filesystem is missing data I added after my sdj1 device died.
In other words, btrfs happily added my device that was way behind and gave me an incomplete fileystem instead of noticing
that sdj1 was behind and giving me a degraded filesystem.
Moral of the story: do not ever re-add a device that got kicked out if you wrote new data after that, or you will end up with an older version of your filesystem (on the plus side, it's consistent and apparently without data corruption. That said, btrfs scrub complained loudly of many errors it didn't know how to fix.
> BTRFS: bdev /dev/dm-6 errs: wr 12, rd 0, flush 4, corrupt 0, gen 0
> BTRFS: bad tree block start 6438453874765710835 61874388992
> BTRFS: bad tree block start 8828340560360071357 61886726144
> BTRFS: bad tree block start 5332618200988957279 61895868416
> BTRFS: bad tree block start 9233018093866324599 61895884800
> BTRFS: bad tree block start 17393001018657664843 61895917568
> BTRFS: bad tree block start 6438453874765710835 61874388992
> BTRFS: bad tree block start 8828340560360071357 61886726144
> BTRFS: bad tree block start 5332618200988957279 61895868416
> BTRFS: bad tree block start 9233018093866324599 61895884800
> BTRFS: bad tree block start 17393001018657664843 61895917568
> BTRFS: checksum error at logical 61826662400 on dev /dev/dm-6, sector 2541568: metadata leaf (level 0) in tree 5
> BTRFS: checksum error at logical 61826662400 on dev /dev/dm-6, sector 2541568: metadata leaf (level 0) in tree 5
> BTRFS: bdev /dev/dm-6 errs: wr 12, rd 0, flush 4, corrupt 1, gen 0
> BTRFS: unable to fixup (regular) error at logical 61826662400 on dev /dev/dm-6
> BTRFS: checksum error at logical 61826678784 on dev /dev/dm-6, sector 2541600: metadata leaf (level 0) in tree 5
> BTRFS: checksum error at logical 61826678784 on dev /dev/dm-6, sector 2541600: metadata leaf (level 0) in tree 5
> BTRFS: bdev /dev/dm-6 errs: wr 12, rd 0, flush 4, corrupt 2, gen 0
> BTRFS: unable to fixup (regular) error at logical 61826678784 on dev /dev/dm-6
> BTRFS: checksum error at logical 61826695168 on dev /dev/dm-6, sector 2541632: metadata leaf (level 0) in tree 5
> BTRFS: checksum error at logical 61826695168 on dev /dev/dm-6, sector 2541632: metadata leaf (level 0) in tree 5
> BTRFS: bdev /dev/dm-6 errs: wr 12, rd 0, flush 4, corrupt 3, gen 0
> BTRFS: unable to fixup (regular) error at logical 61826695168 on dev /dev/dm-6
(...)
> BTRFS: unable to fixup (regular) error at logical 61827186688 on dev /dev/dm-5
> scrub_handle_errored_block: 632 callbacks suppressed
> BTRFS: checksum error at logical 61849731072 on dev /dev/dm-6, sector 2586624: metadata leaf (level 0) in tree 5
> BTRFS: checksum error at logical 61849731072 on dev /dev/dm-6, sector 2586624: metadata leaf (level 0) in tree 5
> btrfs_dev_stat_print_on_error: 632 callbacks suppressed
> BTRFS: bdev /dev/dm-6 errs: wr 12, rd 0, flush 4, corrupt 166, gen 0
> scrub_handle_errored_block: 632 callbacks suppressed
> BTRFS: unable to fixup (regular) error at logical 61849731072 on dev /dev/dm-6
(...)
> BTRFS: unable to fixup (regular) error at logical 61864853504 on dev /dev/dm-5
> btree_readpage_end_io_hook: 16 callbacks suppressed
> BTRFS: bad tree block start 17393001018657664843 61895917568
> BTRFS: bad tree block start 17393001018657664843 61895917568
> scrub_handle_errored_block: 697 callbacks suppressed
> BTRFS: checksum error at logical 61871751168 on dev /dev/dm-3, sector 2629632: metadata leaf (level 0) in tree 5
> BTRFS: checksum error at logical 61871751168 on dev /dev/dm-3, sector 2629632: metadata leaf (level 0) in tree 5
> btrfs_dev_stat_print_on_error: 697 callbacks suppressed
> BTRFS: bdev /dev/dm-3 errs: wr 0, rd 0, flush 0, corrupt 236, gen 0
> scrub_handle_errored_block: 697 callbacks suppressed
> BTRFS: unable to fixup (regular) error at logical 61871751168 on dev /dev/dm-3

On the plus side, I can remove the last drive I added now that I'm not in degraded mode again:
polgara:/mnt/btrfs_backupcopy# btrfs device delete /dev/mapper/crypt_sde1 .
> BTRFS info (device dm-10): relocating block group 72689909760 flags 129
> BTRFS info (device dm-10): found 1 extents
> BTRFS info (device dm-10): found 1 extents


There you go, hope this helps.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
