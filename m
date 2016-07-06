Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:36494 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755676AbcGFSXw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jul 2016 14:23:52 -0400
Received: by mail-oi0-f42.google.com with SMTP id f189so282372545oig.3
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Jul 2016 11:23:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <44c18e92-69b4-1409-1bf3-b1d08f6f84db@gmail.com>
References: <CAJCQCtRQBGNeCyENzTPT=yiqs3Tcc=aD8v6usKNtTnvyOd0uqw@mail.gmail.com>
 <20160705212706.719397fc@jupiter.sol.kaishome.de> <CAJCQCtRyvC6J=KJSVYRd1sOWPoVm69tA--3U8kAVdDynkziwNA@mail.gmail.com>
 <CAJCQCtS7OgKKzstJDz52Sd6+SJygDzoVzMhvwHqGxFmihr6Aqg@mail.gmail.com>
 <CAA91j0VbaRpt46tYf_oqd7fRuRn_ev-=Zxf_Bwiwd=TUHR+2Ow@mail.gmail.com>
 <CAJCQCtSZ=7v5PgD4mYKhayg03UfVqCV0ADBSjTsFDHiVcdxAjw@mail.gmail.com> <44c18e92-69b4-1409-1bf3-b1d08f6f84db@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 6 Jul 2016 12:23:50 -0600
Message-ID: <CAJCQCtRd-=RYAVWJBoVKPLU3-jx0T1oQgmhJwBM01j9zpFsUvg@mail.gmail.com>
Subject: Re: 64-btrfs.rules and degraded boot
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Andrei Borzenkov <arvidjaar@gmail.com>,
        Kai Krakow <hurikhan77@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 6, 2016 at 12:04 PM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2016-07-06 13:19, Chris Murphy wrote:
>>
>> On Wed, Jul 6, 2016 at 3:51 AM, Andrei Borzenkov <arvidjaar@gmail.com>
>> wrote:
>>>
>>> 3) can we query btrfs whether it is mountable in degraded mode?
>>> according to documentation, "btrfs device ready" (which udev builtin
>>> follows) checks "if it has ALL of it’s devices in cache for mounting".
>>> This is required for proper systemd ordering of services.
>>
>>
>> Where does udev builtin use btrfs itself? I see "btrfs ready $device"
>> which is not a valid btrfs user space command.
>>
>> I never get any errors from "btrfs device ready" even when too many
>> devices are missing. I don't know what it even does or if it's broken.
>>
>> This is a three device raid1 where I removed 2 devices and "btrfs
>> device ready" does not complain, it always returns silent for me no
>> matter what. It's been this way for years as far as I know.
>>
>> [root@f24s ~]# lvs
>>   LV         VG Attr       LSize  Pool       Origin Data%  Meta%  Move
>> Log Cpy%Sync Convert
>>   1          VG Vwi-a-tz-- 50.00g thintastic        2.55
>>   2          VG Vwi-a-tz-- 50.00g thintastic        4.00
>>   3          VG Vwi-a-tz-- 50.00g thintastic        2.54
>>   thintastic VG twi-aotz-- 90.00g                   5.05   2.92
>> [root@f24s ~]# btrfs fi show
>> Label: none  uuid: 96240fd9-ea76-47e7-8cf4-05d3570ccfd7
>>     Total devices 3 FS bytes used 2.26GiB
>>     devid    1 size 50.00GiB used 3.00GiB path /dev/mapper/VG-1
>>     devid    2 size 50.00GiB used 2.01GiB path /dev/mapper/VG-2
>>     devid    3 size 50.00GiB used 3.01GiB path /dev/mapper/VG-3
>>
>> [root@f24s ~]# btrfs device ready /dev/mapper/VG-1
>> [root@f24s ~]#
>> [root@f24s ~]# lvchange -an VG/1
>> [root@f24s ~]# lvchange -an VG/2
>> [root@f24s ~]# btrfs dev scan
>> Scanning for Btrfs filesystems
>> [root@f24s ~]# lvs
>>   LV         VG Attr       LSize  Pool       Origin Data%  Meta%  Move
>> Log Cpy%Sync Convert
>>   1          VG Vwi---tz-- 50.00g thintastic
>>   2          VG Vwi---tz-- 50.00g thintastic
>>   3          VG Vwi-a-tz-- 50.00g thintastic        2.54
>>   thintastic VG twi-aotz-- 90.00g                   5.05   2.92
>> [root@f24s ~]# btrfs fi show
>> warning, device 2 is missing
>> Label: none  uuid: 96240fd9-ea76-47e7-8cf4-05d3570ccfd7
>>     Total devices 3 FS bytes used 2.26GiB
>>     devid    3 size 50.00GiB used 3.01GiB path /dev/mapper/VG-3
>>     *** Some devices missing
>>
>> [root@f24s ~]# btrfs device ready /dev/mapper/VG-3
>> [root@f24s ~]#
>
> You won't get any output from it regardless, you have to check the return
> code as it's intended to be a tool for scripts and such.

How do I check the return code? When I use strace, no matter what I'm getting

+++ exited with 0 +++

I see both 'brfs device ready' and the udev btrfs builtin test are
calling BTRFS_IOC_DEVICES_READY so, it looks like udev is not using
user space tools to check but rather a btrfs ioctl. So clearly that
works or I wouldn't have stalled boots when all devices aren't
present.

-- 
Chris Murphy
