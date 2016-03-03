Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59567 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082AbcCCHLi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 3 Mar 2016 02:11:38 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1abNQ7-0006p1-ID
	for linux-btrfs@vger.kernel.org; Thu, 03 Mar 2016 08:11:35 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Mar 2016 08:11:35 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Mar 2016 08:11:35 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: duplicate automounts with btrfs RAID1
Date: Thu, 3 Mar 2016 07:11:29 +0000 (UTC)
Message-ID: <pan$e2a75$149831e4$af0fb9c7$fb8b85f9@cox.net>
References: <1456950881.15729.2.camel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Leigh Orf posted on Wed, 02 Mar 2016 14:34:41 -0600 as excerpted:

> Here is info about my setup (up to date CentOS 7.2):
> 
> % cat /etc/system-release
> CentOS Linux release 7.2.1511 (Core)

> % uname -a
> Linux xxx.xxx.xxx.edu 3.10.0-123.20.1.el7.x86_64 #1 SMP
> Thu Jan 29 18:05:33 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux

> % btrfs --version
> btrfs-progs v3.19.1

Looks like you're getting some issue specific help already, but FWIW, 
here's the somewhat more generic general list recommendations.

First, note that btrfs in kernel 3.10 was still considered experimental, 
and came with big warnings about not using it in production, etc, and 
being sure to stay current as potentially data eating bugs were pretty 
literally being fixed in every release, back then.  That experimental 
lable wasn't removed until kernel 3.12, IIRC.

So as far as the list is concerned, your kernel is not only extremely 
old, it's from when btrfs was still considered experimental, when 
following the current kernel and userspace releases was *very* strongly 
recommended, as bugfix patches were *NOT* reliably backported at that 
point.

Second, realize that this list is mainstream kernel oriented, and that 
btrfs, while past experimental for ~2.5 years and nearing 13 kernel 
release cycles now, is still considered "stabilizing, not fully stable 
and mature", and as such, the strong recommendation is to be sure you 
have backups and are willing to use them if you choose to use btrfs, 
because it really is /not/ fully stable and mature yet.  (But I expect 
you have this point covered.)

Third, because btrfs /is/ still stabilizing, the recommendation remains, 
while not as insistent on staying /absolutely/ current as it was in the 
experimental btrfs era, to pick either the (mainstream stable) LTS kernel 
series or the current kernel series, and stay within two release cycles 
on either one.

With 4.4 both the latest release and the latest LTS series release, and 
4.1 the latest previous LTS series release, the recommendation is thus to 
be on 4.3 or 4.4 if you're following current kernels, and 4.1 or 4.4 if 
you're following the LTS series kernels.  Tho as it happens 3.18, the 
previous LTS series before 4.1, was pretty stable as well, so with it 
we're starting to reach three LTS series back, and continuing to support 
3.18 as well, now.  Whether that will continue thru 4.4 as the latest LTS 
and beyond, I'm not sure, but for now it seems we are.

But previous to 3.18, on-list, we really aren't supporting so well any 
more, because it's simply too old and too much has been fixed and/or 
simply changed, since then.  That doesn't mean we won't do the best we 
can, but simply, our best with that old just doesn't reach the same level 
as our best with 3.18 or newer.

Forth, while we do recognize that there are valid reasons to be 
conservative and want truly stable, given the btrfs status of 
stabilizing, but not yet fully stable and mature, wishing to run the 
still not entirely stable btrfs would seem at odds with a use-case 
requiring the stability of a three year old kernel in any case.  From the 
list perspective, at least, people doing that sort of thing, years-old 
kernel and software because they want stability, while trying to do btrfs 
as well, are choosing a filesystem that is simply not yet at that level 
of stability and maturity, and is thus incompatible with their needs and 
desire for long term stability.  As such, the strong recommendation in 
such cases is to reconsider such a choice, with the expected outcome 
being that they either don't need such years outdated stability after 
all, and can thus use btrfs on a more modern kernel and userspace, or 
they really /do/ need that sort of stability, in which case btrfs 
probably simply isn't an appropriate choice for them at this point.


So from the list perspective, at least, 3.10 is not only old, it's still 
from the experimental btrfs era, and you really ARE strongly encouraged 
to upgrade to more recent.  And by "more recent", we really mean at least 
3.18 LTS series, tho preferably it'd be at least 4.1 LTS, because older 
than that is simply too old to be effectively supported to the level we 
want our support to be.  The alternative of course is to use a filesystem 
more appropriate to the stability needs and concerns of those who for 
that reason choose to use three years outdated kernels.


But fifth, all that said, there's a flip side as well.  The above is 
indeed the general list consensus, but the list is focused on the 
/mainline/ kernel.  We recognize that various distros _have_ chosen to 
provide btrfs support on generally older kernels to which they backport 
many of the fixes, with the general idea being that they backport the 
newer fixes, but hopefully not the newer bugs.

But, it's the _distros_ choosing to provide that support, not the list, 
and only those _distros_ are tracking what patches they've backported and 
what they haven't.  As far as the _list_ is concerned, that's still a 
3.10 experimental btrfs kernel, with an unknown number of who knows which 
patches backported.  We're focused on the mainstream kernel and not the 
various distro efforts, and while we try to support the distro backport 
hackfests at the same version as the corresponding mainstream kernels 
because within our support period they've usually not diverged _that_ far 
from mainstream, there's really no practical way for us to properly 
support three year old kernel versions from the distros, for the same 
reason we aren't supporting three year old kernel versions from 
mainstream, *plus* the fact that we don't track what they've backported 
and what they haven't.

So while we do recognize that distros do offer btrfs support on such old 
kernels, in that case, you really should be taking those distros up on 
that offer, and getting that support from them, rather than from the 
list, because while we /will/ do our best, as the other replies to this 
thread have already demonstrated, often times, "our best", particularly 
when you're running a btrfs so old it was still listed as experimental, 
is going to literally be, "try upgrading to a newer kernel, something 
within the list-recommended kernel range at least, and see if the problem 
still exists."  For actually _staying_ on that old kernel, at least once 
you really hit btrfs issues, in practice, you'll probably need to get 
your support from your distro, who has chosen to provide that support on 
the old kernels we don't.


Finally, for userspace btrfs-progs, while policy is to try to support 
older and newer kernels with older and newer userspace as well, as a 
practical matter, while the kernel code is primary when you're _running_ 
btrfs, when there's problems and you're trying to recover from an 
unmountable filesystem situation, it's the userspace code that's primary, 
so it's then that having the latest btrfs-progs with all the latest fixes 
to recently discovered problems comes in handy.  So you don't really want 
userspace to get too behind, either.

As a rule of thumb, therefore, assuming people are already following the 
kernel recommendations and thus aren't running /too/ old a kernel, 3.18 
or 4.1 LTS series at the oldest, and because the userspace btrfs versions 
sync with those of kernel space so for instance a 4.1 series userspace 
was developed in sync with the 4.1 kernel, keeping userspace updated to 
at least kernel series sync is recommended, but newer is even better, 
because as I said, it gives you a better chance at fixing problems when 
they occur, because it'll have the latest patches to do so.

But you're already running a 3.19.1 btrfs-progs, and as I said, the 
oldest still supported kernel and thus the oldest recommended userspace 
by this rule of thumb is 3.18 series, you're fine on btrfs-progs.

But you really _do_ need to reconsider whether the still stabilizing and 
maturing btrfs is in line with the fact that you're choosing to run three 
years outdated kernels and a distro aimed at stability over currency.  
It's very likely that one or the other is out of sync with your needs.  
And if you find the distro's provision of btrfs support on that old a 
kernel sufficient, then you probably should be looking to your distro 
/for/ that support, as well, not here, as the level of support we can 
provide on such old kernels, particularly when they're old enough that 
btrfs was still experimental on them, really is quite limited, and the 
chances that we won't be able to do much but tell you to try a (much) 
newer kernel on any problems you have is very high.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

