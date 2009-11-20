From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [RFC] proposal for a btrfs filesystem layout
Date: Fri, 20 Nov 2009 14:50:17 -0500
Message-ID: <20091120195017.GZ3110@think>
References: <200911201950.06662.kreijack@libero.it>
 <934f64a20911201124q2a42fddek87d3f8fe864b3c41@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Goffredo Baroncelli <kreijack@gmail.com>,
	linux-btrfs@vger.kernel.org, Chris Ball <cjb@laptop.org>
To: David Nicol <davidnicol@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <934f64a20911201124q2a42fddek87d3f8fe864b3c41@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 20, 2009 at 01:24:42PM -0600, David Nicol wrote:
> On Fri, Nov 20, 2009 at 12:50 PM, Goffredo Baroncelli
> <kreijack@gmail.com> wrote:
> 
> > Any comments ?
> > BR
> > G.Baroncelli
> 
> 
> since COW semantics require touching directory entries all the way up
> to the root of the subvolume, for transaction-intensive applications
> it would make sense to provide something that works like "mkdir" but
> creates a subvolume that will be mounted at a point rather than a
> simple directory entry. To avoid contention serializing updates to the
> root directory.  Is something like that already in place?

COW semantics require touching btree nodes all the way up to the root of
the btree, but this is different from the directory.  Directories are
stored in the btree, but you won't have to touch more than 8 or so btree
levels regardless of how deep your directory tree is.

-chris

