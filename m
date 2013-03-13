Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:34185 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933240Ab3CMTbV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Mar 2013 15:31:21 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id A03DF7C042F
	for <linux-btrfs@vger.kernel.org>; Wed, 13 Mar 2013 13:31:21 -0600 (MDT)
Date: Wed, 13 Mar 2013 15:31:19 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: David Sterba <dsterba@suse.cz>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2] btrfs: enhance superblock checks
Message-ID: <20130313193119.GG15014@shiny.masoncoding.com>
References: <1362585400-13379-1-git-send-email-dsterba@suse.cz>
 <1362748538-12873-1-git-send-email-dsterba@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1362748538-12873-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 08, 2013 at 06:15:38AM -0700, David Sterba wrote:
> The superblock checksum is not verified upon mount. <awkward silence>
> 
> Add that check and also reorder existing checks to a more logical
> order.
> 
> Current mkfs.btrfs does not calculate the correct checksum of
> super_block and thus a freshly created filesytem will fail to mount when
> this patch is applied.

Hi Dave,

Thanks for finding this and writing up the patch.  Can we please change
it to ignore the crc if the transid is from mkfs?  I'd prefer that we
allow older progs for a while longer.  We can take this check out after
a few releases.

-chris
