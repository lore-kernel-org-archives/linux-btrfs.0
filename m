Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:35377 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbcFZWdK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 26 Jun 2016 18:33:10 -0400
Received: by mail-oi0-f44.google.com with SMTP id r2so179309492oih.2
        for <linux-btrfs@vger.kernel.org>; Sun, 26 Jun 2016 15:33:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$60ea0$54eb541$a3b060fc$181835e5@cox.net>
References: <8695beeb-f991-28c4-cf6b-8c92339e468f@inwind.it>
 <CAJCQCtTXJhgKsmQGUXrppntYj8u6vk3jzP9Q4UMBomJ255QTQw@mail.gmail.com> <pan$60ea0$54eb541$a3b060fc$181835e5@cox.net>
From: ronnie sahlberg <ronniesahlberg@gmail.com>
Date: Sun, 26 Jun 2016 15:33:08 -0700
Message-ID: <CAN05THQCJS8x0yF6DjDFfsNWzp1u4edv5dH-BMb1TTofZdtjgA@mail.gmail.com>
Subject: Re: [BUG] Btrfs scrub sometime recalculate wrong parity in raid5
To: Duncan <1i5t5.duncan@cox.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jun 25, 2016 at 7:53 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> Chris Murphy posted on Sat, 25 Jun 2016 11:25:05 -0600 as excerpted:
>
>> Wow. So it sees the data strip corruption, uses good parity on disk to
>> fix it, writes the fix to disk, recomputes parity for some reason but
>> does it wrongly, and then overwrites good parity with bad parity?
>> That's fucked. So in other words, if there are any errors fixed up
>> during a scrub, you should do a 2nd scrub. The first scrub should make
>> sure data is correct, and the 2nd scrub should make sure the bug is
>> papered over by computing correct parity and replacing the bad parity.
>>
>> I wonder if the same problem happens with balance or if this is just a
>> bug in scrub code?
>
> Could this explain why people have been reporting so many raid56 mode
> cases of btrfs replacing a first drive appearing to succeed just fine,
> but then they go to btrfs replace a second drive, and the array crashes
> as if the first replace didn't work correctly after all, resulting in two
> bad devices once the second replace gets under way, of course bringing
> down the array?
>
> If so, then it looks like we have our answer as to what has been going
> wrong that has been so hard to properly trace and thus to bugfix.
>
> Combine that with the raid4 dedicated parity device behavior you're
> seeing if the writes are all exactly 128 MB, with that possibly
> explaining the super-slow replaces, and this thread may have just given
> us answers to both of those until-now-untraceable issues.
>
> Regardless, what's /very/ clear by now is that raid56 mode as it
> currently exists is more or less fatally flawed, and a full scrap and
> rewrite to an entirely different raid56 mode on-disk format may be
> necessary to fix it.
>
> And what's even clearer is that people /really/ shouldn't be using raid56
> mode for anything but testing with throw-away data, at this point.
> Anything else is simply irresponsible.
>
> Does that mean we need to put a "raid56 mode may eat your babies" level
> warning in the manpage and require a --force to either mkfs.btrfs or
> balance to raid56 mode?  Because that's about where I am on it.

Agree. At this point letting ordinary users create raid56 filesystems
is counterproductive.


I would suggest:

1, a much more strongly worded warning in the wiki. Make sure there
are no misunderstandings
that they really should not use raid56 right now for new filesystems.

2, Instead of a --force flag. (Users tend to ignore ---force and
warnings in documentation.)
Instead ifdef out the options to create raid56 in mkfs.btrfs.
Developers who want to test can just remove the ifdef and recompile
the tools anyway.
But if end-users have to recompile userspace, that really forces the
point that "you
really should not use this right now".

3, reach out to the documentation and fora for the major distros and
make sure they update their
documentation accordingly.
I think a lot of end-users, if they try to research something, are
more likely to go to <their-distro> fora and wiki
than search out an upstream fora.
