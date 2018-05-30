Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39187 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752793AbeE3RGi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 May 2018 13:06:38 -0400
Received: from relay1.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 11223AD77
        for <linux-btrfs@vger.kernel.org>; Wed, 30 May 2018 17:06:37 +0000 (UTC)
Date: Wed, 30 May 2018 19:03:53 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 1/2] btrfs: Factor out read portion of
 btrfs_get_blocks_direct
Message-ID: <20180530170353.GH3539@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1525263573-2969-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1525263573-2969-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 02, 2018 at 03:19:32PM +0300, Nikolay Borisov wrote:
> Currently this function handles both the READ and WRITE dio cases. This
> is facilitated by a bunch of 'if' statements, a goto short-circuit
> statement and a very perverse aliasing of "!created"(READ) case
> by setting lockstart = lockend and checking for lockstart < lockend for
> detecting the write. Let's simplify this mess by extracting the
> READ-only code into a separate __btrfs_get_block_direct_read function.
> This is only the first step, the next one will be to factor out the
> write side as well. The end goal will be to have the common locking/
> unlocking code in btrfs_get_blocks_direct and then it will call either
> the read|write subvariants. No functional changes.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
> 
> V3:
>  * Add code to unlock unused portions of the file (if any) in the read case
>  * Improve the comment about the locking in !create case as well, making it 
>  more explicit. 

1 and 2 added to misc-next.
