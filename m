Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39295 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754636AbdIGT1t (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 7 Sep 2017 15:27:49 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0FF3AACF4
        for <linux-btrfs@vger.kernel.org>; Thu,  7 Sep 2017 19:27:48 +0000 (UTC)
Date: Thu, 7 Sep 2017 21:26:19 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 09/10] btrfs: Rework error handling of add_extent_mapping
 in __btrfs_alloc_chunk
Message-ID: <20170907192619.GJ31874@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1503308630-6652-1-git-send-email-nborisov@suse.com>
 <1503308630-6652-10-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1503308630-6652-10-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 21, 2017 at 12:43:49PM +0300, Nikolay Borisov wrote:
> Currently the code executes add_extent_mapping and if it is successful it links
> the new mapping, it then proceeds to unlock the extent mapping tree and check
> for failure and handle them. Instead, rework the code to only perform a single
> check if add_extent_mapping has failed and handle it, otherwise the code
> continues in a linear fashion. No functional changes

I like the new version.

Reviewed-by: David Sterba <dsterba@suse.com>
