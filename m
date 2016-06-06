Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57530 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006AbcFFI6Q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 Jun 2016 04:58:16 -0400
Date: Mon, 6 Jun 2016 10:57:33 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>,
        Anand Jain <anand.jain@oracle.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: Re: [PATCH v2 2/2] Btrfs: add valid checks for chunk loading
Message-ID: <20160606085733.GU29147@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1464980715-6442-1-git-send-email-bo.li.liu@oracle.com>
 <1464980715-6442-2-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1464980715-6442-2-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 03, 2016 at 12:05:15PM -0700, Liu Bo wrote:
> To prevent fuzz filesystem images from panic the whole system,
> we need various validation checks to refuse to mount such an image
> if btrfs finds any invalid value during loading chunks, including
> both sys_array and regular chunks.
> 
> Note that these checks may not be sufficient to cover all corner cases,
> feel free to add more checks.
> 
> Reported-by: Vegard Nossum <vegard.nossum@oracle.com>
> Reported-by: Quentin Casasnovas <quentin.casasnovas@oracle.com>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>

(switched the printk to btrfs_*)
