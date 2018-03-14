Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40259 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751000AbeCNP1H (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Mar 2018 11:27:07 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 02B9FAE02
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Mar 2018 15:27:06 +0000 (UTC)
Date: Wed, 14 Mar 2018 16:24:43 +0100
From: David Sterba <dsterba@suse.cz>
To: Edmund Nadolski <enadolski@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: add missing initialization in btrfs_check_shared
Message-ID: <20180314152443.GI32007@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180314150311.20152-1-enadolski@suse.com>
 <20180314150311.20152-2-enadolski@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180314150311.20152-2-enadolski@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 14, 2018 at 09:03:11AM -0600, Edmund Nadolski wrote:
> btrfs_check_shared calls find_parent_nodes in a loop. In each
> iteration it passes in a share_check struct to request a check for
> a shared extent.  The share_check::share_count must be re-initialized
> to zero for each iteration in order to avoid using a stale count
> value from the previous iteration, thus causing a false
> shared extent indication.
> 
> Signed-off-by: Edmund Nadolski <enadolski@suse.com>

I've replaced the changelog with text from cover letter and added the
Fixes: reference to 3ec4d3238ab that introduces 'shared'.
