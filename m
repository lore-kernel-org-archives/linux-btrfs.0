Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52559 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965266AbeEJOpx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 May 2018 10:45:53 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E8FF4AF48
        for <linux-btrfs@vger.kernel.org>; Thu, 10 May 2018 14:45:51 +0000 (UTC)
Date: Thu, 10 May 2018 16:43:13 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 0/4] btrfs: Add write time super block validation
Message-ID: <20180510144313.GL6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180424044809.29838-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180424044809.29838-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 24, 2018 at 12:48:05PM +0800, Qu Wenruo wrote:
> This patchset can be fetched from github:
> https://github.com/adam900710/linux/tree/write_time_sb_check
> 
> We have 2 reports about corrupted btrfs super block, which has some garbage
> in its super block, but otherwise it's completely fine and its csum even
> matches.
> 
> This means we develop memory corruption during btrfs mount time.
> It's not clear whether it's caused by btrfs or some other kernel module,
> but at least let's do write time verification to catch such corruption
> early.
> 
> Changelog:
> v2:
>   Rename btrfs_check_super_valid() to btrfs_validate_super() suggested
>   by Nikolay and David.
> 
> Qu Wenruo (4):
>   btrfs: Rename btrfs_check_super_valid() to btrfs_validate_super()
>   btrfs: Add incompat flags check for btrfs_check_super_valid()
>   btrfs: Add csum type check for btrfs_check_super_valid()
>   btrfs: Do super block verification before writing it to disk

IIRC there were some comments about the overal structure of the checks,
but I can't find V3 of the patchset. Can you please resend it or point
me to it in case I missed it? Thanks.
