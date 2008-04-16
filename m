From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Multi-device update
Date: Wed, 16 Apr 2008 20:14:38 +0200
Message-ID: <20080416181438.GM12774@kernel.dk>
References: <200804161134.19237.chris.mason@oracle.com> <200804161254.09414.chris.mason@oracle.com> <87fxtlitle.fsf@basil.nowhere.org> <200804161404.04202.chris.mason@oracle.com> <48064114.5080304@firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <48064114.5080304@firstfloor.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 16 2008, Andi Kleen wrote:
> Chris Mason wrote:
> > On Wednesday 16 April 2008, Andi Kleen wrote:
> >> Chris Mason <chris.mason@oracle.com> writes:
> >>> On Wednesday 16 April 2008, Andi Kleen wrote:
> >>>> Chris Mason <chris.mason@oracle.com> writes:
> >>>>> The async work queues include code to checksum data pages without the
> >>>>> FS mutex
> >>>> Are they able to distribute work to other cores?
> >>> Yes, it just uses a workqueue.
> >> Unfortunately work queues don't do that by default currently. They
> >> tend to process on the current CPU only.
> > 
> > Well, I see multiple work queue threads using CPU time, but I haven't spent 
> > much time optimizing it.  There's definitely room for improvement.
> 
> That's likely because you submit from multiple CPUs. But with a single
> submitter running on a single CPU there shouldn't be any load balancing
> currently.

There have been various implementations of queue_work_on() posted
through the years, I've had one version that I've used off and on for a
long time:

http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=c68c42fd6df96f5b3fb5b8b47c571f233d054c71

then you need some balancing decider on top of that, of course.

-- 
Jens Axboe

