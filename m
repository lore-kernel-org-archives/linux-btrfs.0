Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43030 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754612AbbLPLCF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Dec 2015 06:02:05 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a99qM-0007Da-8F
	for linux-btrfs@vger.kernel.org; Wed, 16 Dec 2015 12:02:02 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Dec 2015 12:02:02 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Dec 2015 12:02:02 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: need to recover large file
Date: Wed, 16 Dec 2015 11:01:56 +0000 (UTC)
Message-ID: <pan$8fd1f$d0a2d4bd$a145e3d0$e1171740@cox.net>
References: <E3AE2CD5-D3F1-48CF-9C5E-092DDF41AF3A@neb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Langhorst, Brad posted on Wed, 16 Dec 2015 03:13:48 +0000 as excerpted:

> Hi:
> 
> I just screwed upâŠ spent the last 3 weeks generting a 400G file
> (genome assembly) .
> Went to back it up and swapped the arguments to tar (tar Jcf my_precious
> my_precious.tar.xz)
> what was once 400G is now 108 bytes of xz header - argh.
> 
> This is on a 6-volume btrfs filesystem.
> 
> I immediately unmounted the fs (had to cd /  first).
> 
> After a bit of searching I found Chris Masonâs post about using
> btrfs-debug-tree -R

[Snip most of the result as I'm not familiar with this utility.  But it 
ends with...]

> Btrfs v3.12

[...]
 
> I also read that one can use btrfs-find-root to get a list of files to
> recover and just ran btrfs-find-root on one of the underlying disks but
> I get an error "Super think's the tree root is at 25606900367360,
> chunk root 25606758596608
> Went past the fs size, exiting

WTF?  I thought that bug was patched a long time ago.  How old a btrfs-
progs are you using, anyway?

*OH!* *3.12*

Why are you still using 3.12?  That's nigh back in the dark ages as far 
as btrfs is concerned.  AFAIK, btrfs was either still labeled 
experimental back then, or 3.12 was the first version where experimental 
was stripped, so it's a very long time ago indeed, particularly for a 
filesystem that while no longer experimental, is still under heavy 
development, with bugs being fixed in every release, with the patches not 
always reaching old stable tho since 3.12 for the kernel anyway they do 
try, so if you're running old releases, you're code that's known to be 
buggy and known to have fixes for those bugs in newer releases.

The general list recommendation for the kernel, unless you have a known 
reason (like an already reported but still unfixed bug in newer), is run 
the latest or next to latest release series of either current, which 
would ATM be 4.3 or 4.2, as 4.4 isn't out yet, tho it's getting close, or 
or LTS, which would be 4.1 or 3.18, tho 4.4 will be also and it's getting 
close so you should be already preparing to upgrade to at least 4.1 if 
you're on the LTS series.

The coverage of the penultimate series gives you some time to upgrade to 
the latest, since the penultimate series is covered too.

For runtime, the kernel code is generally used (userspace mostly just 
makes calls to the kernel and lets it do the work), so kernel code is 
most important.  However, once you're trying to recover things, 
basically, when you're working with the unmounted filesystem, userspace 
code is used, so having something reasonably current there becomes 
important.

As a rule of thumb, then, running a btrfs-progs userspace of at least the 
same release series as the kernel you're running is recommended (tho 
newer is fine), since the kernel and userspace were developed at about 
the same time and with the same problems in mind, and if you're keeping 
up with the kernel series recommendation, that means you're userspace 
isn't getting /too/ old.  But even then, once you're trying to do a btrfs 
recovery with those tools, a recommendation to try latest current can be 
considered normal, since it'll be able to detect and usually fix the 
latest problems.

So a 3.18 series kernel and at least a 3.18 series userspace, would be 
recommended, and indeed, for a filesystem like btrfs that is still 
stabilizing and not yet fully stable and mature, is quite reasonable 
indeed.  While some people have reason to use particularly old and 
demonstrated stable versions, and enterprise distros generally cater to 
this need with support for upto a decade, using a still new and maturing 
btrfs is incompatible with a need for old and demonstrated stable, so in 
that case, from the viewpoint of this list at least, if you're looking 
for that old and stable, you really should be using a different 
filesystem, as btrfs simply isn't that old and stable, yet.

Meanwhile, while that's the view of upstream btrfs and thus this upstream 
list, some distros never-the-less choose to support old btrfs, backporting 
patches, etc, as they consider necessary.  However, that's their support 
then, and their business.  If you're trusting them for that support, 
really, you should be contacting them for it, as this list really isn't 
in the best position to supply that sort of support.  Yes, they may be 
using an old in number kernel and perhaps userspace, with newer patches 
backported to it, but it's the distro that makes those choices and knows 
what patches it's backporting, and thus is in the best position to 
support it.  Not that we on the list won't try, but we're simply not in a 
good position to provide that support that far back as we've long since 
moved on, neither do we track what distros have backported and what they 
haven't, etc.


So, basically, you have four choices:

1) Follow list recommendations and upgrade to something that isn't out of 
the dark ages in terms of btrfs history.

2) Follow the presumed recommendations of your distro, and get support 
there, since they're best positioned to support you with those old 
versions.

3) Decide to take your chances at the best support we can offer given 
your old versions, knowing it's not to the level we could offer if you 
upgraded to something semi-current, and it might mean losing data to bugs 
that are long since fixed in current versions.

4) Decide that btrfs is too fast moving for your use-case as you need a 
truly stable filesystem and tools, and switch to something more 
appropriate to your use-case.


Seriously.  I remember discussion of that bug and believe it's fixed in 
anything even close to current userspace.  Meanwhile, the latest btrfs 
restore works quite a bit better as well.  I know as I've used restore a 
couple times myself, and the new version really does work a LOT better. 
=:^)  So I really would suggest upgrading, as I think it very well might 
eliminate the problems you're seeing and let you find and restore from a 
good root, hopefully getting that file back.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

