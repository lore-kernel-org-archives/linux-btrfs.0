Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vb0-f44.google.com ([209.85.212.44]:64477 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191Ab3LOA2u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 14 Dec 2013 19:28:50 -0500
Received: by mail-vb0-f44.google.com with SMTP id x8so2267105vbf.17
        for <linux-btrfs@vger.kernel.org>; Sat, 14 Dec 2013 16:28:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <337E6C9D-298E-4F77-91D7-648A7C65D360@colorremedies.com>
References: <CAD_cGvFdrhwC2erqYTMjPRG7Y=69tsT2O+S-GHYK7+wpBwFSFQ@mail.gmail.com>
	<46A0D70E-99DF-46FE-A4E8-71E9AC45129F@colorremedies.com>
	<CAD_cGvHkpkuveYFKm4kjgc0SkJ=mQ4mpChes0F25fdjc5r3PmQ@mail.gmail.com>
	<337E6C9D-298E-4F77-91D7-648A7C65D360@colorremedies.com>
Date: Sun, 15 Dec 2013 01:28:49 +0100
Message-ID: <CAD_cGvGLHgHagW-G5Qz1yXY4w14BBiZsJj3K0-FmjEGzoo-_rw@mail.gmail.com>
Subject: Re: Blocket for more than 120 seconds
From: Hans-Kristian Bakke <hkbakke@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When I look at the entire FS with df-like tools it is reported as
89.4% used (26638.65 of 29808.2 GB). But this is shared amongst both
data and metadata I guess?

I do know that ~90%+ seems full, but it is still around 3TB in my
case! Are the "percentage rules" of old times still valid with modern
disk sizes? It seems extremely inconvenient that a filesystem like
btrfs is starting to misbehave at "only" 3TB available space for
RAID10 mirroring and metadata, which is probably a little bit over 1TB
actual filestorage counting everything in.

I would normally expect that there is no difference in 1TB free space
on a FS that is 2TB in total, and 1TB free space on a filesystem that
is 30TB in total, other than my sense of urge and that you would
probably expect data growth to be more rapid on the 30TB FS as there
is obviously a need to store a lot of stuff.
Is "free space needed" really a different concept dependning on the
size of your FS?
Mvh

Hans-Kristian Bakke


On 15 December 2013 00:50, Chris Murphy <lists@colorremedies.com> wrote:
>
> On Dec 14, 2013, at 4:19 PM, Hans-Kristian Bakke <hkbakke@gmail.com> wrote:
>
>> Looking into triggering the error again and dmesg and sysrq, but here
>> are the other two:
>>
>> # btrfs fi show
>> Label: none  uuid: 9302fc8f-15c6-46e9-9217-951d7423927c
>>        Total devices 8 FS bytes used 13.00TB
>>        devid    4 size 3.64TB used 3.48TB path /dev/sdt
>>        devid    3 size 3.64TB used 3.48TB path /dev/sds
>>        devid    8 size 3.64TB used 3.48TB path /dev/sdr
>>        devid    6 size 3.64TB used 3.48TB path /dev/sdp
>>        devid    7 size 3.64TB used 3.48TB path /dev/sdq
>>        devid    5 size 3.64TB used 3.48TB path /dev/sdo
>>        devid    1 size 3.64TB used 3.48TB path /dev/sdl
>>        devid    2 size 3.64TB used 3.48TB path /dev/sdm
>>
>> Btrfs v0.20-rc1
>>
>>
>> # btrfs fi df /storage/storage-vol0/
>> Data, RAID10: total=13.89TB, used=12.99TB
>> System, RAID10: total=64.00MB, used=1.19MB
>> System: total=4.00MB, used=0.00
>> Metadata, RAID10: total=21.00GB, used=17.59GB
>
> By my count this is ~ 95.6% full. My past experience with other file systems, including btree file systems, is they get unpredictably fussy when they're this full. I start migration planning once 80% full is reached, and make it a policy to avoid going over 90% full.
>
> I don't know what behavior Btrfs developers anticipate for this scenario. On the one hand it seems reasonable to  expect it to only be slow, rather than block the whole server for 2 minutes. But on the other hand, it's reasonable to expect server storage won't get this full.
>
>
> Chris Murphy--
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
