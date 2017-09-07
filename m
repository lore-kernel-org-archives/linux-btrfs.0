Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60750 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755713AbdIGSlS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 7 Sep 2017 14:41:18 -0400
Date: Thu, 7 Sep 2017 20:39:48 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: search parity device wisely
Message-ID: <20170907183948.GF31874@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170802203246.27121-1-bo.li.liu@oracle.com>
 <20170803195331.20079-1-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170803195331.20079-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 03, 2017 at 01:53:31PM -0600, Liu Bo wrote:
> After mapping block with BTRFS_MAP_WRITE, parities have been sorted to
> the end position, so this search can start from the first parity
> stripe.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>
