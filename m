From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 4/5] btrfs: add nofail variant of set_extent_dirty
Date: Tue, 24 Aug 2010 15:30:55 +0200
Message-ID: <1282656655.2605.2746.camel@laptop>
References: <alpine.DEB.2.00.1008240340010.18908@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.1008240348150.19596@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
To: David Rientjes <rientjes@google.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1008240348150.19596@chino.kir.corp.google.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2010-08-24 at 03:50 -0700, David Rientjes wrote:
> Add set_extent_dirty_nofail().  This function is equivalent to
> set_extent_dirty(), except that it will never fail because of allocation
> failure and instead loop forever trying to allocate memory.
> 
> If the first allocation attempt fails, a warning will be emitted,
> including a call trace.  Subsequent failures will suppress this warning.
> 
> This was added as a helper function for documentation and auditability.
> No future callers should be added.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  fs/btrfs/extent-tree.c |    8 ++++----
>  fs/btrfs/extent_io.c   |   19 +++++++++++++++++++
>  fs/btrfs/extent_io.h   |    2 ++
>  3 files changed, 25 insertions(+), 4 deletions(-)

I'd much rather someone help mason to clean this up.
