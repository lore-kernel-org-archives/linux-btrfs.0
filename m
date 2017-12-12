Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52117 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751554AbdLLTBP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Dec 2017 14:01:15 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 10C22ADCB
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Dec 2017 19:01:14 +0000 (UTC)
Date: Tue, 12 Dec 2017 19:59:13 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: sink extent_write_locked_range tree parameter
Message-ID: <20171212185913.GS3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1512741359-17603-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1512741359-17603-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 08, 2017 at 03:55:58PM +0200, Nikolay Borisov wrote:
> This function is called only from submit_compressed_extents and the
> io tree being passed is always that of the inode. But we are also
> passing the inode, so just move getting the io tree pointer in
> extent_write_locked_range to simplify the signature.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
