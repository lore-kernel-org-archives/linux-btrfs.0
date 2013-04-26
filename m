Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:51623 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239Ab3DZWcR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Apr 2013 18:32:17 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 982637C067C
	for <linux-btrfs@vger.kernel.org>; Fri, 26 Apr 2013 16:32:17 -0600 (MDT)
Date: Fri, 26 Apr 2013 18:32:14 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Dave Chinner <david@fromorbit.com>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "xfs@oss.sgi.com" <xfs@oss.sgi.com>
Subject: Re: [BULK]  Re: [PATCH] xfstests 311: test fsync with dm flakey V2
Message-ID: <20130426223214.GA4117@localhost.localdomain>
References: <1366899176-12876-1-git-send-email-jbacik@fusionio.com>
 <20130425224556.GS30622@dastard>
 <20130426002404.GN2631@localhost.localdomain>
 <20130426010829.GV30622@dastard>
 <20130426013237.GO2631@localhost.localdomain>
 <20130426021214.GX30622@dastard>
 <20130426193101.GR2631@localhost.localdomain>
 <20130426220521.GC30622@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20130426220521.GC30622@dastard>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 26, 2013 at 04:05:22PM -0600, Dave Chinner wrote:
> On Fri, Apr 26, 2013 at 03:31:01PM -0400, Josef Bacik wrote:
> > On Thu, Apr 25, 2013 at 08:12:14PM -0600, Dave Chinner wrote:
> > > > Ok so I think I'll just make this test do all the iterations of the fsync tester
> > > > with and without --nolockfs, since without --nolockfs I'm still seeing problems,
> > > > does that sound reasonable?
> > > 
> > > Sounds like a fine plan to me ;)
> > > 
> > 
> > Btw its test 19 O_DIRECT that gives me a 0 length file, the buffered case is
> > fine.  The test just does a randomly sized sub-block sized write over and over
> > again for a random number of times and fsync()'s in there randomly.  The number
> > is 3072 because that's the largest inline extent we can have in btrfs, I added
> > it specifically to test our inline extent logging.  Thanks,
> 
> Interesting - it only runs fsync every 8 iterations of the loop. Can
> you check that it is running enough loops to execute a fsync?
> 

If the loop doesn't fsync it still fsyncs before the program exits.  Side note I
once wasted a week because Chris's fsync tester _didn't_ fsync() before exit so
it would tell you a md5sum of a file that hadn't fsync()ed before the md5sum and
I just assumed btrfs was broken.  This test does not make this mistake for that
reason :).  Thanks,

Josef
