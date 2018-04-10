Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36060 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751504AbeDJQJT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Apr 2018 12:09:19 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B80FDAF2B
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Apr 2018 16:09:17 +0000 (UTC)
Date: Tue, 10 Apr 2018 18:06:48 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs: Factor out write portion of
 btrfs_get_blocks_direct
Message-ID: <20180410160648.GF2817@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1519315934-13611-1-git-send-email-nborisov@suse.com>
 <1519315934-13611-2-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1519315934-13611-2-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 22, 2018 at 06:12:14PM +0200, Nikolay Borisov wrote:
> Now that the read side is extracted into its own function, do the same
> to the write side. This leaves btrfs_get_blocks_direct_write with the
> sole purpose of handling common locking required. Also flip the
> condition in btrfs_get_blocks_direct_write so that the write case
> comes first and we check for if (Create) rather than if (!create). This
> is purely subjective but I believe makes reading a bit more "linear".

I subjectively agree.

> No functional changes.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>

Same comment as before, no __ and please use the single-return exit
block where possible.

> Both patches survived xfstests runs.

I'll add that to misc-next, thanks.
