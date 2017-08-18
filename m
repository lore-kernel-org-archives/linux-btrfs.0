Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35741 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750944AbdHRN61 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Aug 2017 09:58:27 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D1468AF04
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Aug 2017 13:58:25 +0000 (UTC)
Date: Fri, 18 Aug 2017 15:57:03 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Remove redundant setting of uuid in
 btrfs_block_header.
Message-ID: <20170818135702.GV2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1501228214-11103-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1501228214-11103-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 28, 2017 at 10:50:14AM +0300, Nikolay Borisov wrote:
> btrfs_alloc_dev_extent currently unconditionally sets the uuid in the leaf block
> header the function is working with. This is unnecessary since this operation
> is peformed by the core btree handling code (splitting a node, allocating a new
> btree block etc). So let's remove it.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
