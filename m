Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42548 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751504AbdGUQUJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Jul 2017 12:20:09 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7383FAC1A
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Jul 2017 16:20:08 +0000 (UTC)
Date: Fri, 21 Jul 2017 18:18:53 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs: Remove unused variables from
 btrfs_async_reclaim_metadata_space
Message-ID: <20170721161853.GM2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1500021984-10079-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1500021984-10079-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 14, 2017 at 11:46:24AM +0300, Nikolay Borisov wrote:
> The ret from flush_space is ignored so no point in assigning it to a variable.

It would be good to document why it's safe to ignore return value of
flush_spaces along with removing it.
