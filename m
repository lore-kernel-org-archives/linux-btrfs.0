Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38579 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753516AbdGUPxm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Jul 2017 11:53:42 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 30D63AD82
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Jul 2017 15:53:41 +0000 (UTC)
Date: Fri, 21 Jul 2017 17:52:26 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: Remove unused variables
Message-ID: <20170721155226.GJ2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170718155456.GW2866@twin.jikos.cz>
 <1500450477-22017-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1500450477-22017-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 19, 2017 at 10:47:57AM +0300, Nikolay Borisov wrote:
> clear_super - usage was removed in commit
> cea67ab92d3d ("btrfs: clean the old superblocks before freeing the device") but
> that change forgot to remove the actual variable.
> 
> max_key - commit 6174d3cb43aa ("Btrfs: remove unused max_key arg from
> btrfs_search_forward") removed the max_key parameter but it forgot to remove
> references from callers.
> 
> stripe_len - this one was added by e06cd3dd7cea ("Btrfs: add validadtion checks
> for chunk loading") but even then it wasn't used.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
> 
> Here's an updated change log with info when resp. variable became unused. 

Great, thanks.

Reviewed-by: David Sterba <dsterba@suse.com>
