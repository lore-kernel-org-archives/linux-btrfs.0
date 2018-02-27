Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36187 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753831AbeB0PCt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Feb 2018 10:02:49 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D35A8AE1C
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Feb 2018 15:02:47 +0000 (UTC)
Subject: Re: [PATCH 0/4] Minor xattr handler cleanups
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1519742886.git.dsterba@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <a2cdf7b6-6e90-1341-b234-38250a2a4945@suse.com>
Date: Tue, 27 Feb 2018 17:02:45 +0200
MIME-Version: 1.0
In-Reply-To: <cover.1519742886.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 27.02.2018 16:48, David Sterba wrote:
> Renames, declearation updates.
> 
> David Sterba (4):
>   btrfs: drop underscores from exported xattr functions
>   btrfs: drop extern from function declarations
>   btrfs: adjust return type of btrfs_getxattr
>   btrfs: move btrfs_listxattr prototype to xattr.h
> 
>  fs/btrfs/acl.c       |  6 +++---
>  fs/btrfs/ctree.h     |  3 ---
>  fs/btrfs/extent_io.h |  4 ++--
>  fs/btrfs/props.c     |  6 +++---
>  fs/btrfs/xattr.c     | 12 ++++++------
>  fs/btrfs/xattr.h     |  7 ++++---
>  6 files changed, 18 insertions(+), 20 deletions(-)
> 

The whole series LGTM:

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
