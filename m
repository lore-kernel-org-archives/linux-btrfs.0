Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54219 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753351AbbLEMos (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 5 Dec 2015 07:44:48 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a5CCc-0008CJ-00
	for linux-btrfs@vger.kernel.org; Sat, 05 Dec 2015 13:44:38 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 05 Dec 2015 13:44:37 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 05 Dec 2015 13:44:37 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: 3.16.0 Debian kernel hang
Date: Sat, 5 Dec 2015 12:44:25 +0000 (UTC)
Message-ID: <pan$e22d3$265bc179$9398af1d$aee90b66@cox.net>
References: <201512042100.58127.russell@coker.com.au>
	<5661906A.50309@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S Hemmelgarn posted on Fri, 04 Dec 2015 08:08:58 -0500 as
excerpted:

> On 2015-12-04 05:00, Russell Coker wrote:
>>
>> When I mounted the filesystem with a 4.2.0 kernel it said "The free
>> space cache file (1103101952) is invalid, skip it" and then things
>> worked.  Now that the machine is running 4.2.0 everything is fine.
>>
>> I know that there are no plans to backport things to 3.16 and I don't
>> think the Debian people are going to be very interested in this.  So
>> this message is a FYI for users, maybe consider not using the
>> Debian/Jessie kernel for BTRFS systems.
>>
> I'd suggest extending that suggestion to:
> If you're not using an Enterprise distro (RHEL, SLES, CentOS, OEL), then
> you should probably be building your own kernel, ideally using upstream
> sources.

My personal recommendation differs from that somewhat, in both directions.

The first thing to consider is that in terms of this list, at least, 
while btrfs is considered to be stabilizING, , it's not yet either fully 
stable or mature.  It's "good enough for daily use" provided you're 
following in any case reasonable admin backup policies that respect the 
general admin rule that if the data is of more value than the time and 
resources required to back it up, then it IS backed up, and conversely, 
that if it's not backed up to a particular level, you are by your actions 
defining it as worth less than the time and trouble to do that Nth level 
backup while taking into account the risk factor of actually having to 
use it.

But, that assumes keeping "reasonably" current with both the kernel and 
tools.  Here, the recommendation is much relaxed from what it used to be, 
but the assumption and recommendation is that you'll either follow the 
current kernel, being no more than one release series behind (with 4.3 
out, you might still be on 4.2) unless you have a specific bug (btrfs or 
otherwise) that's still being addressed, OR at least follow the upstream 
kernel LTS series, again, being no further than one such series behind 
(the 4.1 and 3.18 LTS series are thus currently covered, with 4.4 already 
taken on as another LTS series, so those on 3.18 should be well into 
their 4.1 upgrade preparations as 4.4 should be out around Christmas).

The reasoning is that development remains quite rapid, and older kernels 
both have known and long fixed bugs, and in the case of older LTS kernels 
(from 3.12 at least, as that's when the experimental label was stripped) 
which should still at least be getting the critical fixes, are simply too 
prehistoric code to reasonably support on-list, as too much has changed 
since then and btrfs is /not/ yet fully stable.

_But_, that's in terms of the mainline kernel and list support.  Some 
distros, primarily enterprise but the same idea applies to distros in 
general, have chosen to support btrfs on their old "stable series" 
kernels, where they presumably backport the critical btrfs patches along 
with other critical kernel patches.

If some btrfs users choose to accept their distro's claims of support on 
older kernels at face value, that's between them and the distro.  But 
here's the thing, this list is focused on the mainline kernel, and many 
here don't know or particularly care what specific patches random distro 
Y may have backported... or not.  So users that choose to use their 
distro's kernels, particularly older kernel series not well supported on-
list, really need to be looking to their distros for that support, not 
the list, because they're not running versions well supported by the list.


So contrary to Austin's recommendation, mine would be, yeah, run your 
distro's kernel if it's within the general list supported range mentioned 
above.  You don't _have_ to build your own kernel, and if it's within the 
two most current kernel series or the two most recent LTS kernel series, 
we'll do our best on-list to help.

But if you choose to run kernels outside that list-supported range, 
regardless of whether you're running distro kernels or building your own, 
you really shouldn't be relying on this list for support, because while 
we'll generally still try to do our best to help, it's out of our focus 
range and the level of support simply isn't going to be as good as it 
would if you were running newer kernel series, as a result.

For enterprise distro users as well as other distros running ancient 
kernels, that means your best support may well be from your distro, and 
particularly for enterprise distros, that's often what you're paying good 
money to get, so you should be able to expect/demand that support, or you 
can take that money elsewhere.

So my recommendation doesn't really distinguish enterprise users from 
others, except that enterprise users are both often running older kernels 
and paying good money for support.  Enterprise distro or not, however, if 
users choose to run older kernels, they can expect a lower level of 
practical list support because we're simply not focused on that old, but 
if it's an older distro-supported kernel, they _may_ be able to get that 
support from the distro, and enterprise distros should be better equipped 
to provide it.

But whether they can get that support from the distro or not is really a 
matter between them and the distro, not something that concerns the list, 
except to the extent that we can suggest they investigate distro support 
resources if they're running a distro kernel out of the latest two 
current or latest two LTS kernel series, thus making it outside of the 
list's primary focus area.

> Ubuntu is notorious for picking 'stable' kernels that then fail to be
> marked by kernel.org as LTS,

Indeed.  Tho I believe I read an announcement that their next release is 
going to be on the LTS 4.4. =:^)

> Debian picks kernels that are multiple
> versions old by the time they make a release, and I've heard similar
> from other non-enterprise distros that don't inherently make you build
> your own kernel.

While that's true for Debian stable, it's really no different than the 
enterprise distros, and newer pre-built kernels /are/ available, if you 
add the appropriate repos.  But the same thing applies, debian, 
enterprise, or other.  If it's an older distro-supported kernel and 
you're relying on them for support, do just that, rely on them for 
support, as it's not something this list is really going to be good at.  
If they can actually provide that support, great.  If they can't... well, 
perhaps you better reevaluate relying on them for support and consider 
changing either your kernel and btrfs-progs userspace choices, or your 
distro or distro version, or possibly, your filesystem, as the still 
stabilizing btrfs choice really isn't compatible with your old and stable 
kernel choice, at least if your distro isn't willing or able to provide 
the level of support you need.

> Even among ones that you have to build the kernel
> yourself anyway, there are issues (Gentoo for example doesn't often mark
> new kernels as stable, even when they are perfectly usable for pretty
> much everyone).

For gentoo anyway...

FWIW, the ~10-week kernel release cycle, as with other short-cycle 
products such as firefox and chrome, just doesn't work well with a 
general 30-day-testing without serious new bugs before stabilization 
policy.  By the time the testing cycle is complete, a new release is out, 
generally fixing security bugs as well as others, so it's effectively 
impossible to maintain any sort of stable-as-stable policy on these short-
cycle products.

As a result, the stabilization focus is generally on the long term 
support series releases (firefox and kernel both, AFAIK chrome doesn't 
have one so is ~arch aka testing keyworded only) and the short-cycle 
releases are normally not even considered stabilization candidates.

The kernel, firefox and google-chrome have all had threads on gentoo-dev 
over the years where their stabilization policies were formalized, and 
the short-cycle release policy now has solid enough precedent, I expect 
other less headline short-cycle-release packages are following the same 
policy.

As for the kernel itself, gentoo-sources, the ones carrying gentoo's 
mainline patches, follows the stabilization policy above.  Vanilla-
sources, aka unpatched mainline, are also available, and there's even
git-sources following mainline development rcs, but these aren't 
stabilization-tested at all and thus remain ~arch/testing only.  (FWIW 
there's a few other kernel sources series available in-tree as well for 
those who want/need them, aufs, ck, hardened, mips, openvz, pf, 
raspberrypi, rsbac, rt, tuxonice.)


So it's not that gentoo doesn't mark kernels stable.  They do.  They just 
focus on the LTS series kernels, because the short-cycle releases simply 
don't allow enough time for proper stabilization, and are generally out 
of upstream support before they could be stabilized following standard 
stabilization policy.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

