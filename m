Return-Path: <SRS0=Si37=PQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70743C43387
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 19:52:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40FCB206BB
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 19:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1546977131;
	bh=mOPBkzdDdGB6dDaGaLV1GwNSxE8T0xX6CQ8rR2VBovg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=RcwTMuSKLyEG7XMIGzKJHrkOVPJYAFapoxwJ4lMbKTtKuDdlmMeqdTer6GkJuiT1c
	 8qiVq4hWz7ZkJoCw2oAjTS16Ya0VXZtxeOv4KeEJVtTesZO2Dj9MhDgBWE9cJvAFfB
	 HT/sxaGbfZ7JOyQzc1tIASu4/BFU6LXtRAdedb3Q=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732125AbfAHTv7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Jan 2019 14:51:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:39440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731056AbfAHTbV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 Jan 2019 14:31:21 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C27B920665;
        Tue,  8 Jan 2019 19:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1546975880;
        bh=mOPBkzdDdGB6dDaGaLV1GwNSxE8T0xX6CQ8rR2VBovg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a60+Yk64u0P68zYWG9B8W5/09RaOyqM4qF9hlq4ATg1sq213ozFC6VJ7bhbgM42cC
         uskSi+5Z8Js+n8bNxzYKzr5kIS7DY8y1xQAyUaHmFHbJoM+X+y3lf8vR5DZSvX6kdB
         G7MpKlWZgRD6Hv6MY/L70Cg2c1WBZc2Lg58d5Wcg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 57/97] btrfs: alloc_chunk: fix more DUP stripe size handling
Date:   Tue,  8 Jan 2019 14:29:06 -0500
Message-Id: <20190108192949.122407-57-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190108192949.122407-1-sashal@kernel.org>
References: <20190108192949.122407-1-sashal@kernel.org>
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
index 5aa6296699b4..064e86c069ec 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4761,19 +4761,17 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
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

