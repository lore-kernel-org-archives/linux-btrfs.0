Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41777 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932331AbdGJRYZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Jul 2017 13:24:25 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id EEE2CAB43
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Jul 2017 17:24:18 +0000 (UTC)
Date: Mon, 10 Jul 2017 19:23:06 +0200
From: David Sterba <dsterba@suse.cz>
To: jeffm@suse.com
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 1/2] btrfs: account for pinned bytes in
 should_alloc_chunk
Message-ID: <20170710172306.GR2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170622135148.16730-1-jeffm@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170622135148.16730-1-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 22, 2017 at 09:51:47AM -0400, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> 
> In a heavy write scenario, we can end up with a large number of pinned bytes.
> This can translate into (very) premature ENOSPC because pinned bytes
> must be accounted for when allowing a reservation but aren't accounted for
> when deciding whether to create a new chunk.
> 
> This patch adds the accounting to should_alloc_chunk so that we can
> create the chunk.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

I'm adding the two patches to for-next. More reviews welcome.
