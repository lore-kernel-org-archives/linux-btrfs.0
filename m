Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47970 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752190AbeASXfY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Jan 2018 18:35:24 -0500
Date: Sat, 20 Jan 2018 00:33:13 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Use IS_ALIGNED in btrfs_truncate_block instead of
 opencoding it
Message-ID: <20180119233313.GD15713@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1516279626-6111-1-git-send-email-nborisov@suse.com>
 <7d7570f4-43fa-8ebc-9a16-b2777eeabf3f@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <7d7570f4-43fa-8ebc-9a16-b2777eeabf3f@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 19, 2018 at 08:45:40AM +0800, Qu Wenruo wrote:
> 
> 
> On 2018年01月18日 20:47, Nikolay Borisov wrote:
> > No functional changes, just makes the code more readable
> > 
> > Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> 
> Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks, added to 4.16 queue.
