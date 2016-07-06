Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:35243 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917AbcGFRT5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jul 2016 13:19:57 -0400
Received: by mail-oi0-f49.google.com with SMTP id r2so279918795oih.2
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Jul 2016 10:19:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAA91j0VbaRpt46tYf_oqd7fRuRn_ev-=Zxf_Bwiwd=TUHR+2Ow@mail.gmail.com>
References: <CAJCQCtRQBGNeCyENzTPT=yiqs3Tcc=aD8v6usKNtTnvyOd0uqw@mail.gmail.com>
 <20160705212706.719397fc@jupiter.sol.kaishome.de> <CAJCQCtRyvC6J=KJSVYRd1sOWPoVm69tA--3U8kAVdDynkziwNA@mail.gmail.com>
 <CAJCQCtS7OgKKzstJDz52Sd6+SJygDzoVzMhvwHqGxFmihr6Aqg@mail.gmail.com> <CAA91j0VbaRpt46tYf_oqd7fRuRn_ev-=Zxf_Bwiwd=TUHR+2Ow@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 6 Jul 2016 11:19:55 -0600
Message-ID: <CAJCQCtSZ=7v5PgD4mYKhayg03UfVqCV0ADBSjTsFDHiVcdxAjw@mail.gmail.com>
Subject: Re: 64-btrfs.rules and degraded boot
To: Andrei Borzenkov <arvidjaar@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>, Kai Krakow <hurikhan77@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 6, 2016 at 3:51 AM, Andrei Borzenkov <arvidjaar@gmail.com> wrote:
> On Tue, Jul 5, 2016 at 11:10 PM, Chris Murphy <lists@colorremedies.com> wrote:
>> I started a systemd-devel@ thread since that's where most udev stuff
>> gets talked about.
>>
>> https://lists.freedesktop.org/archives/systemd-devel/2016-July/037031.html
>>
>
> Before discussing how to implement it in systemd, we need to decide
> what to implement. I.e.

Fair.


> 1) do you always want to mount filesystem in degraded mode if not
> enough devices are present or only if explicit hint is given?

Right now on Btrfs, it should be explicit. The faulty device concept,
handling, and notification is not mature. It's not a good idea to
silently mount degraded considering Btrfs does not actively catch up
the devices that are behind the next time there's a normal mount. It
only fixes things passively. So the user must opt into degraded mounts
rather than opt out.

The problem is the current udev rule is doing its own check for device
availability. So the mount command with explicit hint doesn't even get
attempted.



> 2) do you want to restrict degrade handling to root only or to other
> filesystems as well? Note that there could be more early boot
> filesystems that absolutely need same treatment (enters separate
> /usr), and there are also normal filesystems that may need be mounted
> even degraded.

I'm mainly concerned with rootfs. And I'm mainly concerned with a very
simple 2 disk raid1. With a simple user opt in using
rootflags=degraded, it should be possible to boot the system. Right
now it's not possible. Maybe just deleting 64-btrfs.rules would fix
this problem, I haven't tried it.


> 3) can we query btrfs whether it is mountable in degraded mode?
> according to documentation, "btrfs device ready" (which udev builtin
> follows) checks "if it has ALL of it’s devices in cache for mounting".
> This is required for proper systemd ordering of services.

Where does udev builtin use btrfs itself? I see "btrfs ready $device"
which is not a valid btrfs user space command.

I never get any errors from "btrfs device ready" even when too many
devices are missing. I don't know what it even does or if it's broken.

This is a three device raid1 where I removed 2 devices and "btrfs
device ready" does not complain, it always returns silent for me no
matter what. It's been this way for years as far as I know.

[root@f24s ~]# lvs
  LV         VG Attr       LSize  Pool       Origin Data%  Meta%  Move
Log Cpy%Sync Convert
  1          VG Vwi-a-tz-- 50.00g thintastic        2.55
  2          VG Vwi-a-tz-- 50.00g thintastic        4.00
  3          VG Vwi-a-tz-- 50.00g thintastic        2.54
  thintastic VG twi-aotz-- 90.00g                   5.05   2.92
[root@f24s ~]# btrfs fi show
Label: none  uuid: 96240fd9-ea76-47e7-8cf4-05d3570ccfd7
    Total devices 3 FS bytes used 2.26GiB
    devid    1 size 50.00GiB used 3.00GiB path /dev/mapper/VG-1
    devid    2 size 50.00GiB used 2.01GiB path /dev/mapper/VG-2
    devid    3 size 50.00GiB used 3.01GiB path /dev/mapper/VG-3

[root@f24s ~]# btrfs device ready /dev/mapper/VG-1
[root@f24s ~]#
[root@f24s ~]# lvchange -an VG/1
[root@f24s ~]# lvchange -an VG/2
[root@f24s ~]# btrfs dev scan
Scanning for Btrfs filesystems
[root@f24s ~]# lvs
  LV         VG Attr       LSize  Pool       Origin Data%  Meta%  Move
Log Cpy%Sync Convert
  1          VG Vwi---tz-- 50.00g thintastic
  2          VG Vwi---tz-- 50.00g thintastic
  3          VG Vwi-a-tz-- 50.00g thintastic        2.54
  thintastic VG twi-aotz-- 90.00g                   5.05   2.92
[root@f24s ~]# btrfs fi show
warning, device 2 is missing
Label: none  uuid: 96240fd9-ea76-47e7-8cf4-05d3570ccfd7
    Total devices 3 FS bytes used 2.26GiB
    devid    3 size 50.00GiB used 3.01GiB path /dev/mapper/VG-3
    *** Some devices missing

[root@f24s ~]# btrfs device ready /dev/mapper/VG-3
[root@f24s ~]#




-- 
Chris Murphy
