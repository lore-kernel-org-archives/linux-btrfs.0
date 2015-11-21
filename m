Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60424 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759375AbbKUSOx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 21 Nov 2015 13:14:53 -0500
Date: Sat, 21 Nov 2015 10:14:51 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, fstests@vger.kernel.org, xfs@oss.sgi.com,
        hch@infradead.org, tao.peng@primarydata.com,
        linux-ext4@vger.kernel.org, Anna.Schumaker@netapp.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] generic/15[78]: fix error messages in the golden
 output
Message-ID: <20151121181451.GA17570@infradead.org>
References: <20151121005001.20398.92856.stgit@birch.djwong.org>
 <20151121005014.20398.22316.stgit@birch.djwong.org>
 <20151121180644.GA23916@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20151121180644.GA23916@infradead.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Shouldn't these be Invalid argument just like the
> to a device case above or the clone case?

E.g. something like this on top of your patch:


diff --git a/tests/generic/158.out b/tests/generic/158.out
index 1210429..dff3692 100644
--- a/tests/generic/158.out
+++ b/tests/generic/158.out
@@ -16,9 +16,9 @@ XFS_IOC_FILE_EXTENT_SAME: Invalid argument
 Try to dedupe to a dir
 TEST_DIR/test-158/dir1: Is a directory
 Try to dedupe to a device
-dedupe: Operation not supported
+dedupe: Invalid argument
 Try to dedupe to a fifo
-dedupe: Operation not supported
+dedupe: Invalid argument
 Try to dedupe an append-only file
 Dedupe two files
 Check scratch fs
