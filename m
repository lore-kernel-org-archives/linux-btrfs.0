Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:49974 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750878AbcLCF7L (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 Dec 2016 00:59:11 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cD3Ll-0007cE-0f
        for linux-btrfs@vger.kernel.org; Sat, 03 Dec 2016 06:59:05 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: missing checksums on reboot
Date: Sat, 3 Dec 2016 05:58:57 +0000 (UTC)
Message-ID: <pan$bcad4$d1ea79$23f69463$e8f55336@cox.net>
References: <CAFuzrVeWdz2Lup-x1OiJjVcknQRysiiZVYG1doxNdGKiHB+Jaw@mail.gmail.com>
        <4533be53-6c95-11a4-e101-6df9ca88410f@bouton.name>
        <CAFuzrVfF61EYSuxfb-68EsnN3evJaMWrABtGj-79OCmb8-ncnA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Blake Lewis posted on Fri, 02 Dec 2016 12:36:29 -0800 as excerpted:

> Well, 3.10 is what you get with the RHEL7.x distributions, so that's why
> people are running it.
> Apparently, it is "good enough" for many purposes.
> 
> My real goal here is to understand the scope of the bug and whether any
> mitigation is possible.  Of course, I don't expect anyone else to make a
> patch for me (or even to accept my patch), but if I knew what the bug is
> and what was done to fix it,
> I'd be in a much better position to decide what to do.  If anyone can
> shed any light on this,
> I'd be very grateful.

I'm going to try to make several points with this post, including a 
(perhaps too simplistic, but it works for me and apparently enough others 
to have a dedicated tool) suggestion for finding the problem, along with 
others basically agreeing with LB's reply but with a bit more 
background.  YMMV but it's posted in the hope that it is of help.

1) I am a list regular and btrfs using admin myself, but not a dev, so 
don't look here for the code-level stuff.

2) This is the btrfs development list, kernel level, not a distro list, 
and the viewpoints generally held here may or may not correspond to that 
of various distros and their support teams.

3) In particular, while btrfs has been officially out of experimental for 
some time now, on this list btrfs is held (by both btrfs devs and list-
regular users) to be still stabilizing, not fully stable and mature, as I 
normally describe it.  Both on this list and on the btrfs wiki (at 
https://btrfs.wiki.kernel.org ), the strong recommendation is to keep 
current on the kernel in particular, because bugs are still being found 
and fixed, and naturally, this list being development-focused, the view 
tends to be rather more forward leaning than particularly "enterprise-
stale^H^Hble" distros.

Also strongly recommended is keeping backups, tested and ready-to-use, 
because there /are/ still serious bugs being fixed, and sometimes the 
problems they trigger are, for non-devs at least, simply easiest to fix 
by blowing away the existing filesystem and starting over with a clean 
one and backups to recover from.

4) OTOH, some distros and other product vendors (including your company) 
obviously consider btrfs if not yet /entirely/ stable, stable /enough/ to 
build and ship product on.  While this is accepted as a questionable but 
already-in-the-wild-so-get-used-to-it position on the list, for kernels 
outside our normal support range (next point), the standard answer to 
users asking here for support is to say that while we recognize some 
distros support it on older kernels and with older btrfs userspace, we on 
this list tend to be forward looking and don't track what patches distros 
and vendors may have backported and which ones they haven't.  Thus, 
there's a 3-way choice they need to make, either (a) upgrade to something 
withing our recommended support range so we can best help, or (b) take 
the distro/vendor up on the support they offer and that the user may in 
fact be paying for, since they're best positioned to provide that support 
for older kernels they've done their own patching to, or (c) stay where 
they are and muddle thru the best they can with the limited support we 
/can/ offer -- we'll still do what we can, but honestly, the "impedance 
mismatch" with code that old is going to make it difficult to apply what 
limited support we can offer.

5) The versions we support best on the list, keeping in mind the above 
"current kernel" recommendation, are the two latest kernel series in 
either the current or LTS series.  On the current side, kernel 4.9 is 
very close to out now, so we like to see 4.8, tho 4.7 is still current 
enough that people on-list are likely to be able to reply sanely in terms 
of whether we recognize a bug and whether it's still current or has 
already been fixed.

On the LTS side, contradicting LB slightly, btrfs does try to backport 
bugfixes when we know they're needed in LTS series -- no effort is made 
to backport to non-LTS beyond the relatively short mainline non-LTS 
current kernel series support period, and as I said, they basically go 
out of support two kernels back.

The two most recent LTS kernel series are 4.4 and 4.1, with 3.18 before 
that.  Based on the two-most-recent policy, 4.4 is definitely still in 
focus, and we do still try for 4.1 as well, tho it's getting long enough 
in the tooth now that if the bug isn't recognized, an early question/
recommendation is going to be to try with a newer kernel.

The 3.18 LTS series actually ended up reasonably stable for btrfs, while 
4.4 may have taken a bit longer than normal to mature (in non-btrfs areas 
as well), so while it's back too far for much active support, it was 
working and is likely still working quite well for many.

3.16 was the LTS series before that, but that was a rough period for 
btrfs, and honestly, btrfs LTS support was new enough back then that we 
were only really trying to support the latest one, so 3.18 is really the 
practical horizon in terms of list support.  Before that there were some 
pretty bad bugs that nobody wants to even think about any more.

6) Meanwhile, what a lot of people don't realize is that until 3.12 (IIRC) 
stripped off the experimental label, btrfs remained officially 
experimental, with a pretty strong warning on both the kernel option and 
mkfs.btrfs on the user side.  In list support terms that's seriously 
ancient history now (think electricity in the 18th century maturity, it 
was a toy people could see was going to do great things one day and 
people were doing stuff with it, but it really /was/ experimental in 
anything even close to modern-day terms) and you're pretty much on your 
own.

Given that you're asking about 3.10, well... like I said, that's still 
btrfs experimental era, and I don't think I'm alone when I seriously 
question the sanity of anyone still attempting to support a product 
running btrfs on /that/!  If you're doing it, and people are willing to 
pay for it, well, I can't argue with that, but in all honesty, it's your 
customer's data you're putting at risk, and were I to see a product still 
running btrfs on a 3.10 kernel (or really, earlier than 3.18, for the 
reasons explained above, but 3.10 really /was/ still labeled experimental!
), I'd immediately mark everything that company sold as highly 
experimental and thus questionable, as well.  <shrug>  Just being honest.


So you can see why you're getting told to upgrade to /something/ semi-
recent, 3.18 LTS, at absolute minimum.  Some of those bugs in the early 
3.15-3.16 era tie my stomach in knots thinking about people still running 
those versions, they were that bad, even if in theory those bugs are long 
patched, by now.  Like I said, we were glad to see 3.18 LTS and it 
really /did/ end up surprisingly stable, up thru early 4.4 at least, when 
we stopped tracking it.

And FWIW, I /could/ be wrong here, but I /believe/ I saw that even Red 
Hat now actively recommends that people move off of btrfs on 3.10 era 
RHEL-7.x.  (At least there was a post on this list that I interpreted to 
that effect, tho if it actually affected me I'd be double-checking.)  I 
don't know what their actual support status is for those that don't.  You 
might want to look that up, because if it's true, it /would/ give your 
company a bit of an out in terms of supporting then-experimental btrfs, 
as well.


All that said, if you insist, again keeping in mind that I'm not a coder, 
so it's unsurprising that I don't have much in the way of specific 
commits to point you at, but at least here's a way to help you find them, 
yourself. =:^)

7) Incremental problem/fix bisect.  Recursively break the problem space 
roughly in half and test to see which half the problem/fix is in, then 
recurse by breaking that half in half and testing again.  You can use 
either git bisect, which has been popularized as a way for even non-
coders like me to nail down bugs (or in your case fixes) to specific 
commits, or perhaps first, to narrow down the range you need to git 
bisect, simply by doing a manual bisect of the release series between 
3.10 and 4.8, to find where the problem goes away, and then looking at 
that commit or the commits around that area to see what might have 
changed that broke, or in your case, fixed, the problem.

Bisect may be dumb and brute force, but it works surprisingly well, 
especially since git bisect automated most of the process, and as I said, 
it has allowed many non-coders to help in tracing and ultimately fixing 
their bugs.  I know it has worked that way for me.  And a modern git 
bisect better stays with release and then rc tags, then big merge points, 
as long as possible before diving down into individual commits, as well, 
making the incremental-bisect process a bit nicer and less "black-box" 
than it used to be, too.

Given what I said about 3.18 being a really good LTS in btrfs terms, I 
might suggest you start by testing it.  If it fixes the problem for you, 
then you can decide whether to try to push it as an upgrade, or try to 
bisect the problem further in ordered to properly backport the fix.  If 
it doesn't, of course the 4.1 and 4.4 LTS kernels are other major test 
points you can try.


So indeed, some of that was rehash, but with hopefully helpful additional 
detail now, and the bisect suggestion may be too simplistic.  But hope 
/some/ of it was helpful, anyway. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

