From: Josef Bacik <jbacik@redhat.com>
Subject: Re: btrfs thinks its full
Date: Thu, 20 Nov 2008 06:54:39 -0500
Message-ID: <20081120115439.GH16041@unused.rdu.redhat.com>
References: <20081119222434.GA29942@tux64-01> <20081119222343.GF16041@unused.rdu.redhat.com> <4924FBB3.6030101@cs.drexel.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <jbacik@redhat.com>, linux-btrfs@vger.kernel.org
To: Lee Trager <lt73@cs.drexel.edu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4924FBB3.6030101@cs.drexel.edu>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 20, 2008 at 12:54:59AM -0500, Lee Trager wrote:
> Is that just finishing btrfs_check_free_space? What would that involve?
> I haven't done much kernel work but I could give it a try.
>

ENOSPC is kind of tricky, which is why it hasn't been done yet ;).  Since btrfs
does delayed allocation you are going to have to keep track of how much data we
want to allocate within this transaction so we don't run out of space while
we're doing the delalloc stuff.  Since btrfs is COW you also can't let the
amount of space you are going to alloc grow to the absolute largest it can for
the disk, since we are going to need space to COW the metadata blocks, so you
are going to have to keep a certain amount of space reserved so that you have
enough space to handle all the COW blocks that will be made.  It may be a bit
much for a first time project, I'd recommend hopping on the IRC channel and get
something to do from Chris, right now he's focusing on finalizing the disk
format, so there is alot of simple work to be done that will familiarize you
with some of the inner workings of btrfs.  When we get the disk layout finalized
I plan to tackle proper ENOSPC handling.  Thanks,

Josef 
