Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45796 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965066AbeEJNh3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 May 2018 09:37:29 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 4E74BAC69
        for <linux-btrfs@vger.kernel.org>; Thu, 10 May 2018 13:37:28 +0000 (UTC)
Date: Thu, 10 May 2018 15:34:49 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 0/8] Delayed refs cleanups/streamlining
Message-ID: <20180510133449.GG6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1524579504-30304-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1524579504-30304-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 24, 2018 at 05:18:16PM +0300, Nikolay Borisov wrote:
> This patchkit aims to simplify and streamline the logic involved in 
> initialising and adding delayed refs/delayed head structures which deal with 
> modification of the extent tree. Currently the logic for init and add was 
> contained in one function for each type of structure. This resulted in very 
> awkward interface with shitloads of arguments, this in turn made it really hard
> to understand the gist of the code. This series rectifies the situation by 
> extracting common parts and using those rather than open coding duplicated
> logic for every type of delayed ref (tree or data ref). 
> 
> The first 5 patches deal with the delayed_ref structs. Each patch is 
> incremental and makes the code bisectable. The last tree factor out the init 
> code for delayed_ref_head into a separate function and begin to use it. The 
> final completely splits the two. 
> 
> The net result is both a cleaner interface as well as somewhat reduced 
> critical section under delayed_refs->lock spinlock. 
> 
> V2: Rebased the patches on latest misc-next.
> 
> Nikolay Borisov (8):
>   btrfs: Factor out common delayed refs init code
>   btrfs: Use init_delayed_ref_common in add_delayed_tree_ref
>   btrfs: Use init_delayed_ref_common in add_delayed_data_ref
>   btrfs: Open-code add_delayed_tree_ref
>   btrfs: Open-code add_delayed_data_ref
>   btrfs: Introduce init_delayed_ref_head
>   btrfs: Use init_delayed_ref_head in add_delayed_ref_head
>   btrfs: split delayed ref head initialization and addition

Reviewed-by: David Sterba <dsterba@suse.com>

On the way to misc-next, it's been in next for quite some time.
