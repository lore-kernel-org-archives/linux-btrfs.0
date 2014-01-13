Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:35065 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751110AbaAMB5C (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 Jan 2014 20:57:02 -0500
Date: Mon, 13 Jan 2014 12:56:58 +1100
From: Dave Chinner <david@fromorbit.com>
To: Chris Mason <clm@fb.com>
Cc: Josef Bacik <jbacik@fb.com>, "sandeen@redhat.com" <sandeen@redhat.com>,
        "bpm@sgi.com" <bpm@sgi.com>,
        "sandeen@sandeen.net" <sandeen@sandeen.net>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "xfs@oss.sgi.com" <xfs@oss.sgi.com>
Subject: Re: [PATCH] xfstests: kill lib/random.c
Message-ID: <20140113015658.GE3469@dastard>
References: <1389038323-8304-1-git-send-email-jbacik@fb.com>
 <52CB20ED.1010705@redhat.com>
 <52CB2336.2060009@fb.com>
 <52CB2452.70507@redhat.com>
 <20140107200135.GD1935@sgi.com>
 <52CC5F27.1090602@sandeen.net>
 <20140107204015.GJ10553@sgi.com>
 <52CC6F00.3060907@fb.com>
 <1389129641.23310.20.camel@ret.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1389129641.23310.20.camel@ret.masoncoding.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 07, 2014 at 09:20:12PM +0000, Chris Mason wrote:
> On Tue, 2014-01-07 at 16:17 -0500, Josef Bacik wrote:
> > On 01/07/2014 03:40 PM, Ben Myers wrote:
> > > On Tue, Jan 07, 2014 at 02:10:15PM -0600, Eric Sandeen wrote:
> > >> On 1/7/14, 2:01 PM, Ben Myers wrote:
> > >>> Hey Gents,
> > >>>
> > >>> On Mon, Jan 06, 2014 at 03:46:58PM -0600, Eric Sandeen wrote:
> > >>>> On 1/6/14, 3:42 PM, Josef Bacik wrote:
> > >>>>> On 01/06/2014 04:32 PM, Eric Sandeen wrote:
> > >>>>>> On 1/6/14, 1:58 PM, Josef Bacik wrote:
> > >>>>>>> I was trying to reproduce something with fsx and I noticed that no matter what
> > >>>>>>> seed I set I was getting the same file.  Come to find out we are overloading
> > >>>>>>> random() with our own custom horribleness for some unknown reason.  So nuke the
> > >>>>>>> damn thing from orbit and rely on glibc's random().  With this fix the -S option
> > >>>>>>> actually does something with fsx.  Thanks,
....
> For now we can just use srandom?

Seems to me like it will solve the problem. Josef?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
