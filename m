Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52631 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750947AbdE2NaB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 May 2017 09:30:01 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 84D7CAB5F
        for <linux-btrfs@vger.kernel.org>; Mon, 29 May 2017 13:30:00 +0000 (UTC)
Date: Mon, 29 May 2017 15:29:00 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: rename btrfs_leaf_data to
 BTRFS_LEAF_DATA_OFFSET
Message-ID: <20170529132900.GC14523@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170526162059.GD30842@twin.jikos.cz>
 <1496040223-13596-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1496040223-13596-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 29, 2017 at 09:43:43AM +0300, Nikolay Borisov wrote:
> Commit 5f39d397dfbe ("Btrfs: Create extent_buffer interface
> for large blocksizes") refactored btrfs_leaf_data function to take
> extent_buffer rather than struct btrfs_leaf. However, as it turns out the
> parameter being passed is never used. Furthermore this function no longer
> returns the leaf data but rather the offset to it. So rename the function
> to BTRFS_LEAF_DATA_OFFSET to make it consistent with other BTRFS_LEAF_*
> helpers and turn it into a macro
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Applied, with a minor change:

BTRFS_LEAF_DATA_OFFSET() -> BTRFS_LEAF_DATA_OFFSET

too trivial to bother your with another resend.
