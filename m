Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:14336 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755839Ab3DZWtl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Apr 2013 18:49:41 -0400
Date: Sat, 27 Apr 2013 08:49:37 +1000
From: Dave Chinner <david@fromorbit.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "xfs@oss.sgi.com" <xfs@oss.sgi.com>
Subject: Re: [BULK]  Re: [PATCH] xfstests 311: test fsync with dm flakey V2
Message-ID: <20130426224937.GA23072@dastard>
References: <1366899176-12876-1-git-send-email-jbacik@fusionio.com>
 <20130425224556.GS30622@dastard>
 <20130426002404.GN2631@localhost.localdomain>
 <20130426010829.GV30622@dastard>
 <20130426013237.GO2631@localhost.localdomain>
 <20130426021214.GX30622@dastard>
 <20130426193101.GR2631@localhost.localdomain>
 <20130426220521.GC30622@dastard>
 <20130426223214.GA4117@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130426223214.GA4117@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 26, 2013 at 06:32:14PM -0400, Josef Bacik wrote:
> On Fri, Apr 26, 2013 at 04:05:22PM -0600, Dave Chinner wrote:
> > On Fri, Apr 26, 2013 at 03:31:01PM -0400, Josef Bacik wrote:
> > > On Thu, Apr 25, 2013 at 08:12:14PM -0600, Dave Chinner wrote:
> > > > > Ok so I think I'll just make this test do all the iterations of the fsync tester
> > > > > with and without --nolockfs, since without --nolockfs I'm still seeing problems,
> > > > > does that sound reasonable?
> > > > 
> > > > Sounds like a fine plan to me ;)
> > > > 
> > > 
> > > Btw its test 19 O_DIRECT that gives me a 0 length file, the buffered case is
> > > fine.  The test just does a randomly sized sub-block sized write over and over
> > > again for a random number of times and fsync()'s in there randomly.  The number
> > > is 3072 because that's the largest inline extent we can have in btrfs, I added
> > > it specifically to test our inline extent logging.  Thanks,
> > 
> > Interesting - it only runs fsync every 8 iterations of the loop. Can
> > you check that it is running enough loops to execute a fsync?
> > 
> 
> If the loop doesn't fsync it still fsyncs before the program exits.

Doh! I noticed that yesterday but forgot about it. Not enough
coffee. I'll have a closer look, then.

> Side note I once wasted a week because Chris's fsync tester
> _didn't_ fsync() before exit so it would tell you a md5sum of a
> file that hadn't fsync()ed before the md5sum and I just assumed
> btrfs was broken.  This test does not make this mistake for that
> reason :).  Thanks,

I think we've all made mistakes like that at least once.... :/

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
