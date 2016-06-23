Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39925 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbcFWJPE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jun 2016 05:15:04 -0400
Date: Thu, 23 Jun 2016 02:15:04 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: check truncate can update file size correctly
 when truncate fails
Message-ID: <20160623091504.GA31644@infradead.org>
References: <1466667400-21639-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1466667400-21639-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 23, 2016 at 03:36:40PM +0800, Wang Xiaoguang wrote:
> In btrfs, when truncate operation fails for enospc reason, file may still
> have some disk blocks, but it will fail to update filesize accordingly.

Any reason this isn't a generic test?  Seems nothing in the test case
really is btrfs specific.
