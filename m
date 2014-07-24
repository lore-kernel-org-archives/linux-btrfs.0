Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47152 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756647AbaGXLpa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jul 2014 07:45:30 -0400
Date: Thu, 24 Jul 2014 13:45:28 +0200
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 6/6] Btrfs: fix wrong extent mapping for DirectIO
Message-ID: <20140724114528.GV1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1405568654-22120-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
 <1405568654-22120-6-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1405568654-22120-6-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 17, 2014 at 11:44:14AM +0800, Wang Shilong wrote:
> btrfs_next_leaf() will use current leaf's last key to search
> and then return a bigger one. So it may still return a file extent
> item that is smaller than expected value and we will
> get an overflow here for @em->len.
> 
> This is easy to reproduce for Btrfs Direct writting, it did not
> cause any problem, because writting will re-insert right mapping later.
> 
> However, by hacking code to make DIO support compression, wrong extent
> mapping is kept and it encounter merging failure(EEXIST) quickly.

So this cannot happen normally (because compression and DIO do not work
together)?

> Fix this problem by looping to find next file extent item that is bigger
> than @start or we could not find anything more.
> 
> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

Reviewed-by: David Sterba <dsterba@suse.cz>
