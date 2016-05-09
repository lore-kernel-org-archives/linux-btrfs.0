Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54000 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913AbcEIJvY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 May 2016 05:51:24 -0400
Date: Mon, 9 May 2016 11:51:00 +0200
From: David Sterba <dsterba@suse.cz>
To: Adam Borowski <kilobyte@angband.pl>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix int32 overflow in shrink_delalloc().
Message-ID: <20160509095100.GK29353@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1462712880-29392-1-git-send-email-kilobyte@angband.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1462712880-29392-1-git-send-email-kilobyte@angband.pl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, May 08, 2016 at 03:08:00PM +0200, Adam Borowski wrote:
> UBSAN: Undefined behaviour in fs/btrfs/extent-tree.c:4623:21
> signed integer overflow:
> 10808 * 262144 cannot be represented in type 'int [8]'
> 
> If 8192<=items<16384, we request a writeback of an insane number of pages
> which is benign (everything will be written).  But if items>=16384, the
> space reservation won't be enough.
> 
> Signed-off-by: Adam Borowski <kilobyte@angband.pl>

Reviewed-by: David Sterba <dsterba@suse.com>

I think this is the best fix, although I usually do not like to see
random type casts. In this case, we'd have to change items to something
else and propagate the change trhough several functions for no apparent
gain.  Just to satisfy one multiplication.
