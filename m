Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:36390 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1752775AbeAJC6X (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Jan 2018 21:58:23 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1eZ6Yn-0004bT-F1
        for linux-btrfs@vger.kernel.org; Wed, 10 Jan 2018 03:56:13 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs scrub not repair corruption
Date: Wed, 10 Jan 2018 02:56:06 +0000 (UTC)
Message-ID: <pan$cfc24$4398bca4$6da14d2f$be710e04@cox.net>
References: <20180108222727.oafq5mdoqel7r36y@wolfsden.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Wolf posted on Mon, 08 Jan 2018 23:27:27 +0100 as excerpted:

> I'm running btrfs scrub on my raid each week (is that too often?) and
> I'm having a problem that it reports corruption, says it's repaired but
> next week reports it again.

I won't attempt to answer the larger question, but on the narrow "too 
often?" question, no, running scrub once a week shouldn't be a problem.

Scrub is read-only unless it finds errors, so even running it repeatedly 
end-to-end shouldn't be a problem, other than the obvious performance 
issue and the potential increased head-seek wear on non-ssd devices.  The 
obvious issue would be slowing down whatever else you're doing at the 
same time, and at whatever presumably scheduled weekly time you run it 
that's evidently not a problem for your use-case.


Also, a bit OT as I don't believe it's related to this, but FWIW...

There *has* been a recent kernel issue with gentoo-hardened compiling 
kernel code incorrectly due to a gcc option enabled by default on 
hardened.  I don't remember the details, but I ran across in in one of 
the kernel development articles I read.  I /think/ it applied only to 
4.15-rc, however, or possibly 4.14.  The fix is to disable that specific 
gcc option when building the kernel, as it was designed for userspace and 
doesn't make much sense for the kernel anyway.  A patch doing just that 
should already be part of the latest 4.15-rcs and if the bug applied to 
4.14 it'll be backported there as well, but I'm not sure of current 4.14-
stable status.

(I run gentoo, so my interest perked when I came across the discussion, 
but not hardened, so I didn't need to retain the details.)

If you're not already aware of that, you might wish to research it a bit 
more, and disable whatever option manually in your kernel-build CFLAGS, 
tho as mentioned once the patch is applied the kernel make files 
automatically apply the appropriate option. (The official kernel CFLAGS 
related vars are KCFLAGS (C), KCPPFLAGS (pre-processor), and KAFLAGS 
(assembler).)  Unfortunately IDR what the specific flag was, 
-fno-something, IIRC.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

