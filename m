Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-db5eur01on0125.outbound.protection.outlook.com ([104.47.2.125]:40192
	"EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751166AbcGVVCW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Jul 2016 17:02:22 -0400
From: =?utf-8?B?TGlib3IgS2xlcMOhxI0=?= <libor.klepac@bcom.cz>
To: Henk Slager <eye1tm@gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Send-recieve performance
Date: Fri, 22 Jul 2016 13:27:15 +0000
Message-ID: <1836752.gta6e4fJGf@libor-nb>
References: <2282942.pRaJJzEdHC@libor-nb>
 <CAPmG0jYbSdEFKg=u9BiNZCSh-tL=93kU=mwyBf7DbZD3xXfm_w@mail.gmail.com>
In-Reply-To: <CAPmG0jYbSdEFKg=u9BiNZCSh-tL=93kU=mwyBf7DbZD3xXfm_w@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Dne pÃ¡tek 22. Äervence 2016 14:59:43 CEST, Henk Slager napsal(a):
> On Wed, Jul 20, 2016 at 11:15 AM, Libor KlepÃ¡Ä <libor.klepac@bcom.cz> wrote:
> > Hello,
> > we use backuppc to backup our hosting machines.
> > 
> > I have recently migrated it to btrfs, so we can use send-recieve for
> > offsite backups of our backups.
> > 
> > I have several btrfs volumes, each hosts nspawn container, which runs in
> > /system subvolume and has backuppc data in /backuppc subvolume .
> > I use btrbk to do snapshots and transfer.
> > Local side is set to keep 5 daily snapshots, remote side to hold some
> > history. (not much yet, i'm using it this way for few weeks).
> > 
> > If you know backuppc behaviour: for every backup (even incremental), it
> > creates full directory tree of each backed up machine even if it has no
> > modified files and places one small file in each, which holds some info
> > for backuppc. So after few days i ran into ENOSPACE on one volume,
> > because my metadata grow, because of inlineing. I switched from mdata=DUP
> > to mdata=single (now I see it's possible to change inline file size,
> > right?).
> I would try mounting both send and receive volumes with max_inline=0
> So then for all small new- and changed files, the filedata will be
> stored in data chunks and not inline in the metadata chunks.

Ok, i will try. Is there way to move existing files from metadata to data 
chunks? Something like btrfs balance with convert filter?

> That you changed metadata profile from dup to single is unrelated in
> principle. single for metadata instead of dup is half the write I/O
> for the harddisks, so in that sense it might speed up send actions a
> bit. I guess almost all time is spend in seeks.

Yes, I just didn't realize that so much files will be in metadata structures 
and it cought me be suprise.

> 
> > My problem is, that on some volumes, send-recieve is relatively fast (rate
> > in MB/s or hundreds of kB/s) but on biggest volume (biggest in space and
> > biggest in contained filesystem trees) rate is just 5-30kB/s.
> > 
> > Here is btrbk progress copyed
> > 785MiB 47:52:00 [12.9KiB/s] [4.67KiB/s]
> > 
> > ie. 758MB in 48 hours.
> > 
> > Reciever has high IO/wait - 90-100%, when i push data using btrbk.
> > When I run dd over ssh it can do 50-75MB/s.
> 
> The send part is the speed bottleneck as it looks like, you can test
> and isolate it by doing a dummy send and pipe it to  | mbuffer >
> /dev/null  and see what speed you get.

I tried it already, did incremental send to file 
#btrfs send -v -p ./backuppc.20160712/  ./backuppc.20160720_1/ | pv > /mnt/
data1/send
At subvol ./backuppc.20160720_1/
joining genl thread
18.9GiB 21:14:45 [ 259KiB/s]

Copied it over scp to reciever with speed 50.9MB/s.
No i will try recieve.


> > Sending machine is debian jessie with kernel 4.5.0-0.bpo.2-amd64 (upstream
> > 4.5.3) , btrfsprogs 4.4.1. It is virtual machine running on volume
> > exported from MD3420, 4 SAS disks in RAID10.
> > 
> > Recieving machine is debian jessie on Dell T20 with 4x3TB disks in MD
> > RAID5 , kernel is 4.4.0-0.bpo.1-amd64 (upstream 4.4.6), btrfsprgos 4.4.1
> > 
> > BTRFS volumes were created using those listed versions.
> > 
> > Sender:
> > ---------
> > #mount | grep hosting
> > /dev/sdg on /mnt/btrfs/hosting type btrfs
> > (rw,noatime,space_cache,subvolid=5,subvol=/) /dev/sdg on
> > /var/lib/container/hosting type btrfs
> > (rw,noatime,space_cache,subvolid=259,subvol=/system) /dev/sdg on
> > /var/lib/container/hosting/var/lib/backuppc type btrfs
> > (rw,noatime,space_cache,subvolid=260,subvol=/backuppc)
> > 
> > #btrfs filesystem usage /mnt/btrfs/hosting
> > 
> > Overall:
> >     Device size:                 840.00GiB
> >     Device allocated:            815.03GiB
> >     Device unallocated:           24.97GiB
> >     Device missing:                  0.00B
> >     Used:                        522.76GiB
> >     Free (estimated):            283.66GiB      (min: 271.18GiB)
> >     Data ratio:                       1.00
> >     Metadata ratio:                   1.00
> >     Global reserve:              512.00MiB      (used: 0.00B)
> > 
> > Data,single: Size:710.98GiB, Used:452.29GiB
> > 
> >    /dev/sdg      710.98GiB
> > 
> > Metadata,single: Size:103.98GiB, Used:70.46GiB
> > 
> >    /dev/sdg      103.98GiB
> 
> This is a very large ratio metadata/data. Large and scattered
> metadata, even on fast rotational media, will result in slow send
> operation is my experience ( incremental send, about 10G metadata). So
> hopefully, when all the small files and many directories from backuppc
> are in data chunks and metadata is significantly smaller, send will be
> faster. However, maybe it is just the huge amount of files and not
> inlining of small files that makes metadata so big.
Backuppc says
"Pool is 462.30GB comprising 5140707 files and 4369 directories"
that is only storage of files, not counting all the server trees

> 
> I assume incremental send of snapshots is done.

Yes, it was incremental

Is anyone interested in btrfs-debug-tree -t 2 output?
It's 2.3GB big (187MB with xz -0 compression)

Libor
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
