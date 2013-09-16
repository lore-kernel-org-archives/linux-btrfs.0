Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36381 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932118Ab3IPLwN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Sep 2013 07:52:13 -0400
Date: Mon, 16 Sep 2013 13:52:07 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, jeff.liu@oracle.com
Subject: Re: [PATCH v3] Btrfs: export btrfs space shared info to userspace
Message-ID: <20130916115207.GS6810@suse.cz>
Reply-To: dsterba@suse.cz
References: <1379323965-21693-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1379323965-21693-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 16, 2013 at 05:32:45PM +0800, Liu Bo wrote:
> Similar to ocfs2, btrfs also supports that extents can be shared by
> different inodes, and there are some userspace tools requesting
> for this kind of 'space shared infomation'.[1]
> 
> ocfs2 uses flag FIEMAP_EXTENT_SHARED, so does btrfs.
> 
> [1]: http://thr3ads.net/ocfs2-devel/2010/09/489052-PATCH-3-3-shared-du-using-fiemap-to-figure-up-the-shared-extents-per-file-and-the-footprint-in
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.cz>
