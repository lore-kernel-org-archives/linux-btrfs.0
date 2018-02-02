Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60857 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753750AbeBBRmu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Feb 2018 12:42:50 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B48A7AE07
        for <linux-btrfs@vger.kernel.org>; Fri,  2 Feb 2018 17:42:48 +0000 (UTC)
Date: Fri, 2 Feb 2018 18:40:36 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RESEND 4/4] btrfs: Remove btrfs_fs_info::open_ioctl_trans
Message-ID: <20180202174036.GY18553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1515590477-22878-1-git-send-email-nborisov@suse.com>
 <1515601933-27331-1-git-send-email-nborisov@suse.com>
 <1515601933-27331-4-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1515601933-27331-4-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 10, 2018 at 06:32:13PM +0200, Nikolay Borisov wrote:
> Since userspace transaction have been removed we no longer have use
> for this field so delete it.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
