Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:36663 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456Ab3IWNRt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Sep 2013 09:17:49 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 35BA87C0645
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Sep 2013 07:17:49 -0600 (MDT)
Date: Mon, 23 Sep 2013 09:17:46 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Liu Bo <bo.li.liu@oracle.com>
CC: <linux-btrfs@vger.kernel.org>, <xfs@oss.sgi.com>
Subject: Re: [PATCH] xfstest/btrfs/001: fix the misuse of subvolume
 set-default
Message-ID: <20130923131746.GA18681@localhost.localdomain>
References: <1379926049-22135-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1379926049-22135-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 23, 2013 at 04:47:29PM +0800, Liu Bo wrote:
> The command is
> btrfs subvolume set-default <subvolid> <path>.
> 
> It uses @subvolid to control the default subvolume and
> @subvolid=0 has always been parsed into FS_TREE no matter
> what subvolume @path points to.
> 
> So in order to set a subvolume to the default one, we need
> to get the id of this subvolume first.
> 
> Also fix a typo:
> s/sbuvolid/subvolid/g
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Sent a patch for this already.  Thanks,

Josef
