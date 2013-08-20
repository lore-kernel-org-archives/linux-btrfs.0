Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:42506 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162Ab3HTAuf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Aug 2013 20:50:35 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 236387C067B
	for <linux-btrfs@vger.kernel.org>; Mon, 19 Aug 2013 18:50:33 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>, Tom Gundersen <teg@jklm.no>
From: Chris Mason <chris.mason@fusionio.com>
In-Reply-To: <5210449B.7000302@redhat.com>
CC: Duncan <1i5t5.duncan@cox.net>, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <pan$926b0$b4061d31$38c7ab48$19af94f0@cox.net>
 <20130817115901.17880.38963@localhost.localdomain>
 <CAG-2HqWDqjS2Er8FvwwgTkfMjoouwvjQeipHy_+ia7iTTfT==w@mail.gmail.com>
 <5210449B.7000302@redhat.com>
Message-ID: <20130820005030.30052.32161@localhost.localdomain>
Subject: Re: Question: btrfs-progs releases?
Date: Mon, 19 Aug 2013 20:50:30 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Eric Sandeen (2013-08-17 23:50:51)
> On 8/17/13 10:25 PM, Tom Gundersen wrote:
> > On Sat, Aug 17, 2013 at 7:59 PM, Chris Mason <chris.mason@fusionio.com> wrote:
> >> The problem with the progs release is I keep finding more things I want
> >> to add.  My local git tree has about a dozen commits that I feel are
> >> important enough for v1.0.  I just have to cut it, the distros and
> >> others are completely correct in asking for an official release.
> > 
> > I know this feeling too well.
> > 
> > In order to just "get something out", it might make sense to just do
> > some time-based releases every now and again (and maybe call them 0.X,
> > rather than 1.0 until you are happy). Even the occasional (maybe after
> > each kernel release) git tag (without actually creating tarballs etc)
> > would be very helpful, as at least we would have a common reference
> > point for bug reports and similar (and after all, numbers are cheap
> > ;-)).
> > 
> > From your point of view, having frequent releases will also (I
> > suppose) be helpful as it will make sure your users/testers are using
> > the most recent version (at least in Arch, whatever you tag we will
> > ship within a few days) and hence you won't have to ask them to
> > rebuild from git to make sure the bug hasn't already been fixed.
> > 
> >> In terms of the quality of the commits, I only put things into the
> >> master branch of the git tree that I have fully confidence in.
> > 
> > Thanks for the info Chris, this is useful to know. I'll keep pushing
> > git snapshots then (but as I said, tags would be better).
> 
> From my perspective, I don't want to push git snapshots; I'll fix one bug
> and add another.
> 
> We desperately need btrfs-progs stabilization and release.

Understood Eric, thanks for all your help so far.

-chris

