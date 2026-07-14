Received: from out203-205-221-245.mail.qq.com (out203-205-221-245.mail.qq.com [203.205.221.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A55381B16;
	Tue, 14 Jul 2026 06:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784009477; cv=none; b=Ko1wEJeWkr0NTyIs4BqseObPtSz+VPr05V4rHlCO5BIz7GamOe6TR3HhM3/3ihxt58isJLYK1+XNjVrQVyRy3kOdQ7r27yN3fg6l2kraDim01DShPTYSvhvHA7aQUiyKWd2ScReB10dAzMuOxZhKKO/Y7PLtIpb+K9nE8LJHZJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784009477; c=relaxed/simple;
	bh=mVRFRY1ZOL05gzsc9tM6KQPKomFyphRVBVTLooxnfKg=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=kiUzNoiwqRkBsUPLBsY8Z4ZAUbY+eTYiwMv/pemfXeuRYxLV3QbJWckqb/IYbD2iVQE8BR14T9VJW2RT+w2JHeXEuO5oKmsWFtZEke41RQ86qyADGF6wdb+W7sGbUN+E0bQ1qZ7tQFwUWCxZOwHn+fM6MvCR7D9O+9QeogaqWc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=VGri0MBE; arc=none smtp.client-ip=203.205.221.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="VGri0MBE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1784009470; bh=C9yAQzDVpBq9fDc6pqK6Iog2dyP2iu0tMpj0kEPnMIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VGri0MBEvR+RHyQ+8S2IMTDpja9934Q4ipjU/pgY5fLwKCWpgdimamZmvAnMJ4Ugm
	 Hwc1ygKJByGHLubG2gD8lZNT1drS0YmCRrDYcbnN+/ibPo+5iKrqG/wSTL9pWsyGUQ
	 rPrIaQXR9T9RirpbvuUdJcq2Cujz4oyE4yCpA0NQ=
Received: from ikun ([221.176.157.250])
	by newxmesmtplogicsvrsza53-0.qq.com (NewEsmtp) with SMTP
	id 2C6982AA; Tue, 14 Jul 2026 14:11:06 +0800
X-QQ-mid: xmsmtpt1784009469t66m6fm5q
Message-ID: <tencent_AA3028EA782A8414BAC141E8C40C52FDF30A@qq.com>
X-QQ-XMAILINFO: MRBm8gEMwvbCDj2F471CsLgWio762pOp4IdBc+oJ0kbkTab9q90CAjycatMKMi
	 4njCHDhIkpbJZfXI7Gelwyyh+AmVHQlPcfgYOBUJqwYGqaJjHXzx342bxspRUNK3eeoQnnERiWLQ
	 XoGFQyCfATmMR342adY4YNwKDdpy/FJ2Yh+RhQVQ1BaDuiSPsqe+Z9o8BMM7TYe2hzg4l68cdW3P
	 ouacGjuLSwh7rGn2WV5Y9u18G/WuiLFp5umLZik4tZtiHlahM+MfolmELYZ0rYYedTeyqBzaDtRt
	 tkXp9x+AvOpr0njAwOa1Jk/tes6IDFnhwCrBGWvDHeWNrAT3yTwodV2s59FrAVxo1lZQTH6clrhI
	 XhEYYBYH068wCT41/yGENvgb4kzLIleIh8sbOjdHxcESjZ2CJEio5oqgxdxVkPKexqDk7X3FmM+v
	 g46ZuqA+J762JkrWEMf/nfra+8BfGHVhWGzzB4i35FgyoBYRVR85KS2HRfTdf16wLD+mBXD/5quJ
	 FJDc7Q52uuvZfSnistytl0bvrW8+gPIUA13aHcFlHQEnDkaDjCilTuCawvmBEq4ffPZwxCeKHien
	 8ASxu0hi9aLlezbjtKtnlgWnjZ+ydiaXczUjgHDkhFI3hXnVyNcU1Y11b9i8cDcH7zIr3RPRCL7x
	 1pY6nYJR22pHrVyvffP2j13PDS8L5uV49HgVc0GESMdT5jnoVVF17LoFWtbeJ8gHFHTkIANoQ4kz
	 mGK2ypE3Nqfre7atdJrqW3IWFKlRuktZ1/S/jlFwQN0IZOeX6pJUwmIevK147qfYhzHGYlxZ2dSX
	 fiSR9mMCVJFRTbey7iHNMxPv9DdJy4+CGMt+hR5+XYY2+ON2GPZED9ne42myZOBcA4jGKNBS4DqK
	 74bBKcxgp3W22El4oYsVeMtTPCjhA7RZn44jMXLfm5Dgh2Quq1sU8kf4HFBoQbhQZl8opm+ZWc3e
	 9/ha5BMA7yu7RNYd1V9bpLuBWtaKM+n0Qfbt19JaCbQuBJXf+qS51tqxS9cXt4Ozblyz2dD8gasZ
	 z4BJnpcv7iRAhmryCBtlTr2g+biqgvdcr9RC0TvrjUHjoZjIIY
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
From: Guanghui Yang <3497809730@qq.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com,
	dsterba@suse.com,
	linux-kernel@vger.kernel.org,
	Guanghui Yang <3497809730@qq.com>,
	stable@vger.kernel.org
Subject: [PATCH 1/3] btrfs: detach failed sprout device from transaction update list
Date: Tue, 14 Jul 2026 14:10:35 +0800
X-OQ-MSGID: <20260714061037.1014-2-3497809730@qq.com>
X-Mailer: git-send-email 2.52.0.windows.1
In-Reply-To: <20260714061037.1014-1-3497809730@qq.com>
References: <20260714061037.1014-1-3497809730@qq.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When creating the first metadata chunk for a sprout filesystem,
create_chunk() adds the new device to the transaction's dev_update_list
through device->post_commit_list.

If the subsequent system chunk creation fails, btrfs_init_new_device()
aborts the transaction and releases the device while post_commit_list is
still linked. This triggers a warning in btrfs_free_device() and leaves
the transaction list referencing freed memory.

Detach the device while holding chunk_mutex before releasing it.

Fixes: bbbf7243d62d ("btrfs: combine device update operations during transaction commit")
Cc: stable@vger.kernel.org
Signed-off-by: Guanghui Yang <3497809730@qq.com>
---
 fs/btrfs/volumes.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 6eab4cc73ce4..556d8a60a5ec 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3071,6 +3071,8 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	btrfs_sysfs_remove_device(device);
 	mutex_lock(&fs_info->fs_devices->device_list_mutex);
 	mutex_lock(&fs_info->chunk_mutex);
+	if (!list_empty(&device->post_commit_list))
+		list_del_init(&device->post_commit_list);
 	list_del_rcu(&device->dev_list);
 	list_del(&device->dev_alloc_list);
 	fs_info->fs_devices->num_devices--;
-- 
2.52.0.windows.1

