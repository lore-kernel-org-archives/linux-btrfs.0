Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-36.italiaonline.it ([212.48.25.164]:43701 "EHLO libero.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751234AbcGGRAz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Jul 2016 13:00:55 -0400
Reply-To: kreijack@inwind.it
Subject: Re: 64-btrfs.rules and degraded boot
References: <CAJCQCtRQBGNeCyENzTPT=yiqs3Tcc=aD8v6usKNtTnvyOd0uqw@mail.gmail.com>
 <20160705212706.719397fc@jupiter.sol.kaishome.de>
 <CAJCQCtRyvC6J=KJSVYRd1sOWPoVm69tA--3U8kAVdDynkziwNA@mail.gmail.com>
 <CAJCQCtS7OgKKzstJDz52Sd6+SJygDzoVzMhvwHqGxFmihr6Aqg@mail.gmail.com>
 <CAA91j0VbaRpt46tYf_oqd7fRuRn_ev-=Zxf_Bwiwd=TUHR+2Ow@mail.gmail.com>
 <CAJCQCtSZ=7v5PgD4mYKhayg03UfVqCV0ADBSjTsFDHiVcdxAjw@mail.gmail.com>
 <44c18e92-69b4-1409-1bf3-b1d08f6f84db@gmail.com>
 <CAJCQCtRd-=RYAVWJBoVKPLU3-jx0T1oQgmhJwBM01j9zpFsUvg@mail.gmail.com>
 <460a10bc-b793-35cb-7d31-73ce08204012@gmail.com>
 <CAJCQCtSO2-ysgHn2KV2-YGoLEsHMb54ikEXYHW+Fz9PKG7uURw@mail.gmail.com>
To: Chris Murphy <lists@colorremedies.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Andrei Borzenkov <arvidjaar@gmail.com>, Kai Krakow <hurikhan77@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <ce59a5f7-5e50-db50-aec5-35c37219e93e@inwind.it>
Date: Thu, 7 Jul 2016 19:00:53 +0200
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSO2-ysgHn2KV2-YGoLEsHMb54ikEXYHW+Fz9PKG7uURw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-07-06 22:00, Chris Murphy wrote:
> On Wed, Jul 6, 2016 at 1:17 PM, Austin S. Hemmelgarn
> <ahferroin7@gmail.com> wrote:
> 
>> In bash or most other POSIX compliant shells, you can run this:
>> echo $?
>> to get the return code of the previous command.
>>
>> In your case though, it may be reporting the FS ready because it had already
>> seen all the devices, IIUC, the flag that checks is only set once, and never
>> unset, which is not a good design in this case.
> 
> Oh dear.
> 
> [root@f24s ~]# lvs
>   LV         VG Attr       LSize  Pool       Origin Data%  Meta%  Move
> Log Cpy%Sync Convert
>   1          VG Vwi---tz-- 50.00g thintastic
>   2          VG Vwi---tz-- 50.00g thintastic
>   3          VG Vwi-a-tz-- 50.00g thintastic        2.54
>   thintastic VG twi-aotz-- 90.00g                   5.05   2.92
> [root@f24s ~]# btrfs dev scan
> Scanning for Btrfs filesystems
> [root@f24s ~]# echo $?
> 0
> [root@f24s ~]# btrfs device ready /dev/mapper/VG-3
> [root@f24s ~]# echo $?
> 0
> [root@f24s ~]# btrfs fi show
> warning, device 2 is missing
> Label: none  uuid: 96240fd9-ea76-47e7-8cf4-05d3570ccfd7
>     Total devices 3 FS bytes used 2.26GiB
>     devid    3 size 50.00GiB used 3.01GiB path /dev/mapper/VG-3
>     *** Some devices missing
> 
> 
> Cute, device 1 is also missing but that's not mentioned. In any case,
> the device is still ready even after a dev scan. I guess this isn't
> exactly testable all that easily unless I reboot.

IIRC a device when "registered" by "btrfs dev scan", is never removed from the available devices. This means that if you remove a valid device after that it is already scanned, "btrfs dev ready" still return OK until a reboot happened.

>From your email, it is not clear if you rebooted (or rmmod-ded btrfs) after you removed the devices.

Only my 2¢...

BR
G.Baroncelli
> 
> 
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
