Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60026 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014AbcEDN5h (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 May 2016 09:57:37 -0400
Date: Wed, 4 May 2016 15:57:20 +0200
From: David Sterba <dsterba@suse.cz>
To: Marek Rusinowski <marekrusinowski@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: subvolume sync: fix handling of -s option
Message-ID: <20160504135720.GW29353@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1462368995-24542-1-git-send-email-marekrusinowski@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1462368995-24542-1-git-send-email-marekrusinowski@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 04, 2016 at 03:36:35PM +0200, Marek Rusinowski wrote:
> Setting check interval for subvolume sync resulted
> in picking wrong element from argv for it's value:
> 
>   $ btrfs subvolume sync -s 10 ./dir
>   ERROR: invalid sleep interval ./dir
>   $ btrfs subvolume sync ./dir -s 10
>   Segmentation fault
> 
> Signed-off-by: Marek Rusinowski <marekrusinowski@gmail.com>

Applied, thanks.
