Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:36081 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbcABCKk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Jan 2016 21:10:40 -0500
Received: by mail-pa0-f53.google.com with SMTP id yy13so76373151pab.3
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Jan 2016 18:10:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+9GZUgnmMoLeGsyeo=tFe2GLsDkLEr0umiDovf3P2aBtDA+Xg@mail.gmail.com>
References: <CA+9GZUitvMjJSgdpmMb8Fsz-CHK4WXV9XVhGCk9mRCWUU_D-VQ@mail.gmail.com>
 <CAJCQCtSyJ8cHrmZcnLQ_fvsaaS1qZiQx_rsFt7-_6LJuvhKR-A@mail.gmail.com> <CA+9GZUgnmMoLeGsyeo=tFe2GLsDkLEr0umiDovf3P2aBtDA+Xg@mail.gmail.com>
From: "cheater00 ." <cheater00@gmail.com>
Date: Sat, 2 Jan 2016 03:10:20 +0100
Message-ID: <CA+9GZUjRWNVShW=6jfCVDTjRdQQCS9T_-cMkOF3s8846uAhn+w@mail.gmail.com>
Subject: Re: 6TB partition, Data only 2TB - aka When you haven't hit the
 "usual" problem
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

here is the info requested, if that helps anyone.

# uname -a
Linux SX20S 4.3.0-040300rc7-generic #201510260712 SMP Mon Oct 26
11:27:59 UTC 2015 i686 i686 i686 GNU/Linux
# aptitude show btrfs-tools
Package: btrfs-tools
State: installed
Automatically installed: no
Version: 4.2.1+ppa1-1~ubuntu15.10.1
# btrfs --version
btrfs-progs v4.2.1
# btrfs fi show Media
Label: 'Media'  uuid: b397b7ef-6754-4ba4-8b1a-fbf235aa1cf8
Total devices 1 FS bytes used 1.92TiB
devid    1 size 5.46TiB used 1.93TiB path /dev/sdd1

btrfs-progs v4.2.1
# btrfs fi usage Media
Overall:
    Device size:   5.46TiB
    Device allocated:   1.93TiB
    Device unallocated:   3.52TiB
    Device missing:     0.00B
    Used:   1.93TiB
    Free (estimated):   3.53TiB (min: 1.76TiB)
    Data ratio:      1.00
    Metadata ratio:      2.00
    Global reserve: 512.00MiB (used: 0.00B)

Data,single: Size:1.92TiB, Used:1.92TiB
   /dev/sdd1   1.92TiB

Metadata,single: Size:8.00MiB, Used:0.00B
   /dev/sdd1   8.00MiB

Metadata,DUP: Size:5.00GiB, Used:3.32GiB
   /dev/sdd1  10.00GiB

System,single: Size:4.00MiB, Used:0.00B
   /dev/sdd1   4.00MiB

System,DUP: Size:8.00MiB, Used:224.00KiB
   /dev/sdd1  16.00MiB

Unallocated:
   /dev/sdd1   3.52TiB



# btrfs-show-super /dev/sdd1
superblock: bytenr=65536, device=/dev/sdd1
---------------------------------------------------------
csum 0xae174f16 [match]
bytenr 65536
flags 0x1
( WRITTEN )
magic _BHRfS_M [match]
fsid b397b7ef-6754-4ba4-8b1a-fbf235aa1cf8
label Media
generation 11983
root 34340864
sys_array_size 226
chunk_root_generation 11982
root_level 1
chunk_root 21135360
chunk_root_level 1
log_root 0
log_root_transid 0
log_root_level 0
total_bytes 6001173463040
bytes_used 2115339448320
sectorsize 4096
nodesize 16384
leafsize 16384
stripesize 4096
root_dir 6
num_devices 1
compat_flags 0x0
compat_ro_flags 0x0
incompat_flags 0x61
( MIXED_BACKREF |
 BIG_METADATA |
 EXTENDED_IREF )
csum_type 0
csum_size 4
cache_generation 11983
uuid_tree_generation 11983
dev_item.uuid 819e1c8a-5e55-4992-81d3-f22fdd088dc9
dev_item.fsid b397b7ef-6754-4ba4-8b1a-fbf235aa1cf8 [match]
dev_item.type 0
dev_item.total_bytes 6001173463040
dev_item.bytes_used 2124972818432
dev_item.io_align 4096
dev_item.io_width 4096
dev_item.sector_size 4096
dev_item.devid 1
dev_item.dev_group 0
dev_item.seek_speed 0
dev_item.bandwidth 0
dev_item.generation 0

I did mount Media -o enospc_debug and now mount shows:
/dev/sdd1 on /media/cheater/Media type btrfs
(rw,nosuid,nodev,enospc_debug,_netdev)


On Wed, Dec 30, 2015 at 11:13 PM, Chris Murphy <lists@colorremedies.com> wrote:
> kernel and btrfs-progs versions
> and output from:
> 'btrfs fi show <mp>'
> 'btrfs fi usage <mp>'
> 'btrfs-show-super <blockdev>'
> 'df -h'
>
> Then umount the volume, and mount with option enospc_debug, and try to
> reproduce the problem, then include everything from dmesg from the
> time the volume was mounted.
>
> --
> Chris Murphy

On Sat, Jan 2, 2016 at 3:09 AM, cheater00 . <cheater00@gmail.com> wrote:
> I have been unable to reproduce so far.
