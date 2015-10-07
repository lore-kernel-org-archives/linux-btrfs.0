Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36305 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752630AbbJGJhx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 7 Oct 2015 05:37:53 -0400
Date: Wed, 7 Oct 2015 11:36:47 +0200
From: David Sterba <dsterba@suse.cz>
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: linux-btrfs@vger.kernel.org, chandan@mykolab.com
Subject: Re: [PATCH] Btrfs: open_ctree: Fix possible memory leak
Message-ID: <20151007093647.GH7734@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1444063465-5641-2-git-send-email-chandan@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1444063465-5641-2-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 05, 2015 at 10:14:25PM +0530, Chandan Rajendra wrote:
> After reading one of chunk or tree root tree's root node from disk, if the
> root node does not have EXTENT_BUFFER_UPTODATE flag set, we fail to release
> the memory used by the root node. Fix this.
> 
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>

Good catch.

Reviewed-by: David Sterba <dsterba@suse.com>
