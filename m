Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 350823375C3
	for <linux-btrfs@vger.kernel.org>; Sun,  2 Aug 2026 23:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785713321; cv=none; b=SzA+eK+4GAjLZo9zSN/Uo+YsBQMyPW/M4DM2USxeYRfzuLBNQRYFKKtmXrD9mMiT1aKkMuGATIyTGs/JKEEKgownQiGXoPrA9iQTRpSwRAO+HwYVDErNRQwK/D6REpnBuLe57jfiPYDyQaeTlrugFoyhHUmVazWpVdrZ5zsARVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785713321; c=relaxed/simple;
	bh=H1lVJxUhCPfGvC+UgDjNS363K4vk26nMs63+FyWoKGE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tg1nXO+N8aKWdyIk0f4UUK019E/KU/1xyzCS1YvPgGALDqTSfrVuBEquQaA78sm25RF0Ex98snqj2df/W1DictJ3yfag6wgQ3fFCcvKhrvH2Yhc9LxsvBP39PD/VfCi/kBB6L0kZXtt/H1vZIp8CeIYDRBxCPH/0s/XFkdUnsKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kKVIZi4+; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kKVIZi4+"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-8efcfdb2b43so20970016d6.3
        for <linux-btrfs@vger.kernel.org>; Sun, 02 Aug 2026 16:28:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785713319; x=1786318119; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=WtWsszqVORiGbzEMc9bRW/MM4TSHLERgRdJFuPi15b0=;
        b=kKVIZi4+M3TllcaS1qmc9g4A3LGTI/xfky+DSw8dowpWrrON6MANHTirI/KM98XC5W
         QYgQC3+neni0VXmvwjwPrOCoqImsQLapAMcUjvtzxM8e7sI1rEL0mgPaMjLZ/cWFU30x
         eKFgPz7LJ6OIHmvkCm5Dpfo12jJeBP7Qu50LHPIvuLGQbZzXdhDZad2jNjVIy560yfpO
         U6T5uQj6UFZRLXLjU96Tl0xgczjuH84aXsOwSpRNklepMcIZpeVNpa9pxNeszqaWSCCa
         vWfApC+qHN6LAoomCA5cznj8pAfF8WCYwfCYwZ047Wv8jLkkJzb/FJ1jRVz+FCAZQTN7
         8T2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785713319; x=1786318119;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WtWsszqVORiGbzEMc9bRW/MM4TSHLERgRdJFuPi15b0=;
        b=fyVLvW+koJc3NrqY6KbnbDzOULlpWD624IVGDB0w14uyseo5Bncjkti9S0RvWfEXwJ
         dCo8AcL5Ez31F9GgaBma4djaN/dNheAVlROypWZNwjfTd3X83Y44mg5Wt44YbHgbIsJF
         5mllQ4SrGUXlKlZQLIF8CQCbT3hA8arGtip/IvhoXs509Jg0LxmAvgTM4ny9x8ilO7rR
         3e0o/6o0Q08QgGjAQF5JCWy/wrBwhTsTsENARDyCmcMQqR5A7DvBMMmnRrD+gDNvNAVh
         Zp53pL8h/vLjmhEXe8gz5LsLQtCbKsL1w+FBowrewzYvBMQO6QrVPwO/AITr5hzrZR6j
         4KsA==
X-Gm-Message-State: AOJu0YwDrkyI6pVZWZdUHS2Bi3XlVNilOuQ84p57AF0Upwmhj5YmhO7G
	u2o9/4XyvOJji9LNayIVUy6qpZfCq69oON4pO5rilFspM4BMdGAMJNf4MWxikBNK
X-Gm-Gg: AR+sD11k6smeAK1iQSXIQwt5f5mno6kWxGFrVwK3o4mQlX2P++EYBJ6DD0x2h5xb+JQ
	DOqOt1nbe9opFyvTrBAhPdmNbf2zM1H0pKFN8mbeIJKpQNozu1Wut4cfeDOA4S9BK9GmSoZ1Qra
	9fbQn+siCCbmbRu0RA26HXvqFwgymCFtDzR0BVJRHl9xhriyFGq7n1H7BV3/ClDOCHvsJPBUfoD
	3HLl2s26Qz/OxJBJbTfYwwll15YqNA+unc3JIlsCmohkMmrG75el9B/xEhtu2y+/YFJHQMGnF+X
	v1WU4jSWG7/4Rb8641HGSFzH5VwhB7JpXiWdsACLG9jCIJubcJfGOFA3IKHwa3JJKeCtEFAvVCz
	Km3vYSEiQn9cPPnXEXaAs7lWscghTEjHy5x5lVwpVr5wTa7yXQjwQzDhArRg5/1O1We/lpUPjRv
	JO7XKDjBWGM4Fgd9YJ+mOGuHg69/ZUC3btH1w4XK4KGKMTgyTIpmkO2oVtgfWryxZh0LN1ta2w5
	AkT5VIvw8nlv1xzIPqbmWoTfZ6R
X-Received: by 2002:ac8:690e:0:b0:51b:fc67:c73c with SMTP id d75a77b69052e-52b566dbe08mr183487601cf.16.1785713319079;
        Sun, 02 Aug 2026 16:28:39 -0700 (PDT)
Received: from i4-l-hqh5357-03.ad.psu.edu ([130.203.139.71])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52b4eb6a862sm50621961cf.16.2026.08.02.16.28.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Aug 2026 16:28:38 -0700 (PDT)
From: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com,
	dsterba@suse.com,
	naohiro.aota@wdc.com,
	linux-kernel@vger.kernel.org,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] btrfs: zoned: fix use-after-free in btrfs_reset_unused_block_groups()
Date: Sun,  2 Aug 2026 19:28:15 -0400
Message-ID: <20260802232815.3180433-1-shuangpeng.kernel@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

btrfs_mark_bg_unused() takes a block group reference when adding it to
unused_bgs. btrfs_reset_unused_block_groups() removes a selected block
group from the list and immediately drops that reference before accessing
bg->physical_map and updating the block group.

A concurrent unused block group deletion can then drop the remaining
references and free both bg and its physical_map, resulting in a
use-after-free.

Keep the unused_bgs reference as a local processing reference after
removing the block group from the list, and drop it only after the zone
reset and block group update have finished. Also release it on the error
and read-only paths.

Fixes: 453a73c3069a ("btrfs: zoned: reclaim unused zone by zone resetting")
Cc: stable@vger.kernel.org
Signed-off-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
---
 fs/btrfs/zoned.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index a016cb471beb..e30b6a61c781 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -3158,7 +3158,6 @@ int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num
 		}
 
 		list_del_init(&bg->bg_list);
-		btrfs_put_block_group(bg);
 		spin_unlock(&fs_info->unused_bgs_lock);
 
 		/*
@@ -3182,6 +3181,7 @@ int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num
 
 			if (ret) {
 				up_read(&fs_info->dev_replace.rwsem);
+				btrfs_put_block_group(bg);
 				return ret;
 			}
 		}
@@ -3193,6 +3193,7 @@ int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num
 		if (bg->ro) {
 			spin_unlock(&bg->lock);
 			spin_unlock(&space_info->lock);
+			btrfs_put_block_group(bg);
 			continue;
 		}
 
@@ -3221,6 +3222,7 @@ int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num
 		spin_unlock(&bg->lock);
 		btrfs_return_free_space(space_info, reclaimed);
 		spin_unlock(&space_info->lock);
+		btrfs_put_block_group(bg);
 
 		if (num_bytes <= reclaimed)
 			break;
-- 
2.43.0

