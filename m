Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-db5eur01on0107.outbound.protection.outlook.com ([104.47.2.107]:60608
	"EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752389AbcG2V6g (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jul 2016 17:58:36 -0400
From: =?utf-8?B?TGlib3IgS2xlcMOhxI0=?= <libor.klepac@bcom.cz>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Send-recieve performance
Date: Fri, 29 Jul 2016 12:25:36 +0000
Message-ID: <5253520.Dd86KHkWUm@libor-nb>
References: <2282942.pRaJJzEdHC@libor-nb>
 <CAPmG0jYbSdEFKg=u9BiNZCSh-tL=93kU=mwyBf7DbZD3xXfm_w@mail.gmail.com>
 <1836752.gta6e4fJGf@libor-nb>
In-Reply-To: <1836752.gta6e4fJGf@libor-nb>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On pÃ¡tek 22. Äervence 2016 13:27:15 CEST Libor KlepÃ¡Ä wrote:
> Hello,
> 
> Dne pÃ¡tek 22. Äervence 2016 14:59:43 CEST, Henk Slager napsal(a):
> 
> > On Wed, Jul 20, 2016 at 11:15 AM, Libor KlepÃ¡Ä <libor.klepac@bcom.cz>
> > wrote:
> 
> > > Hello,
> > > we use backuppc to backup our hosting machines.
> > > 
> > > I have recently migrated it to btrfs, so we can use send-recieve for
> > > offsite backups of our backups.
> > > 
> > > I have several btrfs volumes, each hosts nspawn container, which runs
> > > in
> > > /system subvolume and has backuppc data in /backuppc subvolume .
> > > I use btrbk to do snapshots and transfer.
> > > Local side is set to keep 5 daily snapshots, remote side to hold some
> > > history. (not much yet, i'm using it this way for few weeks).
> > > 
> > > If you know backuppc behaviour: for every backup (even incremental), it
> > > creates full directory tree of each backed up machine even if it has no
> > > modified files and places one small file in each, which holds some info
> > > for backuppc. So after few days i ran into ENOSPACE on one volume,
> > > because my metadata grow, because of inlineing. I switched from
> > > mdata=DUP
> > > to mdata=single (now I see it's possible to change inline file size,
> > > right?).
> > 
> > I would try mounting both send and receive volumes with max_inline=0
> > So then for all small new- and changed files, the filedata will be
> > stored in data chunks and not inline in the metadata chunks.
> 
> 
> Ok, i will try. Is there way to move existing files from metadata to data 
> chunks? Something like btrfs balance with convert filter?
>
Writen on 25.7.2016: 
I will recreate on new filesystems and do new send/receive

Writen on 29.7.2016:
Created new filesystem or copyed to new subvolumes after mounting with 
max_inline=0

Difference is remarkable, for example
before:
------------------
btrfs filesystem usage  /mnt/btrfs/as/
Overall:
    Device size:                 320.00GiB
    Device allocated:            144.06GiB
    Device unallocated:          175.94GiB
    Device missing:                  0.00B
    Used:                        122.22GiB
    Free (estimated):            176.33GiB      (min: 88.36GiB)
    Data ratio:                       1.00
    Metadata ratio:                   1.00
    Global reserve:              512.00MiB      (used: 40.86MiB)

Data,single: Size:98.00GiB, Used:97.61GiB
   /dev/sdb       98.00GiB

Metadata,single: Size:46.00GiB, Used:24.61GiB
   /dev/sdb       46.00GiB

System,DUP: Size:32.00MiB, Used:16.00KiB
   /dev/sdb       64.00MiB

Unallocated:
   /dev/sdb      175.94GiB

after:
-----------------------
   
btrfs filesystem usage  /mnt/btrfs/as/
Overall:
    Device size:                 320.00GiB
    Device allocated:            137.06GiB
    Device unallocated:          182.94GiB
    Device missing:                  0.00B
    Used:                         54.36GiB
    Free (estimated):            225.15GiB      (min: 133.68GiB)
    Data ratio:                       1.00
    Metadata ratio:                   1.00
    Global reserve:              512.00MiB      (used: 0.00B)

Data,single: Size:91.00GiB, Used:48.79GiB
   /dev/sdb       91.00GiB

Metadata,single: Size:46.00GiB, Used:5.58GiB
   /dev/sdb       46.00GiB

System,DUP: Size:32.00MiB, Used:16.00KiB
   /dev/sdb       64.00MiB

Unallocated:
   /dev/sdb      182.94GiB


> 
> > That you changed metadata profile from dup to single is unrelated in
> > principle. single for metadata instead of dup is half the write I/O
> > for the harddisks, so in that sense it might speed up send actions a
> > bit. I guess almost all time is spend in seeks.
> 
> 
> Yes, I just didn't realize that so much files will be in metadata structures
>  and it cought me be suprise.
> 

 
> > The send part is the speed bottleneck as it looks like, you can test
> > and isolate it by doing a dummy send and pipe it to  | mbuffer >
> > /dev/null  and see what speed you get.
> 
> 
> I tried it already, did incremental send to file 
> #btrfs send -v -p ./backuppc.20160712/  ./backuppc.20160720_1/ | pv > /mnt/
> data1/send
> At subvol ./backuppc.20160720_1/
> joining genl thread
> 18.9GiB 21:14:45 [ 259KiB/s]
> 
> Copied it over scp to reciever with speed 50.9MB/s.
> No i will try recieve.
>

Writen on 25.7.2016: 
Receive did 1GB of those 19GB over weekend, so, canceled ...

Writen on 29.7.2016: 
Even after clean filesystems mounted with max_inline=0, send/receive is slow.
I tried to unmount all filesystem, unload btrfs module, then loaded it again.
Send/receive still slow.

Then i set vm.dirty_bytes to 102400
and then set it to
vm.dirty_background_ratio = 10
vm.dirty_ratio = 20

And voila, speed went up dramaticaly, now it has transfered about 10GB in 
30minutes!

Libor
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
