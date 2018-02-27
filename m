Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-me1aus01on0072.outbound.protection.outlook.com ([104.47.116.72]:6958
        "EHLO AUS01-ME1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751767AbeB0F1O (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Feb 2018 00:27:14 -0500
From: Paul Jones <paul@pauljones.id.au>
To: Anand Jain <anand.jain@oracle.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: Help with leaf parent key incorrect
Date: Tue, 27 Feb 2018 05:27:10 +0000
Message-ID: <ME1PR01MB0338D3920E8640FA64F4329C9EC00@ME1PR01MB0338.ausprd01.prod.outlook.com>
References: <MEXPR01MB03427A142FC749C4C2126A0A9EC20@MEXPR01MB0342.ausprd01.prod.outlook.com>
 <d870155a-0523-d453-b302-ca5addeda67e@oracle.com>
 <ME1PR01MB0338086CF4FF5F185BA52C029EC10@ME1PR01MB0338.ausprd01.prod.outlook.com>
 <2fd186fe-34b3-c2dd-ad36-a043368104eb@oracle.com>
In-Reply-To: <2fd186fe-34b3-c2dd-ad36-a043368104eb@oracle.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> -----Original Message-----
> From: Anand Jain [mailto:anand.jain@oracle.com]
> Sent: Monday, 26 February 2018 7:27 PM
> To: Paul Jones <paul@pauljones.id.au>; linux-btrfs@vger.kernel.org
> Subject: Re: Help with leaf parent key incorrect
> 
> 
> 
>  > There is one io error in the log below,
> 
> Apparently, that's not a real EIO. We need to fix it.
> But can't be the root cause we are looking for here.
> 
> ----
>  > Feb 24 22:41:59 home kernel: BTRFS: error (device dm-6) in
> btrfs_run_delayed_refs:3076: errno=-5 IO failure  > Feb 24 22:41:59 home
> kernel: BTRFS info (device dm-6): forced readonly
> 
> static int run_delayed_extent_op(struct btrfs_trans_handle *trans,
>                                   struct btrfs_fs_info *fs_info,
>                                   struct btrfs_delayed_ref_head *head,
>                                   struct btrfs_delayed_extent_op *extent_op) {
> ::
> 
>                  } else {
>                          err = -EIO;
>                          goto out;
>                  }
> ----
> 
>  > but other than that I have never had io errors before, or any other
> troubles.
> 
>   Hm. btrfs dev stat shows real disk IO errors.
>   As this FS isn't mountable .. pls try
>    btrfs dev stat <dev> > file
>    search for 'device stats', there will be one for each disk.
>   Or it reports in the syslog when it happens not necessarily
>   during dedupe.

vm-server ~ # btrfs dev stat /media/storage/
[/dev/mapper/b-storage--b].write_io_errs    0
[/dev/mapper/b-storage--b].read_io_errs     0
[/dev/mapper/b-storage--b].flush_io_errs    0
[/dev/mapper/b-storage--b].corruption_errs  0
[/dev/mapper/b-storage--b].generation_errs  0
[/dev/mapper/a-storage--a].write_io_errs    0
[/dev/mapper/a-storage--a].read_io_errs     0
[/dev/mapper/a-storage--a].flush_io_errs    0
[/dev/mapper/a-storage--a].corruption_errs  0
[/dev/mapper/a-storage--a].generation_errs  0
vm-server ~ # btrfs dev stat /
[/dev/sdb1].write_io_errs    0
[/dev/sdb1].read_io_errs     0
[/dev/sdb1].flush_io_errs    0
[/dev/sdb1].corruption_errs  0
[/dev/sdb1].generation_errs  0
[/dev/sda1].write_io_errs    0
[/dev/sda1].read_io_errs     0
[/dev/sda1].flush_io_errs    0
[/dev/sda1].corruption_errs  0
[/dev/sda1].generation_errs  0
vm-server ~ # btrfs dev stat /dev/mapper/a-backup--a
ERROR: '/dev/mapper/a-backup--a' is not a mounted btrfs device

I check syslog regularly and I haven't seen any errors on any drives for over a year.

> 
>  > One of my other filesystems share the same two discs and it is still fine, so I
> think the hardware is probably ok.
>   Right. I guess that too. A confirmation will be better.
>  > I've copied the beginning of the errors below.
> 
> 
>   At my end finding the root cause of 'parent transid verify failed'
>   during/after dedupe is is kind of fading as disk seems to be had
>   no issues. which I had in mind.
> 
>   Also, there wasn't abrupt power-recycle here? I presume.

No, although now that I think about it I just realised it happened right after I upgraded from 4.15.4 to 4.15.5 and I didn't quit bees before rebooting, I let the system do it. Not sure if it's relevant or not.
I also just noticed that the kernel has spawned hundreds of kworkers - the highest number I can see is 516.

> 
>   It's better to save the output disk1-log and disk2-log as below
>   before further efforts to recovery. Just in case if something
>   pops out.
> 
>    btrfs in dump-super -fa disk1 > disk1-log
>    btrfs in dump-tree --degraded disk1 >> disk1-log [1]

I applied the patch and started dumping the tree, but I stopped it after about 10 mins and 9GB.
Because I use zstd and free space tree the recovery tools wouldn't do anything in RW mode, so I've decided to just blow it away and restore from a backup.
I made a block level copy of both discs in case I need anything.

Thanks for your help anyway.

Regards,
Paul.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
