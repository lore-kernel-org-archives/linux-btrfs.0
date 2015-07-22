Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:51509 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750779AbbGVVKx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Jul 2015 17:10:53 -0400
Date: Thu, 23 Jul 2015 07:10:50 +1000
From: Dave Chinner <david@fromorbit.com>
To: Josef Bacik <jbacik@fb.com>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        Brian Foster <bfoster@redhat.com>, fstests@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] generic/311: Disable dmesg check
Message-ID: <20150722211050.GZ3902@dastard>
References: <1437109003-2357-1-git-send-email-chandan@linux.vnet.ibm.com>
 <55ACEFC4.9040502@fb.com>
 <20150720221220.GU7943@dastard>
 <8410729.YTcdQ5sv7i@localhost.localdomain>
 <20150722000105.GX3902@dastard>
 <55AEE5D3.6020509@fb.com>
 <20150722052700.GY3902@dastard>
 <55AF7E77.5020803@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <55AF7E77.5020803@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 22, 2015 at 07:28:55AM -0400, Josef Bacik wrote:
> On 07/22/2015 01:27 AM, Dave Chinner wrote:
> >>>Josef, Chris, is this really how btrfs handles metadata write
> >>>failures? This handling of errors seems like a design flaw rather
> >>>than a desireable behaviour to me....
> >>>
> >>
> >>Jeeze you are cranky Dave, lets think about what this test is doing.
> >
> >Do you really see anything above that indicates I'm cranky? I'm just
> >following the logic as i read it, reaching a conclusion and the
> >saying "this doesn't sound right - can an expert please confirm I've
> >got this right?".  Last thing I expected was to be shouted at and
> >treated like an idiot.
> >
> >BTW, you'll know when I'm cranky - swearing is a real good
> >indication that I'm pissed off at something or someone.
> 
> Sorry, I didn't mean to come across angry or condescending.
> Obviously I appreciate your expertise and questions, I wasn't pissed
> or anything, this is just how I normally talk, you know I use
> swearing as punctuation.

Yes, I know that, and that doesn't worry me in the least.

You don't normally shout, though.

> >>This is part of the reason for dm-log-writes, to solve this kind of
> >>shitty situation that dm-flakey introduces.
> >
> >Which you've also never explained in any of the dm-log-write patches
> >you've posted in the past.  IOWs, get the dm-log-writes support code
> >reviewed and fix the dm-flakey tests to use it so this problem goes
> >away.
> 
> The dm-log-writes target is already upstream, I sent the xfstests
> stuff months ago, not sure if they ever made it in.  I'll check and
> get them posted again if not.  Thanks,

They didn't, because it wasn't clear when the kernel code was going
to be committed. I did notice yesterday that it was upstream.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
