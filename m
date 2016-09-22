Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40408 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756828AbcIVOoJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Sep 2016 10:44:09 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1EEABAAEF
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Sep 2016 14:44:08 +0000 (UTC)
Date: Thu, 22 Sep 2016 16:42:07 +0200
From: David Sterba <dsterba@suse.cz>
To: jeffm@suse.com
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: ensure that file descriptor used with subvol
 ioctls is a dir
Message-ID: <20160922144207.GN16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1474461089-1526-1-git-send-email-jeffm@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1474461089-1526-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 21, 2016 at 08:31:29AM -0400, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> 
> If the subvol/snapshot create/destroy ioctls are passed a regular file
> with execute permissions set, we'll eventually Oops while trying to do
> inode->i_op->lookup via lookup_one_len.
> 
> This patch ensures that the file descriptor refers to a directory.
> 
> Fixes: cb8e70901d (Btrfs: Fix subvolume creation locking rules)
> Fixes: 76dda93c6a (Btrfs: add snapshot/subvolume destroy ioctl)
> Cc: <stable@vger.kernel.org> #v2.6.29+
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
