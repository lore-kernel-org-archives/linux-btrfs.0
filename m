Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55839 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752362AbcFFIi3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 Jun 2016 04:38:29 -0400
Date: Mon, 6 Jun 2016 10:37:46 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>,
        Anand Jain <anand.jain@oracle.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: Re: [PATCH v2 1/2] Btrfs: add more valid checks for superblock
Message-ID: <20160606083746.GT29147@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1464980715-6442-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1464980715-6442-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 03, 2016 at 12:05:14PM -0700, Liu Bo wrote:
> This adds valid checks for super_total_bytes, super_bytes_used and
> super_stripesize, super_num_devices.
> 
> Reported-by: Vegard Nossum <vegard.nossum@oracle.com>
> Reported-by: Quentin Casasnovas <quentin.casasnovas@oracle.com>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>

I'll switch the printk(KERN_ to the btrfs_* helpers and do minor tweaks
in the messages, but otherwise this version looks good to me. I don't
think we need the helper for stripe value checks as I proposed.
