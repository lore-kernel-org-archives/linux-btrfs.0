From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH V2] Btrfs: Full direct I/O and AIO read implementation.
Date: Tue, 16 Feb 2010 11:01:07 -0500
Message-ID: <20100216160107.GF3497@think>
References: <4B7300BE.5000909@hp.com>
 <20100212192804.GE4191@localhost.localdomain>
 <4B77521F.2060105@gmail.com>
 <20100215164255.GG11057@think>
 <4B799DF7.9090008@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: jim owens <owens6336@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B799DF7.9090008@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 15, 2010 at 02:18:15PM -0500, jim owens wrote:
> Chris Mason wrote:
> >Thanks to both Jim and Josef for their time on this one.  More comments
> >below.
> >
> >On Sat, Feb 13, 2010 at 08:30:07PM -0500, jim owens wrote:
> >>Josef Bacik wrote:
> >>>On Wed, Feb 10, 2010 at 01:53:50PM -0500, jim owens wrote:
> >>>>+	/* traditional 512-byte device sector alignment is the
> >>The problem that I did not explain in my comment is that other fs's
> >>get the blocksize from 1 device bdi, which usually will be 512.  But
> >>the btrfs bdi covers all volumes and gives the btrf logical 4096 size.
> >>If we do what is done in direct-io.c then we only allow access on 4k
> >>(or in the future larger logical) boundaries.
> >
> >We can record the smallest alignment while scanning the devices and just
> >use that.  In general 4K is good enough, although some other database
> >company might be more worried about smaller numbers.
> 
> So you are saying at mount time we will set a new field in a
> btrfs data structure that we can use here instead of the hard-code.
> With today's disks this will usually be 512.

Yes please.

[ use i_mutex for reads? ]

> >
> >But, we're making the performance of the common case (parallel reads)
> >dramatically slower to close a small race.  Reads and writes are allowed
> >to race, and the results are allowed to be undefined.  The only
> >requirement is that we not return garbage (zeros, or good data only).
> 
> I agree with both why we don't want the mutex and that we don't care
> about the read returning old or new data.
> 
> But in spite of what you said above, I found lock_extent() was
> not enough and I needed the i_mutex.
> 
> The problem I had was that if btrfs_wait_ordered_range() does not
> run on the new data, that data can still be on disk but the btree
> checksum is wrong. I need the checksum forced into the btree so
> I don't fail the comparison.
> 
> Even an overwrite when nodatacow is set will cause the same problem.
> 
> I can try to code something like btrfs_page_mkwrite() does and see
> if that works, though I really question if that will be a dramatic
> improvement in parallel read because now we have to take the lock
> and search the ordered tree.

But, we already need the code that btrfs_page_mkwrite uses.  It should
be enough to wait for the ordered extents and have the extent range
locked.

> To me this will be a net loss of
> performance on files that are not being modified as the i_mutex
> does not slow down parallel readers except when the area they
> are reading needs flushed. 

The cost of i_mutex on parallel readers + high speed devices can be
surprising.

> And if the file is being modified in
> the spot we are reading, without i_mutex we may need to flush
> it multiple times, endlessly.  And unlike btrfs_page_mkwrite()
> this code is not doing just 1 page.

If the file is being modified by buffered writes, they get what they
deserve.  That's not what O_DIRECT is for.

> 
> Or am I getting something wrong?
> 
> >I think the temp buffer setup is the best place to start for
> >O_DIRECT + compressed.
> 
> Not sure what you mean by that.

I meant I think your way is right ;)

-chris

