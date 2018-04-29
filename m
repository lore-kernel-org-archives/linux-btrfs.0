Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:59049 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1752455AbeD2IFy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 29 Apr 2018 04:05:54 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1fChJ7-0004DI-SB
        for linux-btrfs@vger.kernel.org; Sun, 29 Apr 2018 10:03:41 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: What is recommended level of btrfs-progs and kernel please
Date: Sun, 29 Apr 2018 08:03:35 +0000 (UTC)
Message-ID: <pan$ba26f$2a16a649$f28cc5cc$12c248a1@cox.net>
References: <006c01d3defa$79d74e20$6d85ea60$@perdrix.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

David C. Partridge posted on Sat, 28 Apr 2018 15:09:07 +0100 as excerpted:

> To what level of btrfs-progs do you recommend I should upgrade once my
> corrupt FS is fixed?  What is the kernel pre-req for that?
> 
> Would prefer not to build from source ... currently running Ubuntu
> 16.04LTS

The way it works is as follows:

In normal operation, the kernel does most of the work, with commands such 
as balance and scrub simply making the appropriate calls to the kernel to 
do the real work.  So the kernel version is what's critical in normal 
operation.  (IIRC, the receive side of btrfs send/receive is an 
exception, userspace is doing the work there, tho the kernel does it on 
the send side.)

This list is mainline and forward-looking development focused, so 
recommended kernels, the ones people here are most familiar with, tend to 
be relatively new.  The two support tracks are current and LTS, and we 
try to support the latest two kernels of each.  On the current kernel 
track, 4.16 is the latest, so the 4.16 and 4.15 series are currently 
supported.  On the LTS track, 4.14 is the newest LTS series and is 
recommended, with 4.9 the previous one, still supported, tho as it gets 
older and memories of what was going on at the time fade, it gets harder 
to support.

That doesn't mean we don't try to help people with older kernels, but 
truth is, the best answer may well be "try it with a newer kernel and see 
if the problem persists".

Similarly for distro kernels, particularly older ones.  We track mainline 
and in general[1] have little idea what patches specific distros may have 
backported... or not.  With newer kernels there's not so much to backport, 
and hopefully none of their added patches actually interferes, but 
particularly outside the mainline LTS series kernels, and older than the 
second newest LTS series kernel for the real LTS distros, the distros 
themselves are choosing what to backport and support, and thus are in a 
better position to support those kernels than we on this list will be.


But when something goes wrong and you need to use the debugging tools or 
btrfs check or restore, it's the btrfs userspace (btrfs-progs) that is 
doing the work, so it becomes the most critical when you have a problem 
you are trying to find/repair/restore-from.

So in normal operation, userspace isn't critical, and the biggest problem 
is simply keeping it current enough that the output remains comparable to 
current output.  With btrfs userspace release numbering following that of 
the kernel, for operational use, a good rule of thumb is to keep 
userspace updated to at least the version of the oldest supported LTS 
kernel series, as mentioned 4.9 at present, thus keeping it at least 
within approximately two years of current.

But once something goes wrong, the newest available userspace, or close 
to it, has the latest fixes, and generally provides the best chance at a 
fix with the least hassle or chance of further breakage instead.  So 
there, basically something within the current track, above, thus 
currently at least a 4.15 if not a 4.16 userspace (btrfs-progs) is your 
best bet.

And often the easiest way to get that if your distro doesn't make it 
directly available, is to make it a point to keep around the latest 
LiveRescue (often install/rescue combined) image of a distro such as 
Fedora or Arch that stays relatively current.  That's often the newest or 
close enough, and if it's not, it at least gives you a way to get back 
online to fetch something newer after booting the rescue image, if you 
have to.

---
[1] In general:  I think one regular btrfs dev works with SuSE, and one 
non-dev but well-practiced support list regular is most familiar with 
Fedora, tho of course Fedora doesn't to be /too/ outdated.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

