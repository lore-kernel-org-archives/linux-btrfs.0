Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50725 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753085AbaCZSKz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Mar 2014 14:10:55 -0400
Date: Wed, 26 Mar 2014 19:10:53 +0100
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] Btrfs: don't compress for a small write
Message-ID: <20140326181053.GU29256@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1395655091-5318-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1395655091-5318-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 24, 2014 at 05:58:10PM +0800, Wang Shilong wrote:
> To compress a small write(<=blocksize) dosen't save us
> disk space at all, skip it can save us some compression time.

The compressibility depends on the data, a block full of zeros can
compress pretty well, so your patch is too limiting IMO.

> This patch can also fix wrong setting nocompression flag for
> inode, say a case when @total_in is 4096, and then we get
> @total_compressed 52,because we do aligment to page cache size
> firstly, and then we get into conclusion @total_in=@total_compressed
> thus we will clear this inode's compression flag.

This is a bug but can be fixed without disabling compression of small
blocks.

I have a similar patch as part of the large compression update, the
logic that decides if the small extent should be compressed or not
depends on the compression algo and some typical data samples. for zlib
it's around ~100 B and lzo at ~200 B. That's a boundary where compressed
size == uncompressed, so there's no benefit, only additional overhead.
