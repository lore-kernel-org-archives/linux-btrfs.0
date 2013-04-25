Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:47424 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756171Ab3DYSsh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Apr 2013 14:48:37 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 2C5209A0699
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Apr 2013 12:48:36 -0600 (MDT)
Date: Thu, 25 Apr 2013 14:48:33 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Liu Bo <bo.li.liu@oracle.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: improve the loop of scrub_stripe
Message-ID: <20130425184833.GK2631@localhost.localdomain>
References: <1366304095-3206-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1366304095-3206-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 18, 2013 at 10:54:55AM -0600, Liu Bo wrote:
> 1) Right now scrub_stripe() is looping in some unnecessary cases:
> * when the found extent item's objectid has been out of the dev extent's range
>   but we haven't finish scanning all the range within the dev extent
> * when all the items has been processed but we haven't finish scanning all the
>   range within the dev extent
> 
> In both cases, we can just finish the loop to save costs.
> 
> 2) Besides, when the found extent item's length is larger than the stripe len(64k),
> we don't have to release the path and search again as it'll get at the same key
> used in the last loop, we can instead increase the logical cursor in place till
> all space of the extent is scanned.
> 
> 3) And we use 0 as the key's offset to search btree, then get to previous item
> to find a smaller item, and again have to move to the next one to get the right
> item.  Setting offset=-1 and previous_item() is the correct way.
> 
> 4) As we won't find any checksum at offset unless this 'offset' is in a data
> extent, we can just find checksum when we're really going to scrub an extent.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

A big chunk of this doesn't apply to btrfs-next and I don't feel comfortable
manually applying it, please rebase and resend.  Thanks,

Josef
