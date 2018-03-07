Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52200 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933479AbeCGPPs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Mar 2018 10:15:48 -0500
Date: Wed, 7 Mar 2018 16:13:26 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: drop nonvaring variable, instead define it
Message-ID: <20180307151326.GD23693@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180305211623.GE5942@twin.jikos.cz>
 <20180307092918.32440-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180307092918.32440-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 07, 2018 at 05:29:18PM +0800, Anand Jain wrote:
> btrfs_defrag_leaves() declares min_trans = 0; as variable, but
> doesn't vary it, so define it.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>

> ---
> v2->v1: Use BTRFS_OLDEST_GENERATION at more places where needed.

I've updated to reflect the change as the new define is the interesting
part, removing min_trans in defrag_leaf is only collateral in this case.
