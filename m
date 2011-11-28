From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [patch 07/99] btrfs: Use mempools for extent_state structures
Date: Mon, 28 Nov 2011 15:53:16 -0800
Message-ID: <m27h2j6byr.fsf@firstfloor.org>
References: <20111124003533.395674389@suse.com>
	<20111124004220.628076319@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Btrfs List <linux-btrfs@vger.kernel.org>
To: Jeff Mahoney <jeffm@suse.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111124004220.628076319@suse.com> (Jeff Mahoney's message of
	"Wed, 23 Nov 2011 19:35:40 -0500")
List-ID: <linux-btrfs.vger.kernel.org>

Jeff Mahoney <jeffm@suse.com> writes:

>  The extent_state structure is used at the core of the extent i/o code
>  for managing flags, locking, etc. It requires allocations deep in the
>  write code and if failures occur they are difficult to recover from.
>
>  We avoid most of the failures by using a mempool, which can sleep when
>  required, to honor the allocations. This allows future patches to convert
>  most of the {set,clear,convert}_extent_bit and derivatives to return
>  void.

Is this really safe?

iirc if there's any operation that needs multiple mempool objects you
can get into the following ABBA style deadlock:

thread 1                     thread 2

get object A from pool 1
                             get object C from pool 2 
get object B from pool 2
pool 2 full -> block
                             get object D from pool 2
                             pool1 full -> block 
                            

Now for thread 1 to make progress it needs thread 2 to free its
object first, but that needs thread 1 to free its object also 
first, which is a deadlock.

It would still work if there are other users which eventually
make progress, but if you're really unlucky either pool 1 or 2 
is complete used by threads doing a multiple object operation.
So you got a nasty rare deadlock ...

The only way to handle this would be to always preallocate
all objects needed for a operation in an atomic way.
Or never use more than one object.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
