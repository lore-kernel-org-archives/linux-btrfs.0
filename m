From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Updated performance results
Date: Thu, 17 Sep 2009 14:52:20 -0400
Message-ID: <20090917185220.GA18165@think>
References: <4A7C32A4.9070106@austin.ibm.com>
 <20090807231240.GD3710@think>
 <4A9C0D19.5010108@austin.ibm.com>
 <20090911192955.GB2894@think>
 <4AAAC2B6.8040105@austin.ibm.com>
 <20090914135130.GE8839@think>
 <4AAEB89C.3040100@austin.ibm.com>
 <20090916005225.GG23965@think>
 <4AB280AD.5080306@hp.com>
 <4AB28245.2000704@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Whitney <eric.whitney@hp.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Steven Pratt <slpratt@austin.ibm.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4AB28245.2000704@austin.ibm.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 17, 2009 at 01:39:01PM -0500, Steven Pratt wrote:
> Eric Whitney wrote:
> >
> >
> >Chris Mason wrote:
> >>On Mon, Sep 14, 2009 at 04:41:48PM -0500, Steven Pratt wrote:
> >>>Only bit of bad news is I did get one error that crashed the system
> >>>on single threaded nocow run. So that data point is missing.
> >>>Output below:
> >>
> >>I hope I've got this fixed.  If you pull from the master branch of
> >>btrfs-unstable there are fixes for async thread races.  The single
> >>patch I sent before is included, but not enough.
> >
> >Chris:
> >
> >FYI - all five of my test systems have now finished my standard
> >test cycle on the -unstable master branch, and I've not seen a
> >single hang. So, your fix for the async thread shutdown race seems
> >to have fixed my problems, even if Steve's still seeing trouble.
> >
> >I'll note that the running times for fsstress on some of my
> >systems have become rather longer with btrfs-unstable/master
> >kernels - 3.5 rather than 2.5 hours on multidevice filesystems.
> >Running times on single device filesystems are roughly the same.
> >
> >I'm going to start another set of tests for thoroughness unless
> >you've got more patches coming.
> I've had some offline discussions with Chris, and it seems the
> problem is triggered by unmounting and re-mounting the file system
> between tests (but not running mkfs again).   I have also just
> verified that the problem does not occur if repeated tests are run
> without the unmount mount cycle.  So in case this is not clear:

Ok, I've triggered it here. Next step is trying Yan Zheng's async
caching update.

------------[ cut here ]------------
kernel BUG at fs/btrfs/extent-tree.c:4097!
invalid opcode: 0000 [#1] SMP

-chris

