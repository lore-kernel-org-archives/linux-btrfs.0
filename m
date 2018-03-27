Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32994 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751028AbeC0TKv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Mar 2018 15:10:51 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E7CD3B028
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Mar 2018 19:10:49 +0000 (UTC)
Date: Tue, 27 Mar 2018 21:08:23 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/8] Delayed refs cleanups/streamlining
Message-ID: <20180327190823.GD30422@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1521621912-25065-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1521621912-25065-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 21, 2018 at 10:45:04AM +0200, Nikolay Borisov wrote:
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
> Nikolay Borisov (8):
>   btrfs: Factor out common delayed refs init code
>   btrfs: Use init_delayed_ref_common in add_delayed_tree_ref
>   btrfs: Use init_delayed_ref_common in add_delayed_data_ref
>   btrfs: Open-code add_delayed_tree_ref
>   btrfs: Open-code add_delayed_data_ref
>   btrfs: Introduce init_delayed_ref_head
>   btrfs: Use init_delayed_ref_head in add_delayed_ref_head
>   btrfs: split delayed ref head initialization and addition

I'll add the patchset to for-next testing branch so it can get picked by
the git repo scrapers, but I haven't reviewed nor tested it. There were
some merge conflict with current misc-next (fs_info exists for
add_delayed_data_ref) so I had a chance to look at some patches closely.
The overall impression is good, so the review sholud make sure there are
no typos or similar issues that can arise when moving code around.
