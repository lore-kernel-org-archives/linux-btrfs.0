Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:2761 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750779AbbGVXCx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Jul 2015 19:02:53 -0400
Date: Thu, 23 Jul 2015 09:02:41 +1000
From: Dave Chinner <david@fromorbit.com>
To: Josef Bacik <jbacik@fb.com>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        Brian Foster <bfoster@redhat.com>, fstests@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] generic/311: Disable dmesg check
Message-ID: <20150722230241.GA3902@dastard>
References: <1437109003-2357-1-git-send-email-chandan@linux.vnet.ibm.com>
 <55ACEFC4.9040502@fb.com>
 <20150720221220.GU7943@dastard>
 <8410729.YTcdQ5sv7i@localhost.localdomain>
 <20150722000105.GX3902@dastard>
 <55AEE5D3.6020509@fb.com>
 <20150722052700.GY3902@dastard>
 <55AF90FA.8010208@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <55AF90FA.8010208@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 22, 2015 at 08:47:54AM -0400, Josef Bacik wrote:
> On 07/22/2015 01:27 AM, Dave Chinner wrote:
> >On Tue, Jul 21, 2015 at 08:37:39PM -0400, Josef Bacik wrote:
> >>This test is to verify that "said shit" is on disk after an fsync.
> >>The "drop all writes from this point onwards" does this silently.
> >>We assume when the device told us that any writes that we did
> >>completed successfully that they actually completed successfully.
> >
> >Sorry, I forgot it dm-flakey didn't return errors. My mistake - I
> >don't look at dm-flakey very often as the tests don't fail on XFS
> >very often.
> >
> >BTW, doesn't such an obviously ludicrous mistake (in hindsight)
> >indicate to you that I simply forgot how dm-flakey behaves? I make
> >mistakes all the time; don't you forget how things work after not
> >looking at them for months at a time?
> 
> Ok one more thing I swear because honestly I feel like this right
> here is the root of everybody's frustrations.  You are not a btrfs
> expert, so I expect to explain btrfs behavior to you, that's what
> the bulk of our emails were about.  You are Dave Chinner, when you
> speak people listen because you have been here forever and done
> everything.  You are the center piece for most LSF conversations,
> you are CC'ed on anything remotely complicated in fs/ or mm related
> to fs stuff.  When you start throwing around things like
> 
> "Josef, Chris, is this really how btrfs handles metadata write
> failures? This handling of errors seems like a design flaw rather
> than a desireable behaviour to me..."
> 
> it carries weight.

Yes, that's a big problem. First of all, I'd suggest that everyone
read this:

http://www.ncbi.nlm.nih.gov/pmc/articles/PMC1118019/

It was written 15 years ago - and I've been thinking about it ever
since.  I came across it a couple of months ago here:

http://pipeline.corante.com/archives/2015/05/26/the_curse_of_expertise.php

What you've just said encapsulates the problem of being considered
an expert - people switch off their brain when the expert says
something, regardless of whether they are right or wrong, simply
because they are "the expert".

I don't want the "Expert" status that I'm given, or the weight being
a Maintainer conveys. I didn't choose to be either, they are just
baggage I have accumulated along the way. And I still make just as
many mistakes as I did years ago - probably more because I'm getting
old and senile - and I rely on peers to catch the mistakes I
make. If you guys are really switching your brains off rather
than thinking properly about what an "expert" says, then we've got a
wider perception problem we need to solve.

>From that perspective, I can fully understand the premise in the
above article that "if what you say is being given "expert"
weighting, then it's time to move on".

But, as Derek commented on the article:

"We need more people for whom that could possibly become a problem,
and more people who would notice that it had become one."

As such, I'm not yet convinced that "move on" is the only solution
to the problem - making people aware of their unconcious biases must
help to some extent, as does making audiences acutely aware that the
"experts" are just as fallable as any other developer in the
project.....

> I know you are asking an honest question, but
> the headlines of Phoronix will read "Btrfs: broken by design says
> long time fs guru Dave Chinner",

s/Btrfs: broken by design/Phoronix Considered Harmful/

But, somehow, I don't think they'd publish such an article.... ;)

> and I'll spend the next year
> answering stupid assertions in email/reddit/person about how btrfs
> doesn't handle write errors properly.  Remember that email from
> Edward Shishkin like 7 years ago about how btrfs's btree was broken
> by design?  I _still_ have to explain to people that he just found a
> bug and it really wasn't a design problem, even though the bug was
> fixed in the same email thread.

That's pretty normal for any long term project. It doesn't even have
to be an Expert Opinion - google will elevate random blogs 

> Your opinion matters greatly to me and the community at large, when
> you start questioning btrfs's design I and everybody else takes that
> very seriously.

Which is exactly why I wanted you to clarify the situation - it did
not seem right to me....

> The tone I took was a mistake, it came across as
> ranty and angry, when I wanted more fun, light, and conversational.
> I'm extremely sorry for that and will ship you booze in payment.

I don't need more encouragement to drink. :/

> So yes it is completely legitimate that you didn't remember how
> dm-flakey works, but we mere mortals sometimes forget that you are
> mortal too ;).  Thanks,

Heh. The resident btrfs expert considers himself a "mere mortal". ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
