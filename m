Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41336 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758097AbcKCSur (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 3 Nov 2016 14:50:47 -0400
Subject: Re: [PATCH 1/4] btrfs: qgroup: Add comments explaining how btrfs
 qgroup works
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20161018013129.23331-1-quwenruo@cn.fujitsu.com>
 <20161018013129.23331-2-quwenruo@cn.fujitsu.com>
Cc: rgoldwyn@suse.com
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Message-ID: <22c12fb4-7463-d5a4-08aa-6d5a2bbf6e4f@suse.de>
Date: Thu, 3 Nov 2016 13:49:38 -0500
MIME-Version: 1.0
In-Reply-To: <20161018013129.23331-2-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Reviewed-by: Goldwyn Rodrigues <rgoldwyn@suse.com>

On 10/17/2016 08:31 PM, Qu Wenruo wrote:
> Add explain how btrfs qgroup works.
> 
> Qgroup is split into 3 main phrases:
> 1) Reserve
>    To ensure qgroup doesn't exceed its limit
> 
> 2) Trace
>    To info qgroup to trace which extent
> 
> 3) Account
>    Calculate qgroup number change for each traced extent.
> 
> This should save quite some time for new developers.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>  fs/btrfs/qgroup.h | 28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
> 
> diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
> index 1bc64c8..a72bf21 100644
> --- a/fs/btrfs/qgroup.h
> +++ b/fs/btrfs/qgroup.h
> @@ -23,6 +23,34 @@
>  #include "delayed-ref.h"
>  
>  /*
> + * Btrfs qgroup overview
> + *
> + * Btrfs qgroup splits into 3 main part:
> + * 1) Reserve
> + *    Reserve metadata/data space for incoming operations
> + *    Affect how qgroup limit works
> + *
> + * 2) Trace
> + *    Tell btrfs qgroup to trace dirty extents.
> + *
> + *    Dirty extents including:
> + *    - Newly allocated extents
> + *    - Extents going to be deleted (in this trans)
> + *    - Extents whose owner is going to be modified
> + *
> + *    This is the main part affects whether qgroup numbers will stay
> + *    consistent.
> + *    Btrfs qgroup can trace clean extents and won't cause any problem,
> + *    but it will consume extra CPU time, it should be avoided if possible.
> + *
> + * 3) Account
> + *    Btrfs qgroup will updates its numbers, based on dirty extents traced
> + *    in previous step.
> + *
> + *    Normally at qgroup rescan and transaction commit time.
> + */
> +
> +/*
>   * Record a dirty extent, and info qgroup to update quota on it
>   * TODO: Use kmem cache to alloc it.
>   */
> 

-- 
Goldwyn
