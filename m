Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:44846 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755722Ab3EFTpT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 May 2013 15:45:19 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 87AE77C0684
	for <linux-btrfs@vger.kernel.org>; Mon,  6 May 2013 13:45:18 -0600 (MDT)
Date: Mon, 6 May 2013 15:45:16 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Liu Bo <bo.li.liu@oracle.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] Btrfs: fix off-by-one in fiemap
Message-ID: <20130506194516.GL12414@localhost.localdomain>
References: <1367425421-10598-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1367425421-10598-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 01, 2013 at 10:23:41AM -0600, Liu Bo wrote:
> lock_extent/unlock_extent expect an exclusive end.
> 

Can you make an xfstest for this so we can make sure we don't screw this up in
the future?  Thanks,

Josef
