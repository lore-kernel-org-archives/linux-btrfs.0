Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f195.google.com ([209.85.213.195]:36531 "EHLO
	mail-ig0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335AbcAOPWk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jan 2016 10:22:40 -0500
Received: by mail-ig0-f195.google.com with SMTP id o2so1425792iga.3
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Jan 2016 07:22:40 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <pan$225c9$759721a9$6dacacd5$7fd39236@cox.net>
References: <1452751054-2365-1-git-send-email-quwenruo@cn.fujitsu.com>
	<1452751054-2365-18-git-send-email-quwenruo@cn.fujitsu.com>
	<CAL3q7H4-Ztmx9Z4=jNT3610Y6eZbL5GqZXXOajYg3FoP_uyxYA@mail.gmail.com>
	<56984D50.3040106@cn.fujitsu.com>
	<CAL3q7H4ZS_qj3VqiFmDkvCBZK8f34SQ-T3jCDQv-V+rXrpu8Ng@mail.gmail.com>
	<pan$225c9$759721a9$6dacacd5$7fd39236@cox.net>
Date: Fri, 15 Jan 2016 15:22:39 +0000
Message-ID: <CAL3q7H5gusvi1Q0Q5uwXvf2zA+h6jHa5nSmQex4n9AZHzAR-Zw@mail.gmail.com>
Subject: Re: [PATCH v4 17/18] btrfs: dedup: add a property handler for online dedup
From: Filipe Manana <fdmanana@gmail.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 15, 2016 at 12:36 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> Filipe Manana posted on Fri, 15 Jan 2016 09:19:28 +0000 as excerpted:
>
>>> Yes, test driven development is very nice, but there is also problem,
>>> especially for btrfs, like btrfs/047 which needs btrfs send
>>> --stream-version support.
>>
>> Yes, this one was a special case in that around 2 years ago it seemed
>> the functionality was going to be merged, but it ended up not being
>> merged due to reasons not known to me (no reasons pointed in the mailing
>> list nor in private).
>
> AFAIK/IIRC, the reason as I understood it is that ideally Chris Mason
> wants to do just one more stream version bump, which means being /very/
> sure it includes anything that has come up as needed in intervening
> development.  There's a few things agreed to be missing in the current
> stream version

Either you have had access to information I didn't had (Chris didn't
ever commented on
it, but Josef, David and Mark had) or you missed part of past discussions in the
mailing list (or perhaps my mail accounts didn't got anything).
Yes there were several new things discussed for a new version (and lot
of it listed in some
wiki page iirc), some of which I implemented and the remaining I
didn't, but left the necessary
changes in the stream format to avoid bumping the stream version
again. And that's where things
settled, without any more comments (neither on the mailing list nor
anywhere I could read,
something that happens often unfortunately).

>, yes, but it's usable as-is in the near term, and before
> that bump is done, everything else related needs to be in a mature enough
> development state that we can be reasonably sure nothing else is going to
> come up as still missing, at least for a couple years after the stream
> version bump.

Yes, send has had (and still has) several problems, but that shouldn't
prevent it from
getting more new useful commands indefinitely. Just like every part of
btrfs still has
bugs (you can see it either from the endless user reports or patches
coming in in every
release) with several degrees of severity.

>
> And without a second stream version to try, a --stream-version option
> isn't particularly testable, so it was judged to be too early to add it
> as an option.
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
