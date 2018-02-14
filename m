Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57442 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1030233AbeBNNe1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Feb 2018 08:34:27 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 151F8AB5D
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Feb 2018 13:34:26 +0000 (UTC)
Date: Wed, 14 Feb 2018 14:32:10 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Move error handling of
 btrfs_start_dirty_block_groups closer to call site
Message-ID: <20180214133210.GE3003@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1518168618-16708-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1518168618-16708-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 09, 2018 at 11:30:18AM +0200, Nikolay Borisov wrote:
> Even though btrfs_start_dirty_block_groups fairly in the beginning of
> btrfs_commit_transaction outside of the critical section defined by the
> transaction states it can only be run by a single comitter. In other
> words it defines its own critical section thanks to the
> BTRFS_TRANS_DIRTY_BG run flag and ro_block_group_mutex. However, its
> error handling is outside of this critical section which is a bit
> counter-intuitive. So move the error handling righ after the function
> is executed and let the sole runner of dirty block groups handle the
> return value. no functional changes
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
