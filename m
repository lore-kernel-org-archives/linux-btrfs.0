Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46321 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbcEKFq1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 May 2016 01:46:27 -0400
Date: Tue, 10 May 2016 22:46:26 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: fdmanana@gmail.com,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        fstests@vger.kernel.org
Subject: Re: [PATCH] fstests: btrfs: Test fiemap ioctl on completely deduped
 file
Message-ID: <20160511054626.GA10667@infradead.org>
References: <1462869581-19227-1-git-send-email-quwenruo@cn.fujitsu.com>
 <CAL3q7H5Mn2561cxK49vis3+XW1eTzx_j9h-iQpUJQ6qEGMczvQ@mail.gmail.com>
 <55ce1c42-fda3-520f-ebb1-11048df8799f@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <55ce1c42-fda3-520f-ebb1-11048df8799f@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 11, 2016 at 10:14:42AM +0800, Qu Wenruo wrote:
> BTW, does other fs support reflink file range?
> I found a lot xfs test cases using reflink, but I still can't reflink a file
> range inside the same inode

XFS work is under development and not in mainline yet.

Also NFS can support reflinks if the server supports it, which includes
a Linux server with btrfs or the XFS patches.
