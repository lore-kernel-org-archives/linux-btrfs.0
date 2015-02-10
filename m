Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:43512 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbbBJSSu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Feb 2015 13:18:50 -0500
Received: by labhv19 with SMTP id hv19so21945226lab.10
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Feb 2015 10:18:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <ntnoqb-jvq.ln1@hurikhan77.spdns.de>
References: <CAGwxe4gXPEOTPfNc2=0E0HAfDfTRKRcqqPjVJimbWJr5riz4DA@mail.gmail.com>
 <ntnoqb-jvq.ln1@hurikhan77.spdns.de>
From: Tobias Holst <tobby@tobby.eu>
Date: Tue, 10 Feb 2015 19:18:28 +0100
Message-ID: <CAGwxe4hVkLKDWWeTVLdZuWNYt8px-CyPMzYiX-Bfs3Sx03mnmQ@mail.gmail.com>
Subject: Re: Repair broken btrfs raid6?
To: Kai Krakow <hurikhan77@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2015-02-10 8:17 GMT+01:00 Kai Krakow <hurikhan77@gmail.com>:
> Tobias Holst <tobby@tobby.eu> schrieb:
>
>> and "btrfs scrub status /[device]" gives me the following output:
>>> "scrub status for [UUID]
>>>scrub started at Mon Feb  9 18:16:38 2015 and was aborted after 2008
>>>seconds total bytes scrubbed: 113.04GiB with 0 errors"
>
> Does not look very correct to me:
>
> Why should a scrub in a six-drivers btrfs array which is probably multi-
> terabytes big (as you state a restore from backup would take days) take only
> ~2000 seconds? And scrub only ~120 GB worth of data. Either your 6 devices
> are really small (then why RAID-6), or your data is very sparse (then way
> does it take so long), or scrub prematurely aborts and never checks the
> complete devices (I guess this is it).

Yes, sorry, I didn't post an output of "btrfs filesystem show" - but here it is:

Label: 'tobby-btrfs'  uuid: b689ab76-7ff5-434c-a2c6-03efb45faa46
        Total devices 6 FS bytes used 13.13TiB
        devid    1 size 3.64TiB used 3.28TiB path /dev/mapper/sde_crypt
        devid    2 size 3.64TiB used 3.28TiB path /dev/mapper/sdd_crypt
        devid    3 size 3.64TiB used 3.28TiB path /dev/mapper/sdf_crypt
        devid    4 size 3.64TiB used 3.28TiB path /dev/mapper/sda_crypt
        devid    5 size 3.64TiB used 3.28TiB path /dev/mapper/sdb_crypt
        devid    6 size 3.64TiB used 3.28TiB path /dev/mapper/sdc_crypt
btrfs-progs v3.19-rc2

So there are ~13TiB of data on this raid6 - but like it says it was
"aborted" after 2008 seconds (about half an hour) and ~120GB of data.
Then a "parent transid verify failed" happened, the volume got
unreadable and the scrub was aborted. Until a remount of the btrfs -
and until it happens again...

>
> And that's what it actually says: "aborted after 2008" seconds. I'd expect
> "finished after XXXX seconds" if I remember my scrub runs correctly (which I
> currently don't do regularly because it takes long and IO performance sucks
> during running it).
>
> --
> Replies to list only preferred.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
