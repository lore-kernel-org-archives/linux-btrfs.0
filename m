Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59529 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753029AbcH2RM3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Aug 2016 13:12:29 -0400
Date: Mon, 29 Aug 2016 19:11:10 +0200
From: David Sterba <dsterba@suse.cz>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: russell@coker.com.au, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Lukas Lueg <lukas.lueg@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: Carefully crafted BTRFS-image causes kernel to crash
Message-ID: <20160829171110.GZ16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAJF-kYngS4U6=oiXhs0ZF3Na3ezTGcMX1Wyd5HVVm887V61mWw@mail.gmail.com>
 <5535C11C.2050308@cn.fujitsu.com>
 <201504211938.35080.russell@coker.com.au>
 <5536380C.9080102@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5536380C.9080102@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 21, 2015 at 07:44:12AM -0400, Austin S Hemmelgarn wrote:
> On 2015-04-21 05:38, Russell Coker wrote:
> > On Tue, 21 Apr 2015, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
> >> Although we may add extra check for such problem to improve robustness,
> >> but IMHO it's not a real world problem.
> >
> > Some of the ReiserFS developers gave a similar reaction to some of my bug
> > reports.  ReiserFS wasn't the most robust filesystem.
> >
> > I think that it should be EXECTED that a kernel will have to occasionally deal
> > with filesystem images that are created by hostile parties.  Userspace crash
> > and kernel freeze is not a suitable way of dealing with it.
> >
> And that kind of reaction is why ReiserFS isn't taken very seriously in 
> an enterprise environment.
> 
> Just because something shouldn't be possible in a 'real world' 
> environment, doesn't mean it won't happen; never underestimate the 
> ability of hardware to fail in new and unexpected ways, or the ability 
> of administrators to make stupid mistakes.

I agree, given the high number of random memory bitflips that I've seen
in past years, that were stored to the disk with valid checksums.
Whether it's a real-world or potentially a hw problem IMO adjusts the
priority, but the issues should be fixed if possible.
