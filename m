Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60550 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751315AbdAPWpP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Jan 2017 17:45:15 -0500
Subject: Re: Unocorrectable errors with RAID1
To: Christoph Groth <christoph@grothesque.org>, linux-btrfs@vger.kernel.org
References: <87o9z7dzvd.fsf@grothesque.org>
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Message-ID: <42eaf69b-c444-fc50-2128-3a1fbd18b335@suse.de>
Date: Mon, 16 Jan 2017 16:45:10 -0600
MIME-Version: 1.0
In-Reply-To: <87o9z7dzvd.fsf@grothesque.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 01/16/2017 05:10 AM, Christoph Groth wrote:
> Hi,
> 
> I’ve been using a btrfs RAID1 of two hard disks since early 2012 on my
> home server.  The machine has been working well overall, but recently
> some problems with the file system surfaced.  Since I do have backups, I
> do not worry about the data, but I post here to better understand what
> happened.  Also I cannot exclude that my case is useful in some way to
> btrfs development.
> 
> First some information about the system:
> 
> root@mim:~# uname -a
> Linux mim 4.6.0-1-amd64 #1 SMP Debian 4.6.3-1 (2016-07-04) x86_64 GNU/Linux
> root@mim:~# btrfs --version
> btrfs-progs v4.7.3
> root@mim:~# btrfs fi show
> Label: none  uuid: 2da00153-f9ea-4d6c-a6cc-10c913d22686
>     Total devices 2 FS bytes used 345.97GiB
>     devid    1 size 465.29GiB used 420.06GiB path /dev/sda2
>     devid    2 size 465.29GiB used 420.04GiB path /dev/sdb2
> 
> root@mim:~# btrfs fi df /
> Data, RAID1: total=417.00GiB, used=344.62GiB
> Data, single: total=8.00MiB, used=0.00B
> System, RAID1: total=40.00MiB, used=68.00KiB
> System, single: total=4.00MiB, used=0.00B
> Metadata, RAID1: total=3.00GiB, used=1.35GiB
> Metadata, single: total=8.00MiB, used=0.00B
> GlobalReserve, single: total=464.00MiB, used=0.00B
> root@mim:~# dmesg | grep -i btrfs
> [    4.165859] Btrfs loaded
> [    4.481712] BTRFS: device fsid 2da00153-f9ea-4d6c-a6cc-10c913d22686
> devid 1 transid 2075354 /dev/sda2
> [    4.482025] BTRFS: device fsid 2da00153-f9ea-4d6c-a6cc-10c913d22686
> devid 2 transid 2075354 /dev/sdb2
> [    4.521090] BTRFS info (device sdb2): disk space caching is enabled
> [    4.628506] BTRFS info (device sdb2): bdev /dev/sdb2 errs: wr 0, rd
> 0, flush 0, corrupt 3, gen 0
> [    4.628521] BTRFS info (device sdb2): bdev /dev/sda2 errs: wr 0, rd
> 0, flush 0, corrupt 3, gen 0
> [   18.315694] BTRFS info (device sdb2): disk space caching is enabled
> 
> The disks themselves have been turning for almost 5 years by now, but
> their SMART health is still fully satisfactory.
> 
> I noticed that something was wrong because printing stopped to work.  So
> I did a scrub that detected 0 "correctable errors" and 6 "uncorrectable"
> errors.  The relevant bits from kern.log are:
> 
> Jan 11 11:05:56 mim kernel: [159873.938579] BTRFS warning (device sdb2):
> checksum error at logical 180829634560 on dev /dev/sdb2, sector
> 353143968, root 5, inode 10014144, offset 221184, length 4096, links 1
> (path: usr/lib/x86_64-linux-gnu/libcups.so.2)
> Jan 11 11:05:57 mim kernel: [159874.857132] BTRFS warning (device sdb2):
> checksum error at logical 180829634560 on dev /dev/sda2, sector
> 353182880, root 5, inode 10014144, offset 221184, length 4096, links 1
> (path: usr/lib/x86_64-linux-gnu/libcups.so.2)
> Jan 11 11:28:42 mim kernel: [161240.083721] BTRFS warning (device sdb2):
> checksum error at logical 260254629888 on dev /dev/sda2, sector
> 508309824, root 5, inode 9990924, offset 6676480, length 4096, links 1
> (path:
> var/lib/apt/lists/ftp.fr.debian.org_debian_dists_unstable_main_binary-amd64_Packages)
> 
> Jan 11 11:28:42 mim kernel: [161240.235837] BTRFS warning (device sdb2):
> checksum error at logical 260254638080 on dev /dev/sda2, sector
> 508309840, root 5, inode 9990924, offset 6684672, length 4096, links 1
> (path:
> var/lib/apt/lists/ftp.fr.debian.org_debian_dists_unstable_main_binary-amd64_Packages)
> 
> Jan 11 11:37:21 mim kernel: [161759.725120] BTRFS warning (device sdb2):
> checksum error at logical 260254629888 on dev /dev/sdb2, sector
> 508270912, root 5, inode 9990924, offset 6676480, length 4096, links 1
> (path:
> var/lib/apt/lists/ftp.fr.debian.org_debian_dists_unstable_main_binary-amd64_Packages)
> 
> Jan 11 11:37:21 mim kernel: [161759.750251] BTRFS warning (device sdb2):
> checksum error at logical 260254638080 on dev /dev/sdb2, sector
> 508270928, root 5, inode 9990924, offset 6684672, length 4096, links 1
> (path:
> var/lib/apt/lists/ftp.fr.debian.org_debian_dists_unstable_main_binary-amd64_Packages)
> 
> 
> As you can see each disk has the same three errors, and there are no
> other errors.  Random bad blocks cannot explain this situation. I asked
> on #btrfs and someone suggested that these errors are likely due to RAM
> problems.  This may indeed be the case, since the machine has no ECC.  I
> managed to fix these errors by replacing the broken files with good
> copies.  Scrubbing shows no errors now:
> 
> root@mim:~# btrfs scrub status /
> scrub status for 2da00153-f9ea-4d6c-a6cc-10c913d22686
>     scrub started at Sat Jan 14 12:52:03 2017 and finished     after
> 01:49:10
>     total bytes scrubbed: 699.17GiB with 0 errors
> 
> However, there are further problems.  When trying to archive the full
> filesystem I noticed that some files/directories cannot be read.  (The
> problem is localized to some ".git" directory that I don’t need.)  Any
> attempt to read the broken files (or to delete them) does not work:
> 
> $ du -sh .git
> du: cannot access
> '.git/objects/28/ea2aae3fe57ab4328adaa8b79f3c1cf005dd8d': No such file
> or directory
> du: cannot access
> '.git/objects/28/fd95a5e9d08b6684819ce6e3d39d99e2ecccd5': Stale file handle
> du: cannot access
> '.git/objects/28/52e887ed436ed2c549b20d4f389589b7b58e09': Stale file handle
> du: cannot access '.git/objects/info': Stale file handle
> du: cannot access '.git/objects/pack': Stale file handle
> 
> During the above command the following lines were added to kern.log:
> 
> Jan 16 09:41:34 mim kernel: [132206.957566] BTRFS critical (device
> sda2): corrupt leaf, slot offset bad: block=192561152,root=1, slot=15
> Jan 16 09:41:34 mim kernel: [132206.957924] BTRFS critical (device
> sda2): corrupt leaf, slot offset bad: block=192561152,root=1, slot=15
> Jan 16 09:41:34 mim kernel: [132206.958505] BTRFS critical (device
> sda2): corrupt leaf, slot offset bad: block=192561152,root=1, slot=15
> Jan 16 09:41:34 mim kernel: [132206.958971] BTRFS critical (device
> sda2): corrupt leaf, slot offset bad: block=192561152,root=1, slot=15
> Jan 16 09:41:34 mim kernel: [132206.959534] BTRFS critical (device
> sda2): corrupt leaf, slot offset bad: block=192561152,root=1, slot=15
> Jan 16 09:41:34 mim kernel: [132206.959874] BTRFS critical (device
> sda2): corrupt leaf, slot offset bad: block=192561152,root=1, slot=15
> Jan 16 09:41:34 mim kernel: [132206.960523] BTRFS critical (device
> sda2): corrupt leaf, slot offset bad: block=192561152,root=1, slot=15
> Jan 16 09:41:34 mim kernel: [132206.960943] BTRFS critical (device
> sda2): corrupt leaf, slot offset bad: block=192561152,root=1, slot=15
> 
> So I tried to repair the file system by running "btrfs check --repair",
> but this doesn’t work:
> 
> (initramfs) btrfs --version
> btrfs-progs v4.7.3
> (initramfs) btrfs check --repair /dev/sda2
> UUID: ...
> checking extents
> incorrect offsets 2527 2543
> items overlap, can't fix
> cmds-check.c:4297: fix_item_offset: Assertion `ret` failed.
> btrfs[0x41a8b4]
> btrfs[0x41a8db]
> btrfs[0x42428b]
> btrfs[0x424f83]
> btrfs[0x4259cd]
> btrfs(cmd_check+0x1111)[0x427d6d]
> btrfs(main+0x12f)[0x40a341]
> /lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf1)[0x7fd98859d2b1]
> btrfs(_start+0x2a)[0x40a37a]
> 

Would you be able to upload a btrfs-image for me to examine. This is a
core ctree error where most probably item size is incorrectly registered.

Thanks,

-- 
-- 
Goldwyn
