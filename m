Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34375 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751891AbeFFO6z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 6 Jun 2018 10:58:55 -0400
Date: Wed, 6 Jun 2018 16:56:08 +0200
From: David Sterba <dsterba@suse.cz>
To: Hans van Kranenburg <hans@knorrie.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: fi-usage: fix RAID10 raw disk usage
Message-ID: <20180606145608.GK3539@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180602212641.928-1-hans@knorrie.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180602212641.928-1-hans@knorrie.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jun 02, 2018 at 11:26:41PM +0200, Hans van Kranenburg wrote:
> In case of RAID10, fi usage is reporting half the amount of allocated
> space and twice the amount of unallocated disk space. Let's fix this.
> 
> For example, a RAID10 chunk of 3GiB with num_stripes 6, half of the
> stripes (dev extents) are a mirror of the other half, so the 3GiB of
> actual data has to be divided by 3, and not 6 to get the size of each of
> those device extents.
> 
> Signed-off-by: Hans van Kranenburg <hans@knorrie.org>

Applied, thanks.
