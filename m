Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:34220 "EHLO
        mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752066AbdHPBvx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Aug 2017 21:51:53 -0400
Received: by mail-qk0-f182.google.com with SMTP id u139so13292727qka.1
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Aug 2017 18:51:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <dfb985f1-bfab-ddb9-e727-fa042619cd0b@gmx.com>
References: <CADJPUQ9awnz30XzGZLGQAUhAqeH5ek6stDN5N5JTzc3dGtdiug@mail.gmail.com>
 <dfb985f1-bfab-ddb9-e727-fa042619cd0b@gmx.com>
From: Paulo Dias <paulo.miguel.dias@gmail.com>
Date: Tue, 15 Aug 2017 22:51:31 -0300
Message-ID: <CADJPUQ-Rok_oWe0_0ZPDZ10vVSsM8iOKd5P=4ZSyXfq_ZU2EPw@mail.gmail.com>
Subject: Re: qcow2 images make scrub believe the filesystem is corrupted.
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, thanks for the quick answer.

So, since i wrote this i tested this even further.

First, and as you predicted, if i try to cp the file to another
location i get read errors:

root@kerberos:/home/groo# cp Fedora/Fedora.qcow2 /
cp: error reading 'Fedora/Fedora.qcow2': Input/output error

so i used this trick:

# modprobe nbd
# qemu-nbd --connect=/dev/nbd0 Fedora2.qcow2
# ddrescue /dev/nbd0 new_file.raw
# qemu-nbd --disconnect /dev/nbd0
# qemu-img convert -O qcow2 new_file.raw new_file.qcow2

and sure enough i was able to recreate the qcow2 but with this errors:

ago 15 22:19:49 kerberos kernel: block nbd0: Other side returned error (5)
ago 15 22:19:49 kerberos kernel: print_req_error: I/O error, dev nbd0,
sector 22159872
ago 15 22:19:49 kerberos kernel: BTRFS warning (device sda3): csum
failed root 258 ino 968837 off 17455849472 csum 0xcc028588 expected
csum 0xe3338de1 mirror 1
ago 15 22:19:49 kerberos kernel: block nbd0: Other side returned error (5)
ago 15 22:19:49 kerberos kernel: print_req_error: I/O error, dev nbd0,
sector 22160016
ago 15 22:19:49 kerberos kernel: Buffer I/O error on dev nbd0, logical
block 2770002, async page read
ago 15 22:19:49 kerberos kernel: BTRFS warning (device sda3): csum
failed root 258 ino 968837 off 17455849472 csum 0xcc028588 expected
csum 0xe3338de1 mirror 1
ago 15 22:19:49 kerberos kernel: block nbd0: Other side returned error (5)
ago 15 22:19:49 kerberos kernel: print_req_error: I/O error, dev nbd0,
sector 22160016
ago 15 22:19:49 kerberos kernel: Buffer I/O error on dev nbd0, logical
block 2770002, async page read
ago 15 22:20:47 kerberos kernel: BTRFS warning (device sda3): csum
failed root 258 ino 968837 off 17455849472 csum 0xcc028588 expected
csum 0xe3338de1 mirror 1
ago 15 22:20:47 kerberos kernel: BTRFS warning (device sda3): csum
failed root 258 ino 968837 off 17455849472 csum 0xcc028588 expected
csum 0xe3338de1 mirror 1
ago 15 22:20:47 kerberos kernel: block nbd0: Other side returned error (5)
ago 15 22:20:47 kerberos kernel: print_req_error: I/O error, dev nbd0,
sector 22160016
ago 15 22:20:47 kerberos kernel: BTRFS warning (device sda3): csum
failed root 258 ino 968837 off 17455849472 csum 0xcc028588 expected
csum 0xe3338de1 mirror 1
ago 15 22:20:47 kerberos kernel: block nbd0: Other side returned error (5)
ago 15 22:20:47 kerberos kernel: print_req_error: I/O error, dev nbd0,
sector 22160016
ago 15 22:20:47 kerberos kernel: Buffer I/O error on dev nbd0, logical
block 2770002, async page read
ago 15 22:20:47 kerberos kernel: BTRFS warning (device sda3): csum
failed root 258 ino 968837 off 17455849472 csum 0xcc028588 expected
csum 0xe3338de1 mirror 1
ago 15 22:20:47 kerberos kernel: block nbd0: Other side returned error (5)
ago 15 22:20:47 kerberos kernel: print_req_error: I/O error, dev nbd0,
sector 22160016
ago 15 22:20:47 kerberos kernel: Buffer I/O error on dev nbd0, logical
block 2770002, async page read
ago 15 22:20:47 kerberos kernel: BTRFS warning (device sda3): csum
failed root 258 ino 968837 off 17455849472 csum 0xcc028588 expected
csum 0xe3338de1 mirror 1
ago 15 22:20:47 kerberos kernel: block nbd0: Other side returned error (5)
ago 15 22:20:47 kerberos kernel: print_req_error: I/O error, dev nbd0,
sector 22160016
ago 15 22:20:47 kerberos kernel: Buffer I/O error on dev nbd0, logical
block 2770002, async page read
ago 15 22:20:47 kerberos kernel: BTRFS warning (device sda3): csum
failed root 258 ino 968837 off 17455849472 csum 0xcc028588 expected
csum 0xe3338de1 mirror 1
ago 15 22:20:47 kerberos kernel: block nbd0: Other side returned error (5)
ago 15 22:20:47 kerberos kernel: print_req_error: I/O error, dev nbd0,
sector 22160016
ago 15 22:20:47 kerberos kernel: Buffer I/O error on dev nbd0, logical
block 2770002, async page read
ago 15 22:20:47 kerberos kernel: BTRFS warning (device sda3): csum
failed root 258 ino 968837 off 17455849472 csum 0xcc028588 expected
csum 0xe3338de1 mirror 1
ago 15 22:20:47 kerberos kernel: block nbd0: Other side returned error (5)
ago 15 22:20:47 kerberos kernel: print_req_error: I/O error, dev nbd0,
sector 22160016
ago 15 22:20:47 kerberos kernel: Buffer I/O error on dev nbd0, logical
block 2770002, async page read
ago 15 22:20:47 kerberos kernel: BTRFS warning (device sda3): csum
failed root 258 ino 968837 off 17455849472 csum 0xcc028588 expected
csum 0xe3338de1 mirror 1
ago 15 22:20:47 kerberos kernel: block nbd0: Other side returned error (5)
ago 15 22:20:47 kerberos kernel: print_req_error: I/O error, dev nbd0,
sector 22160016
ago 15 22:20:47 kerberos kernel: Buffer I/O error on dev nbd0, logical
block 2770002, async page read
ago 15 22:20:47 kerberos kernel: BTRFS warning (device sda3): csum
failed root 258 ino 968837 off 17455849472 csum 0xcc028588 expected
csum 0xe3338de1 mirror 1
ago 15 22:20:47 kerberos kernel: block nbd0: Other side returned error (5)
ago 15 22:20:47 kerberos kernel: print_req_error: I/O error, dev nbd0,
sector 22160016
ago 15 22:20:47 kerberos kernel: Buffer I/O error on dev nbd0, logical
block 2770002, async page read
ago 15 22:20:47 kerberos kernel: BTRFS warning (device sda3): csum
failed root 258 ino 968837 off 17455849472 csum 0xcc028588 expected
csum 0xe3338de1 mirror 1
ago 15 22:20:47 kerberos kernel: block nbd0: Other side returned error (5)
ago 15 22:20:47 kerberos kernel: print_req_error: I/O error, dev nbd0,
sector 22160016
ago 15 22:20:47 kerberos kernel: Buffer I/O error on dev nbd0, logical
block 2770002, async page read
ago 15 22:21:32 kerberos kernel: block nbd0: NBD_DISCONNECT
ago 15 22:21:32 kerberos kernel: block nbd0: shutting down sockets

i deleted the original Fedora.qcow2 and again scrub said i didnt had
any errors, so i wondered, could it be the raid1 code (long shot), so
i moved the metadata back to DUP.

btrfs fi balance start -dconvert=single -mconvert=dup /home/

root@kerberos:/home/groo# btrfs filesystem usage -T /home/
Overall:
    Device size:                 333.50GiB
    Device allocated:             18.06GiB
    Device unallocated:          315.44GiB
    Device missing:                  0.00B
    Used:                         16.25GiB
    Free (estimated):            315.83GiB      (min: 158.11GiB)
    Data ratio:                       1.00
    Metadata ratio:                   2.00
    Global reserve:               39.45MiB      (used: 0.00B)

             Data     Metadata  System
Id Path      single   DUP       DUP      Unallocated
-- --------- -------- --------- -------- -----------
 1 /dev/sda3 16.00GiB   2.00GiB 64.00MiB   181.94GiB
 2 /dev/sdb7        -         -        -   133.03GiB
 3 /dev/sdb8        -         -        -   488.13MiB
-- --------- -------- --------- -------- -----------
   Total     16.00GiB   1.00GiB 32.00MiB   315.44GiB
   Used      15.61GiB 329.27MiB 16.00KiB

and once again copied the NEW fedora.qcow2 back to home and rerun scrub

and once again i got errors:

root@kerberos:/home/groo# btrfs scrub start -B /home/
scrub done for ae9ae869-720d-4643-b673-6924d09b2fe0
        scrub started at Tue Aug 15 22:36:32 2017 and finished after 00:01:04
        total bytes scrubbed: 32.56GiB with 13 errors
        error details: csum=13
        corrected errors: 0, uncorrectable errors: 13, unverified errors: 0

ago 15 22:37:36 kerberos kernel: BTRFS error (device sda3): bdev
/dev/sda3 errs: wr 0, rd 0, flush 0, corrupt 35, gen 0
ago 15 22:37:36 kerberos kernel: BTRFS error (device sda3): unable to
fixup (regular) error at logical 418909777920 on dev /dev/sda3
ago 15 22:37:36 kerberos kernel: BTRFS error (device sda3): bdev
/dev/sda3 errs: wr 0, rd 0, flush 0, corrupt 36, gen 0
ago 15 22:37:36 kerberos kernel: BTRFS error (device sda3): unable to
fixup (regular) error at logical 418913218560 on dev /dev/sda3
ago 15 22:37:36 kerberos kernel: BTRFS error (device sda3): bdev
/dev/sda3 errs: wr 0, rd 0, flush 0, corrupt 37, gen 0
ago 15 22:37:36 kerberos kernel: BTRFS error (device sda3): unable to
fixup (regular) error at logical 418913234944 on dev /dev/sda3
ago 15 22:37:36 kerberos kernel: BTRFS error (device sda3): bdev
/dev/sda3 errs: wr 0, rd 0, flush 0, corrupt 38, gen 0
ago 15 22:37:36 kerberos kernel: BTRFS error (device sda3): unable to
fixup (regular) error at logical 418909618176 on dev /dev/sda3
ago 15 22:37:36 kerberos kernel: BTRFS error (device sda3): bdev
/dev/sda3 errs: wr 0, rd 0, flush 0, corrupt 39, gen 0
ago 15 22:37:36 kerberos kernel: BTRFS error (device sda3): unable to
fixup (regular) error at logical 418909630464 on dev /dev/sda3
ago 15 22:37:36 kerberos kernel: BTRFS error (device sda3): bdev
/dev/sda3 errs: wr 0, rd 0, flush 0, corrupt 40, gen 0
ago 15 22:37:36 kerberos kernel: BTRFS error (device sda3): unable to
fixup (regular) error at logical 418910056448 on dev /dev/sda3
ago 15 22:37:36 kerberos kernel: BTRFS error (device sda3): bdev
/dev/sda3 errs: wr 0, rd 0, flush 0, corrupt 41, gen 0
ago 15 22:37:36 kerberos kernel: BTRFS error (device sda3): unable to
fixup (regular) error at logical 418910064640 on dev /dev/sda3
ago 15 22:37:36 kerberos kernel: BTRFS error (device sda3): bdev
/dev/sda3 errs: wr 0, rd 0, flush 0, corrupt 42, gen 0
ago 15 22:37:36 kerberos kernel: BTRFS error (device sda3): unable to
fixup (regular) error at logical 418913071104 on dev /dev/sda3
ago 15 22:37:36 kerberos kernel: BTRFS error (device sda3): bdev
/dev/sda3 errs: wr 0, rd 0, flush 0, corrupt 43, gen 0
ago 15 22:37:36 kerberos kernel: BTRFS error (device sda3): unable to
fixup (regular) error at logical 418912890880 on dev /dev/sda3
ago 15 22:37:36 kerberos kernel: BTRFS error (device sda3): bdev
/dev/sda3 errs: wr 0, rd 0, flush 0, corrupt 44, gen 0
ago 15 22:37:36 kerberos kernel: BTRFS error (device sda3): unable to
fixup (regular) error at logical 418912997376 on dev /dev/sda3

since i still have the original (recovered) Fedora.qcow2 back in the
root volume, i went back and changed the medatada back to raid1.

root@kerberos:/home/groo# btrfs filesystem usage -T /home/
Overall:
    Device size:                 333.50GiB
    Device allocated:             18.06GiB
    Device unallocated:          315.44GiB
    Device missing:                  0.00B
    Used:                         16.25GiB
    Free (estimated):            315.83GiB      (min: 158.11GiB)
    Data ratio:                       1.00
    Metadata ratio:                   2.00
    Global reserve:               38.98MiB      (used: 0.00B)

             Data     Metadata  System
Id Path      single   RAID1     RAID1    Unallocated
-- --------- -------- --------- -------- -----------
 1 /dev/sda3 16.00GiB   1.00GiB 32.00MiB   182.97GiB
 2 /dev/sdb7        -   1.00GiB 32.00MiB   132.00GiB
 3 /dev/sdb8        -         -        -   488.13MiB
-- --------- -------- --------- -------- -----------
   Total     16.00GiB   1.00GiB 32.00MiB   315.44GiB
   Used      15.61GiB 328.80MiB 16.00KiB

and thats when you answered my email.

now to answer your questions:

Any special setting on the file or the Fedora directory? Like nodatasum?

nope

And is there any special setup like off-line dedupe?

nope

its a plain btrfs setup with discard and thats it.

the qcow2 is the plain one created via libvirt/virt-manager.

also, its not the only one, if i create an image with minishift (a
openshift dockerized solution) i get even more errors, since i have 2
sparse files. if i delete them, the errors go away.

im stumped at this.

any ideas?
| Paulo Dias
| paulo.miguel.dias@gmail.com

Tempora mutantur, nos et mutamur in illis.


On Tue, Aug 15, 2017 at 10:40 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
> On 2017年08月16日 09:12, Paulo Dias wrote:
>>
>> Hello/2 all
>>
>> I'm using libvirt with a qcow2 image and everytime i run btrfs scrub
>> -H /home (subvolume where the image is), i get:
>>
>> ago 15 21:58:08 kerberos kernel: BTRFS error (device sda3): bdev
>> /dev/sda3 errs: wr 0, rd 0, flush 0, corrupt 30, gen 0
>> ago 15 21:58:08 kerberos kernel: BTRFS error (device sda3): unable to
>> fixup (regular) error at logical 289831161856 on dev /dev/sda3
>> ago 15 21:58:08 kerberos kernel: BTRFS error (device sda3): bdev
>> /dev/sda3 errs: wr 0, rd 0, flush 0, corrupt 31, gen 0
>> ago 15 21:58:08 kerberos kernel: BTRFS error (device sda3): unable to
>> fixup (regular) error at logical 289830309888 on dev /dev/sda3
>> ago 15 21:58:08 kerberos kernel: BTRFS error (device sda3): bdev
>> /dev/sda3 errs: wr 0, rd 0, flush 0, corrupt 32, gen 0
>> ago 15 21:58:08 kerberos kernel: BTRFS error (device sda3): unable to
>> fixup (regular) error at logical 289831055360 on dev /dev/sda3
>> ago 15 21:58:08 kerberos kernel: BTRFS error (device sda3): bdev
>> /dev/sda3 errs: wr 0, rd 0, flush 0, corrupt 33, gen 0
>> ago 15 21:58:08 kerberos kernel: BTRFS error (device sda3): unable to
>> fixup (regular) error at logical 289861591040 on dev /dev/sda3
>> ago 15 21:58:09 kerberos kernel: BTRFS warning (device sda3): checksum
>> error at logical 290297204736 on dev /dev/sda3, sector 67982824, root
>> 258, inode 968837, offset 17455849472, length 4096, links 1 (path:
>> groo/Fedora/Fedora.qcow2)
>
>
> Any special setting on the file or the Fedora directory? Like nodatasum?
>
> And is there any special setup like off-line dedupe?
>
> Considering the number of corruption, only less than 50 and not continuous
> at all, it's a little weird.
> For normal corruption, (at least on HDD) corruption range should be
> continuous, and more errors should be detected.
>
>> ago 15 21:58:09 kerberos kernel: BTRFS error (device sda3): bdev
>> /dev/sda3 errs: wr 0, rd 0, flush 0, corrupt 34, gen 0
>> ago 15 21:58:09 kerberos kernel: BTRFS error (device sda3): unable to
>> fixup (regular) error at logical 290297204736 on dev /dev/sda3
>>
>> The thing is, as soon as i move the image to another subvolume, root
>> in this case, and delete it, the errors go away and scrub tells me i
>> have zero errors again.
>
>
> This makes things even more weird.
>
> If you're *moving* the file to another subvolume, its data still locates
> where it was, nothing is modified.
>
> If you're *copying* the file to another subvolume, without reflinking, then
> kernel will try to read out the data and write it back to new place.
> During the read, it will verify data checksum. And if it doesn't match,
> you'll get EIO error during the copy.
>
> If you're *reflinking* the file, using cp --reflink=always, it's the same
> result as *moving*.
>
> Anyway, the data of your image is either kept as it is, or re-written to new
> place.
> If there is really some corruption, for copy case you should get some error,
> and for moving/reflinking case, scrub will always report error.
>
> I doubt if there is something wrong with scrub.
>
> Can you even reproduce it with a smaller sparse file? For example several
> mega size.
> And is it only happening in that specified Fedora directory?
>
> Thanks,
> Qu
>
>>
>> Then if i AGAIN copy the file back to /home, i get the same errors.
>>
>> qemu-img check tells me the qcow2 file is fine, and smart doesnt show
>> me anything wrong with my ssd:
>>
>> root@kerberos:/home/groo# smartctl -Ai /dev/sda
>> smartctl 6.6 2016-05-31 r4324 [x86_64-linux-4.13.0-041300rc4-generic]
>> (local build)
>> Copyright (C) 2002-16, Bruce Allen, Christian Franke,
>> www.smartmontools.org
>>
>> === START OF INFORMATION SECTION ===
>> Model Family:     Samsung based SSDs
>> Device Model:     Samsung SSD 850 EVO M.2 500GB
>> Serial Number:    S33DNX0H812686V
>> LU WWN Device Id: 5 002538 d4130d027
>> Firmware Version: EMT21B6Q
>> User Capacity:    500.107.862.016 bytes [500 GB]
>> Sector Size:      512 bytes logical/physical
>> Rotation Rate:    Solid State Device
>> Form Factor:      M.2
>> Device is:        In smartctl database [for details use: -P show]
>> ATA Version is:   ACS-2, ATA8-ACS T13/1699-D revision 4c
>> SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 6.0 Gb/s)
>> Local Time is:    Tue Aug 15 21:59:34 2017 -03
>> SMART support is: Available - device has SMART capability.
>> SMART support is: Enabled
>>
>> === START OF READ SMART DATA SECTION ===
>> SMART Attributes Data Structure revision number: 1
>> Vendor Specific SMART Attributes with Thresholds:
>> ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
>> UPDATED  WHEN_FAILED RAW_VALUE
>>    5 Reallocated_Sector_Ct   0x0033   100   100   010    Pre-fail
>> Always       -       0
>>    9 Power_On_Hours          0x0032   099   099   000    Old_age
>> Always       -       1739
>>   12 Power_Cycle_Count       0x0032   099   099   000    Old_age
>> Always       -       392
>> 177 Wear_Leveling_Count     0x0013   099   099   000    Pre-fail
>> Always       -       7
>> 179 Used_Rsvd_Blk_Cnt_Tot   0x0013   100   100   010    Pre-fail
>> Always       -       0
>> 181 Program_Fail_Cnt_Total  0x0032   100   100   010    Old_age
>> Always       -       0
>> 182 Erase_Fail_Count_Total  0x0032   100   100   010    Old_age
>> Always       -       0
>> 183 Runtime_Bad_Block       0x0013   100   100   010    Pre-fail
>> Always       -       0
>> 187 Uncorrectable_Error_Cnt 0x0032   100   100   000    Old_age
>> Always       -       0
>> 190 Airflow_Temperature_Cel 0x0032   061   050   000    Old_age
>> Always       -       39
>> 195 ECC_Error_Rate          0x001a   200   200   000    Old_age
>> Always       -       0
>> 199 CRC_Error_Count         0x003e   100   100   000    Old_age
>> Always       -       0
>> 235 POR_Recovery_Count      0x0012   099   099   000    Old_age
>> Always       -       54
>> 241 Total_LBAs_Written      0x0032   099   099   000    Old_age
>> Always       -       7997549567
>>
>> this is the usage for /home:
>>
>> root@kerberos:/home/groo# btrfs filesystem usage -T /home/
>> Overall:
>>      Device size:                 333.50GiB
>>      Device allocated:             74.12GiB
>>      Device unallocated:          259.38GiB
>>      Device missing:                  0.00B
>>      Used:                         32.70GiB
>>      Free (estimated):            297.36GiB      (min: 167.67GiB)
>>      Data ratio:                       1.00
>>      Metadata ratio:                   2.00
>>      Global reserve:               58.12MiB      (used: 0.00B)
>>
>>               Data     Metadata  System
>> Id Path      single   RAID1     RAID1    Unallocated
>> -- --------- -------- --------- -------- -----------
>>   1 /dev/sda3 68.00GiB   2.00GiB 64.00MiB   129.94GiB
>>   2 /dev/sdb7  2.00GiB   2.00GiB 64.00MiB   128.96GiB
>>   3 /dev/sdb8        -         -        -   488.13MiB
>> -- --------- -------- --------- -------- -----------
>>     Total     70.00GiB   2.00GiB 64.00MiB   259.38GiB
>>     Used      32.02GiB 348.12MiB 16.00KiB
>>
>> and for root subvolume:
>>
>> root@kerberos:/home/groo# btrfs filesystem usage -T /
>> Overall:
>>      Device size:                  65.29GiB
>>      Device allocated:             65.28GiB
>>      Device unallocated:           12.00MiB
>>      Device missing:                  0.00B
>>      Used:                         14.94GiB
>>      Free (estimated):             48.72GiB      (min: 48.72GiB)
>>      Data ratio:                       1.00
>>      Metadata ratio:                   1.00
>>      Global reserve:               42.20MiB      (used: 0.00B)
>>
>>               Data     Metadata  System
>> Id Path      single   single    single   Unallocated
>> -- --------- -------- --------- -------- -----------
>>   1 /dev/sda2 63.24GiB   2.01GiB 32.00MiB    12.00MiB
>> -- --------- -------- --------- -------- -----------
>>     Total     63.24GiB   2.01GiB 32.00MiB    12.00MiB
>>     Used      14.52GiB 425.16MiB 16.00KiB
>>
>> i see this with both kernel 4.12 and 4.13rc4
>>
>> the btrfstools are:
>>
>> root@kerberos:/home/groo# btrfs version
>> btrfs-progs v4.12-dirty
>>
>> /etc/fstab:
>>
>> UUID=e31faa09-99e5-4c75-815c-629402ec92f2 /               btrfs
>> defaults,discard,subvol=@ 0       1
>> # /boot was on /dev/sda1 during installation
>> UUID=55796428-a9b8-4f1b-9a7e-8fe3aa8d8097 /boot           ext4
>> defaults        0       2
>> # /boot/efi was on /dev/sdb2 during installation
>> UUID=D4F8-9F87  /boot/efi       vfat    umask=0077      0       1
>> # /home was on /dev/sda3 during installation
>> UUID=ae9ae869-720d-4643-b673-6924d09b2fe0 /home           btrfs
>> defaults,discard,subvol=@home 0       2
>> # swap was on /dev/sdb6 during installation
>> #UUID=fc2a432b-4c40-4fe4-9730-869a1d1911ef none            swap    sw
>>              0       0
>> /dev/mapper/cryptswap1 none swap sw 0 0
>>
>>
>> this is reproducible every single time.
>>
>> is btrfs scrub maybe getting confused with a sparse file? is it
>> possible to get a bad checksum with raid1 in this scenario?
>>
>> any help is appreciated
>>
>> | Paulo Dias
>> | paulo.miguel.dias@gmail.com
>>
>> Tempora mutantur, nos et mutamur in illis.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
