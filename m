Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D14B138B158
	for <linux-btrfs@vger.kernel.org>; Wed,  7 Oct 2026 16:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791389040; cv=none; b=X5wwW9V77YiOjn8pKHcpej77XAdrYUtlYhwbWt6AgEYtxCmG1f9+90I7bhAHmOtC5HF2e7QITaccKvEnf/E/L//W2Hy9Sd9FnGWwKY4hUMeYgoPsZZjc9Tewk8IRlJQAdN6vkHqv+aeALBSkpO4dQPwisSoMfNnlkABsgOau4a0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791389040; c=relaxed/simple;
	bh=nYKBNXbASZM91FNGwDQtCQ6idrk4/AMl4BBgb6Mk4FM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jeW20Me3X9sLkHJrotRDaiybxrmOE7Rpo5ojsdAiAdTy5X+XQQYn/xZWR2jSQAM0rJEqvG8D2MtYEpsBTHC94YJTSP0h5iaD2x3udS9yWQ1T4reC3feq4EaJ8DvKnFO+/FXYBjjM/ARsH5k4gtRHD6b+UXcWdJle1X+NtJLDr+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D0lgEnkJ; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D0lgEnkJ"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3964dfb5b9aso2198825a91.1
        for <linux-btrfs@vger.kernel.org>; Wed, 07 Oct 2026 09:03:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791389038; x=1791993838; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tEp2cJm5A66MilSFbf82vwQxlK5XKvvApSBvw85ugEw=;
        b=D0lgEnkJPaAPCT41uli+LCV6GvThfBKsk5mZIwOMXiHEQsbJRDWrb0qRyle27UexfO
         pkBpmAnXsD0KZ25kUpL6KnGyG9oShJ8wXGQZlNLl8qBXaQp4UXhnFBCWpza2aFXMnDRX
         oLDAQCKlytFJdzZgRUSyll0dK7rTQdrpuxQC2NlYdpnXWOKA1YM3GHxJBqmHk4qKsry6
         cx1PDxqIEPO+GHwEvgS4G0CgYiPbP4GuVbrHcz5uP3X2DI4cWr2cetzU5IKtiWSDnW1W
         1gDaIP+06j4EqTKeru3cbbDKLVZMxgpsVY1QdD+YS22PAt5/EeWwztMoinSPX6Xj92J2
         /JSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791389038; x=1791993838;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=tEp2cJm5A66MilSFbf82vwQxlK5XKvvApSBvw85ugEw=;
        b=oEotq4Sr3TLvYUXQCdEorlN5HPRj2CeJf3UCMEK/DHfAnN/0qTr/Z4rQz816vQQ9fa
         Sr8FN/vVukxUgVjOBQTTIVV+fd12qzyOsveXklL2tWF6vsxrLsP6baPLEYX7Vi5ScJN7
         SlJ9i2jui4qylMU74D+ZXu14U7+AkXuJYP/XQqetEruI8p02ydJKi/9/QaR4ExrgOPr1
         I6B7+7dN7myFVeTDp1VuGajgvesIi7xPG+43PXYlj+9N3i3CEwS5kNcyiwjkS/+m97iZ
         bzryxU1WiCMgDOn9oM7F51HE9sUbfQWy2n1/QiZihdEbcBkngLU8xUP3sQzIifcloGp+
         +VmQ==
X-Forwarded-Encrypted: i=1; AKwUvBymXm+KLD6y0HRTcg2F6iu+kVzDHzKPiuydVLZdb7GLNyQ4LQhb80uY0EySTV8XQb1oro3jnsQyqd2xjQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYI3NWPvvaOz2QFc6XXmm853pbqCfdOt45roeGruC67c3vljYQ+Y
	HcxfPXmMkcrMfsZ+L7PeIsMZLDgGdabhMEaG5wPUnbObjFRnt45CHRhm
X-Gm-Gg: AYBFou3fd2MMI+6q89NxyBhirBsFn1Ob7tTCdXMQVnreXGG3Vr5HSIPRpfCmjEJP9rG
	jHkpecXJo7mMxI1otyNofaxfVsmt0G5YYxJ7NV/W1IWHSoD90CIxKdq3oMwEcvNJmN5V22SWJyR
	T3rgmOIf9EixWXbK7nwRm+iZQHoN68W1XmnsP5Slmw6VXeGTkLBWwaNq5sdwsm3cIJcUhClFSb6
	pD/DZRpdQbXUBmhMMOjcSF7sTyeV758ygqtHmRrnjOy+8NTjlNg1ULJIB7UAfmKB3CJ39OTjJ1b
	LwXU/nmaL0Ac9tYOmlS9qcVSlozwDwJw42l0uvKA278qBvwLXY5ieCgSq6cDbC7ImQ8B9cfd3er
	W2aCgktxDmikGObzsseybdMFeaXVZPYn8qdZkpzBCHfcA5D+4VGT+MjXdcC45KxSCj303zX7I5c
	mJb01ZxUUZ5OeUmV3PDPcLuN4Nf0XA1jRt/iGL1/zRuN0TZuDw3wJWWP7nPYDg+e2r0nJ9duII
X-Received: by 2002:a17:90b:2683:b0:3a0:a055:1759 with SMTP id 98e67ed59e1d1-3a8a0f341d7mr2589050a91.40.1791389038153;
        Wed, 07 Oct 2026 09:03:58 -0700 (PDT)
Received: from archlinux ([103.208.68.128])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a9ff7aaf8asm57354a91.6.2026.10.07.09.03.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2026 09:03:57 -0700 (PDT)
From: Adarsh Das <adarshdas950@gmail.com>
To: johannes.thumshirn@wdc.com
Cc: adarshdas950@gmail.com,
	dsterba@suse.com,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mason@kernel.org,
	syzbot+3bf3e110b2d406b8166c@syzkaller.appspotmail.com
Subject: [PATCH v2] btrfs: unwind device add when sysfs registration fails
Date: Wed,  7 Oct 2026 21:33:49 +0530
Message-ID: <20261007160349.22411-1-adarshdas950@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <eb63c9f9-a158-4a70-b3ed-30046b15de11@wdc.com>
References: <eb63c9f9-a158-4a70-b3ed-30046b15de11@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

btrfs_init_new_device() ignored the return value of
btrfs_sysfs_add_device(). When sysfs link creation failed (e.g. -EEXIST),
the add path continued, aborted the transaction with the same errno, and
tripped WARN_ON(btrfs_abort_should_print_stack()) while leaving the device
half-registered in memory.

Check the return value and unwind when registration fails, without
aborting the filesystem for errnos like -EEXIST. If add failed before
anything was published in sysfs, tear down the in-memory device state only
and do not call btrfs_sysfs_remove_device(). When the block-device link
was created but devid kobject registration fails, drop the link inside
btrfs_sysfs_add_device() before returning the error.

Reported-by: syzbot+3bf3e110b2d406b8166c@syzkaller.appspotmail.com
Link: https://lore.kernel.org/all/6a791c94.01d0871a.3a0d52.0099.GAE@google.com
Tested-by: syzbot+3bf3e110b2d406b8166c@syzkaller.appspotmail.com
Assisted-by: LLM
Signed-off-by: Adarsh Das <adarshdas950@gmail.com>
---
v2:
 - Unwind without sysfs remove when add failed (review on v1)
 - Roll back block-device link if devid kobject add fails
v1: https://lore.kernel.org/all/20261003111951.24527-1-adarshdas950@gmail.com/
---
 fs/btrfs/sysfs.c   | 3 +++
 fs/btrfs/volumes.c | 7 ++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 39cb01ee441a..2f034689e71b 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -2165,6 +2165,9 @@ int btrfs_sysfs_add_device(struct btrfs_device *device)
 	ret = kobject_init_and_add(&device->devid_kobj, &devid_ktype,
 				   devinfo_kobj, "%llu", device->devid);
 	if (ret) {
+		if (device->bdev)
+			sysfs_remove_link(devices_kobj,
+					  bdev_kobj(device->bdev)->name);
 		kobject_put(&device->devid_kobj);
 		btrfs_warn(device->fs_info,
 			   "devinfo init for devid %llu failed: %d",
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 85ea9c5d4536..56b38f012093 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3066,7 +3066,11 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	mutex_unlock(&fs_info->chunk_mutex);
 
 	/* Add sysfs device entry */
-	btrfs_sysfs_add_device(device);
+	ret = btrfs_sysfs_add_device(device);
+	if (ret) {
+		mutex_unlock(&fs_devices->device_list_mutex);
+		goto error_unwind_device;
+	}
 
 	mutex_unlock(&fs_devices->device_list_mutex);
 
@@ -3147,6 +3151,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 
 error_sysfs:
 	btrfs_sysfs_remove_device(device);
+error_unwind_device:
 	mutex_lock(&fs_info->fs_devices->device_list_mutex);
 	if (seeding_dev)
 		btrfs_assign_next_active_device(device, seed_devices->latest_dev);
