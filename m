Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47187 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757206AbcG1MGD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Jul 2016 08:06:03 -0400
Date: Thu, 28 Jul 2016 14:05:43 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] btrfs-progs: fix btrfsck of space_cache=v2 bitmaps on
 big-endian
Message-ID: <20160728120543.GV30795@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <17d32b3a20611fe19ab62726bf8626563ff3ec19.1468609012.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <17d32b3a20611fe19ab62726bf8626563ff3ec19.1468609012.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 15, 2016 at 12:12:48PM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> Copy le_test_bit() from the kernel and use that for the free space tree
> bitmaps.
> 
> Signed-off-by: Omar Sandoval <osandov@fb.com>

Applied, thanks.
