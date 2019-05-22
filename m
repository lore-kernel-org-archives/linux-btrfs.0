Return-Path: <SRS0=N9Hd=TW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 274EFC282CE
	for <linux-btrfs@archiver.kernel.org>; Wed, 22 May 2019 20:00:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED9B820862
	for <linux-btrfs@archiver.kernel.org>; Wed, 22 May 2019 20:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1558555258;
	bh=5JJ0A4YTngVp1poDwCyZPpjaELnYqOmKSWSMbOpvHyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=c9RTX4rq12HF+A4VIZrm4G0wOitu+PpNe83T8qAwbupLYg0+taHeTPGHXgQY+S1uD
	 YdeMdCBPzFBYwQ4JWw7DgzWtH30YQior8rKvig6l+y9UqIQDR4pmZJ4LVkU85vI/5r
	 LcYQHrXyeLWC2TsSBCq/7mQeqEONsBfy19GjPptM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731331AbfEVUAx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 22 May 2019 16:00:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:43732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730653AbfEVTW4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 May 2019 15:22:56 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FDAA20675;
        Wed, 22 May 2019 19:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558552976;
        bh=5JJ0A4YTngVp1poDwCyZPpjaELnYqOmKSWSMbOpvHyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q8hcDmIJp+F2RwoxChqPqPPVXn6ROpbTYpYHo8rkZwj61o8XgXmj1OGOa/6iy95Fx
         KBKyQk9Ly2I/ddPa7BUEVlYk0rDpRAiSnmyBcPBmg3Q0vy+q/FqVUqE+XTNmyFW4xh
         akImDO8qullPekPW4WaB3LHsL8XXxIdz+OS0O/kA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Robbie Ko <robbieko@synology.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 056/375] Btrfs: fix data bytes_may_use underflow with fallocate due to failed quota reserve
Date:   Wed, 22 May 2019 15:15:56 -0400
Message-Id: <20190522192115.22666-56-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192115.22666-1-sashal@kernel.org>
References: <20190522192115.22666-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Robbie Ko <robbieko@synology.com>

[ Upstream commit 39ad317315887c2cb9a4347a93a8859326ddf136 ]

When doing fallocate, we first add the range to the reserve_list and
then reserve the quota.  If quota reservation fails, we'll release all
reserved parts of reserve_list.

However, cur_offset is not updated to indicate that this range is
already been inserted into the list.  Therefore, the same range is freed
twice.  Once at list_for_each_entry loop, and once at the end of the
function.  This will result in WARN_ON on bytes_may_use when we free the
remaining space.

At the end, under the 'out' label we have a call to:

   btrfs_free_reserved_data_space(inode, data_reserved, alloc_start, alloc_end - cur_offset);

The start offset, third argument, should be cur_offset.

Everything from alloc_start to cur_offset was freed by the
list_for_each_entry_safe_loop.

Fixes: 18513091af94 ("btrfs: update btrfs_space_info's bytes_may_use timely")
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Robbie Ko <robbieko@synology.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/file.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 34fe8a58b0e9c..0832449722c12 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -3132,6 +3132,7 @@ static long btrfs_fallocate(struct file *file, int mode,
 			ret = btrfs_qgroup_reserve_data(inode, &data_reserved,
 					cur_offset, last_byte - cur_offset);
 			if (ret < 0) {
+				cur_offset = last_byte;
 				free_extent_map(em);
 				break;
 			}
@@ -3181,7 +3182,7 @@ static long btrfs_fallocate(struct file *file, int mode,
 	/* Let go of our reservation. */
 	if (ret != 0 && !(mode & FALLOC_FL_ZERO_RANGE))
 		btrfs_free_reserved_data_space(inode, data_reserved,
-				alloc_start, alloc_end - cur_offset);
+				cur_offset, alloc_end - cur_offset);
 	extent_changeset_free(data_reserved);
 	return ret;
 }
-- 
2.20.1

