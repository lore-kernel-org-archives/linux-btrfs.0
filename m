From: David Rientjes <rientjes@google.com>
Subject: Re: [patch 1/5] mm: add nofail variants of kmalloc kcalloc and
 kzalloc
Date: Wed, 25 Aug 2010 13:59:55 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1008251359290.16484@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1008240340010.18908@chino.kir.corp.google.com> <1282656558.2605.2742.camel@laptop> <4C73CA24.3060707@fusionio.com> <alpine.DEB.2.00.1008241309170.21242@chino.kir.corp.google.com> <20100825112433.GB4453@thunk.org>
 <1282736132.2605.3563.camel@laptop> <20100825115709.GD4453@thunk.org> <1282740516.2605.3644.camel@laptop> <20100825132417.GQ31488@dastard> <1282743342.2605.3707.camel@laptop> <20100825205342.GG4453@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: "Ted Ts'o" <tytso@mit.edu>, Peter Zijlstra <peterz@infradead.org>,
	Dave Chinner <david@fromorbit.com>,
	Jens Axboe <jaxboe@fusionio.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ne
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100825205342.GG4453@thunk.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 25 Aug 2010, Ted Ts'o wrote:

> A pool of free pages which is reserved for routines that are doing
> page cleaning would probably also be a good idea.  Maybe that's just
> retrying with GFP_ATOMIC if a normal allocation fails, or maybe we
> need our own special pool, or maybe we need to dynamically resize the
> GFP_ATOMIC pool based on how many subsystems might need to use it....
> 

PF_MEMALLOC is used for those tasks, not GFP_ATOMIC.
