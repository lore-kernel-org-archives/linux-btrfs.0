Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35465 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753551AbdHUQbO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Aug 2017 12:31:14 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 87FD8AD08
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Aug 2017 16:31:13 +0000 (UTC)
Date: Mon, 21 Aug 2017 18:29:50 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: Remove chunk_objectid parameter of
 btrfs_alloc_dev_extent
Message-ID: <20170821162950.GN2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170818141402.GW2866@twin.jikos.cz>
 <1503068303-27545-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1503068303-27545-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 18, 2017 at 05:58:22PM +0300, Nikolay Borisov wrote:
> THe function is always called with chunk_objectid set to
> BTRFS_FIRST_CHUNK_TREE_OBJECTID. Let's collapse the parameter in the function
> itself. No functional changes
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
