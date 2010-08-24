From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 1/5] mm: add nofail variants of kmalloc kcalloc and
 kzalloc
Date: Tue, 24 Aug 2010 16:03:31 +0200
Message-ID: <1282658611.2605.2781.camel@laptop>
References: <alpine.DEB.2.00.1008240340010.18908@chino.kir.corp.google.com>
	 <1282656558.2605.2742.camel@laptop>  <20100824135522.GK31488@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: David Rientjes <rientjes@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Neil Brown <neilb@suse.de>, Alasdair G Kergon <agk@redhat.com>,
	Chris Mason <chris.mason@oracle.com>,
	Steven Whitehouse <swhiteho@redhat.com>,
	Jens Axboe <jaxboe@fusionio.com>, Jan Kara <jack@suse.cz>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	linux-raid@vger.kernel.org, linux-btrfs@vger.kernel.org,
	cluster-devel@redhat.com, linux-ext4@vger.kernel.org,
	reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
In-Reply-To: <20100824135522.GK31488@dastard>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2010-08-24 at 23:55 +1000, Dave Chinner wrote:
> no one has noticed
> that XFS has been doing these "allocations can't fail" loop in
> kmem_alloc() and kmem_zone_alloc(), well, forever 

I occasionally check if its still there and cry a little ;-)
