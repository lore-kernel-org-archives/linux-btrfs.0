Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:34235 "EHLO
        mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751792AbdFGSTj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Jun 2017 14:19:39 -0400
Received: by mail-pf0-f177.google.com with SMTP id 9so8387688pfj.1
        for <linux-btrfs@vger.kernel.org>; Wed, 07 Jun 2017 11:19:39 -0700 (PDT)
Date: Wed, 7 Jun 2017 11:19:37 -0700
From: Omar Sandoval <osandov@osandov.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/8] btrfs: btrfs_bio_clone never fails, skip error
 handling
Message-ID: <20170607181937.GD7481@vader.DHCP.thefacebook.com>
References: <cover.1496422340.git.dsterba@suse.com>
 <aa834758a79dc983410da678aac76d039b4cfdc2.1496422340.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <aa834758a79dc983410da678aac76d039b4cfdc2.1496422340.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 02, 2017 at 06:58:36PM +0200, David Sterba wrote:
> Update direct callers of btrfs_bio_clone that do error handling, that we
> can now remove.
> 
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/inode.c   | 4 ----
>  fs/btrfs/volumes.c | 1 -
>  2 files changed, 5 deletions(-)
> 
>  
>  		if (dev_nr < total_devs - 1) {
>  			bio = btrfs_bio_clone(first_bio, GFP_NOFS);
> -			BUG_ON(!bio); /* -ENOMEM */
>  		} else
>  			bio = first_bio;

Could you please get rid of the extra curly braces now, too?
