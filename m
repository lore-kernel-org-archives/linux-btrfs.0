Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41323 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752006AbdI2Rnv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Sep 2017 13:43:51 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 11B2AABB3
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Sep 2017 17:43:50 +0000 (UTC)
Date: Fri, 29 Sep 2017 19:42:16 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org, fdmanana@suse.com
Subject: Re: [PATCH 1/2] btrfs: Explicitly handle btrfs_update_root failure
Message-ID: <20170929174216.GU31640@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170927140007.GH31640@twin.jikos.cz>
 <1506585198-32494-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1506585198-32494-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 28, 2017 at 10:53:17AM +0300, Nikolay Borisov wrote:
> btrfs_udpate_root can fail and it aborts the transaction, the correct way to
> handle an aborted transaction is to explicitly end with btrfs_end_transaction.
> Even now the code is correct since btrfs_commit_transaction would handle an
> aborted transaction but this is more of an implementation detail. So let's be
> explicit in handling failure in btrfs_update_root.
> 
> Furthermore btrfs_commit_transaction can also fail and by ignoring it's return
> value we could have left the in-memory copy of the root item in an inconsistent
> state. So capture the error value which allows us to correctly revert the RO/RW
> flags in case of commit failure.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
