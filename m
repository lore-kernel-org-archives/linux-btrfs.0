Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:49349 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752560AbbLNIEr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Dec 2015 03:04:47 -0500
Subject: Re: btrfs check inconsistency with raid1, part 1
To: Chris Murphy <lists@colorremedies.com>
References: <CAJCQCtSQUu8c-eG01tJwwUzC9jONuuaVRTpyLLDCK-gwEE6hUg@mail.gmail.com>
 <566E584B.5040104@cn.fujitsu.com>
 <CAJCQCtRzQ=9NbaaajPuoP2KOCvOd_rFT6P990aU=-EOo8dKS1A@mail.gmail.com>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <566E77FA.3050405@cn.fujitsu.com>
Date: Mon, 14 Dec 2015 16:04:10 +0800
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRzQ=9NbaaajPuoP2KOCvOd_rFT6P990aU=-EOo8dKS1A@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Chris Murphy wrote on 2015/12/14 00:24 -0700:
> Thanks for the reply.
>
>
> On Sun, Dec 13, 2015 at 10:48 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>>
>>
>> Chris Murphy wrote on 2015/12/13 21:16 -0700:
>>> btrfs check with devid 1 and 2 present produces thousands of scary
>>> messages, e.g.
>>> checksum verify failed on 714189357056 found E4E3BDB6 wanted 00000000
>>
>>
>> Checked the full output.
>> The interesting part is, the calculated result is always E4E3BDB6, and
>> wanted is always all 0.
>>
>> I assume E4E3BDB6 is crc32 of all 0 data.
>>
>>
>> If there is a full disk dump, it will be much easier to find where the
>> problem is.
>> But I'm a afraid it won't be possible.
>
> What is a full disk dump? I can try to see if it's possible.

Just a dd dump.

dd if=<disk1> of=disk1.img bs=1M

> Main
> thing though is only if it can make Btrfs overall better, because I
> don't need this volume repaired, there's no data loss (backups!) so
> this volume's purpose now is for study.

But please also consider your privacy before doing this.

And more important thing is the size...

Considering how large your -t 2 dump is, I won't ever try to do the dump 
even I have enough spare space to contain the image, it won't be an easy 
thing to find a place to upload them.

>
>
>> At least, 'btrfs-debug-tree -t 2' should help to locate what's wrong with
>> the bytenr in the warning.
>
> Both devs attached (not mounted).
>
> [root@f23a ~]# btrfs-debug-tree -t 2 /dev/sdb > btrfsdebugtreet2_verb.txt
> checksum verify failed on 714189570048 found E4E3BDB6 wanted 00000000
> checksum verify failed on 714189570048 found E4E3BDB6 wanted 00000000
> checksum verify failed on 714189471744 found E4E3BDB6 wanted 00000000
> checksum verify failed on 714189471744 found E4E3BDB6 wanted 00000000
> checksum verify failed on 714189357056 found E4E3BDB6 wanted 00000000
> checksum verify failed on 714189357056 found E4E3BDB6 wanted 00000000
> checksum verify failed on 714189750272 found E4E3BDB6 wanted 00000000
> checksum verify failed on 714189750272 found E4E3BDB6 wanted 00000000
>
> https://drive.google.com/open?id=0B_2Asp8DGjJ9NUdmdXZFQ1Myek0
>

Got the result, and things is very interesting.

It seems all these tree blocks (search by the bytenr) shares the same 
crc32 by coincidence.
Or we won't be able to read them all (and their contents all seems valid).


I hope if I can have some raw blocks dump of that bytenr.
Here is the procedure:
$ btrfs-map-logical -l <LOGICAL> -n 16384 -c 2 <DEVICE1or2>
mirror 1 logical <LOGICAL> physical XXXXXXXX device <DEVICE1>
mirror 2 logical <LOGICAL> physical YYYYYYYY device <DEVICE2>

$ dd if=<DEVICE1> of=dev1_<LOGICAL>.img bs=1 count=16384 skip=XXXXXXX
$ dd if=<DEVICE2> of=dev2_<LOGICAL>.img bs=1 count=16384 skip=YYYYYYY

In your output, there are 12 different bytenr, but the most interesting 
ones are *714189357056* and *714189471744*.
They are extent tree blocks. If they are really broken, btrfsck should 
complain about it.

Others are mostly csum tree block, less interesting.

And unlike the super large disk dump, it's very small, exactly 16K each.
64K in total.

>
>>
>>
>> The good news is, the fs seems to be OK without major problem.
>> As except the csum error, btrfsck doesn't give other error/warning.
>
> Yes, I think so. Main issue here seems to be the scary warnings and
> uncertainty what the user should do next, if anything at all.
>
>> I guess btrfsck did the wrong device assemble, but that's just my personal
>> guess.
>> And since I can't reproduce in my test environment, it won't be easy to find
>> the root cause.
>
> It might be reproducible. More on that in the next email. Easy to get
> you remote access if useful.
>
>
>>> So. What's the theory in this case? And then does it differ from reality?
>>
>>
>> Personally speaking, it may be a false alert from btrfsck.
>> So in this case, I can't provide much help.
>>
>> If you're brave enough, mount it rw to see what will happen(although it may
>> mount just OK).
>
> I'm brave enough. I'll give it a try tomorrow unless there's another
> request for more info before then.
>
>
Great!

Thanks,
Qu


