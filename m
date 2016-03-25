Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:33540 "EHLO
	mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883AbcCYUJK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Mar 2016 16:09:10 -0400
Received: by mail-lf0-f54.google.com with SMTP id f67so6119522lfb.0
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Mar 2016 13:09:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAA7pwKP90OTQLdOw4LHtGxZEBWhz3bZCam2E2-CHwA1p9CMdnA@mail.gmail.com>
References: <1458906560.3786108.559411242.3678497C@webmail.messagingengine.com>
	<CAA7pwKNj+qEUk+RhzyceRFqThzhUkroYMxS3b3gAn_5KEyawMQ@mail.gmail.com>
	<CAA7pwKNgDi9C8E+duwNA6H8MrT1nVEHkWAm4=JZp3GjFgAvZ1g@mail.gmail.com>
	<1458926454.3855039.559662618.4F365498@webmail.messagingengine.com>
	<CAA7pwKP90OTQLdOw4LHtGxZEBWhz3bZCam2E2-CHwA1p9CMdnA@mail.gmail.com>
Date: Fri, 25 Mar 2016 21:09:08 +0100
Message-ID: <CAGGqMYR9LdCiqHfO5Rn5zY1G7_YKYjrEzkovTVVaFRXqQ7vpeQ@mail.gmail.com>
Subject: Re: Possible Raid Bug
From: Alexander Fougner <fougner89@gmail.com>
To: Patrik Lundquist <patrik.lundquist@gmail.com>
Cc: Stephen Williams <stephenw@veryfast.biz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2016-03-25 20:57 GMT+01:00 Patrik Lundquist <patrik.lundquist@gmail.com>:
> On 25 March 2016 at 18:20, Stephen Williams <stephenw@veryfast.biz> wrote:
>>
>> Your information below was very helpful and I was able to recreate the
>> Raid array. However my initial question still stands - What if the
>> drives dies completely? I work in a Data center and we see this quite a
>> lot where a drive is beyond dead - The OS will literally not detect it.
>
> That's currently a weakness of Btrfs. I don't know how people deal
> with it in production. I think Anand Jain is working on improving it.
>
>> At this point would the Raid10 array be beyond repair? As you need the
>> drive present in order to mount the array in degraded mode.
>
> Right... let's try it again but a little bit differently.
>
> # mount /dev/sdb /mnt
>
> Let's drop the disk.
>
> # echo 1 >/sys/block/sde/device/delete
>
> [ 3669.024256] sd 5:0:0:0: [sde] Synchronizing SCSI cache
> [ 3669.024934] sd 5:0:0:0: [sde] Stopping disk
> [ 3669.037028] ata6.00: disabled
>
> # touch /mnt/test3
> # sync
>
> [ 3845.960839] BTRFS error (device sdb): bdev /dev/sde errs: wr 1, rd
> 0, flush 0, corrupt 0, gen 0
> [ 3845.961525] BTRFS error (device sdb): bdev /dev/sde errs: wr 2, rd
> 0, flush 0, corrupt 0, gen 0
> [ 3845.962738] BTRFS error (device sdb): bdev /dev/sde errs: wr 3, rd
> 0, flush 0, corrupt 0, gen 0
> [ 3845.963038] BTRFS error (device sdb): bdev /dev/sde errs: wr 4, rd
> 0, flush 0, corrupt 0, gen 0
> [ 3845.963422] BTRFS error (device sdb): bdev /dev/sde errs: wr 4, rd
> 0, flush 1, corrupt 0, gen 0
> [ 3845.963686] BTRFS warning (device sdb): lost page write due to IO
> error on /dev/sde
> [ 3845.963691] BTRFS error (device sdb): bdev /dev/sde errs: wr 5, rd
> 0, flush 1, corrupt 0, gen 0
> [ 3845.963932] BTRFS warning (device sdb): lost page write due to IO
> error on /dev/sde
> [ 3845.963941] BTRFS error (device sdb): bdev /dev/sde errs: wr 6, rd
> 0, flush 1, corrupt 0, gen 0
>
> # umount /mnt
>
> [ 4095.276831] BTRFS error (device sdb): bdev /dev/sde errs: wr 7, rd
> 0, flush 1, corrupt 0, gen 0
> [ 4095.278368] BTRFS error (device sdb): bdev /dev/sde errs: wr 8, rd
> 0, flush 1, corrupt 0, gen 0
> [ 4095.279152] BTRFS error (device sdb): bdev /dev/sde errs: wr 8, rd
> 0, flush 2, corrupt 0, gen 0
> [ 4095.279373] BTRFS warning (device sdb): lost page write due to IO
> error on /dev/sde
> [ 4095.279377] BTRFS error (device sdb): bdev /dev/sde errs: wr 9, rd
> 0, flush 2, corrupt 0, gen 0
> [ 4095.279609] BTRFS warning (device sdb): lost page write due to IO
> error on /dev/sde
> [ 4095.279612] BTRFS error (device sdb): bdev /dev/sde errs: wr 10, rd
> 0, flush 2, corrupt 0, gen 0
>
> # mount -o degraded /dev/sdb /mnt
>
> [ 4608.113751] BTRFS info (device sdb): allowing degraded mounts
> [ 4608.113756] BTRFS info (device sdb): disk space caching is enabled
> [ 4608.113757] BTRFS: has skinny extents
> [ 4608.116557] BTRFS info (device sdb): bdev /dev/sde errs: wr 6, rd
> 0, flush 1, corrupt 0, gen 0
>
> # touch /mnt/test4
> # sync
>
> Writing to the filesystem works while the device is missing.
> No new errors in dmesg after re-mounting degraded. Reboot to get back /dev/sde.
>
> [    4.329852] BTRFS: device fsid 75737bea-d76c-42f5-b0e6-7d346e38610d
> devid 4 transid 26 /dev/sde
> [    4.330157] BTRFS: device fsid 75737bea-d76c-42f5-b0e6-7d346e38610d
> devid 3 transid 31 /dev/sdd
> [    4.330511] BTRFS: device fsid 75737bea-d76c-42f5-b0e6-7d346e38610d
> devid 2 transid 31 /dev/sdc
> [    4.330865] BTRFS: device fsid 75737bea-d76c-42f5-b0e6-7d346e38610d
> devid 1 transid 31 /dev/sdb
>
> /dev/sde transid is lagging behind, of course.
>
> # wipefs -a /dev/sde
> # btrfs device scan
>
> # mount -o degraded /dev/sdb /mnt
>
> [  507.248621] BTRFS info (device sdb): allowing degraded mounts
> [  507.248626] BTRFS info (device sdb): disk space caching is enabled
> [  507.248628] BTRFS: has skinny extents
> [  507.252815] BTRFS info (device sdb): bdev /dev/sde errs: wr 6, rd
> 0, flush 1, corrupt 0, gen 0
> [  507.252919] BTRFS: missing devices(1) exceeds the limit(0),

single/dup profile has zero-limit tolerance for missing devices. Only
ro-mount allowed in that case.

> writeable mount is not allowed
> [  507.278277] BTRFS: open_ctree failed
>
> Well, that was unexpected! Reboot again.
>
> # mount -o degraded /dev/sdb /mnt
>
> [   94.368514] BTRFS info (device sdd): allowing degraded mounts
> [   94.368519] BTRFS info (device sdd): disk space caching is enabled
> [   94.368521] BTRFS: has skinny extents
> [   94.370909] BTRFS warning (device sdd): devid 4 uuid
> 8549a275-f663-4741-b410-79b49a1d465f is missing
> [   94.372170] BTRFS info (device sdd): bdev (null) errs: wr 6, rd 0,
> flush 1, corrupt 0, gen 0
> [   94.372284] BTRFS: missing devices(1) exceeds the limit(0),
> writeable mount is not allowed
> [   94.395021] BTRFS: open_ctree failed
>
> No go.
>
> # mount -o degraded,ro /dev/sdb /mnt
> # btrfs device stats /mnt
> [/dev/sdb].write_io_errs   0
> [/dev/sdb].read_io_errs    0
> [/dev/sdb].flush_io_errs   0
> [/dev/sdb].corruption_errs 0
> [/dev/sdb].generation_errs 0
> [/dev/sdc].write_io_errs   0
> [/dev/sdc].read_io_errs    0
> [/dev/sdc].flush_io_errs   0
> [/dev/sdc].corruption_errs 0
> [/dev/sdc].generation_errs 0
> [/dev/sdd].write_io_errs   0
> [/dev/sdd].read_io_errs    0
> [/dev/sdd].flush_io_errs   0
> [/dev/sdd].corruption_errs 0
> [/dev/sdd].generation_errs 0
> [(null)].write_io_errs   6
> [(null)].read_io_errs    0
> [(null)].flush_io_errs   1
> [(null)].corruption_errs 0
> [(null)].generation_errs 0
>
> Only errors on the device formerly known as /dev/sde, so why won't it
> mount degraded,rw? Now I'm stuck like Stephen.
>

Because during the first degraded mount single profile chunks were created.
I believe this is what Anand is working on. To actually check device
degradation on a blockgroup basis rather than on FS basis.

> # btrfs device usage /mnt
> /dev/sdb, ID: 1
>    Device size:             2.00GiB
>    Data,single:           624.00MiB
>    Data,RAID10:           102.38MiB
>    Metadata,RAID10:       102.38MiB
>    System,RAID10:           4.00MiB
>    Unallocated:             1.19GiB
>
> /dev/sdc, ID: 2
>    Device size:             2.00GiB
>    Data,RAID10:           102.38MiB
>    Metadata,RAID10:       102.38MiB
>    System,single:          32.00MiB
>    System,RAID10:           4.00MiB
>    Unallocated:             1.76GiB
>
> /dev/sdd, ID: 3
>    Device size:             2.00GiB
>    Data,RAID10:           102.38MiB
>    Metadata,single:       256.00MiB
>    Metadata,RAID10:       102.38MiB
>    System,RAID10:           4.00MiB
>    Unallocated:             1.55GiB
>
> missing, ID: 4
>    Device size:               0.00B
>    Data,RAID10:           102.38MiB
>    Metadata,RAID10:       102.38MiB
>    System,RAID10:           4.00MiB
>    Unallocated:             1.80GiB
>
> The data written while mounted degraded is in profile 'single' and
> will have to be converted to 'raid10' once the filesystem is whole
> again.
>
> So what do I do now? Why did it degrade further after a reboot?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
