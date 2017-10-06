Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43452 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750849AbdJFQQ1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 6 Oct 2017 12:16:27 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id EFBC1AB9B
        for <linux-btrfs@vger.kernel.org>; Fri,  6 Oct 2017 16:16:25 +0000 (UTC)
Date: Fri, 6 Oct 2017 18:14:43 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.com
Subject: Re: [PATCH v2 2/2] btrfs: Fix transaction abort during failure in
 btrfs_rm_dev_item
Message-ID: <20171006161443.GT3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1506509327-18862-1-git-send-email-nborisov@suse.com>
 <1506588327-6616-1-git-send-email-nborisov@suse.com>
 <1506588327-6616-2-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1506588327-6616-2-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 28, 2017 at 11:45:27AM +0300, Nikolay Borisov wrote:
> btrfs_rm_dev_item calls several function under an activa transaction, however
> it fails to abort it if an error happens. Fix this by adding explicit
> btrfs_abort_transaction/btrfs_end_transaction calls
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
> 
> v2: 
>  * Explicitly handle every failure case w.r.t transaction abort rather than 
>  rely on final btrfs_commit_transaction() to do the right thing. 
> 
>  * Also consider the -ENOENT case from btrfs_search_slot as a failure.

The devid is checked in the caller, outside of the transaction, so it is
fine to abort here, the devid is supposed to be there.

Reviewed-by: David Sterba <dsterba@suse.com>
