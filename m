Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35511 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755603AbaEGOJb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 7 May 2014 10:09:31 -0400
Date: Wed, 7 May 2014 16:09:27 +0200
From: David Sterba <dsterba@suse.cz>
To: Hugo Mills <hugo@carfax.org.uk>, Brendan Hide <brendan@swiftspirit.co.za>,
        Marc MERLIN <marc@merlins.org>,
        Calvin Walton <calvin.walton@kepstin.ca>,
        Russell Coker <russell@coker.com.au>, linux-btrfs@vger.kernel.org
Subject: Re: Please review and comment, dealing with btrfs full issues
Message-ID: <20140507140927.GW5988@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20140506121937.GD10159@merlins.org>
 <53690E27.6090101@swiftspirit.co.za>
 <20140506164324.GC24298@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140506164324.GC24298@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 06, 2014 at 05:43:24PM +0100, Hugo Mills wrote:
> > >So in my case when I hit that case, I had to use dusage=0 to recover.
> > >Anything above that just didn't work.
> > 
> > I suspect when using more than zero the first chunk it wanted to balance
> > wasn't empty - and it had nowhere to put it. Then when you did dusage=0, it
> > didn't need a destination for the data. That is actually an interesting
> > workaround for that case.
> 
>    I've actually looked into implementing a "smallest=n" filter that
> would taken only the n least-full chunks (by fraction) and balance
> those. However, it's not entirely trivial to do efficiently with the
> current filtering code.

I've prototyped something similar, to limit the number of balanced
chunks by a number. To achieve "n least-full chunks" would be an
iterative process of increasing the usage filter and limiting the number
of chunks until the desired N is reached.

N=n
F=0
while (N > 0) {
	balance -dusage=F,limit=N
	N -= <number of balanced chunks>
	F++
}

The patch is in branch dev/balance-limit in my git repos.

We can then implement the n-least-full as a synthetic filter from
userspace.
