Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35045 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750992AbdFUNs5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Jun 2017 09:48:57 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A7B59AD19
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Jun 2017 13:48:55 +0000 (UTC)
Date: Wed, 21 Jun 2017 15:47:50 +0200
From: David Sterba <dsterba@suse.cz>
To: jeffm@suse.com
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: add cond_resched to btrfs_qgroup_trace_leaf_items
Message-ID: <20170621134750.GI21388@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170620121526.13661-1-jeffm@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170620121526.13661-1-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 20, 2017 at 08:15:26AM -0400, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> 
> On an uncontended system, we can end up hitting soft lockups while
> doing replace_path.  At the core, and frequently called is
> btrfs_qgroup_trace_leaf_items, so it makes sense to add a cond_resched
> there.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
