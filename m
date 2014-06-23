Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tetsuo.zabbo.net ([50.193.208.193]:39632 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753100AbaFWWaf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Jun 2014 18:30:35 -0400
Date: Mon, 23 Jun 2014 15:23:05 -0700
From: Zach Brown <zab@zabbo.net>
To: Filipe David Borba Manana <fdmanana@gmail.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] generic/017: skip invalid block sizes for btrfs
Message-ID: <20140623222305.GH5499@lenny.home.zabbo.net>
References: <1403519280-24216-1-git-send-email-fdmanana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1403519280-24216-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 23, 2014 at 11:28:00AM +0100, Filipe David Borba Manana wrote:
> In btrfs the block size (called sector size in btrfs) can not be
> smaller then the page size.

Nor larger.

commit 8d082fb727ac11930ea20bf1612e334ea7c2b697
Author: Liu Bo <liubo2009@cn.fujitsu.com>
Date:   Tue Apr 3 09:56:53 2012 +0800

    Btrfs: do not mount when we have a sectorsize unequal to PAGE_SIZE
    
    Our code is not ready to cope with a sectorsize that's not equal to PAGE_SIZE.
    It will lead to hanging-on while writing something.

- z
