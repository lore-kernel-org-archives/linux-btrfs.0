Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56357 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754642AbbEZQea (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 May 2015 12:34:30 -0400
Date: Tue, 26 May 2015 18:34:27 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] [PATCH 2/2] Btrfs: fix up read_tree_block to return
 proper error
Message-ID: <20150526163427.GN23255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1432546215-10954-1-git-send-email-bo.li.liu@oracle.com>
 <1432546215-10954-2-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1432546215-10954-2-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 25, 2015 at 05:30:15PM +0800, Liu Bo wrote:
> The return value of read_tree_block() can confuse callers as it always
> returns NULL for either -ENOMEM or -EIO, so it's likely that callers
> parse it to a wrong error, for instance, in btrfs_read_tree_root().
> 
> This fixes the above issue.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.cz>
