Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58067 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753125AbcHXLxV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Aug 2016 07:53:21 -0400
Date: Wed, 24 Aug 2016 13:51:31 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v2] Btrfs: detect corruption when non-root leaf has zero
 item
Message-ID: <20160824115131.GM16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1470286628-4123-1-git-send-email-bo.li.liu@oracle.com>
 <1471990978-27124-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1471990978-27124-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 23, 2016 at 03:22:58PM -0700, Liu Bo wrote:
> Right now we treat leaf which has zero item as a valid one
> because we could have an empty tree, that is, a root that is
> also a leaf without any item, however, in the same case but
> when the leaf is not a root, we can end up with hitting the
> BUG_ON(1) in btrfs_extend_item() called by
> setup_inline_extent_backref().
> 
> This makes us check the situation as a corruption if leaf is
> not its own root.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>
