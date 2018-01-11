Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35471 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965416AbeAKTJX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 14:09:23 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C2EB5AED0
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 19:09:21 +0000 (UTC)
Date: Thu, 11 Jan 2018 20:07:14 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Make btrfs_inode_rsv_release static
Message-ID: <20180111190714.GV13726@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1515678404-18736-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1515678404-18736-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 11, 2018 at 03:46:44PM +0200, Nikolay Borisov wrote:
> It's not used outside of extent-tree so there is no reason to not be
> static.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Added to 4.16 queue, thanks.
