Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40652 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752271AbbKPRsP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Nov 2015 12:48:15 -0500
Date: Mon, 16 Nov 2015 18:46:36 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>, David Sterba <dsterba@suse.com>
Subject: Re: Ideas for btrfs-convert fix(or rework)
Message-ID: <20151116174636.GA31035@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <56418E5D.9020604@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56418E5D.9020604@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 10, 2015 at 02:27:41PM +0800, Qu Wenruo wrote:
> [[FIX IDEA]]
> 1. Too many patches

Not percieved as a problem as long as the patches are well separated and
reviewable. If you prefer reasonably many preparatory and trivial
patches, then be it.

> 2. superblock reserve is d*mning hard, not matter at what timing.
>     Until I need to codes for superblock reserve, the codes are quite
>     easy to write.
>     But when it comes to sb reserve, I'm going to get crazy...

What do you mean by the 'sb reserve'?

>     I'll either add tons of codes to the simple chunk allocation to
>     avoid using SB space and keep all chunks are large enough.
>     Or I need to implement user-space whole chunk relocation codes.
> 
>     I miss the old days when sb_bytenr can be specified by user...
>     Then my work should be quite close to end...
> 
> 3. Too aggressive rework
>     I suppose this will not be a fix, but a total rework of the whole
>     btrfs-convert program.
>     Maybe only less than 30% old codes will stay, most of them will be
>     rewritten.

I suppose that the rewrite would also touch generic code, so as far as
it's cleanups and other refactoring I won't object investing the time to
that.

>     No matter how I think the new code will be superior than old one,
>     I'm pretty sure there will be tons of regression or new bugs for
>     such huge rework.
> 
>     But without such work, btrfs-convert will always be a mess and no
>     real support for balance.
> 
> So any ideas or advice is welcomed for this rework.

In general, I welcome the efforts to make convert better. The in-place
conversion is a unique feature and a nice to have. Several people
mentioned that.  Next, we want to add support more filesystems, eg.
reiserfs code is ready and needs configure checks and minor updates to
convert.c.  Basically any filesystem that provides a library API similar
to what ext2 does can be added. Convert code in a good shape would save
us trouble.

Expecting the regressions, the test set for the convertors needs to be
enhanced, the current state is less then ideal. Possibly we can use the
images from e2fsprogs testsuite.
