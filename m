Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43748 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731105AbeGSPoJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jul 2018 11:44:09 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 16CCAAFC2
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Jul 2018 15:00:34 +0000 (UTC)
Date: Thu, 19 Jul 2018 17:00:24 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: Simplify page unlocking in alloc_extent_buffer
Message-ID: <20180719150024.GS26141@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1530689092-18090-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1530689092-18090-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 04, 2018 at 10:24:51AM +0300, Nikolay Borisov wrote:
> Current version of the page unlocking code was added in
> 727011e07cbd ("Btrfs: allow metadata blocks larger than the page size")
> but even in this commit that particular flag was never used per-se. In
> fact, btrfs only uses PageChecked for data pages to identify pages
> which have been dirtied but don't have ORDERED bit set. For more
> information see 247e743cbe6e ("Btrfs: Use async helpers to deal with
> pages that have been improperly dirtied"). However, this doesn't apply
> to extent buffer pages. The important bit here is that the pages are
> unlocked AFTER the extent buffer has been properly recorded in the
> radix tree to avoid races with btree_releasepage. Let's exploit this
> fact and simplify the page unlocking sequence by unlocking the pages
> in-order and removing the redundant PageChecked flag setting/clearing.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
