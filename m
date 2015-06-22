Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vn0-f43.google.com ([209.85.216.43]:38931 "EHLO
	mail-vn0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbbFVQwo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Jun 2015 12:52:44 -0400
Received: by vnav203 with SMTP id v203so5503607vna.6
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Jun 2015 09:52:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGqmi774WEukmUt9NAFZQ8R9kCCyOFm3M_TP2ULgvtgpDnMM1w@mail.gmail.com>
References: <556457b8.e72b980a.ee08.ffffce60@mx.google.com>
	<CAJCQCtQFyCEn3kdeYOrOyk_vqekNH_MiOyA=WSOxLCoQS6PV1w@mail.gmail.com>
	<CAGqmi75OK8ofM7p0SqUsy8WhW3ZveQ_3NMtQCAchmHnUP7KoPg@mail.gmail.com>
	<CAGqmi757StwNda-8y-zvjB-8cVrWLd=R8xuZnvzdwhhmxbTuXw@mail.gmail.com>
	<CAJCQCtROb83vdCcv=GHG+eOB99u+LAgSUARPX0FedL8hn2Be2w@mail.gmail.com>
	<CAGqmi774WEukmUt9NAFZQ8R9kCCyOFm3M_TP2ULgvtgpDnMM1w@mail.gmail.com>
Date: Mon, 22 Jun 2015 10:52:43 -0600
Message-ID: <CAJCQCtTXiWWie+OtkdNhjmUEjPoyx565LZ15KC3Kfr7DC9ucpQ@mail.gmail.com>
Subject: Re: RAID1: system stability
From: Chris Murphy <lists@colorremedies.com>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 22, 2015 at 10:36 AM, Timofey Titovets <nefelim4ag@gmail.com> wrote:
> 2015-06-22 19:03 GMT+03:00 Chris Murphy <lists@colorremedies.com>:
>> On Mon, Jun 22, 2015 at 5:35 AM, Timofey Titovets <nefelim4ag@gmail.com> wrote:
>>> Okay, logs, i did release disk /dev/sde1 and get:
>>> Jun 22 14:28:40 srv-lab-ceph-node-01 kernel: Read(10): 28 00 11 1d 69
>>> 00 00 00 08 00
>>> Jun 22 14:28:40 srv-lab-ceph-node-01 kernel: blk_update_request: I/O
>>> error, dev sde, sector 287140096
>>> Jun 22 14:28:40 srv-lab-ceph-node-01 kernel: mptbase: ioc0:
>>> LogInfo(0x31010011): Originator={PL}, Code={Open Failure},
>>> SubCode(0x0011) cb_idx mptscsih_io_done
>>> Jun 22 14:28:40 srv-lab-ceph-node-01 kernel: sd 0:0:5:0: [sde] FAILED
>>> Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
>>> Jun 22 14:28:40 srv-lab-ceph-node-01 kernel: sd 0:0:5:0: [sde] CDB:
>>> Jun 22 14:28:40 srv-lab-ceph-node-01 kernel: Read(10): 28 00 11 1d 69
>>> 00 00 00 08 00
>>> Jun 22 14:28:40 srv-lab-ceph-node-01 kernel: blk_update_request: I/O
>>> error, dev sde, sector 287140096
>>
>> So what's up with this? This only happens after you try to (software)
>> remove /dev/sde1? Or is it happening also before that? Because this
>> looks like some kind of hardware problem when the drive is reporting
>> an error for a particular sector on read, as if it's a bad sector.
>
> Nope, i've physically remove device and as you see it's produce errors
> on block layer -.-
> and this disks have 100% 'health'
>
> Because it's hot-plug device, kernel see what device now missing and
> remove all kernel objects reletad to them.

OK I actually don't know what the intended block layer behavior is
when unplugging a device, if it is supposed to vanish, or change state
somehow so that thing that depend on it can know it's "missing" or
what. So the question here is, is this working as intended? If the
layer Btrfs depends on isn't working as intended, then Btrfs is
probably going to do wild and crazy things. And I don't know that the
part of the block layer Btrfs depends on for this is the same (or
different) as what the md driver depends on.


>
>>
>>> Jun 22 14:28:40 srv-lab-ceph-node-01 kernel: Buffer I/O error on dev sde1, logical block 35892256, async page read
>>> Jun 22 14:28:40 srv-lab-ceph-node-01 kernel: mptbase: ioc0: LogInfo(0x31010011): Originator={PL}, Code={Open Failure},
>>> SubCode(0x0011) cb_idx mptscsih_io_done
>>> Jun 22 14:28:40 srv-lab-ceph-node-01 kernel: mptbase: ioc0: LogInfo(0x31010011): Originator={PL}, Code={Open Failure},
>>> SubCode(0x0011) cb_idx mptscsih_io_done
>>> Jun 22 14:28:40 srv-lab-ceph-node-01 kernel: sd 0:0:5:0: [sde] FAILED Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
>>> Jun 22 14:28:40 srv-lab-ceph-node-01 kernel: sd 0:0:5:0: [sde] CDB:
>>> Jun 22 14:28:40 srv-lab-ceph-node-01 kernel: Read(10): 28 00 11 1d 69 00 00 00 08 00
>>> Jun 22 14:28:40 srv-lab-ceph-node-01 kernel: blk_update_request: I/O error, dev sde, sector 287140096
>>
>> Again same sector as before. This is not a Btrfs error message, it's
>> coming from the block layer.
>>
>>
>>> Jun 22 14:28:40 srv-lab-ceph-node-01 kernel: Buffer I/O error on dev sde1, logical block 35892256, async page read
>>
>> I'm not a dev so take it with a grain of salt but because this
>> references a logical block, this is the layer in between Btrfs and the
>> physical device. Btrfs works on logical blocks and those have to be
>> translated to device and physical sector. Maybe what's happening is
>> there's confusion somewhere about this device not actually being
>> unavailable so Btrfs or something else is trying to read this logical
>> block again, which causes a read attempt to happen instead of a flat
>> out "this device doesn't exist" type of error. So I don't know if this
>> is a problem strictly in Btrfs missing device error handling, or if
>> there's something else that's not really working correctly.
>>
>> You could test by physically removing the device, if you have hot plug
>> support (be certain all the hardware components support it), you can
>> see if you get different results. Or you could try to reproduce the
>> software delete of the device with mdraid or lvm raid with XFS and no
>> Btrfs at all, and see if you get different results.
>>
>> It's known that the btrfs multiple device failure use case is weak
>> right now. Data isn't lost, but the error handling, notification, all
>> that is almost non-existent compared to mdadm.
>
> So sad -.-
> i've test this test case with md raid1 and system continue work
> without problem when i release one of two md device

OK well then it's either a Btrfs bug or something it directly depends
on that md does not.


> You right about usb devices, it's not produce oops.
> May be its because kernel use different modules for SAS/SATA disks and
> usb sticks.

They appear as sd devices on my system, so they're using libata and as
such they ultimately still depend on the SCSI block layer. But there
may be a very different kind of missing device error handling for USB
that somehow makes its way up to libata differently than SAS/SATA
hotplug.

I'd say the oops is definitely a Btrfs bug. But it might also be worth
while to post the kernel messages to linux-scsi@ list, listing the
hardware details (logic board, SAS/SATA card, drives) and of course
the full kernel messages along with reproduce steps and see if the
fact the device doesn't actually drop out like with USB devices is
intended behavior.


-- 
Chris Murphy
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
