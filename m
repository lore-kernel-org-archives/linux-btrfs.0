Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47644 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752148AbdHPNGk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Aug 2017 09:06:40 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2DC5DAE78
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Aug 2017 13:06:39 +0000 (UTC)
Date: Wed, 16 Aug 2017 15:05:17 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Fix -EOVERFLOW handling in
 btrfs_ioctl_tree_search_v2
Message-ID: <20170816130517.GC2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1501846878-10627-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1501846878-10627-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 04, 2017 at 02:41:18PM +0300, Nikolay Borisov wrote:
> The buffer passed to btrfs_ioctl_tree_search* functions have to be at least
> sizeof(struct btrfs_ioctl_search_header). If this is not the case then the
> ioctl should return -EOVERFLOW and set the uarg->buf_size to the minimum
> required size. Currently btrfs_ioctl_tree_search_v2 would return an -EOVERFLOW
> error with ->buf_size being set to the value passed by user space. Fix this by
> removing the size check and relying on search_ioctl, which already includes it
> and correctly sets buf_size.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
