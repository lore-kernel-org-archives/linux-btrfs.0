From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Updated performance results
Date: Tue, 28 Jul 2009 16:23:55 -0400
Message-ID: <20090728202355.GC13940@think>
References: <4A68AD69.4030803@dangyankee.net>
 <20090723210051.GB1040@think>
 <4A68DE81.3020505@dangyankee.net>
 <20090724132407.GC16192@think>
 <20090724140002.GD16192@think>
 <4A6F5BB6.4020204@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Steven Pratt <slpratt@austin.ibm.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A6F5BB6.4020204@austin.ibm.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 28, 2009 at 03:12:38PM -0500, Steven Pratt wrote:
> Chris Mason wrote:
> >On Fri, Jul 24, 2009 at 09:24:07AM -0400, Chris Mason wrote:
> >>>Sure, will try to get to it tomorrow.
> >>Sorry, I missed a fix in the experimental branch.  I'll push out a
> >>rebased version in a few minutes.
> >>
> >
> >Ok, the rebased version is ready to use.
> New results are up for both with and without nodatacow.  Not much change.
> 
> http://btrfs.boxacle.net/repository/raid/history/History.html
> 
> Have another run going with nodatacow and ssd.

Hi Steve,

I think I'm going to start tuning something other than the
random-writes, there is definitely low hanging fruit in the large file
creates workload ;)  Thanks again for posting all of these.

The history graph has 2.6.31-rc btrfs against 2.6.29-rc ext4.  Have you
done more recent runs on ext4?

-chris
