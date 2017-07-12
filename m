Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35912 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753208AbdGLPjk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Jul 2017 11:39:40 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B91B7AD59
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Jul 2017 15:39:38 +0000 (UTC)
Date: Wed, 12 Jul 2017 17:38:25 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Prevent possible ERR_PTR() dereference
Message-ID: <20170712153825.GI2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1499781351-3156-1-git-send-email-nborisov@suse.com>
 <20170711172442.GY2866@twin.jikos.cz>
 <21f0034c-fd24-863f-a760-8f8732558468@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <21f0034c-fd24-863f-a760-8f8732558468@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 11, 2017 at 10:29:49PM +0300, Nikolay Borisov wrote:
> 
> 
> On 11.07.2017 20:24, David Sterba wrote:
> > On Tue, Jul 11, 2017 at 04:55:51PM +0300, Nikolay Borisov wrote:
> >> In btrfs_full_stripe_len/btrfs_is_parity_mirror we have similar code which
> >> gets the chunk map for a particular range via get_chunk_map. However,
> >> get_chunk_map can return an ERR_PTR value and while the 2 callers do catch
> >> this with a WARN_ON they then proceed to indiscriminately dereference the
> >> extent map. This of course leads to a crash. Fix the offenders by making the
> >> dereference conditional on IS_ERR.
> > 
> > While the code makes it better, the whole callchain should be fixed. The
> > WARN_ON used to be a BUG_ON and the error handling was absent, and still
> > is. Although it's unlikely to see the warnings from that, I'd rather see
> > it fixed properly. The direct caller of btrfs_full_stripe_len will be
> > able to handle it.
> 
> What should be returned in case we can't find the chunk_map -EINVAL ?

Returning what get_chunk_map seems ok in btrfs_full_stripe_len (compared
to other callers of get_chunk_map that may interpret a failure in a
different way).

But EINVAL is IMO wrong as it's more like the ENOENT when the mapping is
missing or EUCLEAN when the mapping looks incorrect.

The failure of btrfs_full_stripe_len in btrfs_create_block_group_cache
could be best handled if we return ERR_PTR instead of assuming ENOMEM in
all of its callers (btrfs_read_block_groups and btrfs_make_block_group).
