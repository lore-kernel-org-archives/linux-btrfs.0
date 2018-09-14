Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37486 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727866AbeINVoO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Sep 2018 17:44:14 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 41866AFB2
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Sep 2018 16:28:59 +0000 (UTC)
Date: Fri, 14 Sep 2018 18:28:57 +0200
From: David Sterba <dsterba@suse.cz>
To: jeffm@suse.com
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs: keep trim from interfering with transaction
 commits
Message-ID: <20180914162857.GU5847@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180906211816.12121-1-jeffm@suse.com>
 <20180906211816.12121-4-jeffm@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180906211816.12121-4-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 06, 2018 at 05:18:16PM -0400, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> 
> Commit 499f377f49f08 (btrfs: iterate over unused chunk space in FITRIM)
> fixed free space trimming, but introduced latency when it was running.
> This is due to it pinning the transaction using both a incremented
> refcount and holding the commit root sem for the duration of a single
> trim operation.
> 
> This was to ensure safety but it's unnecessary.  We already hold the the
> chunk mutex so we know that the chunk we're using can't be allocated
> while we're trimming it.
> 
> In order to check against chunks allocated already in this transaction,
> we need to check the pending chunks list.  To to that safely without
> joining the transaction (or attaching than then having to commit it) we
> need to ensure that the dev root's commit root doesn't change underneath
> us and the pending chunk lists stays around until we're done with it.
> 
> We can ensure the former by holding the commit root sem and the latter
> by pinning the transaction.  We do this now, but the critical section
> covers the trim operation itself and we don't need to do that.
> 
> This patch moves the pinning and unpinning logic into helpers and
> unpins the transaction after performing the search and check for
> pending chunks.
> 
> Limiting the critical section of the transaction pinning improves
> the latency substantially on slower storage (e.g. image files over NFS).
> 
> Fixes: 499f377f49f08 (btrfs: iterate over unused chunk space in FITRIM
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
