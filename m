Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37976 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932771AbbAIPlF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 Jan 2015 10:41:05 -0500
Date: Fri, 9 Jan 2015 16:41:03 +0100
From: David Sterba <dsterba@suse.cz>
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: Lennart Poettering <lennart@poettering.net>, linux-btrfs@vger.kernel.org
Subject: Re: price to pay for nocow file bit?
Message-ID: <20150109154103.GA3685@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20150107174315.GA21865@gardel-login>
 <20150108155610.GA12859@hungrycats.org>
 <20150108165321.GA23339@gardel-login>
 <20150108183620.GA12857@hungrycats.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150108183620.GA12857@hungrycats.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 08, 2015 at 01:36:21PM -0500, Zygo Blaxell wrote:
> Hmmm...it seems the handwaving about tail-packing that I was previously
> ignoring is important after all.
> 
> A few quick tests with filefrag show that btrfs isn't doing full
> tail-packing, only small file allocation (i.e. files smaller than 4096
> bytes get stored inline, and nothing else does, not even sparse files
> with a single 1-byte extent at offset != 0).  Thus the inline storage
> avoids fragmentation only to the minimum extent possible.

That's right, btrfs does not do the reiserfs-style tail packing, and
IMHO will never do that. This brings a lot of code complexity than it's
worth in the end.

> Short appends to the end of the file effectively become modifications
> of the last block of the file.  That triggers CoW on the append, and if
> we're doing lots of tiny writes the file becomes extremely fragmented
> (exactly the worst case of one fragment per block).  A mix of big and
> small appends seems to use fallocated space for those writes that cover
> complete blocks, which is arguably worse than not fallocating at all.
> 
> So fallocate will not help until btrfs learns to do tail-packing, or
> some other way to avoid this problem.
> 
> > > This would work on ext4, xfs, and others, and provide the same benefit
> > > (or even better) without filesystem-specific code.  journald would
> > > preallocate a contiguous chunk past the end of the file for appends,
> > > and
> > 
> > That's precisely what we do. But journald's write pattern is not
> > purely appending to files, it's "append something to the end, then
> > link it up in the beginning". And for the "append" part we are
> > fine with fallocate(). It's the "link up" part that completely fucks
> > up fragmentation so far.
> 
> Wrong theory but same result.  The writes at the beginning just keep
> replacing a single extent over and over, which has a worst-case effect
> of adding a single fragment to the beginning of a file that would not
> otherwise be fragmented.  The appends are causing fragmentation all
> by themselves.  :-P

OTOH, the appending write and the header rewrite happen at roughly same
time so the actual block allocations may end up close to each other as
well. But yes, one cannot rely on that.
