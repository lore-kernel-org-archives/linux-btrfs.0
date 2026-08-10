Received: from out162-62-57-49.mail.qq.com (out162-62-57-49.mail.qq.com [162.62.57.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76E3B3DD85A;
	Mon, 10 Aug 2026 12:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786364202; cv=none; b=h1D9ONCbj6ZOMHZyu2cv42vt3QJICoZtzeUoPW2IvjIjrKyl8f2V6pMaX0VgjKs6coa0/KsvrJf81Z4GPwg6pKcmBRwdEH6F3l1chraKQ79sC1oLZu9hCh/NFhM+pmoLbOw+dQbZVnF6wSp97AB7ckIEJ2R2hDcU6qlJz+wJXA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786364202; c=relaxed/simple;
	bh=oBNNAKOCLTjYf+SvkQWifw0FP20704I1CuWj/dLBvno=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=JfZ6telgh9w4EgCRtHOvZsryIR+YU+rXhX0Y9/oZc5bfdBiZaxwEKKrBqLgNok5ZTZKgjXTEF/YKl2POD3h6WZFf7Hy8Vrrc/ec7gv6XmX1qPGqJYWqPwhIRPrAbrjSgmnoSFv33La6qfP1IC2znZc1bx2ZcsX2Nt6zL+RlIpWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=if/MO6sD; arc=none smtp.client-ip=162.62.57.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="if/MO6sD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1786364194; bh=mrirLj7V7LD+Eg8V4NeOpsC3CJJVwZOhcyCFjfYbIkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=if/MO6sDkcd1rnEGZPz/q9BmhEMj7e/umyEfjF3rU8imXc414oRpbIGe6xUQtGo16
	 U8+KeC6jjGXfNj1sxvmgtXCuNGc3YexPJ73XreKOvX/LCa17V8gXOzxFB4ygYjUw0Z
	 n08j49kShrYTXhAqZ8G428cM0AEirUHbOlqrUCpQ=
Received: from ikun-VMware-Virtual-Platform.localdomain ([2409:8a20:b30:4fb4:bdd2:8b42:d496:7e16])
	by newxmesmtplogicsvrsza53-0.qq.com (NewEsmtp) with SMTP
	id 41134061; Mon, 10 Aug 2026 20:16:17 +0800
X-QQ-mid: xmsmtpt1786364180t3ws8opp6
Message-ID: <tencent_36AA741E5645124FF3102D372408BE984907@qq.com>
X-QQ-XMAILINFO: MPEorwW6cFo9gA7CqBfL+7IjYLsuaA0BDdAIc4MLP6ugmowRF7ZQ2i25Ob4ovC
	 c0WzqJH/yLaSZg2bV3yph0Qk5pkiG1QqOWDUDxUjUR4TXlH/0lUwW7LZR6WPNyDccFBnXqbp0XfR
	 EZeWpVDOCayHyAjdZkvWCladF93/5CZ0U7bSLTeli/0+Kk44klTDiQIkeZ/SSFeVPOBjaFl1Ydr3
	 caOz3B/SaXq3zLF00t7MGKkjLrVGgetpq0K+xfL6/V6hj7q6qFXj63KJr4hdSfhiiAEY3uxBNCxD
	 arAlpDTPw1/vb38ryu+dF/+4YFnc4zc9BHWjfJrr9TH1oedYbnp1hM401Eh5NJAvcNFMSOA8A+zQ
	 YA5SeFqrNh9WiDPYDFl8suHt3hlEryoTmg950h5+GXEo4QA6S4+/BkYpuGRAAcdo3XJLhGirpRn0
	 kcc5E6giAGA8+tQ92KLN+c+2UlyMsLqzrWiyvU86ryYhsnhk2PPTECGOh9ixdrj+jXKDHpDjE+K+
	 inYt+QwvaivvapQ7IJZqhTH/y78sr4LgdOG46momoPRp1itSRn9XrH4dm6Bs/eA3h0YGh0mIY43f
	 t9UTiFHQgxj1N5+8IwyakcKs/uni6tP7yKuc4INh5FDCEeCt0t/dQn8kXVYaxPikpzBByVI0ultW
	 Timl+Cs0fzCcUDMdnRr3xV6zpbstBbbJwxWNq/gh9kWSnpnxNia97OnfKvM9kLpJ6j6Mb+4skuvw
	 sU588Kqvt6ZKQFWPAcYwnQnWAMdrI9T+yRq3CTkVp+G46MmofklTdCSCRsQksSxRTjUPrdwXbZMe
	 hSU03tMG2YRb31LmDH6YTsmXGC8J/OQ1Fpmi7901chlRlpTF9/t7Dwrah3lq2uLQBPQ6gFjmxhZZ
	 pM7V5UGKAhisGeJCh/dlFB/Me4b5oR+Y9tq6Yi3n0MPaZIpkHiTLyO+EMCObgG2mHHrEtRSDVLW0
	 jXrzQYk2S4u0ng9I7Zb+sh/mDuaBLLbK5F/5O31GbnqjVEWQuB5iysuVfrnc1qTp0kmLnEdOsiVn
	 m/RqZK+/kxxwJ4CcaPdHhL9a2Uv2lNLV31GuI3IURGGBE81KHPEyesY3XRlak00L5Qme+iG44wSv
	 U0z4U5QP0y6Z19EJ61Zd0q7XUMMC3aQryFFLOgIN1Ery+xjhf52Vx6UrNCKQ==
X-QQ-XMRINFO: Mp0Kj//9VHAxzExpfF+O8yhSrljjwrznVg==
From: Guanghui Yang <3497809730@qq.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com,
	dsterba@suse.com,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Guanghui Yang <3497809730@qq.com>
Subject: [PATCH v3 1/3] btrfs: detach failed sprout device from transaction update list
Date: Mon, 10 Aug 2026 20:16:04 +0800
X-OQ-MSGID: <52afe633e485d69ec377bb161da65427f369ac84.1786363229.git.3497809730@qq.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1786363229.git.3497809730@qq.com>
References: <cover.1786363229.git.3497809730@qq.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When creating the first metadata chunk for a sprout filesystem, create_chunk() adds the new device to the transaction dev_update_list through device->post_commit_list.

If the subsequent system chunk creation fails, btrfs_init_new_device() aborts the transaction and releases the device while post_commit_list is still linked. This triggers a warning in btrfs_free_device() and leaves the transaction list referencing freed memory.

Detach the device while holding chunk_mutex before releasing it.

Fixes: bbbf7243d62d ("btrfs: combine device update operations during transaction commit")

Cc: stable@vger.kernel.org
Signed-off-by: Guanghui Yang <3497809730@qq.com>
---
 fs/btrfs/volumes.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 3f8afbd1e..ffd076e87 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2988,6 +2988,8 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	btrfs_sysfs_remove_device(device);
 	mutex_lock(&fs_info->fs_devices->device_list_mutex);
 	mutex_lock(&fs_info->chunk_mutex);
+	if (!list_empty(&device->post_commit_list))
+		list_del_init(&device->post_commit_list);
 	list_del_rcu(&device->dev_list);
 	list_del(&device->dev_alloc_list);
 	fs_info->fs_devices->num_devices--;
-- 
2.53.0

