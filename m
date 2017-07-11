Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52964 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755370AbdGKRTa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Jul 2017 13:19:30 -0400
Date: Tue, 11 Jul 2017 19:18:16 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: clm@fb.com, linux-btrfs@vger.kernel.org, dsterba@suse.com
Subject: Re: [PATCH] btrfs: Remove redundant checks from
 btrfs_alloc_data_chunk_ondemand
Message-ID: <20170711171816.GX2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1499770070-28334-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1499770070-28334-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 11, 2017 at 01:47:50PM +0300, Nikolay Borisov wrote:
> Many commits ago the data space_info in alloc_data_chunk_ondemand used to be
> acquired from the inode. At that point commit
> 33b4d47f5e24 ("Btrfs: deal with NULL space info") got introduced to deal with
> spurios cases where the space info could be null, following a rebalance.
> Nowadays, however, the space info is referenced directly from the btrfs_fs_info
> struct which is initialised at filesystem mount time. This makes the null
> checks redundant, so remove them.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
