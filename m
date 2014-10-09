Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo102.cox.net ([68.230.241.214]:41863 "EHLO
	eastrmfepo102.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbaJIMmd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Oct 2014 08:42:33 -0400
Received: from eastrmimpo210 ([68.230.241.225]) by eastrmfepo102.cox.net
          (InterMail vM.8.01.05.15 201-2260-151-145-20131218) with ESMTP
          id <20141009124232.KMML24978.eastrmfepo102.cox.net@eastrmimpo210>
          for <linux-btrfs@vger.kernel.org>; Thu, 9 Oct 2014 08:42:32 -0400
Date: Thu, 9 Oct 2014 05:42:31 -0700
From: Duncan <1i5t5.duncan@cox.net>
To: Hugo Mills <hugo@carfax.org.uk>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: What is the vision for btrfs fs repair?
Message-ID: <20141009054231.7f28f7d5@ws>
In-Reply-To: <0zvr1p0162Q6ekd01zvtN0>
References: <54358C77.2070808@redhat.com>
	<54367193.6000202@gmail.com>
	<pan$3113d$a3bae425$2c8363e3$ea9c68d9@cox.net>
	<0zvr1p0162Q6ekd01zvtN0>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 9 Oct 2014 12:55:50 +0100
Hugo Mills <hugo@carfax.org.uk> wrote:

> On Thu, Oct 09, 2014 at 11:53:23AM +0000, Duncan wrote:
> > Austin S Hemmelgarn posted on Thu, 09 Oct 2014 07:29:23 -0400 as
> > excerpted:
> > 
> > > Also, you should be running btrfs scrub regularly to correct
> > > bit-rot and force remapping of blocks with read errors.  While
> > > BTRFS technically handles both transparently on reads, it only
> > > corrects thing on disk when you do a scrub.
> > 
> > AFAIK that isn't quite correct.  Currently, the number of copies is 
> > limited to two, meaning if one of the two is bad, there's a 50%
> > chance of btrfs reading the good one on first try.
> 
>    Scrub checks both copies, though. It's ordinary reads that don't.

While I believe I was clear in full context (see below), agreed.  I was
talking about normal reads in the above, not scrub, as the full quote
should make clear.  I guess I could have made it clearer in the
immediate context, however.  Thanks.

> > Thus, while btrfs may randomly bump into a bad block and rewrite it
> > with the good copy, scrub is the only way to systematically detect
> > and (if there's a good copy) fix these checksum errors.



-- 
Duncan - No HTML messages please, as they are filtered as spam.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman
