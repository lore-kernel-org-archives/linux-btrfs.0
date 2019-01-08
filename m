Return-Path: <SRS0=Si37=PQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 909ACC43387
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 19:52:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 61696206BB
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 19:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1546977129;
	bh=tnGu0IeRazSJhzU9kv4qJ89Pajls4j4/DXyBm+Q5vGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=tthq3/9SCjlYmJjy88LIXe/FRApGVL0cHFQwyJdyvIW1VyV0T5vrGe475D5h11thI
	 iN8iJqV3QmA1i2DuKKfnLYouFPP7zI3h5z3eb3fu4OlmtIZechXAH+zzsQ7Pdl9pVj
	 v5KR3R3Zt1IM60HmrXfLsql/QRVKgTJ0lvJUs0YQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732882AbfAHTv7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Jan 2019 14:51:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:39422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731038AbfAHTbU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 Jan 2019 14:31:20 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCB0320645;
        Tue,  8 Jan 2019 19:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1546975879;
        bh=tnGu0IeRazSJhzU9kv4qJ89Pajls4j4/DXyBm+Q5vGM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y7hY9Rr/nYFFmQRPT/ZooxG8nn4Jv4jlYGkX4ktAHZJGrIKcbqQHM0xHD0W6xnD52
         Wl6JMa7GGFovMP6G9aJ4aySKT0yNv8DmNbAH35V1KEs0jSBPR3sIeLWg83m0eNikRm
         c63F71RjLsjU7RGLCTmzHxHLT3tgjs2sxCwTXOx4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 56/97] btrfs: volumes: Make sure there is no overlap of dev extents at mount time
Date:   Tue,  8 Jan 2019 14:29:05 -0500
Message-Id: <20190108192949.122407-56-sashal@kernel.org>
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

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 5eb193812a42dc49331f25137a38dfef9612d3e4 ]

Enhance btrfs_verify_dev_extents() to remember previous checked dev
extents, so it can verify no dev extents can overlap.

Analysis from Hans:

"Imagine allocating a DATA|DUP chunk.

 In the chunk allocator, we first set...
   max_stripe_size = SZ_1G;
   max_chunk_size = BTRFS_MAX_DATA_CHUNK_SIZE
 ... which is 10GiB.

 Then...
   /* we don't want a chunk larger than 10% of writeable space */
   max_chunk_size = min(div_factor(fs_devices->total_rw_bytes, 1),
       		 max_chunk_size);

 Imagine we only have one 7880MiB block device in this filesystem. Now
 max_chunk_size is down to 788MiB.

 The next step in the code is to search for max_stripe_size * dev_stripes
 amount of free space on the device, which is in our example 1GiB * 2 =
 2GiB. Imagine the device has exactly 1578MiB free in one contiguous
 piece. This amount of bytes will be put in devices_info[ndevs - 1].max_avail

 Next we recalculate the stripe_size (which is actually the device extent
 length), based on the actual maximum amount of available raw disk space:
   stripe_size = div_u64(devices_info[ndevs - 1].max_avail, dev_stripes);

 stripe_size is now 789MiB

 Next we do...
   data_stripes = num_stripes / ncopies
 ...where data_stripes ends up as 1, because num_stripes is 2 (the amount
 of device extents we're going to have), and DUP has ncopies 2.

 Next there's a check...
   if (stripe_size * data_stripes > max_chunk_size)
 ...which matches because 789MiB * 1 > 788MiB.

 We go into the if code, and next is...
   stripe_size = div_u64(max_chunk_size, data_stripes);
 ...which resets stripe_size to max_chunk_size: 788MiB

 Next is a fun one...
   /* bump the answer up to a 16MB boundary */
   stripe_size = round_up(stripe_size, SZ_16M);
 ...which changes stripe_size from 788MiB to 800MiB.

 We're not done changing stripe_size yet...
   /* But don't go higher than the limits we found while searching
    * for free extents
    */
   stripe_size = min(devices_info[ndevs - 1].max_avail,
       	      stripe_size);

 This is bad. max_avail is twice the stripe_size (we need to fit 2 device
 extents on the same device for DUP).

 The result here is that 800MiB < 1578MiB, so it's unchanged. However,
 the resulting DUP chunk will need 1600MiB disk space, which isn't there,
 and the second dev_extent might extend into the next thing (next
 dev_extent? end of device?) for 22MiB.

 The last shown line of code relies on a situation where there's twice
 the value of stripe_size present as value for the variable stripe_size
 when it's DUP. This was actually the case before commit 92e222df7b
 "btrfs: alloc_chunk: fix DUP stripe size handling", from which I quote:
   "[...] in the meantime there's a check to see if the stripe_size does
 not exceed max_chunk_size. Since during this check stripe_size is twice
 the amount as intended, the check will reduce the stripe_size to
 max_chunk_size if the actual correct to be used stripe_size is more than
 half the amount of max_chunk_size."

 In the previous version of the code, the 16MiB alignment (why is this
 done, by the way?) would result in a 50% chance that it would actually
 do an 8MiB alignment for the individual dev_extents, since it was
 operating on double the size. Does this matter?

 Does it matter that stripe_size can be set to anything which is not
 16MiB aligned because of the amount of remaining available disk space
 which is just taken?

 What is the main purpose of this round_up?

 The most straightforward thing to do seems something like...
   stripe_size = min(
       div_u64(devices_info[ndevs - 1].max_avail, dev_stripes),
       stripe_size
   )
 ..just putting half of the max_avail into stripe_size."

Link: https://lore.kernel.org/linux-btrfs/b3461a38-e5f8-f41d-c67c-2efac8129054@mendix.com/
Reported-by: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
[ add analysis from report ]
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/volumes.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f4405e430da6..5aa6296699b4 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -7467,6 +7467,8 @@ int btrfs_verify_dev_extents(struct btrfs_fs_info *fs_info)
 	struct btrfs_path *path;
 	struct btrfs_root *root = fs_info->dev_root;
 	struct btrfs_key key;
+	u64 prev_devid = 0;
+	u64 prev_dev_ext_end = 0;
 	int ret = 0;
 
 	key.objectid = 1;
@@ -7511,10 +7513,22 @@ int btrfs_verify_dev_extents(struct btrfs_fs_info *fs_info)
 		chunk_offset = btrfs_dev_extent_chunk_offset(leaf, dext);
 		physical_len = btrfs_dev_extent_length(leaf, dext);
 
+		/* Check if this dev extent overlaps with the previous one */
+		if (devid == prev_devid && physical_offset < prev_dev_ext_end) {
+			btrfs_err(fs_info,
+"dev extent devid %llu physical offset %llu overlap with previous dev extent end %llu",
+				  devid, physical_offset, prev_dev_ext_end);
+			ret = -EUCLEAN;
+			goto out;
+		}
+
 		ret = verify_one_dev_extent(fs_info, chunk_offset, devid,
 					    physical_offset, physical_len);
 		if (ret < 0)
 			goto out;
+		prev_devid = devid;
+		prev_dev_ext_end = physical_offset + physical_len;
+
 		ret = btrfs_next_item(root, path);
 		if (ret < 0)
 			goto out;
-- 
2.19.1

