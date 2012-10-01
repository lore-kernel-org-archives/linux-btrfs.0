Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:35383 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298Ab2JAAAM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Sep 2012 20:00:12 -0400
Date: Mon, 1 Oct 2012 02:00:05 +0200
From: David Sterba <dave@jikos.cz>
To: Josef Bacik <jbacik@fusionio.com>
Cc: David Sterba <dave@jikos.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: ENOSPC design issues
Message-ID: <20121001000005.GR14582@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <20120920190306.GG2272@localhost.localdomain>
 <20120925164335.GZ14582@twin.jikos.cz>
 <20120925170239.GA2328@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120925170239.GA2328@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 25, 2012 at 01:02:39PM -0400, Josef Bacik wrote:
> > implemented as follows on top of next/master, in short:
> > * disable overcommit completely
> > * do the optimistically best guess for the metadata and reserve only up
> >   to the current tree height
> 
> So I had tried to do this before, the problem is when height changes our reserve
> changes.  So for things like delalloc we say we have X number of extents and we
> reserve that much space, but then when we run delalloc we re-calculate the
> metadata size for X number extents we've removed and that number could come out
> differently since the height of the tree would have changed.

Understood, I did not came accross this during testing because I did not
reproduce the required conditions that do not seem frequent but
definetelly are possible.

Let me proceed with V2:

* disable overcommit completely
* reserve only up to the current tree height + 1

You can object that the tree height may grow by 2, namely at the early
stage from 0 -> 2 if the number of operations is quite high and all of
this finishes within one transaction.

So improvement that also covers that:

* reserve up to MIN( BTRFS_MAX_LEVEL, max(tree->height + 1, 3) )

with the assumption that growing three from 3->4 will take more
operations that could fit into one transaction period even on a fast
device. (More accurate analysis required, but this should give the
idea).

The estimated savings in metadata block reservations start at 3/8 (and
decreases with the larger filesystem use). This estimate does not have
the property of being 'almost exact' as the V1 proposal, so some sort of
overcommit math should also take place. I leave this out for now.

thanks,
david
