Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56988 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751415AbdGRQKd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Jul 2017 12:10:33 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 82DAEAC05
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Jul 2017 16:10:32 +0000 (UTC)
Date: Tue, 18 Jul 2017 18:09:18 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 2/3] btrfs: Remove unused parameters from volume.c
 functions
Message-ID: <20170718160917.GX2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1499935063-24401-1-git-send-email-nborisov@suse.com>
 <1499935063-24401-3-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1499935063-24401-3-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 13, 2017 at 11:37:42AM +0300, Nikolay Borisov wrote:
> This also adjusts the respective callers in other files. Those were found with
> -Wunused-parameter.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Same comment as for 1/3, please document when and possibly why the
parameters became unused.

> -	trace_btrfs_space_reservation(fs_info, "orphan", btrfs_ino(inode), 
> +	trace_btrfs_space_reservation(fs_info, "orphan", btrfs_ino(inode),

So before we spend another round on whitespace discussion, please don't
sneak unrelated changes to patches.
