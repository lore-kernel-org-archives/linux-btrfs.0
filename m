Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38153 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752009AbeEANc6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 1 May 2018 09:32:58 -0400
Date: Tue, 1 May 2018 15:30:21 +0200
From: David Sterba <dsterba@suse.cz>
To: ethanwu <ethanwu@synology.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: Take trans lock before access running trans in
 check_delayed_ref
Message-ID: <20180501133021.GQ21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1524988782-2680-1-git-send-email-ethanwu@synology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1524988782-2680-1-git-send-email-ethanwu@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Apr 29, 2018 at 03:59:42PM +0800, ethanwu wrote:
> In preivous patch:
> Btrfs: kill trans in run_delalloc_nocow and btrfs_cross_ref_exist

If you know which patch introduced the bug, please add it with the
commit id and as

Fixes: e4c3b2dcd144 ("Btrfs: kill trans in run_delalloc_nocow and btrfs_cross_ref_exist")

to the tags (signed-off section).

> We avoid starting btrfs transaction and get this information from
> fs_info->running_transaction directly.
> 
> When accessing running_transaction in check_delayed_ref, there's a
> chance that current transaction will be freed by commit transaction
> after the NULL pointer check of running_transaction is passed.
> 
> After looking all the other places using fs_info->running_transaction,
> they are either protected by trans_lock or holding the transactions.
> 
> Fix this by using trans_lock and increasing the use_count.
> 
> Signed-off-by: ethanwu <ethanwu@synology.com>

Added to next, thanks.
