Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f45.google.com ([209.85.213.45]:35142 "EHLO
	mail-vk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754386AbcGVM7p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Jul 2016 08:59:45 -0400
Received: by mail-vk0-f45.google.com with SMTP id w127so155929653vkh.2
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Jul 2016 05:59:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2282942.pRaJJzEdHC@libor-nb>
References: <2282942.pRaJJzEdHC@libor-nb>
From: Henk Slager <eye1tm@gmail.com>
Date: Fri, 22 Jul 2016 14:59:43 +0200
Message-ID: <CAPmG0jYbSdEFKg=u9BiNZCSh-tL=93kU=mwyBf7DbZD3xXfm_w@mail.gmail.com>
Subject: Re: Send-recieve performance
To: =?UTF-8?B?TGlib3IgS2xlcMOhxI0=?= <libor.klepac@bcom.cz>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 20, 2016 at 11:15 AM, Libor Klepáč <libor.klepac@bcom.cz> wrote:
> Hello,
> we use backuppc to backup our hosting machines.
>
> I have recently migrated it to btrfs, so we can use send-recieve for offsite backups of our backups.
>
> I have several btrfs volumes, each hosts nspawn container, which runs in /system subvolume and has backuppc data in /backuppc subvolume
> .
> I use btrbk to do snapshots and transfer.
> Local side is set to keep 5 daily snapshots, remote side to hold some history. (not much yet, i'm using it this way for few weeks).
>
> If you know backuppc behaviour: for every backup (even incremental), it creates full directory tree of each backed up machine even if it has no modified files and places one small file in each, which holds some info for backuppc.
> So after few days i ran into ENOSPACE on one volume, because my metadata grow, because of inlineing.
> I switched from mdata=DUP to mdata=single (now I see it's possible to change inline file size, right?).

I would try mounting both send and receive volumes with max_inline=0
So then for all small new- and changed files, the filedata will be
stored in data chunks and not inline in the metadata chunks.

That you changed metadata profile from dup to single is unrelated in
principle. single for metadata instead of dup is half the write I/O
for the harddisks, so in that sense it might speed up send actions a
bit. I guess almost all time is spend in seeks.

> My problem is, that on some volumes, send-recieve is relatively fast (rate in MB/s or hundreds of kB/s) but on biggest volume (biggest in space and biggest in contained filesystem trees) rate is just 5-30kB/s.
>
> Here is btrbk progress copyed
> 785MiB 47:52:00 [12.9KiB/s] [4.67KiB/s]
>
> ie. 758MB in 48 hours.
>
> Reciever has high IO/wait - 90-100%, when i push data using btrbk.
> When I run dd over ssh it can do 50-75MB/s.

The send part is the speed bottleneck as it looks like, you can test
and isolate it by doing a dummy send and pipe it to  | mbuffer >
/dev/null  and see what speed you get.

> Sending machine is debian jessie with kernel 4.5.0-0.bpo.2-amd64 (upstream 4.5.3) , btrfsprogs 4.4.1. It is virtual machine running on volume exported from MD3420, 4 SAS disks in RAID10.
>
> Recieving machine is debian jessie on Dell T20 with 4x3TB disks in MD RAID5 , kernel is 4.4.0-0.bpo.1-amd64 (upstream 4.4.6), btrfsprgos 4.4.1
>
> BTRFS volumes were created using those listed versions.
>
> Sender:
> ---------
> #mount | grep hosting
> /dev/sdg on /mnt/btrfs/hosting type btrfs (rw,noatime,space_cache,subvolid=5,subvol=/)
> /dev/sdg on /var/lib/container/hosting type btrfs (rw,noatime,space_cache,subvolid=259,subvol=/system)
> /dev/sdg on /var/lib/container/hosting/var/lib/backuppc type btrfs (rw,noatime,space_cache,subvolid=260,subvol=/backuppc)
>
> #btrfs filesystem usage /mnt/btrfs/hosting
> Overall:
>     Device size:                 840.00GiB
>     Device allocated:            815.03GiB
>     Device unallocated:           24.97GiB
>     Device missing:                  0.00B
>     Used:                        522.76GiB
>     Free (estimated):            283.66GiB      (min: 271.18GiB)
>     Data ratio:                       1.00
>     Metadata ratio:                   1.00
>     Global reserve:              512.00MiB      (used: 0.00B)
>
> Data,single: Size:710.98GiB, Used:452.29GiB
>    /dev/sdg      710.98GiB
>
> Metadata,single: Size:103.98GiB, Used:70.46GiB
>    /dev/sdg      103.98GiB

This is a very large ratio metadata/data. Large and scattered
metadata, even on fast rotational media, will result in slow send
operation is my experience ( incremental send, about 10G metadata). So
hopefully, when all the small files and many directories from backuppc
are in data chunks and metadata is significantly smaller, send will be
faster. However, maybe it is just the huge amount of files and not
inlining of small files that makes metadata so big.

I assume incremental send of snapshots is done.

> System,DUP: Size:32.00MiB, Used:112.00KiB
>    /dev/sdg       64.00MiB
>
> Unallocated:
>    /dev/sdg       24.97GiB
>
> # btrfs filesystem show /mnt/btrfs/hosting
> Label: 'BackupPC-BcomHosting'  uuid: edecc92a-646a-4585-91a0-9cbb556303e9
>         Total devices 1 FS bytes used 522.75GiB
>         devid    1 size 840.00GiB used 815.03GiB path /dev/sdg
>
> #Reciever:
> #mount | grep hosting
> /dev/mapper/vgPecDisk2-lvHostingBackupBtrfs on /mnt/btrfs/hosting type btrfs (rw,noatime,space_cache,subvolid=5,subvol=/)
>
> #btrfs filesystem usage /mnt/btrfs/hosting/
> Overall:
>     Device size:                 896.00GiB
>     Device allocated:            604.07GiB
>     Device unallocated:          291.93GiB
>     Device missing:                  0.00B
>     Used:                        565.98GiB
>     Free (estimated):            313.62GiB      (min: 167.65GiB)
>     Data ratio:                       1.00
>     Metadata ratio:                   1.00
>     Global reserve:              512.00MiB      (used: 55.80MiB)
>
> Data,single: Size:530.01GiB, Used:508.32GiB
>    /dev/mapper/vgPecDisk2-lvHostingBackupBtrfs   530.01GiB
>
> Metadata,single: Size:74.00GiB, Used:57.65GiB
>    /dev/mapper/vgPecDisk2-lvHostingBackupBtrfs    74.00GiB
>
> System,DUP: Size:32.00MiB, Used:80.00KiB
>    /dev/mapper/vgPecDisk2-lvHostingBackupBtrfs    64.00MiB
>
> Unallocated:
>    /dev/mapper/vgPecDisk2-lvHostingBackupBtrfs   291.93GiB
>
> #btrfs filesystem show /mnt/btrfs/hosting/
> Label: none  uuid: 2d7ea471-8794-42ed-bec2-a6ad83f7b038
>         Total devices 1 FS bytes used 564.56GiB
>         devid    1 size 896.00GiB used 604.07GiB path /dev/mapper/vgPecDisk2-lvHostingBackupBtrfs
>
>
>
> What can i do about it? I tried to defragment /backuppc subvolume (without recursive option), should i do it for all snapshots/subvolumes on both sides?
> Should upgrade to 4.6.x kernel help (there is 4.6.3 in backports)?

I think defragmenting in this case won't help much, it results in cow
writes in metadata and files itself are mostly small as I understand.
Also 4.6.x kernel+progs won't help in principle.
