Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44433 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750981AbeDRWRX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Apr 2018 18:17:23 -0400
Date: Thu, 19 Apr 2018 00:14:49 +0200
From: David Sterba <dsterba@suse.cz>
To: Howard McLauchlan <hmclauchlan@fb.com>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        kernel-team@fb.com
Subject: Re: [PATCH 1/2] btrfs: remove le_bitmap_clear()
Message-ID: <20180418221449.GW21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180418213059.8025-1-hmclauchlan@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180418213059.8025-1-hmclauchlan@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 18, 2018 at 02:30:58PM -0700, Howard McLauchlan wrote:
> le_bitmap_clear() was implemented as a parallel to le_bitmap_set() but
> is actually not being used. This patch removes it.
> 
> Signed-off-by: Howard McLauchlan <hmclauchlan@fb.com>

Reviewed-by: David Sterba <dsterba@suse.com>

I've noticed that le_bitmap_set is only used for the free-space-tree so
it can be moved there and made static.
