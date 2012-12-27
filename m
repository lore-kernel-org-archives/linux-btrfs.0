Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36422 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753079Ab2L0Rel (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Dec 2012 12:34:41 -0500
Date: Thu, 27 Dec 2012 18:34:38 +0100
From: David Sterba <dsterba@suse.cz>
To: Jeff Liu <jeff.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, anand.jain@oracle.com, miaox@cn.fujitsu.com,
        kreijack@inwind.it, dsterba@suse.cz
Subject: Re: [RFC PATCH v7 2/2] Btrfs: Add a new ioctl to set/change the
 label of a mounted file system
Message-ID: <20121227173438.GT14116@twin.jikos.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50D2CF9A.6040704@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <50D2CF9A.6040704@oracle.com>

On Thu, Dec 20, 2012 at 04:43:06PM +0800, Jeff Liu wrote:
> With the new ioctl(2) BTRFS_IOC_SET_FSLABEL, we can set/change the label of a mounted file system.
>  
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> Cc: Miao Xie <miaox@cn.fujitsu.com>
> Cc: Goffredo Baroncelli <kreijack@inwind.it>
> Cc: David Sterba <dsterba@suse.cz>

Reviewed-by: David Sterba <dsterba@suse.cz>
