Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f175.google.com ([209.85.216.175]:37452 "EHLO
        mail-qt0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753726AbdHURg6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Aug 2017 13:36:58 -0400
Received: by mail-qt0-f175.google.com with SMTP id 16so85810165qtz.4
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Aug 2017 10:36:58 -0700 (PDT)
Date: Mon, 21 Aug 2017 13:36:56 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: Nikolay Borisov <nborisov@suse.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/10] Unused parameter cleanup
Message-ID: <20170821173655.GD23807@destiny>
References: <1503308630-6652-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1503308630-6652-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 21, 2017 at 12:43:40PM +0300, Nikolay Borisov wrote:
> Hello, 
> 
> Here is a series that I've been sitting on for a while. It removes unused 
> parameter in various functions, no functional changes. Patch 09/10 reworks
> some error handling to eliminate an if branch in __btrfs_alloc_chunk, but it's
> still a minor refactoring. 
> 
> Nikolay Borisov (10):
>   btrfs: Remove chunk_objectid parameter of btrfs_alloc_dev_extent
>   btrfs: remove superfluous chunk_tree argument from
>     btrfs_alloc_dev_extent
>   btrfs: Remove unused variable
>   btrfs: Remove unused parameters from various functions
>   btrfs: Remove unused arguments from btrfs_changed_cb_t
>   btrfs: Remove unused parameter from check_direct_IO
>   btrfs: Remove unused parameter from extent_clear_unlock_delalloc
>   btrfs: remove unused parameter in cow_file_range
>   btrfs: Rework error handling of add_extent_mapping in
>     __btrfs_alloc_chunk
>   btrfs: Remove redundant argument of __link_block_group
> 

You can add

Reviewed-by: Josef Bacik <jbacik@fb.com>

to the whole series.  Thanks,

Josef
