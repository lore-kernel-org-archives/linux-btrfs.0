Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40865 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751880AbeEHRK2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 May 2018 13:10:28 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3B22DAF56
        for <linux-btrfs@vger.kernel.org>; Tue,  8 May 2018 17:10:26 +0000 (UTC)
Date: Tue, 8 May 2018 19:07:47 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/3] Misc cleanups to cached extent
Message-ID: <20180508170747.GJ6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1525420047-17397-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1525420047-17397-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 04, 2018 at 10:47:24AM +0300, Nikolay Borisov wrote:
> Here are a couple of cleanups I stumbled upon while looking at the freespace 
> validation code. The first one simplifies btrfs_rmap_block that has an unused 
> parameter. The next 2 patches cleanup the cache_extent apis since they provide
> more than we are actually using (or have ever used).
> 
> Nikolay Borisov (3):
>   btrfs-progs: Remove devid parameter from btrfs_rmap_block
>   btrfs-progs: Remove add_cache_extent2
>   btrfs-progs: Remove objectid argument from alloc_cache_extent

Applied, thanks.
