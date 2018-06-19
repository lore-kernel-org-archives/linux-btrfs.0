Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43212 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S937544AbeFSNiA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Jun 2018 09:38:00 -0400
Received: from relay2.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 72F84AD31
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Jun 2018 13:37:59 +0000 (UTC)
Date: Tue, 19 Jun 2018 15:35:08 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org, jeffm@suse.com
Subject: Re: [PATCH 0/3] Cleanups around extent increment
Message-ID: <20180619133508.GO24375@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1529323166-29931-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1529323166-29931-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 18, 2018 at 02:59:23PM +0300, Nikolay Borisov wrote:
> This series improves the functions involved around extent reference increment. 
> The first patch just removes a redundant argument, the second one documents the 
> parameters of __btrfs_inc_extent_ref. It can be considered v2 of the standalone
> version which Jeff had some input to. The final patch fixes a comment in 
> lookup_inline_extent_backref which transpired while Jeff was revieweing the 
> documentation patch. 
> 
> Nikolay Borisov (3):
>   btrfs: Remove fs_info argument from __btrfs_inc_extent_ref

>   btrfs: Document __btrfs_inc_extent_ref
>   btrfs: Fix comment in lookup_inline_extent_backref

2 and 3 added to misc-next, thanks.
