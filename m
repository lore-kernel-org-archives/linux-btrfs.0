Received: from out162-62-57-64.mail.qq.com (out162-62-57-64.mail.qq.com [162.62.57.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1597938D;
	Mon, 10 Aug 2026 12:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.64
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786364282; cv=none; b=h3VvrOfIdKSJivr/zRYGK4v/FMie+e5drwBLbSP40i3KCkkiez91pmgbHcZ9PWcbN906Dvhkrjt6cdV5it3Mp+UlbZmBIzVzyLaqrK1/iaVVtZhRsG0Si+tFyo5cp/UgcG4playB0VUS22dzArcfRxiuJuu/cSMlQcLCvbnyEd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786364282; c=relaxed/simple;
	bh=jq8IG/kX/0qiMRmU3pXV6T9osKpeL2QWQ8PhkyyT3ZU=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=XHhzrd6Ar7wxMygAk9UJYB3DBpwlvFszGPim9J335NnDP+v6Fkt8qIyppKm6g5Wddg+rXUozspBhJ8D2+qRBILRCjREAjz0GCxwLRMHNTIVEPBpwYHdhP4hT+pZ3FqO9ovcA93Ds32pLJGh0k0tY/VPVG0zbK8f+P7zxDK2g0nU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=az3ihARm; arc=none smtp.client-ip=162.62.57.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="az3ihARm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1786364269; bh=H1f8WzOZadw6epSITVVA3XcQ1v3joYwcYQuF11rR/nA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=az3ihARmMIco/I+skHouV1Imd34JD32hoG/UeDh4DWz5dFiv4xgD+1t6LVaoMGBXT
	 XzXYlnkqQ/+7FvrascM6k5oy53+W4QZTb51pDxauEJkAvZWuQGP1MEQHGKCjPU+UDI
	 Bb8cw1vrw+C5xvonAmgMnFNC3hi61bCu1+XPgspQ=
Received: from ikun-VMware-Virtual-Platform.localdomain ([2409:8a20:b30:4fb4:bdd2:8b42:d496:7e16])
	by newxmesmtplogicsvrsza53-0.qq.com (NewEsmtp) with SMTP
	id 41134061; Mon, 10 Aug 2026 20:16:17 +0800
X-QQ-mid: xmsmtpt1786364193tolvez68p
Message-ID: <tencent_27152D4F8FE2B1274FC8BADB1B84644C0506@qq.com>
X-QQ-XMAILINFO: NGZp1yYNf7Y+70bg0OMg3rnSgqRmBFbeJobteN+9Y+s5sPWu4rRlCnOFbExJHk
	 62ntm03Z2pP6rwXpwY/T1S7wwDYKpOYh2Dinjq4Vmm74EeUEtrWkbhUK8ZvFRDkVnGfj6l+AH6Dj
	 FRiZ0r4h2w4gkyUHGMiue9ScoB0Ip9pkGnEPR9xgDWH8tysCTRiVdmUgBTNMPoXC1JH98sG9XJOX
	 SnXQN7du2XxUbfST6r+yWIa6ydo0UcS1OGB3gWn2QJprwoNEHiF3xG3Top991q5l8OuB66csv5lP
	 Is2Ee+TX+fc9juTvdSkzGCFkBFW3i8mwl1CY8kZ+EaZJdWM5aDl9SI0vTityXlyvXAT4Z+Yp9+eM
	 4y2VYBeDKL9Bbp+wsx9zbKvmTU8YiDC+ztfGGPsdd8YuIWC+Xmvby7LZxulE8Nsd2ZVrw1Maa6+i
	 OHHiK3T6clPynpGds4Ybao/MK6yrKDxWlFsyQ+qcKhaMD5hioAc+CzFCtcKEFPNA+WcbS0zWHaXe
	 yP6VcRXP1iAflDIe4DtDEMbREtkLxnvSAUFu1UYwnnReI17ulyPgEmQiFLF6cWeqmyyEpvpMGvs8
	 tLakC88gnvazgjhhXsqxbBSXRlzg6y7NQ2SA2ctaa2N50MJnz4KYbFf+7zvTfDFqVhw0UbDoDWp8
	 Zs6HDjxHsbKGcHRir9K53rQt6aKaoGW+taEsAUkmCsfRpVIR0O32pR9/cDUtTG/tDH0aYmJhzgaV
	 jZAmq6/TLYAqtzZlBTVRakL8a6rYd0gSyycJSmaXotGo3vlBRlVJD+/jMPOSlu6cGdCFGlPdWrKs
	 NdCynr4ku+je65rIcIhPGMYlor5tZ6EWC5OxUZLUxw/2+59JfLbKe1t3jkJxOYSdQz5KK8evAakq
	 p0M/z4IExew0TKrQd/j+jQTubMCHV1oKG4PozLz6ww0Vg8J+atAQQcxIqcVuMqBXAlz7BPiGofZx
	 0MAq28xUtq9qIdZPUJJq+fBreG6FL7G4zoBONbXMgP0sAGRdiRkbD3rPAHlRvpdqX9WQiYCRbayv
	 S49Jg4FZ0m3SEbqUcWR/iW6A98g3mNwubjgDwWunhGfg3TAJvvhPFtRe+LRHahAXNiOGVomuEa46
	 CdZ0l57oekFbCvIossCmECObu/xCCktsQC0H4uHLS4wXGZmo0qFRePXFLb4cDepqj6jTq9idnQ/a
	 xwgTZOWm4DWMvedA==
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
From: Guanghui Yang <3497809730@qq.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com,
	dsterba@suse.com,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Guanghui Yang <3497809730@qq.com>
Subject: [PATCH v3 2/3] btrfs: restore active device pointers after failed sprout
Date: Mon, 10 Aug 2026 20:16:05 +0800
X-OQ-MSGID: <62f930b3a904a7ca4be2c87cea3727f226f5e6cb.1786363229.git.3497809730@qq.com>
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

btrfs_init_new_device() switches latest_dev and possibly s_bdev from the seed device to the new sprout device before creating the first writable chunks.

If chunk creation or the subsequent sprout setup fails, the error path releases the new device without switching those pointers back. btrfs_show_devname() can then dereference the freed latest_dev and crash.

Restore the active device pointers to the latest seed device before removing and releasing the failed sprout device.

Fixes: b7cb29e666fe ("btrfs: update latest_dev when we create a sprout device")

Cc: stable@vger.kernel.org
Signed-off-by: Guanghui Yang <3497809730@qq.com>
---
 fs/btrfs/volumes.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index ffd076e87..f3f77c89c 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2987,6 +2987,9 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 error_sysfs:
 	btrfs_sysfs_remove_device(device);
 	mutex_lock(&fs_info->fs_devices->device_list_mutex);
+	if (seeding_dev)
+		btrfs_assign_next_active_device(device,
+						seed_devices->latest_dev);
 	mutex_lock(&fs_info->chunk_mutex);
 	if (!list_empty(&device->post_commit_list))
 		list_del_init(&device->post_commit_list);
-- 
2.53.0

