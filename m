Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tetsuo.zabbo.net ([50.193.208.193]:38304 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422655Ab3BGWSO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Feb 2013 17:18:14 -0500
Date: Thu, 7 Feb 2013 14:18:13 -0800
From: Zach Brown <zab@zabbo.net>
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [RFC] Btrfs: Allow the compressed extent size limit to be
 modified v2
Message-ID: <20130207221813.GT14246@lenny.home.zabbo.net>
References: <1360273114-4672-1-git-send-email-mitch.harder@sabayonlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1360273114-4672-1-git-send-email-mitch.harder@sabayonlinux.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 07, 2013 at 03:38:34PM -0600, Mitch Harder wrote:
> Provide for modification of the limit of compressed extent size
> utilizing mount-time configuration settings.
> 
> The size of compressed extents was limited to 128K, which
> leads to fragmentation of the extents (although the extents
> themselves may still be located contiguously).  This limit is
> put in place to ease the RAM required when spreading compression
> across several CPUs, and to make sure the amount of IO required
> to do a random read is reasonably small.
> 
> Signed-off-by: Mitch Harder <mitch.harder@sabayonlinux.org>
> ---
> Changelog v1 -> v2:
> - Use more self-documenting variable name:
>   compressed_extent_size -> max_compressed_extent_kb
> - Use #define BTRFS_DEFAULT_MAX_COMPR_EXTENTS instead of raw 128.
> - Fix min calculation for nr_pages.
> - Comment cleanup.
> - Use more self-documenting mount option parameter:
>   compressed_extent_size -> max_compressed_extent_kb
> - Fix formatting in btrfs_show_options.

Cool, thanks for cleaning those up.  It looks a lot better now.

- z
