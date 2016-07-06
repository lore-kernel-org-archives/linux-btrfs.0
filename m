Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:35693 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755571AbcGFUAI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jul 2016 16:00:08 -0400
Received: by mail-oi0-f51.google.com with SMTP id r2so285833277oih.2
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Jul 2016 13:00:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <460a10bc-b793-35cb-7d31-73ce08204012@gmail.com>
References: <CAJCQCtRQBGNeCyENzTPT=yiqs3Tcc=aD8v6usKNtTnvyOd0uqw@mail.gmail.com>
 <20160705212706.719397fc@jupiter.sol.kaishome.de> <CAJCQCtRyvC6J=KJSVYRd1sOWPoVm69tA--3U8kAVdDynkziwNA@mail.gmail.com>
 <CAJCQCtS7OgKKzstJDz52Sd6+SJygDzoVzMhvwHqGxFmihr6Aqg@mail.gmail.com>
 <CAA91j0VbaRpt46tYf_oqd7fRuRn_ev-=Zxf_Bwiwd=TUHR+2Ow@mail.gmail.com>
 <CAJCQCtSZ=7v5PgD4mYKhayg03UfVqCV0ADBSjTsFDHiVcdxAjw@mail.gmail.com>
 <44c18e92-69b4-1409-1bf3-b1d08f6f84db@gmail.com> <CAJCQCtRd-=RYAVWJBoVKPLU3-jx0T1oQgmhJwBM01j9zpFsUvg@mail.gmail.com>
 <460a10bc-b793-35cb-7d31-73ce08204012@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 6 Jul 2016 14:00:06 -0600
Message-ID: <CAJCQCtSO2-ysgHn2KV2-YGoLEsHMb54ikEXYHW+Fz9PKG7uURw@mail.gmail.com>
Subject: Re: 64-btrfs.rules and degraded boot
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Andrei Borzenkov <arvidjaar@gmail.com>,
        Kai Krakow <hurikhan77@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 6, 2016 at 1:17 PM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:

> In bash or most other POSIX compliant shells, you can run this:
> echo $?
> to get the return code of the previous command.
>
> In your case though, it may be reporting the FS ready because it had already
> seen all the devices, IIUC, the flag that checks is only set once, and never
> unset, which is not a good design in this case.

Oh dear.

[root@f24s ~]# lvs
  LV         VG Attr       LSize  Pool       Origin Data%  Meta%  Move
Log Cpy%Sync Convert
  1          VG Vwi---tz-- 50.00g thintastic
  2          VG Vwi---tz-- 50.00g thintastic
  3          VG Vwi-a-tz-- 50.00g thintastic        2.54
  thintastic VG twi-aotz-- 90.00g                   5.05   2.92
[root@f24s ~]# btrfs dev scan
Scanning for Btrfs filesystems
[root@f24s ~]# echo $?
0
[root@f24s ~]# btrfs device ready /dev/mapper/VG-3
[root@f24s ~]# echo $?
0
[root@f24s ~]# btrfs fi show
warning, device 2 is missing
Label: none  uuid: 96240fd9-ea76-47e7-8cf4-05d3570ccfd7
    Total devices 3 FS bytes used 2.26GiB
    devid    3 size 50.00GiB used 3.01GiB path /dev/mapper/VG-3
    *** Some devices missing


Cute, device 1 is also missing but that's not mentioned. In any case,
the device is still ready even after a dev scan. I guess this isn't
exactly testable all that easily unless I reboot.



-- 
Chris Murphy
