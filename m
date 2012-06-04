Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:45543 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755204Ab2FDPIi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Jun 2012 11:08:38 -0400
Received: by vbbff1 with SMTP id ff1so2509153vbb.19
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Jun 2012 08:08:37 -0700 (PDT)
Message-ID: <4FCCCF74.8070501@gmail.com>
Date: Mon, 04 Jun 2012 11:08:36 -0400
From: Maxim Mikheev <mikhmv@gmail.com>
MIME-Version: 1.0
To: Stefan Behrens <sbehrens@giantdisaster.de>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Help with recover data
References: <4FC54A5D.8000600@gmail.com> <4FCCA8E3.7080209@giantdisaster.de> <4FCCA983.50400@gmail.com> <4FCCB20A.7010300@giantdisaster.de> <4FCCC176.1020007@gmail.com> <4FCCCE02.3010506@giantdisaster.de>
In-Reply-To: <4FCCCE02.3010506@giantdisaster.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Can I roll back to 9095, as all disks has 9095?
How can I send this file to the mailing list?


On 06/04/2012 11:02 AM, Stefan Behrens wrote:
> On Mon, 04 Jun 2012 10:08:54 -0400, Maxim Mikheev wrote:
>> Disks were connected to RocketRaid 2760 directly as JBOD.
>>
>> There is no LVM, MD or encryption. I used plain disks directly.
>>
>> The file system was 55% full (1.7TB from 3TB for each disk).
>>
>> Logs are attached.
>> The error happens at May 29, 13:55.
>>
>> Log contain errors on May 27 for ZFS, It is why I decided to switch to
>> btrfs. On the moment of failure, no ZFS was installed in the system.
> According to the kern.1.log file that you have sent (which is not
> visible on the mailing list because it exceeded the 100,000 chars limit
> of vger.kernel.org), a rebalance operation was active when the disks or
> the RAID controller started to cause IO errors.
>
> There seems to be a bug! Like that a write failure is ignored in btrfs.
> For instance, the result of barrier_all_devices() is ignored. Afterwards
> the superblocks are written referencing trees which have not been
> completely written to disk.
>
>
> ...
> May 29 13:08:07 s0 kernel: [46017.194519] btrfs: relocating block group
> 7236780818432 flags 9
> May 29 13:08:36 s0 kernel: [46046.149492] btrfs: found 18543 extents
> May 29 13:09:03 s0 kernel: [46072.944773] btrfs: found 18543 extents
> May 29 13:09:04 s0 kernel: [46074.317760] btrfs: relocating block group
> 7235707076608 flags 20
> ...
> May 29 13:55:56 s0 kernel: [48882.551881]
> /home/apw/COD/linux/drivers/scsi/mvsas/mv_sas.c 1858:port 6 slot 1
> rx_desc 30001 has error info8000000080000000.
> May 29 13:55:56 s0 kernel: [48882.551918]
> /home/apw/COD/linux/drivers/scsi/mvsas/mv_94xx.c 626:command active
> FFFFFCFD,  slot [1].
> May 29 13:55:56 s0 kernel: [48882.552084] btrfs csum failed ino 62276
> off 1019039744 csum 1546305812 private 3211821089
> May 29 13:55:56 s0 kernel: [48882.552241] btrfs csum failed ino 62276
> off 1018056704 csum 3750159096 private 3390793248
> ...
> May 29 13:55:56 s0 kernel: [48882.553791] btrfs csum failed ino 62276
> off 1018712064 csum 872056089 private 2640477920
> May 29 13:55:56 s0 kernel: [48882.554528]
> /home/apw/COD/linux/drivers/scsi/mvsas/mv_sas.c 1858:port 6 slot 1
> rx_desc 30001 has error info0000000000010000.
> May 29 13:55:56 s0 kernel: [48882.554541]
> /home/apw/COD/linux/drivers/scsi/mvsas/mv_94xx.c 626:command active
> FF3FFEFD,  slot [1].
> May 29 13:55:56 s0 kernel: [48882.555626]
> /home/apw/COD/linux/drivers/scsi/mvsas/mv_sas.c 1858:port 6 slot 22
> rx_desc 30016 has error info0000000001000000.
> May 29 13:55:56 s0 kernel: [48882.555635]
> /home/apw/COD/linux/drivers/scsi/mvsas/mv_94xx.c 626:command active
> FF3FFEFB,  slot [16].
> May 29 13:55:56 s0 kernel: [48882.555659] sd 8:0:3:0: [sde] command
> ffff880006c57800 timed out
> May 29 13:56:00 s0 kernel: [48886.313989] sd 8:0:3:0: [sde] command
> ffff88117af65700 timed out
> ...
> May 29 13:56:00 s0 kernel: [48886.314186] sas: Enter
> sas_scsi_recover_host busy: 31 failed: 31
> May 29 13:56:00 s0 kernel: [48886.314204] sas: trying to find task
> 0xffff881083807640
> May 29 13:56:00 s0 kernel: [48886.314210] sas: sas_scsi_find_task:
> aborting task 0xffff881083807640
> May 29 13:56:00 s0 kernel: [48886.314220]
> /home/apw/COD/linux/drivers/scsi/mvsas/mv_sas.c 1632:mvs_abort_task()
> mvi=ffff8837faa80000 task=ffff881083807640 slot=ffff8837faaa5140 slot_idx=x3
> May 29 13:56:00 s0 kernel: [48886.314231] sas: sas_scsi_find_task: task
> 0xffff881083807640 is aborted
> May 29 13:56:00 s0 kernel: [48886.314236] sas: sas_eh_handle_sas_errors:
> task 0xffff881083807640 is aborted
> ...
> May 29 13:56:00 s0 kernel: [48886.315030] sas: ata10: end_device-8:3:
> cmd error handler
> May 29 13:56:00 s0 kernel: [48886.315108] sas: ata7: end_device-8:0: dev
> error handler
> May 29 13:56:00 s0 kernel: [48886.315138] sas: ata8: end_device-8:1: dev
> error handler
> May 29 13:56:00 s0 kernel: [48886.315168] sas: ata9: end_device-8:2: dev
> error handler
> May 29 13:56:00 s0 kernel: [48886.315193] sas: ata10: end_device-8:3:
> dev error handler
> May 29 13:56:00 s0 kernel: [48886.315219] ata10.00: exception Emask 0x1
> SAct 0x7fffffff SErr 0x0 action 0x6 frozen
> May 29 13:56:00 s0 kernel: [48886.315239] ata10.00: failed command:
> WRITE FPDMA QUEUED
> May 29 13:56:00 s0 kernel: [48886.315255] ata10.00: cmd
> 61/08:00:88:a0:98/00:00:7c:00:00/40 tag 0 ncq 4096 out
> May 29 13:56:00 s0 kernel: [48886.315258]          res
> 41/54:08:68:d6:98/00:00:7c:00:00/40 Emask 0x8d (timeout)
> May 29 13:56:00 s0 kernel: [48886.315278] ata10.00: status: { DRDY ERR }
> May 29 13:56:00 s0 kernel: [48886.315286] ata10.00: error: { UNC IDNF ABRT }
> ...
> May 29 13:56:54 s0 kernel: [48940.752647] btrfs: run_one_delayed_ref
> returned -5
> May 29 13:56:54 s0 kernel: [48940.752652] btrfs: run_one_delayed_ref
> returned -5
> May 29 13:56:54 s0 kernel: [48940.752656]  99 28
> May 29 13:56:54 s0 kernel: [48940.752665] ------------[ cut here
> ]------------
> May 29 13:56:54 s0 kernel: [48940.752669] ------------[ cut here
> ]------------
> May 29 13:56:54 s0 kernel: [48940.752674]  c2 00
> May 29 13:56:54 s0 kernel: [48940.752683] ------------[ cut here
> ]------------
> May 29 13:56:54 s0 kernel: [48940.752747] WARNING: at
> /home/apw/COD/linux/fs/btrfs/super.c:219
> __btrfs_abort_transaction+0xae/0xc0 [btrfs]()
> May 29 13:56:54 s0 kernel: [48940.752760]  30
> May 29 13:56:54 s0 kernel: [48940.752825] WARNING: at
> /home/apw/COD/linux/fs/btrfs/super.c:219
> __btrfs_abort_transaction+0xae/0xc0 [btrfs]()
> May 29 13:56:54 s0 kernel: [48940.752832]  45
> May 29 13:56:54 s0 kernel: [48940.752862] WARNING: at
> /home/apw/COD/linux/fs/btrfs/super.c:219
> __btrfs_abort_transaction+0xae/0xc0 [btrfs]()
> May 29 13:56:54 s0 kernel: [48940.752871]  00
> May 29 13:56:54 s0 kernel: [48940.752876] Hardware name: H8QG6
> May 29 13:56:54 s0 kernel: [48940.752880]  bf
> May 29 13:56:54 s0 kernel: [48940.752884] Hardware name: H8QG6
> May 29 13:56:54 s0 kernel: [48940.752892]  00
> May 29 13:56:54 s0 kernel: [48940.752896] btrfs: Transaction aborted 44
> May 29 13:56:54 s0 kernel: [48940.752902] btrfs: Transaction aborted
> ...
> May 29 13:56:54 s0 kernel: [48940.754032]  [<ffffffffa00db45e>]
> __btrfs_abort_transaction+0xae/0xc0 [btrfs]
> ...
> May 29 13:56:54 s0 kernel: [48940.756438] BTRFS error (device sdg) in
> __btrfs_free_extent:5134: IO failure
> May 29 13:56:54 s0 kernel: [48940.756455] btrfs: run_one_delayed_ref
> returned -5
> May 29 13:56:54 s0 kernel: [48940.756462] BTRFS error (device sdg) in
> btrfs_run_delayed_refs:2454: IO failure
> May 29 13:56:55 s0 kernel: [48940.997869] BUG: unable to handle kernel
> paging request at ffffffffffffff99
> May 29 13:56:55 s0 kernel: [48940.997904] IP: [<ffffffffa012305c>]
> btrfs_dec_test_ordered_pending+0xdc/0x220 [btrfs]
> May 29 13:56:55 s0 kernel: [48940.998631] Call Trace:
> May 29 13:56:55 s0 kernel: [48940.998682]  [<ffffffffa010e838>]
> btrfs_finish_ordered_io+0x58/0x3c0 [btrfs]
> May 29 13:56:55 s0 kernel: [48940.998714]  [<ffffffff8103ff59>] ?
> default_spin_lock_flags+0x9/0x10
> May 29 13:56:55 s0 kernel: [48940.998739]  [<ffffffff8166c7bf>] ?
> _raw_spin_lock_irqsave+0x2f/0x40
> May 29 13:56:55 s0 kernel: [48940.998796]  [<ffffffffa010ebf1>]
> btrfs_writepage_end_io_hook+0x51/0xa0 [btrfs]
> May 29 13:56:55 s0 kernel: [48940.998860]  [<ffffffffa0127b39>]
> end_extent_writepage+0x69/0x100 [btrfs]
> May 29 13:56:55 s0 kernel: [48940.998919]  [<ffffffffa0127c36>]
> end_bio_extent_writepage+0x66/0xa0 [btrfs]
> May 29 13:56:55 s0 kernel: [48940.998949]  [<ffffffff811b80fd>]
> bio_endio+0x1d/0x40
> May 29 13:56:55 s0 kernel: [48940.999009]  [<ffffffffa00fbe45>]
> end_workqueue_fn+0x45/0x50 [btrfs]
> May 29 13:56:55 s0 kernel: [48940.999058]  [<ffffffffa013433c>]
> worker_loop+0x16c/0x510 [btrfs]
