Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54515 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751790AbeCNSXD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Mar 2018 14:23:03 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 99330AFA0
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Mar 2018 18:23:01 +0000 (UTC)
Date: Wed, 14 Mar 2018 19:20:39 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: Use sizeof directly instead of a constant
 variable
Message-ID: <20180314182039.GP32007@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1520873548-26667-1-git-send-email-nborisov@suse.com>
 <1520929566-4155-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1520929566-4155-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 13, 2018 at 10:26:06AM +0200, Nikolay Borisov wrote:
> The kernel would like to have all stack VLA usage removed[1].
> Unfortunately using an integer constant variable as the size of an
> array is still considered a VLA. Instead let's use directly sizeof(var)
> which removes the VLA usage. Use the occasion to remove csum_size
> altogether and use sizeof() also for the size passed to memcmp
> 
> [1]: https://lkml.org/lkml/2018/3/7/621
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
> 
> V2: 
>  * Use sizeof(result) in memcmp to make it more clear what we are comparing. 

Reviewed-by: David Sterba <dsterba@suse.com>

Added to next, thanks.
