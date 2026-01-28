Received: from mail.synology.com (mail.synology.com [211.23.38.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E4C3316184
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Jan 2026 07:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.23.38.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769584016; cv=none; b=OXV5FTN0pjNDhntuzusZ9KBoGsF+TFVQU4pd5KuQHUCuMiSBfnb069RkLgx820Kj4HubM/QBkpDL4f3xw0QMe8qiUOYfyuPtCjjfEZcdpWqiIK2WRkqwJKtP27BwSFltmmZxyweiR5eReOxU1eOTo2IxqLHjgafqRHlJijIRpns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769584016; c=relaxed/simple;
	bh=0fxh6cPhB5tes26bern+HNKBq+2PJsSPpLfoNNNmMHc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LPsgZD4OC2peEAKjkKyQEr4byz7SRfFqqSM9Q48LzWTUv3xfCB5Hel+lIRiy9mVhysF8WQL3NlSqlI9tWaEgbV4MTRDXYnBtJNppU/WHZJ+bza1U9cV5/u4T1EVSefrR1ZBGyJ9l9ML0x+Mm2BSnBn9iZbwG4wNTKMjqz4DGETs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com; spf=pass smtp.mailfrom=synology.com; dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b=iBmg8I5K; arc=none smtp.client-ip=211.23.38.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=synology.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="iBmg8I5K"
Received: from vbm-jinbaohong.. (unknown [10.17.211.178])
	by mail.synology.com (Postfix) with ESMTPA id 4f1Cxn43gzzGCgmqm;
	Wed, 28 Jan 2026 15:06:53 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
	t=1769584013; bh=0fxh6cPhB5tes26bern+HNKBq+2PJsSPpLfoNNNmMHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iBmg8I5KnREg+cgIaCkLfvmswVew7Eyt04Wc9S02mh1EidtC1Sy4ZUIWTPYgoMr46
	 Y8/8acI6alehN7qPg6zQeqRiGCYn1d0eCDsr5tukn6aumgej+1gyVd+OX6aBqzxnVn
	 tn5S1A4ZSKnByxJNUPwxUsCg+xr+gMPQkfvLR4C4=
From: jinbaohong <jinbaohong@synology.com>
To: linux-btrfs@vger.kernel.org
Cc: fdmanana@kernel.org,
	dsterba@suse.com,
	jinbaohong <jinbaohong@synology.com>,
	Robbie Ko <robbieko@synology.com>
Subject: [PATCH v4 1/4] btrfs: continue trimming remaining devices on failure
Date: Wed, 28 Jan 2026 07:06:38 +0000
Message-Id: <20260128070641.826722-2-jinbaohong@synology.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260128070641.826722-1-jinbaohong@synology.com>
References: <20260128070641.826722-1-jinbaohong@synology.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Synology-Spam-Flag: no
X-Synology-Virus-Status: no
X-Synology-MCP-Status: no
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
Content-Type: text/plain

Commit 93bba24d4b5a ("btrfs: Enhance btrfs_trim_fs function to handle
error better") intended to make device trimming continue even if one
device fails, tracking failures and reporting them at the end. However,
it used 'break' instead of 'continue', causing the loop to exit on the
first device failure.

Fix this by replacing 'break' with 'continue'.

Fixes: 93bba24d4b5a ("btrfs: Enhance btrfs_trim_fs function to handle error better")
Signed-off-by: Robbie Ko <robbieko@synology.com>
Signed-off-by: jinbaohong <jinbaohong@synology.com>
---
 fs/btrfs/extent-tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 0ce2a7def0f3..bd167466b770 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6688,7 +6688,7 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_info, struct fstrim_range *range)
 		if (ret) {
 			dev_failed++;
 			dev_ret = ret;
-			break;
+			continue;
 		}
 	}
 	mutex_unlock(&fs_devices->device_list_mutex);
-- 
2.34.1


Disclaimer: The contents of this e-mail message and any attachments are confidential and are intended solely for addressee. The information may also be legally privileged. This transmission is sent in trust, for the sole purpose of delivery to the intended recipient. If you have received this transmission in error, any use, reproduction or dissemination of this transmission is strictly prohibited. If you are not the intended recipient, please immediately notify the sender by reply e-mail or phone and delete this message and its attachments, if any.
