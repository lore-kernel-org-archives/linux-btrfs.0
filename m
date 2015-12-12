Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f46.google.com ([209.85.215.46]:33121 "EHLO
	mail-lf0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbbLLOrS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 12 Dec 2015 09:47:18 -0500
Received: by lfap203 with SMTP id p203so27906821lfa.0
        for <linux-btrfs@vger.kernel.org>; Sat, 12 Dec 2015 06:47:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAMG9ccx6ahFfnsq3DHUzemYjQwuTHD46nL1SqPsjeDNL4KTRWg@mail.gmail.com>
References: <566b0cff.pXiyzYE4dYIOt31+%sivan606@gmail.com>
	<CAJCQCtTLrGin24rFGdvYV-JcegEgGEE7qK3gAYSd8K_SXFeu=g@mail.gmail.com>
	<CAMG9ccx6ahFfnsq3DHUzemYjQwuTHD46nL1SqPsjeDNL4KTRWg@mail.gmail.com>
Date: Sat, 12 Dec 2015 15:47:17 +0100
Message-ID: <CAPmG0jYyi8LX9nKZAB6oPwvwoPJnOqpO5CRXO4j7UvVsUoi2dA@mail.gmail.com>
Subject: Re: Will "btrfs check --repair" fix the mounting problem?
From: Henk Slager <eye1tm@gmail.com>
To: Ivan Sizov <sivan606@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I had a similar issue yesterday, although the fs is not a converted
one. It just started with this in dmesg:
BTRFS critical (device sdf1): corrupt leaf, slot offset bad:
block=77130973184,root=1, slot=150

I hope you can still mount RO, but I don't know a way to preserve the
btrfs CoW features/structures.

RO mounting did not work for me, so my options were trying --repair or
dd back an older image copy of the partition (60G size).
I decided to try --repair first by doing a dd image of the broken fs
and doing btrfs checks on that. Similar as for you, the read-only
checks did not get me a step further, also tools crash. The many
similar dmesg errors come from snapshots as far as can see, so it's
just the 1 read error that is the main problem. Then I did a   btrfs
check --repair /dev/loop0   (booted PC with another OS version, kernel
4.4-rc4, tools 4.3.1) and it was successful. Same thing on the real
partition and the PC now runs fine from it and I didn't / don't see
problems due to this corrupt leaf issue.

Maybe you had already done some balancing etc on the converted fs,
that might give a bit higher chance of successful repair I think, if
it is just this one error that btrfs check sees. I haven't done
anything with btrfs-convert or a converted fs recently, but at about
kernel 3.16 or so times, it has worked quite OK for me.
I hope the fs is not too big otherwise there is probably less to try.
Maybe btrfs restore might be an option.


On Sat, Dec 12, 2015 at 11:34 AM, Ivan Sizov <sivan606@gmail.com> wrote:
> 2015-12-11 21:24 GMT+03:00 Chris Murphy <lists@colorremedies.com>:
>> I would not repair it if the risk of it getting worse is bad for your data.
>>
>> Note the wiki says this feature is not well tested and is reported to
>> not work reliably.
>> https://btrfs.wiki.kernel.org/index.php/Conversion_from_Ext3
>>
>> Qu is working on patches to fix some of these problems, I don't know
>> the status of any of that. I just did a conversion myself the other
>> day with kernel 4.4.0rc3 and btrfs-progs 4.3.1 and that worked without
>> error. But there were also no big files at all (it was just a clean OS
>> installation). I immediately took a snapshot of that, and btrfs
>> send/receive it to a new Btrfs volume, and then discarded the
>> converted one entirely.
>>
>> The trace looks like it's mounting read-only? If it can be mounted
>> read only, get the important data off the volume if it's not already
>> backed up, and then blow it away. I personally wouldn't bother with
>> repairing it.
>
> What is the better way to get data? send/receive works only with RO
> snapshots. Is there another way to preserve subvolumes and CoW
> structure (a lot of files was copied between subvols using "cp
> --reflink=always")? Or just rsync'ing files is all what I can do?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
