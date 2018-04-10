Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43221 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752279AbeDJIXe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Apr 2018 04:23:34 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 39639AD0B
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Apr 2018 08:23:33 +0000 (UTC)
Subject: Re: [PATCH 0/7] Tracepoint updates
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1523275048.git.dsterba@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <cfffb057-7573-f6b8-6673-9990962c06fe@suse.com>
Date: Tue, 10 Apr 2018 11:23:31 +0300
MIME-Version: 1.0
In-Reply-To: <cover.1523275048.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  9.04.2018 14:58, David Sterba wrote:
> Switch the inode number type to u64, plus other cleanups and fixups.
> 
> David Sterba (7):
>   btrfs: tracepoints, use correct type for inode number
>   btrfs: tracepoints, use %llu instead of %Lu
>   btrfs: tracepoints, drop unnecessary ULL casts
>   btrfs: tracepoints, fix whitespace in strings
>   btrfs: tracepoints, use extended format with UUID where possible
>   btrfs: tests: pass fs_info to extent_map tests
>   btrfs: use fs_info for btrfs_handle_em_exist tracepoint

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> 
>  fs/btrfs/extent_map.c             |   6 +-
>  fs/btrfs/extent_map.h             |   3 +-
>  fs/btrfs/inode.c                  |   2 +-
>  fs/btrfs/tests/extent-map-tests.c |  60 ++++++----
>  include/trace/events/btrfs.h      | 225 +++++++++++++++++++-------------------
>  5 files changed, 158 insertions(+), 138 deletions(-)
> 
