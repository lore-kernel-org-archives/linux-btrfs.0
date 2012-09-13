Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:40825 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757852Ab2IMMih (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Sep 2012 08:38:37 -0400
Date: Thu, 13 Sep 2012 08:38:34 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Miao Xie <miaox@cn.fujitsu.com>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] Revert "Btrfs: do not do
 filemap_write_and_wait_range in fsync"
Message-ID: <20120913123834.GC12994@localhost.localdomain>
References: <5051BB3B.5020201@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <5051BB3B.5020201@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 13, 2012 at 04:53:47AM -0600, Miao Xie wrote:
> This reverts commit 0885ef5b5601e9b007c383e77c172769b1f214fd
> 
> After applying the above patch, the performance slowed down because the dirty
> page flush can only be done by one task, so revert it.
> 
> The following is the test result of sysbench:
> 	Before		After
> 	24MB/s		39MB/s
> 

Ah I didn't think about that, good point, thanks!

Josef
