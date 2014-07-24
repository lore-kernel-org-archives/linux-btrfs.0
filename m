Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46094 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771AbaGXK5b (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jul 2014 06:57:31 -0400
Date: Thu, 24 Jul 2014 12:57:29 +0200
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/6] Btrfs: fix wrong skipping compression for an inode
Message-ID: <20140724105729.GQ1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1405568654-22120-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1405568654-22120-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 17, 2014 at 11:44:09AM +0800, Wang Shilong wrote:
> If a file's compression ratios is bad, we will set NOCOMPRESS
> flag for it, and it will skip compression for that inode next time.
> 
> However, if we remount fs to COMPRESS_FORCE, it still should try
> if we could compress pages for that inode, this patch fix wrong
> check for this problem.
> 
> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

Reviewed-by: David Sterba <dsterba@suse.cz>

The documented compression precedence
https://btrfs.wiki.kernel.org/index.php/Compression#What.27s_the_precedence_of_all_the_options_affecting_compression.3F

matches the way you've fixed it.
