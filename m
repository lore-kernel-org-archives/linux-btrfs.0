Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:32963 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbbBZWUw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Feb 2015 17:20:52 -0500
Received: by wghb13 with SMTP id b13so15373375wgh.0
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Feb 2015 14:20:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1424988253.7413.0@mail.thefacebook.com>
References: <CAG-aW06oJ3NB1zOZ0NuAmLK36kOdKKJhQgJhKCZmVtpAqbZXrA@mail.gmail.com>
	<1424988253.7413.0@mail.thefacebook.com>
Date: Thu, 26 Feb 2015 23:20:51 +0100
Message-ID: <CAG-aW07LJ5Bi5AvaajR56ynoR6bZfiHjnyU3pjKiLQ3Yd+fMZw@mail.gmail.com>
Subject: Re: Btrfs fixes, changes don't appear on git repo
From: Matt <jackdachef@gmail.com>
To: Chris Mason <clm@fb.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, jbacik@fb.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 26, 2015 at 11:04 PM, Chris Mason <clm@fb.com> wrote:
>
>
> On Thu, Feb 26, 2015 at 4:49 PM, Matt <jackdachef@gmail.com> wrote:
>>
>> Hi linux-btrfs list,
>>
>> Hi Chris, Hi Josef,
>>
>>
>> it seemingly happened in the past and now it seems to happen again:
>>
>> after patches have been posted to the linux-btrfs mailing list and
>> pulled by Linus,
>>
>> changes occured and additional pull-requests followed - the old
>> commits don't appear to be anywhere accessible besides Linus' tree
>>
>>
>> example:
>>
>> http://marc.info/?l=linux-btrfs&m=142203898505309&w=2
>>
>> [GIT PULL] Btrfs fixes
>> from January 23rd
>
>
> Sorry for the confusion.  What happens is that I send Linus pulls for the
> things he's missing, and we have slightly parallel development branches.
>
> Before 3.19-rc1, I forked 3.18-rc5 and rebased my 3.19 merge window on top
> of that.  All of my commits for 3.19 went on top of this branch.
>
> I forked our tree for the 4.0 merge window at 3.19-rc5.  This is where all
> the 4.0 commits went.  But, 3.19 kept rolling and we had additional fixes in
> before 3.19-final.
>
> I use the same branch for every pull to Linus (for-linus), so during
> 3.19-rc6 I sent him code on top of for-linus, which at the time was based on
> 3.18-rc5 and had all my 3.19 code in it.
>
> Then the 4.0 merge window started and I switched to my 3.19-rc5 based merge
> window tree, which was actually missing the commit you mentioned because
> Linus took it after rc5.
>
> It all works for Linus because git merges things easily, and he actually
> prefers that you don't merge in later releases unless you need some fix to
> keep things stable.  In other words, if my for-linus for the 4.0 merge
> window has a merge with 3.19-final, he may push back.

Thanks for the swift and elaborate explanation !

Yes, that's what got me now and in the past confused - I'm sure I'm
not the only one ;)

>
> In general, you can take my for-linus on top of the last released Linus
> kernel and have all the current commits that are considered stable.

That's the plan :)

>
> In the future, I'll keep a for-linus-xxyyzz for the last release to make
> this less confusing.

Wow, this would make things a lot clearer and getting an overview much faster !

Your repo then probably would resemble Paul E. McKenney's (
https://git.kernel.org/cgit/linux/kernel/git/paulmck/linux-rcu.git/ )
but I like it that way - everything accessible and comprehensible

Surely a win-win for the devs & community

Thanks again

>
> -chris
>
>
>

Kind Regards

Matt
