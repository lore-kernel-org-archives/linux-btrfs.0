Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57387 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbbKKN4p (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Nov 2015 08:56:45 -0500
Date: Wed, 11 Nov 2015 05:56:39 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, david@fromorbit.com,
        fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
        Anna.Schumaker@netapp.com, linux-btrfs@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: [RFCv3 00/12] xfstests: test the btrfs/xfs reflink/dedupe ioctls
Message-ID: <20151111135639.GA4760@infradead.org>
References: <20151007051257.3260.73072.stgit@birch.djwong.org>
 <20151109075926.GB17974@infradead.org>
 <20151109184913.GB3255@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20151109184913.GB3255@birch.djwong.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 09, 2015 at 10:49:13AM -0800, Darrick J. Wong wrote:
> I found a few more bugs in the kernel-side implementation, which might explain
> that.  I'm about to start working on making CoW less crappy, but I'll push all
> the patches out to github.  (I wasn't planning on patchbombing again until
> December.)

Yes, please push your WIP code out as often as possible!

Btw, here is another additional fixup, as two tests were wrongly
tagged as needing reflink instead of dedupe:


diff --git a/tests/generic/827 b/tests/generic/827
index cc1bc52..c8ce7cf 100755
--- a/tests/generic/827
+++ b/tests/generic/827
@@ -47,7 +47,7 @@ _supported_fs generic
 _supported_os Linux
 
 _require_scratch
-_require_xfs_io_command "reflink"
+_require_xfs_io_command "dedupe"
 
 echo "Format and mount"
 _scratch_mkfs > $seqres.full 2>&1
diff --git a/tests/generic/828 b/tests/generic/828
index 1757985..f5b7298 100755
--- a/tests/generic/828
+++ b/tests/generic/828
@@ -47,7 +47,7 @@ _supported_fs generic
 _supported_os Linux
 
 _require_scratch
-_require_xfs_io_command "reflink"
+_require_xfs_io_command "dedupe"
 
 echo "Format and mount"
 _scratch_mkfs > $seqres.full 2>&1
