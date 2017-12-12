Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52154 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752077AbdLLTBi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Dec 2017 14:01:38 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 9176DAF87
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Dec 2017 19:01:37 +0000 (UTC)
Date: Tue, 12 Dec 2017 19:59:37 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs: sink extent_write_full_page tree argument
Message-ID: <20171212185937.GT3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1512741359-17603-1-git-send-email-nborisov@suse.com>
 <1512741359-17603-2-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1512741359-17603-2-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 08, 2017 at 03:55:59PM +0200, Nikolay Borisov wrote:
> The tree argument passed to extent_write_full_page is referenced from
> the page being passed to the same function. Since we already have
> enough information to get the reference, remove the function parameter.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
