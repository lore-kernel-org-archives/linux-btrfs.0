Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57241 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751525AbeDXO1d (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Apr 2018 10:27:33 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E9CD2AC25
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Apr 2018 14:27:31 +0000 (UTC)
Date: Tue, 24 Apr 2018 16:24:58 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: Unexport btrfs_alloc_delalloc_work
Message-ID: <20180424142458.GI21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1524470057-21969-6-git-send-email-nborisov@suse.com>
 <1524579839-31778-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1524579839-31778-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 24, 2018 at 05:23:59PM +0300, Nikolay Borisov wrote:
> It's used only in inode.c so makes no sense to have it exported. Also
> move the definition of btrfs_delalloc_work to inode.c since it's used
> only this file.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
