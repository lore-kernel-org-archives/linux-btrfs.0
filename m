Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41847 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935284AbcJ1Ojc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Oct 2016 10:39:32 -0400
Date: Fri, 28 Oct 2016 16:39:28 +0200
From: David Sterba <dsterba@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: don't abuse REQ_OP_* flags for btrfs_map_block
Message-ID: <20161028143928.GG12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1477553256-25937-1-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1477553256-25937-1-git-send-email-hch@lst.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 27, 2016 at 09:27:36AM +0200, Christoph Hellwig wrote:
> btrfs_map_block supports different types of mappings, which to a large
> extent resemble block layer operations.  But they don't always do, and
> currently btrfs dangerously overlays it's own flag over the block layer
> flags.  This is just asking for a conflict, so introduce a different
> map flags enum inside of btrfs instead.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: David Sterba <dsterba@suse.com>
