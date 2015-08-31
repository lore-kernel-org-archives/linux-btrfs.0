Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60241 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752618AbbHaPUo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 31 Aug 2015 11:20:44 -0400
Date: Mon, 31 Aug 2015 17:20:05 +0200
From: David Sterba <dsterba@suse.cz>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/4] btrfs-progs: Fix infinite loop of btrfs subvolumn
 sync
Message-ID: <20150831152004.GX11834@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <e7e430d22bb78d6ab8b28a514685cda221bfe379.1440597812.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <e7e430d22bb78d6ab8b28a514685cda221bfe379.1440597812.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 26, 2015 at 10:03:36PM +0800, Zhao Lei wrote:
> We can trigger the bug by following operation:
>   (no wait between commands 3~5)
>   btrfs subvolume create /mnt/btrfs/mysubvol
>   btrfs subvolume snapshot /mnt/btrfs/mysubvol /mnt/btrfs/mysubvol_snap
>   btrfs subvolume delete /mnt/btrfs/mysubvol_snap
>   btrfs subvolume delete /mnt/btrfs/mysubvol
>   btrfs subvolume sync /mnt/btrfs
> The last command will not exit.
> 
> Reason:
>   List of "deleted subvolumes" are not currectly set.
> 
>   It caused by a typo of value assign, in detail:
>   *ids[idx] = sh->offset;
>   should be:
>   (*ids)[idx] = sh->offset;
>   So only first element is set to right memory address.
> 
>   If there are multiple "deleted subvolumes", program will
>   keep wait.
> 
> Above typo also caused some segment fault in my test.
> 
> This patch fixed above bug.
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>

Applied, thanks.
