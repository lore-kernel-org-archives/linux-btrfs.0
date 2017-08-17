Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53813 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750903AbdHQLtm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Aug 2017 07:49:42 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C681DABB1
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Aug 2017 11:49:40 +0000 (UTC)
Date: Thu, 17 Aug 2017 13:48:18 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs: expose internal free space tree routine only if
 sanity tests are enabled
Message-ID: <20170817114818.GQ2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1502896523-2431-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1502896523-2431-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 16, 2017 at 06:15:23PM +0300, Nikolay Borisov wrote:
> The internal free space tree management routines are always exposed for testing
> purposes. Make them dependent on SANITY_TESTS being on so that they are exposed
> only when they really have to.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
