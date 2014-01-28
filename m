Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo202.cox.net ([68.230.241.217]:43468 "EHLO
	eastrmfepo202.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845AbaA1LlS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jan 2014 06:41:18 -0500
Received: from eastrmimpo306 ([68.230.241.238]) by eastrmfepo202.cox.net
          (InterMail vM.8.01.05.09 201-2260-151-124-20120717) with ESMTP
          id <20140128114117.MHZO3871.eastrmfepo202.cox.net@eastrmimpo306>
          for <linux-btrfs@vger.kernel.org>;
          Tue, 28 Jan 2014 06:41:17 -0500
Date: Tue, 28 Jan 2014 04:41:16 -0700
From: Duncan <1i5t5.duncan@cox.net>
To: KC <impactoria@googlemail.com>, linux-btrfs@vger.kernel.org
Subject: Re: Options for SSD - autodefrag etc?
Message-ID: <20140128044116.7198cfda@ws>
In-Reply-To: <KA9w1n01A0tVtje01A9yLn>
References: <52E2B73E.1050903@gmail.com>
	<7uuara-hf5.ln1@hurikhan77.spdns.de>
	<CAK5rZE6bF+z6Y9=X7SxtRPHE=1nNRPMmASC0VU8u90HQ_LbzVA@mail.gmail.com>
	<3664592.9YULOPb9vW@merkaba>
	<pan$3b2b3$cc9fb70b$a75e7148$4cfd82fc@cox.net>
	<KA9w1n01A0tVtje01A9yLn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 27 Jan 2014 23:09:55 +0100
KC <impactoria@googlemail.com> wrote:

> I forgot to ask about space_cache. Should it be off on SSD (ie 
> nospace_cache)?

[I don't see this on the list (which I read/reply-to using nntp via
gmane.org's list2news service) yet, so I'll reply to both the list and
you directly via mail...]

The default is now space_cache -- formerly a btrfs needed mounted with
it once, after which the option was "sticky" and applied by default so
it didn't need to be used again, and I believe the wiki mount-option
documentation at least still says that, but for at least several
kernels, the option seems to be on by default -- I never mounted with
space_cache specifically given here, yet all my btrfs have it listed
in /proc/self/mounts.

So space-cache is now the default unless specifically turned off.  And
while I don't have a specific reason to use it on ssd, I don't have a
good reason not to either, so not knowing anything specific I figured
I'd be best sticking with the defaults.

So on my btrfs on SSDs, space_cache is default-on simply because it's
the default and I know no good reason to mess with the defaults in that
case.  Actually I hadn't even thought of it in the context of something
else to record and thus to contribute to write-cycles, if there's no
real benefit to it on SSDs otherwise, but I guess there is, or it'd
default to off when ssds are detected, just like the ssd option is
automatically turned on in that case.  (In general, btrfs should in
most cases be able to detect ssd if it's on the "bare metal" physical
device or a partition on it.  If the btrfs is on top of lvm or mdraid,
however, or on some other mid-layer virtual device, it's less likely to
properly detect ssd, and you'd likely need to turn that option on
manually.)

-- 
Duncan - No HTML messages please, as they are filtered as spam.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman
