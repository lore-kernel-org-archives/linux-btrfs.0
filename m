Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:40186 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751158AbcL2Gzz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Dec 2016 01:55:55 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cMUcj-0006EH-TR
        for linux-btrfs@vger.kernel.org; Thu, 29 Dec 2016 07:55:37 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: some free space cache corruptions
Date: Thu, 29 Dec 2016 06:55:31 +0000 (UTC)
Message-ID: <pan$ae58d$e95cfda2$c0f069cf$47ecd8f5@cox.net>
References: <1482703234.6497.1.camel@scientia.net>
        <pan$6de89$3108fb7c$12cf2501$859bb20@cox.net>
        <1482983015.6556.14.camel@scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christoph Anton Mitterer posted on Thu, 29 Dec 2016 04:43:35 +0100 as
excerpted:

> On Mon, 2016-12-26 at 00:12 +0000, Duncan wrote:
>> By themselves, free-space cache warnings are minor and not a serious
>> issue at all -- the cache is just that, a cache, designed to speed
>> operation but not actually necessary, and btrfs can detect and route
>> around space-cache corruption on-the-fly so by itself it's not a big
>> deal.
> Well... sure about that? Haven't we had recently that serious bug in the
> FST, which could cause data corruption as btrfs used space as free,
> while it wasn't?

Well, the free-space-tree (FST) itself remains experimental and not 
recommended for general use yet.  The btrfs (5) manpage (as of -progs-4.9 
at least) calls space_cache=v1 the safe default, and the wiki status page 
lists v2 (tree) as orange level (/mostly/ OK).

And note that I said free-space _cache_, not free-space _tree_.

Of course that's not to (unwisely) claim there are no bugs in the free-
space _cache_ (aka v1), but rather, to claim that its status is exactly 
the same as that of btrfs in general, stabilizing but not fully stable, 
workable in general for daily use as long as you keep your backups 
updated and ready to use, and stay away from the known to be less stable 
features... which do /not/ include the free-space cache (v1), but /do/ 
include the free-space tree (v2).

And that cache (as opposed to tree) functionality really /is/ quite 
stable, as it has been rather heavily tested by now.  The only exception 
would be the usual one for new code over old, where the new code hasn't 
been well tested, but that's a given for projects at this stage, so has 
little need to be explicitly stated.

> 
>> These warnings are however hints that something out of the routine has
>> happened
> Which again just likely means that there was/is some bug in btrfs...
> other than that, why should it suddenly get some corrupted cache, when
> only ro-snapshots were removed in bewtween?

That wasn't plain to me in the message I replied to.  What I had in mind 
with that out of the routine reference was an ungraceful shutdown or 
crash, which /does/ commonly leave the free-space-cache in an 
inconsistent state, that btrfs routinely detects and deals with, 
invalidating and not using the section of cache that doesn't match what 
it knows to be the case from the other trees.

And in such an ungraceful shutdown situation, exactly as I stated, the 
free-space-cache warning is expected and dealt with routinely, but it's a 
hint that something else might have gone wrong in the event as well, that 
isn't necessarily so easily fixed, and that very well may /not/ be fixed 
automatically, and further, that continuing to use the filesystem with 
that problem still lurking can potentially cause further damage.

>> 2) It recently came to the attention of the devs that the existing
>> btrfs mount-option method of clearing the free-space cache only clears
>> it for block-groups/chunks it encounters on-the-fly.  It doesn't do a
>> systematic beginning-to-end clear.

> So that calls for fixing the documentation as well?!

It's documented already (in -progs 4.9) in the btrfs-check manpage, but 
you are correct in that it's not documented in the btrfs (5) manpage, 
which covers the mount options themselves.

On the wiki the manpages apparently haven't been regenerated from git 
recently, so they're missing the 4.9 content mentioned above, unless you 
follow the link in the warning at the top of each one, to the git 
version.  The git version of the manpages appears to have the same status 
as the 4.9 manpages, given above.

Of course if people are following this list as recommended, they'll know 
about it as well, because they will have seen the recent discussion.  Tho 
of course that's not going to help people who will be starting to 
investigate btrfs in some weeks' time, unless they read the list archive 
back far enough to see the discussion.  So it definitely needs documented 
in the btrfs (5) manpage ASAP, with the wiki manpage versions regenerated 
after it hits git.

>> 3) As a result of #2, the devs only very recently added support in
>> btrfs check for a /full/ space-cache-v1 clear, using the new
>> --clear-space-cache option.  But your btrfs-progs v4.7.3 is too old to
>> support it.  I know it's in the v4.9 I just upgraded to... checking the
>> wiki it appears the option was added in btrfs-progs v4.8.3 (v4.8.4 for
>> v2 cache).
> 
> And is the new option stable?! ;-)

The btrfs check option should be reasonably stable, yes.  Because it's a 
full clear on an unmounted filesystem, which has far less ways to go 
wrong than attempting to do a partial clear on a mounted filesystem.

Additionally, it has been there since 4.8.3, so thru that, 4.8.4, 4.8.5, 
and now into 4.9.0, without noted problems.  So it should be reasonably 
stable.

Put it this way, unlike most of the non-read-only options in btrfs check, 
I'd be quite willing to use it on my own systems without worry about 
risking further damage, should it be necessary.  And I tend to be pretty 
cautious about using known-unstable or stability-questionable features 
and options.  Of course there's always the chance that some bug might 
cause it to go wildly wrong, but that's _precisely_ why nobody here 
seriously claims that btrfs is fully stable and mature yet, and why 
keeping up with and being willing to use backups should it become 
necessary is so strongly recommended.  Given those parameters, I'd not 
hesitate at all to use the btrfs check --clear-space-cache option on my 
own systems or recommend its use to others, because I believe the risk of 
that specific option to be no more than, and arguably relatively less 
than, that I'm already taking by choosing to run btrfs in the first place.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

