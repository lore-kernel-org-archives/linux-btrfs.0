Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53281 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756075AbdGKR0G (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Jul 2017 13:26:06 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2CDFAADBA
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Jul 2017 17:25:55 +0000 (UTC)
Date: Tue, 11 Jul 2017 19:24:42 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs: Prevent possible ERR_PTR() dereference
Message-ID: <20170711172442.GY2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1499781351-3156-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1499781351-3156-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 11, 2017 at 04:55:51PM +0300, Nikolay Borisov wrote:
> In btrfs_full_stripe_len/btrfs_is_parity_mirror we have similar code which
> gets the chunk map for a particular range via get_chunk_map. However,
> get_chunk_map can return an ERR_PTR value and while the 2 callers do catch
> this with a WARN_ON they then proceed to indiscriminately dereference the
> extent map. This of course leads to a crash. Fix the offenders by making the
> dereference conditional on IS_ERR.

While the code makes it better, the whole callchain should be fixed. The
WARN_ON used to be a BUG_ON and the error handling was absent, and still
is. Although it's unlikely to see the warnings from that, I'd rather see
it fixed properly. The direct caller of btrfs_full_stripe_len will be
able to handle it.

> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
