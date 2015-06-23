Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35163 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754707AbbFWO4x (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Jun 2015 10:56:53 -0400
Date: Tue, 23 Jun 2015 16:56:51 +0200
From: David Sterba <dsterba@suse.cz>
To: Mark Fasheh <mfasheh@suse.de>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/5] btrfs: fix clone / extent-same deadlocks
Message-ID: <20150623145651.GG6761@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1435013262-23252-1-git-send-email-mfasheh@suse.de>
 <1435013262-23252-4-git-send-email-mfasheh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1435013262-23252-4-git-send-email-mfasheh@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 22, 2015 at 03:47:40PM -0700, Mark Fasheh wrote:
> Clone and extent same lock their source and target inodes in opposite order.
> In addition to this, the range locking in clone doesn't take ordering into
> account. Fix this by having clone use the same locking helpers as
> btrfs-extent-same.
> 
> In addition, I do a small cleanup of the locking helpers, removing a case
> (both inodes being the same) which was poorly accounted for and never
> actually used by the callers.
> 
> Signed-off-by: Mark Fasheh <mfasheh@suse.de>

Reviewed-by: David Sterba <dsterba@suse.cz>
