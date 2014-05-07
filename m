Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36209 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216AbaEGOu3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 7 May 2014 10:50:29 -0400
Date: Wed, 7 May 2014 16:50:26 +0200
From: David Sterba <dsterba@suse.cz>
To: Hugo Mills <hugo@carfax.org.uk>, dsterba@suse.cz,
        Brendan Hide <brendan@swiftspirit.co.za>,
        Marc MERLIN <marc@merlins.org>,
        Calvin Walton <calvin.walton@kepstin.ca>,
        Russell Coker <russell@coker.com.au>, linux-btrfs@vger.kernel.org
Subject: Re: Smallest-n balance filter (was Re: Please review and comment,
 dealing with btrfs full issues)
Message-ID: <20140507145026.GX5988@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20140506121937.GD10159@merlins.org>
 <53690E27.6090101@swiftspirit.co.za>
 <20140506164324.GC24298@carfax.org.uk>
 <20140507140927.GW5988@twin.jikos.cz>
 <20140507142300.GB19199@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140507142300.GB19199@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 07, 2014 at 03:23:01PM +0100, Hugo Mills wrote:
> > N=n
> > F=0
> > while (N > 0) {
> > 	balance -dusage=F,limit=N
> > 	N -= <number of balanced chunks>
> > 	F++
> > }
> > 
> > The patch is in branch dev/balance-limit in my git repos.
> > 
> > We can then implement the n-least-full as a synthetic filter from
> > userspace.
> 
>    This is inefficient, because we've got an O(m) pass through all the
> chunks for every call. If we reduce the number of calls by increasing
> the increment of F (F+=3, say), then we risk overbalancing, or missing
> out on smaller chunks we could have balanced earlier. From a practical
> point of view, it may make little difference, but the computer
> scientist in me is going "ewwwww".

I'm trying to find the practical way, no doubts about the inefficiencies.
The +1 increment was meant to outline the idea, I'm usually using the
sequence 0, 1, 5, 10, [etc +10].

I think we can afford some inaccuracy, I as a user would not mind if
there's some overbalancing (within a sane margin).

>    The other method, for small n only, would be to construct the list
> first, an O(m log n) operation for a filesystem of size m, requiring
> O(n) storage, and then iterate over just those chunks.

The size of filesystem matters, but the scanning phase of balance uses
in-memory structures and this should not be that bad for terabyte-sized
filesystems (ie. number of blockgoups will be "some thousands").

Possibly we can stop looking for new chunks in the first phase of
balance when there are already N candidate chunks found, and process them.

> The problem with that is the storage requirements, and keeping track
> of the state of the list for restart purposes. [actually, there's
> probably an O(m) algorithm to get the n smallest items, but those are
> a bit complicated]

If the filesystem is under load, the chunks' usage may increase or
decrease in time and as we know, balance takes time, so the
chunk-todo-list may look different when next one is about to be
processed.

But yeah, this could be a cheaper check to skip a given chunk if it's
out of the filter criteria than going through the whole list again.
