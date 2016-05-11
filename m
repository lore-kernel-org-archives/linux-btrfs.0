Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42650 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbcEKFZr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 May 2016 01:25:47 -0400
Date: Tue, 10 May 2016 22:25:46 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH] fstests: btrfs: Test fiemap ioctl on completely deduped
 file
Message-ID: <20160511052546.GA7447@infradead.org>
References: <1462869581-19227-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1462869581-19227-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 10, 2016 at 04:39:41PM +0800, Qu Wenruo wrote:
> For a completely deduped file, which means all its file extent are
> pointing to one bytenr, if calling fiemap on it, btrfs will cause soft
> hang up or just takes years long.
> 
> This bug can be reproduced even without any in-band or out-of-band
> dedupe, normal clone_file_range() call can create such situation.
> 
> This test case will detect it.

Why is this a btrfs specific test?
