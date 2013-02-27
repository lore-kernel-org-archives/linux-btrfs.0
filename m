Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60664 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757414Ab3B0L7u (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Feb 2013 06:59:50 -0500
Date: Wed, 27 Feb 2013 12:59:44 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, zab@redhat.com
Subject: Re: [PATCH] btrfs: cleanup for open-coded alignment
Message-ID: <20130227115944.GA27541@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1361866222-5746-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1361866222-5746-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 26, 2013 at 04:10:22PM +0800, Qu Wenruo wrote:
> Though most of the btrfs codes are using ALIGN macro for page alignment,
> there are still some codes using open-coded alignment like the
> following:
> ------
>         u64 mask = ((u64)root->stripesize - 1);
>         u64 ret = (val + mask) & ~mask;
> ------
> Or even hidden one:
> ------
>         num_bytes = (end - start + blocksize) & ~(blocksize - 1);

It's unobvious but not a bug. The 'end' values are sometimes inclusive,
sometimes not.  The range we want to align is

   RANGE = end + start + 1

then the alignment transformation does

  (RANGE + ALIGNMENT - 1) & ~(ALIGNMENT - 1)

where

  RANGE + ALIGNMENT - 1 = end + start + 1 + ALIGNMENT - 1
                        = end + start + ALIGNMENT

I have covered all cases in my original patch with a coccinelle semantic
patch http://www.spinics.net/lists/linux-btrfs/msg12750.html and also
removed the useless stripe_align helper and updated it's callers (and it
still applies after merging the raid56 code that updated the function
with 2 unused arguments).

> Also there is a previous patch from David Sterba with similar changes,
> but the patch is for 3.2 kernel and seems not merged.
> http://www.spinics.net/lists/linux-btrfs/msg12747.html

Yeah, amount of unmerged patches was high back then and I got no
feedback whether such changes are desired not, moreover a few of them
touched all sources likely to clash with every secnod patch in flight
(eg. "Btrfs: kill key type helpers").

If you used my patch I'd appreciate to keep the signed-off.

> Cc: David Sterba <dave@jikos.cz>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
