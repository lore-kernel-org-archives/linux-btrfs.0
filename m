Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:56222 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755610Ab2LMVGa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Dec 2012 16:06:30 -0500
Date: Thu, 13 Dec 2012 16:06:28 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Zach Brown <zab@zabbo.net>
CC: Chris Mason <clmason@fusionio.com>,
        Nirbheek Chauhan <nirbheek.chauhan@gmail.com>,
        Hugo Mills <hugo@carfax.org.uk>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: no activity in kernel.org btrfs-progs git repo?
Message-ID: <20121213210628.GB27308@shiny>
References: <20121212224214.GA9195@lenny.home.zabbo.net>
 <20121212225157.GD19051@carfax.org.uk>
 <CADqQcK7OGPbj2CYwSwrk+1-GLfTJ1YYxh8eaDH3_1y+k_u1=2A@mail.gmail.com>
 <20121212234150.GB9195@lenny.home.zabbo.net>
 <20121213145610.GA12369@shiny>
 <20121213195040.GE9195@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20121213195040.GE9195@lenny.home.zabbo.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 13, 2012 at 12:50:40PM -0700, Zach Brown wrote:
> On Thu, Dec 13, 2012 at 09:56:10AM -0500, Chris Mason wrote:
> > 
> > Yes, I've got the big raid56 push ready to go out, and I've just been
> > trying to test it all.  I'll put that in a raid branch and get the fixes
> > onto master.
> 
> Thanks.
> 
> I was asking because it's pretty annoying to go through patchwork to see
> if someone else has already fixed bugs in the git tree.  This happened
> to me when our distro package infrastructure freaked out at btrfs-progs
> (-fno-strict-aliasing, int/ptr differences, static code analysis
> lighting up a like a christmas tree).
> 
> Would it be fair to say that the project is accepting applications for
> an active btrfs-progs maintainer? :)

Well, the problem is the active maintainer is busy piling in other
features.  But yeah, I need to pull in the fixes, sorry.

-chris

