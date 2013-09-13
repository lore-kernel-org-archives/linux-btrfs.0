Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58965 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932070Ab3IMO3N (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Sep 2013 10:29:13 -0400
Date: Fri, 13 Sep 2013 16:29:06 +0200
From: David Sterba <dsterba@suse.cz>
To: chandan <chandan@linux.vnet.ibm.com>
Cc: linux-btrfs@vger.kernel.org, chandra.seetharaman@us.ibm.com,
        alexander.karbstein@gmail.com
Subject: Re: [PATCH] Btrfs: btrfs_ioctl_default_subvol: Revert back to
 toplevel subvolume when arg is 0
Message-ID: <20130913142906.GK6810@suse.cz>
Reply-To: dsterba@suse.cz
References: <3458610.yWSLv9Ftnr@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <3458610.yWSLv9Ftnr@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 13, 2013 at 07:34:10PM +0530, chandan wrote:
> This patch makes it possible to set BTRFS_FS_TREE_OBJECTID as the default
> subvolume by passing a subvolume id of 0.
> 
> Signed-off-by: chandan <chandan@linux.vnet.ibm.com>
Reviewed-by: David Sterba <dsterba@suse.cz>
