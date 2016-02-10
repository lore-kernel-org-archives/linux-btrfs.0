Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35920 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609AbcBJJAO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Feb 2016 04:00:14 -0500
Subject: Re: RAID5 Unable to remove Failing HD
To: Rene Castberg <rene@castberg.org>, linux-btrfs@vger.kernel.org
References: <CAKUFzr8gm-yN01CY=H_j6jdEXJL5b0A_vS6gJ5iH1YN1+ZJAvg@mail.gmail.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <56BAFC15.6080106@oracle.com>
Date: Wed, 10 Feb 2016 17:00:05 +0800
MIME-Version: 1.0
In-Reply-To: <CAKUFzr8gm-yN01CY=H_j6jdEXJL5b0A_vS6gJ5iH1YN1+ZJAvg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Rene,

Thanks for the report. Fixes are in the following patch sets

  concern1:
  Btrfs to fail/offline a device for write/flush error:
    [PATCH 00/15] btrfs: Hot spare and Auto replace

  concern2:
  User should be able to delete a device when device has failed:
    [PATCH 0/7] Introduce device delete by devid

  If you were able to tryout these patches, pls lets know.

Thanks, Anand


On 02/10/2016 03:17 PM, Rene Castberg wrote:
> Hi,
>
> This morning i woke up to a failing disk:
>
> [230743.953079] BTRFS: bdev /dev/sdc errs: wr 1573, rd 45648, flush
> 503, corrupt 0, gen 0
> [230743.953970] BTRFS: bdev /dev/sdc errs: wr 1573, rd 45649, flush
> 503, corrupt 0, gen 0
> [230744.106443] BTRFS: lost page write due to I/O error on /dev/sdc
> [230744.180412] BTRFS: lost page write due to I/O error on /dev/sdc
> [230760.116173] btrfs_dev_stat_print_on_error: 5 callbacks suppressed
> [230760.116176] BTRFS: bdev /dev/sdc errs: wr 1577, rd 45651, flush
> 503, corrupt 0, gen 0
> [230760.726244] BTRFS: bdev /dev/sdc errs: wr 1577, rd 45652, flush
> 503, corrupt 0, gen 0
> [230761.392939] btrfs_end_buffer_write_sync: 2 callbacks suppressed
> [230761.392947] BTRFS: lost page write due to I/O error on /dev/sdc
> [230761.392953] BTRFS: bdev /dev/sdc errs: wr 1578, rd 45652, flush
> 503, corrupt 0, gen 0
> [230761.393813] BTRFS: lost page write due to I/O error on /dev/sdc
> [230761.393818] BTRFS: bdev /dev/sdc errs: wr 1579, rd 45652, flush
> 503, corrupt 0, gen 0
> [230761.394843] BTRFS: lost page write due to I/O error on /dev/sdc
> [230761.394849] BTRFS: bdev /dev/sdc errs: wr 1580, rd 45652, flush
> 503, corrupt 0, gen 0
> [230802.000425] nfsd: last server has exited, flushing export cache
> [230898.791862] BTRFS: lost page write due to I/O error on /dev/sdc
> [230898.791873] BTRFS: bdev /dev/sdc errs: wr 1581, rd 45652, flush
> 503, corrupt 0, gen 0
> [230898.792746] BTRFS: lost page write due to I/O error on /dev/sdc
> [230898.792752] BTRFS: bdev /dev/sdc errs: wr 1582, rd 45652, flush
> 503, corrupt 0, gen 0
> [230898.793723] BTRFS: lost page write due to I/O error on /dev/sdc
> [230898.793728] BTRFS: bdev /dev/sdc errs: wr 1583, rd 45652, flush
> 503, corrupt 0, gen 0
> [230898.830893] BTRFS info (device sdd): allowing degraded mounts
> [230898.830902] BTRFS info (device sdd): disk space caching is enabled
>
> Eventually i remounted it as degraded, hopefully to prevent any loss of data.
>
> It seems taht the btrfs filesystem still hasn't noticed that the disk
> has failed:
> $btrfs fi show
> Label: 'RenesData'  uuid: ee80dae2-7c86-43ea-a253-c8f04589b496
>          Total devices 5 FS bytes used 5.38TiB
>          devid    1 size 2.73TiB used 1.84TiB path /dev/sdb
>          devid    2 size 2.73TiB used 1.84TiB path /dev/sde
>          devid    3 size 3.64TiB used 1.84TiB path /dev/sdf
>          devid    4 size 2.73TiB used 1.84TiB path /dev/sdd
>          devid    5 size 3.64TiB used 1.84TiB path /dev/sdc
>
> I tried deleting the device:
> # btrfs device delete /dev/sdc /mnt2/RenesData/
> ERROR: error removing device '/dev/sdc': Invalid argument
>
> I have been unlucky and already had a failure last friday, where a
> RAID5 array failed after a disk failure.  I rebooted, and the data was
> unrecoverable. Fortunately this was only temp data so the failure
> wasn't a real issue.
>
> Can somebody give me some advice how to delete the failing disk? I
> plan on replacing the disk but unfortunately the system doesn't have
> hotplug, so i will need to shutdown to replace the disk without
> loosing any of the data stored on these devices.
>
> Regards
>
> Rene Castberg
>
> # uname -a
> Linux midgard 4.3.3-1.el7.elrepo.x86_64 #1 SMP Tue Dec 15 11:18:19 EST
> 2015 x86_64 x86_64 x86_64 GNU/Linux
> [root@midgard ~]# btrfs --version
> btrfs-progs v4.3.1
> [root@midgard ~]# btrfs fi df  /mnt2/RenesData/
> Data, RAID6: total=5.52TiB, used=5.37TiB
> System, RAID6: total=96.00MiB, used=480.00KiB
> Metadata, RAID6: total=17.53GiB, used=11.86GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
>
>
> # btrfs device stats /mnt2/RenesData/
> [/dev/sdb].write_io_errs   0
> [/dev/sdb].read_io_errs    0
> [/dev/sdb].flush_io_errs   0
> [/dev/sdb].corruption_errs 0
> [/dev/sdb].generation_errs 0
> [/dev/sde].write_io_errs   0
> [/dev/sde].read_io_errs    0
> [/dev/sde].flush_io_errs   0
> [/dev/sde].corruption_errs 0
> [/dev/sde].generation_errs 0
> [/dev/sdf].write_io_errs   0
> [/dev/sdf].read_io_errs    0
> [/dev/sdf].flush_io_errs   0
> [/dev/sdf].corruption_errs 0
> [/dev/sdf].generation_errs 0
> [/dev/sdd].write_io_errs   0
> [/dev/sdd].read_io_errs    0
> [/dev/sdd].flush_io_errs   0
> [/dev/sdd].corruption_errs 0
> [/dev/sdd].generation_errs 0
> [/dev/sdc].write_io_errs   1583
> [/dev/sdc].read_io_errs    45652
> [/dev/sdc].flush_io_errs   503
> [/dev/sdc].corruption_errs 0
> [/dev/sdc].generation_errs 0
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
