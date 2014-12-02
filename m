Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:56688 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932269AbaLBHpK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 2 Dec 2014 02:45:10 -0500
Message-ID: <547D6DF4.7000408@web.de>
Date: Tue, 02 Dec 2014 08:44:52 +0100
From: Oliver <r.oliver@web.de>
MIME-Version: 1.0
To: Robert White <rwhite@pobox.com>, linux-btrfs@vger.kernel.org
Subject: Re: Online Drive Replacement: BTRFS with RAID 6
References: <547C7F7C.3080701@web.de> <547CC28E.2050208@pobox.com>
In-Reply-To: <547CC28E.2050208@pobox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear Robert,

thank you for all the possibilities! I think option 4 + 3 would be my 
prefered ones.

Until I received your answer I allready played around with that volume 
and converting it to Raid 5 seems to work too, I'll attach the steps I 
took. Soon  I'll try your solution and do some checksuming to verify the 
integrity of the files that were written while I pulled out the drive.

Please check in the steps below that I can violate Raid6 geometry by 
removing sdk again.
--------------------
$ btrfs fi sh
Label: none  uuid: 28410e37-77c1-4c01-8075-0d5068d9ffc2
	Total devices 4 FS bytes used 257.05GiB
	devid    1 size 465.76GiB used 262.03GiB path /dev/sdi1
	devid    2 size 465.76GiB used 262.00GiB path /dev/sdj1
	devid    3 size 465.76GiB used 261.03GiB path /dev/sdh1
	devid    4 size 465.76GiB used 0.00 path /dev/sdk1


$ btrfs fi balance start -dconvert=raid5 /mnt
Done, had to relocate 261 out of 263 chunks


$ btrfs fi sh
Label: none  uuid: 28410e37-77c1-4c01-8075-0d5068d9ffc2
	Total devices 4 FS bytes used 257.09GiB
	devid    1 size 465.76GiB used 262.03GiB path /dev/sdi1
	devid    2 size 465.76GiB used 262.00GiB path /dev/sdj1
	devid    3 size 465.76GiB used 261.03GiB path /dev/sdh1
	devid    4 size 465.76GiB used 0.00 path /dev/sdk1


$ btrfs fi df /mnt
Data, RAID5: total=522.00GiB, used=256.82GiB
System, RAID1: total=32.00MiB, used=56.00KiB
Metadata, RAID1: total=1.00GiB, used=271.49MiB


$ btrfs de de /dev/sdk1 /mnt


$ btrfs fi sh
Label: none  uuid: 28410e37-77c1-4c01-8075-0d5068d9ffc2
	Total devices 3 FS bytes used 257.09GiB
	devid    1 size 465.76GiB used 262.03GiB path /dev/sdi1
	devid    2 size 465.76GiB used 262.00GiB path /dev/sdj1
	devid    3 size 465.76GiB used 261.03GiB path /dev/sdh1


$ btrfs de ad /dev/sdk1 /mnt
/dev/sdk1 appears to contain an existing filesystem (btrfs).
Use the -f option to force overwrite.


$ btrfs de ad -f /dev/sdk1 /mnt
/dev/sdk1 is mounted


$ mount
...
/dev/sdi1 on /mnt type btrfs (rw,degraded)


$ mount -t btrfs -o remount,rw /dev/sdi1 /mnt


$ btrfs de ad -f /dev/sdk1 /mnt
/dev/sdk1 is mounted


$ umount /dev/sdk1
umount: /dev/sdk1 ist nicht eingehängt


$ dd if=/dev/zero of=/dev/sdk bs=1M count=100
100+0 Datensätze ein
100+0 Datensätze aus
104857600 Bytes (105 MB) kopiert, 1,68492 s, 62,2 MB/s

$ fdisk /dev/sdk # o+n+w

$ btrfs de ad -f /dev/sdk1 /mnt
/dev/sdk1 is mounted
# still not able to mount sdk, but this is most likely the cause:

$ btrfs fi sh /dev/sdk1
Label: none  uuid: 28410e37-77c1-4c01-8075-0d5068d9ffc2
	Total devices 3 FS bytes used 257.09GiB
	devid    1 size 465.76GiB used 262.03GiB path /dev/sdi1
	devid    2 size 465.76GiB used 262.00GiB path /dev/sdj1
	devid    3 size 465.76GiB used 261.03GiB path /dev/sdh1


$ wipefs /dev/sdk1
# this did not help, wipefs does not see any signatures


# I don't know what I did yesterday, but it suddently worked:
$ btrfs de ad -f /dev/sdk1 /mnt

$ btrfs fi sh
Label: none  uuid: 28410e37-77c1-4c01-8075-0d5068d9ffc2
	Total devices 4 FS bytes used 257.05GiB
	devid    1 size 465.76GiB used 131.00GiB path /dev/sdi1
	devid    2 size 465.76GiB used 130.03GiB path /dev/sdj1
	devid    3 size 465.76GiB used 131.03GiB path /dev/sdh1
	devid    4 size 465.76GiB used 0.00 path /dev/sdk1

$ btrfs fi balance start -dconvert=raid6 /mnt
Done, had to relocate 130 out of 132 chunks

$ btrfs fi sh
Label: none  uuid: 28410e37-77c1-4c01-8075-0d5068d9ffc2
	Total devices 4 FS bytes used 257.09GiB
	devid    1 size 465.76GiB used 131.00GiB path /dev/sdi1
	devid    2 size 465.76GiB used 130.03GiB path /dev/sdj1
	devid    3 size 465.76GiB used 131.03GiB path /dev/sdh1
	devid    4 size 465.76GiB used 130.00GiB path /dev/sdk1

$ btrfs de de /dev/sdk1 /mnt
# now I can remove sdk and violate Raid6 geometry:

$ btrfs fi sh
Label: none  uuid: 28410e37-77c1-4c01-8075-0d5068d9ffc2
	Total devices 3 FS bytes used 257.03GiB
	devid    1 size 465.76GiB used 267.00GiB path /dev/sdi1
	devid    2 size 465.76GiB used 266.03GiB path /dev/sdj1
	devid    3 size 465.76GiB used 267.03GiB path /dev/sdh1

$ btrfs fi df /mnt
Data, RAID6: total=266.00GiB, used=256.77GiB
System, RAID1: total=32.00MiB, used=52.00KiB
Metadata, RAID1: total=1.00GiB, used=270.72MiB
$ btrfs fi sh
Label: none  uuid: 28410e37-77c1-4c01-8075-0d5068d9ffc2
	Total devices 4 FS bytes used 257.05GiB
	devid    1 size 465.76GiB used 262.03GiB path /dev/sdi1
	devid    2 size 465.76GiB used 262.00GiB path /dev/sdj1
	devid    3 size 465.76GiB used 261.03GiB path /dev/sdh1
	devid    4 size 465.76GiB used 0.00 path /dev/sdk1


$ btrfs fi balance start -dconvert=raid5 /mnt
Done, had to relocate 261 out of 263 chunks


$ btrfs fi sh
Label: none  uuid: 28410e37-77c1-4c01-8075-0d5068d9ffc2
	Total devices 4 FS bytes used 257.09GiB
	devid    1 size 465.76GiB used 262.03GiB path /dev/sdi1
	devid    2 size 465.76GiB used 262.00GiB path /dev/sdj1
	devid    3 size 465.76GiB used 261.03GiB path /dev/sdh1
	devid    4 size 465.76GiB used 0.00 path /dev/sdk1


$ btrfs fi df /mnt
Data, RAID5: total=522.00GiB, used=256.82GiB
System, RAID1: total=32.00MiB, used=56.00KiB
Metadata, RAID1: total=1.00GiB, used=271.49MiB


$ btrfs de de /dev/sdk1 /mnt


$ btrfs fi sh
Label: none  uuid: 28410e37-77c1-4c01-8075-0d5068d9ffc2
	Total devices 3 FS bytes used 257.09GiB
	devid    1 size 465.76GiB used 262.03GiB path /dev/sdi1
	devid    2 size 465.76GiB used 262.00GiB path /dev/sdj1
	devid    3 size 465.76GiB used 261.03GiB path /dev/sdh1


$ btrfs de ad /dev/sdk1 /mnt
/dev/sdk1 appears to contain an existing filesystem (btrfs).
Use the -f option to force overwrite.


$ btrfs de ad -f /dev/sdk1 /mnt
/dev/sdk1 is mounted


$ mount
...
/dev/sdi1 on /mnt type btrfs (rw,degraded)


$ mount -t btrfs -o remount,rw /dev/sdi1 /mnt


$ btrfs de ad -f /dev/sdk1 /mnt
/dev/sdk1 is mounted


$ umount /dev/sdk1
umount: /dev/sdk1 ist nicht eingehängt


$ dd if=/dev/zero of=/dev/sdk bs=1M count=100
100+0 Datensätze ein
100+0 Datensätze aus
104857600 Bytes (105 MB) kopiert, 1,68492 s, 62,2 MB/s

$ fdisk /dev/sdk # o+n+w

$ btrfs de ad -f /dev/sdk1 /mnt
/dev/sdk1 is mounted
# still not able to mount sdk, but this is most likely the cause:

$ btrfs fi sh /dev/sdk1
Label: none  uuid: 28410e37-77c1-4c01-8075-0d5068d9ffc2
	Total devices 3 FS bytes used 257.09GiB
	devid    1 size 465.76GiB used 262.03GiB path /dev/sdi1
	devid    2 size 465.76GiB used 262.00GiB path /dev/sdj1
	devid    3 size 465.76GiB used 261.03GiB path /dev/sdh1


$ wipefs /dev/sdk1
# this did not help, wipefs does not see any signatures


# I don't know what I did yesterday, but it suddently worked:
$ btrfs de ad -f /dev/sdk1 /mnt

$ btrfs fi sh
Label: none  uuid: 28410e37-77c1-4c01-8075-0d5068d9ffc2
	Total devices 4 FS bytes used 257.05GiB
	devid    1 size 465.76GiB used 131.00GiB path /dev/sdi1
	devid    2 size 465.76GiB used 130.03GiB path /dev/sdj1
	devid    3 size 465.76GiB used 131.03GiB path /dev/sdh1
	devid    4 size 465.76GiB used 0.00 path /dev/sdk1

$ btrfs fi balance start -dconvert=raid6 /mnt
Done, had to relocate 130 out of 132 chunks

$ btrfs fi sh
Label: none  uuid: 28410e37-77c1-4c01-8075-0d5068d9ffc2
	Total devices 4 FS bytes used 257.09GiB
	devid    1 size 465.76GiB used 131.00GiB path /dev/sdi1
	devid    2 size 465.76GiB used 130.03GiB path /dev/sdj1
	devid    3 size 465.76GiB used 131.03GiB path /dev/sdh1
	devid    4 size 465.76GiB used 130.00GiB path /dev/sdk1

$ btrfs de de /dev/sdk1 /mnt
# now I can remove sdk and violate Raid6 geometry:

$ btrfs fi sh
Label: none  uuid: 28410e37-77c1-4c01-8075-0d5068d9ffc2
	Total devices 3 FS bytes used 257.03GiB
	devid    1 size 465.76GiB used 267.00GiB path /dev/sdi1
	devid    2 size 465.76GiB used 266.03GiB path /dev/sdj1
	devid    3 size 465.76GiB used 267.03GiB path /dev/sdh1

$ btrfs fi df /mnt
Data, RAID6: total=266.00GiB, used=256.77GiB
System, RAID1: total=32.00MiB, used=52.00KiB
Metadata, RAID1: total=1.00GiB, used=270.72MiB



Am 01.12.2014 um 20:33 schrieb Robert White:
> On 12/01/2014 06:47 AM, Oliver wrote:
>> Hi All,
>>
>> on a testing machine I installed four HDDs and they are configured as
>> RAID6. For a test I removed one of the drives (/dev/sdk) while the
>> volume was mounted and data was written to it. This worked well, as far
>> as I can see. Some I/O errors were written to /var/log/syslog, but the
>> volume kept working. Unfortunately the command "btrfs fi sh" did not
>> show any missing drives. So I remounted the volume in degraded mode:
>> "mount -t btrfs /dev/sdx1 -o remount,rw,degraded,noatime /mnt". This way
>> the drive in question was reported as missing. Then I plugged in the HDD
>> again (it is of course /dev/sdk again) and started a balancing in hope
>> that this will restore RAID6: "btrfs filesystem balance start /mnt". Now
>> the volume looks like this:
>
> Since it was already running and such, remounting it as degraded was
> probably not a good thing (or even vaguely necessary).
>
> The WIKI, in discussing add/remove and failed drives goes to great
> lengths (big red box) to discuss the current instability of RAID5/6 format.
>
> I am guessing here but I _think_ you should do the following...
>
> (0) Backup your data. [okay this is a test system that you deliberately
> purturbed but still... 8-) ]
>
> Option 1:
>
> (reasonable, but undocumented .. Either blance or scrub _ought_ to look
> at the disk sectors and trigger some re-copying from the good parts.)
>
> The disk is in the array (again), you may just need to re-balance or
> scrub the array to get the data on the drive back in harmony with the
> state of the array overall.
>
> Option 2:
>
> (unlikely :: add and remove are about making the geometry smaller/larger
> and, as stated, a RAID 6 cannot be less than 4 drives by definition, so
> there is no three-drive geometry for a RAID 6.)
>
> re-unplug the device, then use btrfs remove /dev/sdk /mnt
> then re-plug-in the device and use btrfs add /dev/sdk /mnt
>
>
> Option 3:
>
> (reasonable, but undocumented :: replace by device id -- 4 in your
> example case -- instead of system path. This would, I should think, skip
> the check of /dev/sdk1's separate status)
>
> btrfs replace start -f 4 /dev/sdk1 /mnt
>
> Option 3a:
>
> (got to get /dev/sdk1 back out of the list of active devices for /mnt so
> the system wont see /dev/sdk1 as "mounted" (e.g. held by a subsystem))
>
> unplug device.
> mount -o remount,degraded etc...
> plug in device.
> btrfs replace start -f 4 /dev/sdk1 /mnt
>
> Option 4:
>
> (most likely, most time consuming)
>
> Unplug /dev/sdk. Plug it into another computer and zero a decent chunk
> of partition 1.
> Plug it back into the original computer
> do the replace operation as in Option 3.
>
> This is the most-likely correct option if a simple rebalance or scrub
> doesn't work, as you will be presenting the system with three attached
> drives, one "missing" drive that will not match any necessary
> signatures, and a "new, blank" drive in its place.
>
> ===
>
> In all cases, you may need to unmount or remount or remount degraded  in
> there somewhere, particularly because you have already done so at least
> once.
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
