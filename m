Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57569 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753256AbeE3OuQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 May 2018 10:50:16 -0400
Received: from relay2.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3C4DBAE6F
        for <linux-btrfs@vger.kernel.org>; Wed, 30 May 2018 14:50:15 +0000 (UTC)
Date: Wed, 30 May 2018 16:47:31 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 3/4] btrfs: lzo: Add header length check to avoid slab
 out of bounds access
Message-ID: <20180530144731.GC3539@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180523082301.29874-4-wqu@suse.com>
 <20180530045824.11965-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180530045824.11965-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 30, 2018 at 12:58:24PM +0800, Qu Wenruo wrote:
> 
> Reported-by: James Harvey <jamespharvey20@gmail.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> changelog:
> v3->v4:

Patch replaced, thanks.
