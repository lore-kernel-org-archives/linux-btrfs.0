Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:37188 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427AbbLNHYV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Dec 2015 02:24:21 -0500
Received: by igcto18 with SMTP id to18so76483917igc.0
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Dec 2015 23:24:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <566E584B.5040104@cn.fujitsu.com>
References: <CAJCQCtSQUu8c-eG01tJwwUzC9jONuuaVRTpyLLDCK-gwEE6hUg@mail.gmail.com>
	<566E584B.5040104@cn.fujitsu.com>
Date: Mon, 14 Dec 2015 00:24:21 -0700
Message-ID: <CAJCQCtRzQ=9NbaaajPuoP2KOCvOd_rFT6P990aU=-EOo8dKS1A@mail.gmail.com>
Subject: Re: btrfs check inconsistency with raid1, part 1
From: Chris Murphy <lists@colorremedies.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for the reply.


On Sun, Dec 13, 2015 at 10:48 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>
>
> Chris Murphy wrote on 2015/12/13 21:16 -0700:
>> btrfs check with devid 1 and 2 present produces thousands of scary
>> messages, e.g.
>> checksum verify failed on 714189357056 found E4E3BDB6 wanted 00000000
>
>
> Checked the full output.
> The interesting part is, the calculated result is always E4E3BDB6, and
> wanted is always all 0.
>
> I assume E4E3BDB6 is crc32 of all 0 data.
>
>
> If there is a full disk dump, it will be much easier to find where the
> problem is.
> But I'm a afraid it won't be possible.

What is a full disk dump? I can try to see if it's possible. Main
thing though is only if it can make Btrfs overall better, because I
don't need this volume repaired, there's no data loss (backups!) so
this volume's purpose now is for study.


> At least, 'btrfs-debug-tree -t 2' should help to locate what's wrong with
> the bytenr in the warning.

Both devs attached (not mounted).

[root@f23a ~]# btrfs-debug-tree -t 2 /dev/sdb > btrfsdebugtreet2_verb.txt
checksum verify failed on 714189570048 found E4E3BDB6 wanted 00000000
checksum verify failed on 714189570048 found E4E3BDB6 wanted 00000000
checksum verify failed on 714189471744 found E4E3BDB6 wanted 00000000
checksum verify failed on 714189471744 found E4E3BDB6 wanted 00000000
checksum verify failed on 714189357056 found E4E3BDB6 wanted 00000000
checksum verify failed on 714189357056 found E4E3BDB6 wanted 00000000
checksum verify failed on 714189750272 found E4E3BDB6 wanted 00000000
checksum verify failed on 714189750272 found E4E3BDB6 wanted 00000000

https://drive.google.com/open?id=0B_2Asp8DGjJ9NUdmdXZFQ1Myek0


>
>
> The good news is, the fs seems to be OK without major problem.
> As except the csum error, btrfsck doesn't give other error/warning.

Yes, I think so. Main issue here seems to be the scary warnings and
uncertainty what the user should do next, if anything at all.

> I guess btrfsck did the wrong device assemble, but that's just my personal
> guess.
> And since I can't reproduce in my test environment, it won't be easy to find
> the root cause.

It might be reproducible. More on that in the next email. Easy to get
you remote access if useful.


>> So. What's the theory in this case? And then does it differ from reality?
>
>
> Personally speaking, it may be a false alert from btrfsck.
> So in this case, I can't provide much help.
>
> If you're brave enough, mount it rw to see what will happen(although it may
> mount just OK).

I'm brave enough. I'll give it a try tomorrow unless there's another
request for more info before then.


-- 
Chris Murphy
