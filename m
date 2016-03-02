Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60521 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772AbcCBPFE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 2 Mar 2016 10:05:04 -0500
Date: Wed, 2 Mar 2016 16:04:48 +0100
From: David Sterba <dsterba@suse.cz>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Cc: Alexander Fougner <fougner89@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs-progs: initial scan-build results
Message-ID: <20160302150448.GA29310@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <56D58E93.9000705@googlemail.com>
 <CAGGqMYRKppf3vxjLCHrgwCp5-E6jf8kc6Mdj-NVmhoux6W-eVQ@mail.gmail.com>
 <56D5B90C.6000101@googlemail.com>
 <56D5C5C1.7000202@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <56D5C5C1.7000202@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 01, 2016 at 05:39:29PM +0100, Holger Hoffstätte wrote:
> On 03/01/16 16:45, Holger Hoffstätte wrote:
> > On 03/01/16 14:41, Alexander Fougner wrote:
> >> All zero-sized allocations are false positives, except the
> 
> Right, I've now also reviewed them all and they are all guarded
> by other conditions or plain wrong - very likely because this
> particular warning itself turns out to be a bug in llvm:
> https://llvm.org/bugs/show_bug.cgi?id=15708

Thanks for running the scan. I've played with the static scanner in the
past and my evaluation found like 5% of issues worth fixing, but more or
less low or moderate importance. The real value I see is that one has to
review some part of code and this usually leads to fixes.

The quality of the reports is IMHO questionable, just look at the path
of the reported problems, counted by branches and some important code
points. I've simply skipped anything that was more than like 20. Keeping
the whole context in head was hard and sometims there were "cannot
happen" conditions that were not visible to the checker.

I'm submitting progs to coverity regularly, the reports are totally
different from clang checker, and usually worth fixing. Also tracking
errors is a bit more friendly as it has the web ui to classify them.
A resubmission will mark off the fixed errors. Processing new batch of
errors means going through like 2-10 new errors, and it's usually on
code that I've seen recently.

Overall, I think it's good to try different checkers from time to time,
as the quality supposedly increases.
