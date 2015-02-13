Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33413 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752848AbbBMPo5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Feb 2015 10:44:57 -0500
Date: Fri, 13 Feb 2015 16:44:55 +0100
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3 v2] Btrfs: account for large extents with enospc
Message-ID: <20150213154455.GH8720@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20150212043653.GB2416@localhost.localdomain>
 <1423757811-2511-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1423757811-2511-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 12, 2015 at 11:16:51AM -0500, Josef Bacik wrote:
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -198,6 +198,14 @@ static int btrfs_csum_sizes[] = { 4, 0 };
>  
>  #define BTRFS_DIRTY_METADATA_THRESH	(32 * 1024 * 1024)
>  
> +#define BTRFS_MAX_EXTENT_SIZE (128 * 1024 * 1024)
> +#define BTRFS_MAX_EXTENT_BIT 27

#include <linux/ilog2.h>

#define BTRFS_MAX_EXTENT_SHIFT ilog2(BTRFS_MAX_EXTENT_SIZE)
