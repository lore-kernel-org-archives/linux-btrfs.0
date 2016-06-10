Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:33642 "EHLO
	tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbcFJRWJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Jun 2016 13:22:09 -0400
Date: Fri, 10 Jun 2016 19:22:03 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Nikolaus Rath <Nikolaus@rath.org>, linux-btrfs@vger.kernel.org
Subject: Re: fsck: to repair or not to repair
Message-ID: <20160610172203.GB18657@angband.pl>
References: <87y47g1esh.fsf@thinkpad.rath.org>
 <87fuslg19q.fsf@vostro.rath.org>
 <ec929c7d-079d-8ea5-87d7-fce0ed1c45b7@gmail.com>
 <87twh1t4xv.fsf@thinkpad.rath.org>
 <20160610165046.GA18657@angband.pl>
 <271297eb-f557-4b9b-e236-81dd3f70c1be@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <271297eb-f557-4b9b-e236-81dd3f70c1be@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 10, 2016 at 01:12:42PM -0400, Austin S. Hemmelgarn wrote:
> On 2016-06-10 12:50, Adam Borowski wrote:
> >And, as of coreutils 8.25, the default is no reflink, with "never" not being
> >recognized even as a way to avoid an alias.  As far as I remember, this
> >applies to every past version with support for reflinks too.
> >
> Odd, I could have sworn that was an option...
> 
> And I do know there was talk at least at one point of adding it and
> switching to reflink=auto by default.

Yes please!

It's hard to come with a good reason for not reflinking when it's possible
-- the only one I see is if you have a nocow VM and want to slightly improve
speed at a cost of lots of disk space.  And even then, there's cat a >b for
that.

And the cost on non-btrfs non-unmerged-xfs is a single syscall per file,
that's utterly negligible compared to actually copying the data.

-- 
An imaginary friend squared is a real enemy.
