Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57882 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751354AbdGRQU0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Jul 2017 12:20:26 -0400
Date: Tue, 18 Jul 2017 18:19:10 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: quwenruo.btrfs@gmx.com, linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v2] btrfs: Remove find_raid56_stripe_len
Message-ID: <20170718161910.GY2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <adde7cae-a365-ae97-8193-92564f17d960@gmx.com>
 <1500015341-3154-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1500015341-3154-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 14, 2017 at 09:55:41AM +0300, Nikolay Borisov wrote:
> find_raid56_stripe_len statically returns SZ_64K which equals BTRFS_STRIPE_LEN.
> It's sole caller is __btrfs_alloc_chunk and it assigns the return value to ai
> variable which is already set to BTRFS_STRIPE_LEN. So remove the function
> invocation altogether and remove the function itself. Also remove the variable
> since it's only aliasing BTRFS_STRIPE_LEN and use the define directly. Use
> the occassion to simplify the rounding down of stripe_size now that the value 
> we want it to align is a power of 2. 
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
> 
> V2:
>  * Incorporate Qu's suggestion to use round_down macro. Updated commit 
>  message accordingly. 

The custom stripe length support would need to start from zero anyway,
so we don't lose anything if the function gets removed. All the
alignment, rounding etc will have to be checked.

Reviewed-by: David Sterba <dsterba@suse.com>
