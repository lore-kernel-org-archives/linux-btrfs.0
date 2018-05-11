Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35670 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751406AbeEKJqL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 May 2018 05:46:11 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 33107AE6C
        for <linux-btrfs@vger.kernel.org>; Fri, 11 May 2018 09:46:10 +0000 (UTC)
Date: Fri, 11 May 2018 11:43:32 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 2/3] btrfs: Refactor btrfs_check_super_valid()
Message-ID: <20180511094332.GQ6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180511053527.28378-1-wqu@suse.com>
 <20180511053527.28378-3-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180511053527.28378-3-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 11, 2018 at 01:35:26PM +0800, Qu Wenruo wrote:
> Refactor btrfs_check_super_valid() by the ways:
> 
> 1) Rename it to btrfs_validate_mount_super()
>    Now it's more obvious when the function should be called.
> 
> 2) Extract core check routine into __validate_super()
>    So later write time check can reuse it, and if needed, we could also
>    use __validate_super() to check each super block.

As there's no validate_super without the underscores, I'd rather drop
them. Otherwise ok.

Reviewed-by: David Sterba <dsterba@suse.com>
