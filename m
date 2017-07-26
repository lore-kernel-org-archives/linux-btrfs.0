Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40279 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750816AbdGZRcr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Jul 2017 13:32:47 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A6CE0AD1F
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Jul 2017 17:32:42 +0000 (UTC)
Date: Wed, 26 Jul 2017 19:31:26 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Make flush_space return void
Message-ID: <20170726173126.GK2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170721161853.GM2866@twin.jikos.cz>
 <1500994108-19285-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1500994108-19285-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 25, 2017 at 05:48:28PM +0300, Nikolay Borisov wrote:
> The return value of flush_space was used to have significance in the early days
> when the code was first introduced and before the ticketed enospc rework. Since
> the latter got introduced the return value lost any significance whatsoever to
> its callers. So let's remove it. While at it also remove the unused ticket
> variable in btrfs_async_reclaim_metadata_space. It was used in the initial
> version of the ticketed ENOSPC work, however Wang Xiaoguang detected a problem
> with this and fixed it in ce129655c9d9 ("btrfs: introduce tickets_id to
> determine whether asynchronous metadata reclaim work makes progress").
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>

I've added a comment to the function, as it's not obvious why all the
error conditions inside get ignored in the end.
