Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38364 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759515AbdACQZI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Jan 2017 11:25:08 -0500
Date: Tue, 3 Jan 2017 17:24:52 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 2/2 RFC] btrfs: btrfs_defrag_root() doesn't defrag extent
 root tree
Message-ID: <20170103162452.GR12081@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161221074208.32597-1-anand.jain@oracle.com>
 <20161221074208.32597-2-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161221074208.32597-2-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 21, 2016 at 03:42:08PM +0800, Anand Jain wrote:
> Since btrfs_defrag_leaves() does not support extent_root,
> remove its corresponding call. The user can use the file
> based defrag to defrag extents as of now.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>

Oh right, btrfs_defrag_leaves even explicitly checks for extent_root, so
this has never worked anyway, safe to remove.
