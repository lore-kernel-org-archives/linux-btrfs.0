From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Multi-device update
Date: Wed, 16 Apr 2008 20:26:50 +0200
Message-ID: <20080416182650.GN12774@kernel.dk>
References: <200804161134.19237.chris.mason@oracle.com> <200804161254.09414.chris.mason@oracle.com> <87fxtlitle.fsf@basil.nowhere.org> <200804161404.04202.chris.mason@oracle.com> <48064114.5080304@firstfloor.org> <20080416181438.GM12774@kernel.dk> <48064469.2090208@firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <48064469.2090208@firstfloor.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 16 2008, Andi Kleen wrote:
> 
> > There have been various implementations of queue_work_on() posted
> > through the years, I've had one version that I've used off and on for a
> > long time:
> 
> queue_work_on is the wrong interface I think. You rather
> want a pool of non pinned threads that are then load balanced by the
> scheduler (who knows best what cpus have cycles available)

Yeah, that actually sounds like the best interface. What I described
typically ends up trying to be too clever, you really want to leave any
scheduling decisions to the scheduler.

-- 
Jens Axboe

