Return-Path: <SRS0=Si37=PQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B792C43387
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 19:28:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF7EA2176F
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 19:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1546975719;
	bh=eibgdlO0U8PzF/l1D+WU9mVFGccVypalRmkl57PbZHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=0Ol0D33j4C2pU/2HDPCKLjJy+SHBQ+fpZeCIkH0vJ7SRPtp1JsWOjim0nCv+2Qwpm
	 eFKov6ODJFO1sbioUJ46lmjMh13QV+Ym9PG/EEWoWAE6lyy71mRcdZpO7fXPIm/Ffj
	 jr5A5Y0dWE3DtRpWZJz9YQZ6NPNfWM/rPHfNpwhs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730100AbfAHT2g (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Jan 2019 14:28:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:35670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730086AbfAHT2f (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 Jan 2019 14:28:35 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C00920645;
        Tue,  8 Jan 2019 19:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1546975715;
        bh=eibgdlO0U8PzF/l1D+WU9mVFGccVypalRmkl57PbZHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L/vhXcVxO6+mdqE89m+LbXVKrlEA9O1rVWagYRsQmOXWJlIoQthfuNV3y+cMj39NL
         DvAN9oJx4X1kn65928uKuRRHrg3o2eLHdqmZ2AvsbxuEq98DM/fozDHj7p1MMAvYQw
         vG3SBnrrjWHUBl7vJ7/dBNzzh+XBwiGf/cF6g6xs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.20 072/117] btrfs: alloc_chunk: fix more DUP stripe size handling
Date:   Tue,  8 Jan 2019 14:25:40 -0500
Message-Id: <20190108192628.121270-72-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190108192628.121270-1-sashal@kernel.org>
References: <20190108192628.121270-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>

[ Upstream commit baf92114c7e6dd6124aa3d506e4bc4b694da3bc3 ]

Commit 92e222df7b "btrfs: alloc_chunk: fix DUP stripe size handling"
fixed calculating the stripe_size for a new DUP chunk.

However, the same calculation reappears a bit later, and that one was
not changed yet. The resulting bug that is exposed is that the newly
allocated device extents ('stripes') can have a few MiB overlap with the
next thing stored after them, which is another device extent or the end
of the disk.

The scenario in which this can happen is:
* The block device for the filesystem is less than 10GiB in size.
* The amount of contiguous free unallocated disk space chosen to use for
  chunk allocation is 20% of the total device size, or a few MiB more or
  less.

An example:
- The filesystem device is 7880MiB (max_chunk_size gets set to 788MiB)
- There's 1578MiB unallocated raw disk space left in one contiguous
  piece.

In this case stripe_size is first calculated as 789MiB, (half of
1578MiB).

Since 789MiB (stripe_size * data_stripes) > 788MiB (max_chunk_size), we
enter the if block. Now stripe_size value is immediately overwritten
while calculating an adjusted value based on max_chunk_size, which ends
up as 788MiB.

Next, the value is rounded up to a 16MiB boundary, 800MiB, which is
actually more than the value we had before. However, the last comparison
fails to detect this, because it's comparing the value with the total
amount of free space, which is about twice the size of stripe_size.

In the example above, this means that the resulting raw disk space being
allocated is 1600MiB, while only a gap of 1578MiB has been found. The
second device extent object for this DUP chunk will overlap for 22MiB
with whatever comes next.

The underlying problem here is that the stripe_size is reused all the
time for different things. So, when entering the code in the if block,
stripe_size is immediately overwritten with something else. If later we
decide we want to have the previous value back, then the logic to
compute it was copy pasted in again.

With this change, the value in stripe_size is not unnecessarily
destroyed, so the duplicated calculation is not needed any more.

Signed-off-by: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/volumes.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index a567ee0bf060..1797a82eb7df 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4768,19 +4768,17 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	/*
 	 * Use the number of data stripes to figure out how big this chunk
 	 * is really going to be in terms of logical address space,
-	 * and compare that answer with the max chunk size
+	 * and compare that answer with the max chunk size. If it's higher,
+	 * we try to reduce stripe_size.
 	 */
 	if (stripe_size * data_stripes > max_chunk_size) {
-		stripe_size = div_u64(max_chunk_size, data_stripes);
-
-		/* bump the answer up to a 16MB boundary */
-		stripe_size = round_up(stripe_size, SZ_16M);
-
 		/*
-		 * But don't go higher than the limits we found while searching
-		 * for free extents
+		 * Reduce stripe_size, round it up to a 16MB boundary again and
+		 * then use it, unless it ends up being even bigger than the
+		 * previous value we had already.
 		 */
-		stripe_size = min(devices_info[ndevs - 1].max_avail,
+		stripe_size = min(round_up(div_u64(max_chunk_size,
+						   data_stripes), SZ_16M),
 				  stripe_size);
 	}
 
-- 
2.19.1

