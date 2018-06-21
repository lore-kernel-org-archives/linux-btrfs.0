Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58365 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753906AbeFULOW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Jun 2018 07:14:22 -0400
Received: from relay1.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 361C2AB3D
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Jun 2018 11:14:21 +0000 (UTC)
Date: Thu, 21 Jun 2018 13:11:31 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Streamline log_extent_csums a bit
Message-ID: <20180621111131.GL24375@suse.cz>
Reply-To: dsterba@suse.cz
References: <20180620134303.GY24375@twin.jikos.cz>
 <1529504802-10871-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1529504802-10871-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 20, 2018 at 05:26:42PM +0300, Nikolay Borisov wrote:
> Currently this function takes the root as an argument only to get the
> log_root from it. Simplify this by directly passing the log root from
> the caller. Also eliminate the fs_info local var, since it's used only
> once, so directly reference it from the transaction handle.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
