Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34234 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753349AbcCVJjx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Mar 2016 05:39:53 -0400
Date: Tue, 22 Mar 2016 10:39:23 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] Btrfs: fix invalid reference in replace_path
Message-ID: <20160322093923.GF8095@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1458597593-29699-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1458597593-29699-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 21, 2016 at 02:59:53PM -0700, Liu Bo wrote:
> Dan Carpenter's static checker has found this error, it's introduced by
> commit 64c043de466d
> ("Btrfs: fix up read_tree_block to return proper error")
> 
> It's really supposed to 'break' the loop on error like others.
> 
> Cc: Dan Carpenter <dan.carpenter@oracle.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>
