Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60137 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751603AbdKASEf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 1 Nov 2017 14:04:35 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 182E4AE24
        for <linux-btrfs@vger.kernel.org>; Wed,  1 Nov 2017 18:04:34 +0000 (UTC)
Date: Wed, 1 Nov 2017 19:02:44 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Use locked_end rather than open coding it
Message-ID: <20171101180244.GI3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1509528965-4818-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1509528965-4818-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 01, 2017 at 11:36:05AM +0200, Nikolay Borisov wrote:
> Right before we go into this loop locked_end is set to alloc_end - 1 and is
> being used in nearby functions, no need to have exceptions. This just makes the
> code consistent, no functional changes
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
