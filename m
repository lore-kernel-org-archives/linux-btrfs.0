Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36776 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935383AbeE2QUV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 May 2018 12:20:21 -0400
Received: from relay2.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E2545AD03
        for <linux-btrfs@vger.kernel.org>; Tue, 29 May 2018 16:20:19 +0000 (UTC)
Date: Tue, 29 May 2018 18:17:35 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/3] btrfs: Delay block group auto removal to avoid
 interfering qgroups
Message-ID: <20180529161735.GD4325@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180528092009.32562-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180528092009.32562-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 28, 2018 at 05:20:06PM +0800, Qu Wenruo wrote:
> The patchset can be fetched from github:
> https://github.com/adam900710/linux/tree/delayed_bg_removal
> 
> It's based on v4.17-rc5 branch.

Please refresh the patches on top of today's misc-next. The patch 2/3
has been there already and now is deleted as it conflicts with 1/3, so
I'm going to apply them in the order as they are in this pathset.

Patch 3/3 is nontrivial and I'd like to have a closer look at the bg
tracking and locking, 1 and 2 can go to misc-next now.
