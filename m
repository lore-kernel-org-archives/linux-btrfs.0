Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52460 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751633AbeDIO5C (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 9 Apr 2018 10:57:02 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 91075AF2A
        for <linux-btrfs@vger.kernel.org>; Mon,  9 Apr 2018 14:57:00 +0000 (UTC)
Date: Mon, 9 Apr 2018 16:54:31 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 0/5] btrfs-progs: extent buffer related refactor and
 cleanup
Message-ID: <20180409145430.GV8557@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180330054857.6106-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180330054857.6106-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 30, 2018 at 01:48:52PM +0800, Qu Wenruo wrote:
> The patchset can be fetched from github:
> https://github.com/adam900710/btrfs-progs/tree/eb_cleanup
> 
> Just like kernel cleanup and refactors, this patchset will embed
> btrfs_fs_info structure into extent_buffer.
> 
> And fixes several possible NULL pointer dereference (although not
> utilized in btrfs-progs yet).
> 
> Changelog:
> v2:
>   Embarrassingly, I forgot to install reiserfsprogs in my development
>   machine, so the 3rd patch lacks one call site in
>   convert/source-reiserfs.c.
> 
> Qu Wenruo (5):
>   btrfs-progs: extent_io: Fix NULL pointer dereference in
>     free_extent_buffer_final()
>   btrfs-progs: extent_io: Init eb->lru to avoid NULL pointer dereference
>   btrfs-progs: extent_io: Refactor alloc_extent_buffer() to follow
>     kernel parameters
>   btrfs-progs: Unify btrfs_leaf_free_psace() parameter with kernel
>   btrfs-progs: print-tree: Remove btrfs_root parameter

Applied, thanks.
