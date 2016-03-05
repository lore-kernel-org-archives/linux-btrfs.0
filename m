Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:33892 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755993AbcCEKqB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 5 Mar 2016 05:46:01 -0500
Received: by mail-ig0-f174.google.com with SMTP id ir4so17660624igb.1
        for <linux-btrfs@vger.kernel.org>; Sat, 05 Mar 2016 02:46:00 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <pan$297ce$3e554bcd$6c1aeaa$9eef485a@cox.net>
References: <c2e396477401f3441bdc364456b399f4@smoula.net>
	<20160305034910.576d2230@natsu>
	<pan$297ce$3e554bcd$6c1aeaa$9eef485a@cox.net>
Date: Sat, 5 Mar 2016 10:46:00 +0000
Message-ID: <CAL3q7H5KQYHWeAfMQgLnffQdb6yU_-3jiGg8LfnU=f2cD0o09Q@mail.gmail.com>
Subject: Re: ENOSPC while creating snapshot
From: Filipe Manana <fdmanana@gmail.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 5, 2016 at 2:09 AM, Duncan <1i5t5.duncan@cox.net> wrote:
> Roman Mamedov posted on Sat, 05 Mar 2016 03:49:10 +0500 as excerpted:
>
>> As you use the nodatacow mount option, this seems to be another case of
>> http://www.spinics.net/lists/linux-btrfs/msg51276.html
>> http://www.spinics.net/lists/linux-btrfs/msg51819.html
>>
>> and is fixed by https://patchwork.kernel.org/patch/7967161/
>>
>> Unfortunately the bug is known since the start of the 4.4 series and the
>> patch is out for 2 months, but it didn't get included into even 4.4.4
>> released recently. You have to apply it by yourself and recompile the
>> kernel.
>
> Tho AFAIK it should be in 4.5, which is getting close to release, so if
> you prefer to run 4.5-rcX to applying the patch yourself, that should
> work as well.

No, it's not in any 4.5-rc.
It's in the integration branch for 4.6, however.

>
> --
> Duncan - List replies preferred.   No HTML msgs.
> "Every nonfree program has a lord, a master --
> and if you use the program, he is your master."  Richard Stallman
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
