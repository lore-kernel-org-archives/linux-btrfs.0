Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:51684 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330Ab2F0RWl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jun 2012 13:22:41 -0400
Date: Wed, 27 Jun 2012 10:21:30 -0700
From: Marc MERLIN <marc@merlins.org>
To: Alexander Block <ablock84@googlemail.com>
Cc: linux-btrfs@vger.kernel.org, dave@jikos.cz, hch@infradead.org,
        linux-fsdevel@vger.kernel.org, chris.mason@fusionio.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Allow cross subvolume reflinks (2nd attempt)
Message-ID: <20120627172130.GD7472@merlins.org>
References: <1340188512-5761-1-git-send-email-ablock84@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1340188512-5761-1-git-send-email-ablock84@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 20, 2012 at 12:35:11PM +0200, Alexander Block wrote:
> Hello,
> 
> This is the second attempt to bring in cross subvolume reflinks into btrfs.
> The first attempt was NAKed due to missing vfs mount checks and a clear
> description of what btrfs subvolumes are and probably also why cross 
> subvolume reflinks are ok in the case of btrfs. This version of the patch 
> comes from David and is in SUSE kernels since a long time, so it is tested 
> and working. The patch also does proper vfs mount checks, so cross mount 
> point reflinks are not possible with this patch. It only allows cross 
> reflinks between two subvolumes which are in the same mount point. 
 
Thank you for bringing this back. This would have saved me a lot of
trouble

I'm not familiar with the code, but here's a big thumbs up from me.

Anyone doing reviews, please consider this :)

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/
