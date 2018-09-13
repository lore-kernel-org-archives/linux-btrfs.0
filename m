Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35744 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726794AbeIMP1O (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Sep 2018 11:27:14 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BC2A0AF08
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Sep 2018 10:18:24 +0000 (UTC)
Date: Thu, 13 Sep 2018 12:18:23 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Handle error of get_old_root
Message-ID: <20180913101823.GS2154@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1536827710-20534-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1536827710-20534-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 13, 2018 at 11:35:10AM +0300, Nikolay Borisov wrote:
> In btrfs_search_old_slot get_old_root is always used with the
> assumption it cannot fail. However, this is not true in rare
> circumstance it can fail and return null.

Currently this will not happen, as the code returning NULL

1383         if (!eb)
1384                 return NULL;

is preceed by btrfs_clone_extent_buffer or alloc_dummy_extent_buffer
that will not fail due to GFP_NOFAIL in __alloc_extent_buffer.

However I agree the error handling in btrfs_search_old_slot should be
there as the NOFAIL semantics is hidden and may change eventually.
