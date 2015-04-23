Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60617 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966392AbbDWQRB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Apr 2015 12:17:01 -0400
Date: Thu, 23 Apr 2015 18:16:59 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, lukas.lueg@gmail.com
Subject: Re: [PATCH] btrfs: Check superblock csum type to avoid 0 division or
 array overflow.
Message-ID: <20150423161659.GL4996@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1429752681-566-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1429752681-566-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 23, 2015 at 09:31:21AM +0800, Qu Wenruo wrote:
> Current btrfs only support CRC32 checksum, and if csum_type is 1, we
> will get 0 csum size, causing 0 division later destroy the whole kernel.
> Or csum_type is later than 1, we will get data from other random memory
> causing more problem.

The check for csum type is already there in btrfs_check_super_csum, but
it's wrong and should be fixed.

btrfs_csum_sizes = { 4, 0 };

 429         if (csum_type >= ARRAY_SIZE(btrfs_csum_sizes)) {
 430                 printk(KERN_ERR "BTRFS: unsupported checksum algorithm %u\n",
 431                                 csum_type);
 432                 ret = 1;
 433         }
 434

and the check fails to catch csum_type == 1.
