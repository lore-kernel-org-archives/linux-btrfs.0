Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF5134E744
	for <linux-btrfs@vger.kernel.org>; Tue,  9 Jun 2026 15:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781018424; cv=none; b=jOZcUEhAnEG4yLpNHadTu5O2ZKqpyIJOzxjyQln6scqfMCcWQkXbvMgl6r5r+KXAcHszAxqd0aVrGws0xZ94hqXVKN1gB6aS5rgzt2hK05DWmrNC8AGax+1GILosH2qc5AXEIQbAofO09yZxOkkMB8L/uzkI7o52zdYTbQSEUKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781018424; c=relaxed/simple;
	bh=bbaQwjH0ueWOvUp7vofVLG7zdPNe2fEterp4IvclDcE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PaBb97WGTEhlpQMpkLISp7HU0YfMK9oyqsRF2vinDKzMc4MmsmgO6zwNypLS6Q1QnH1mtH9jxJtaCFsQn6Kiv2Zg063Jip0slktW2hzWmKB79dGSpA9nduiX4iXHXuCr62RiwKIdTbU9zkPGiTJRIgwokzWVoIUk1lXVnDUTLtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AV1Kd5VN; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AV1Kd5VN"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2c0bd02d97eso64026245ad.2
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Jun 2026 08:20:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781018423; x=1781623223; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7ep25mQRShZvtAoE+zhCOcr3eqQcangziKu+EpncKHU=;
        b=AV1Kd5VN4T3f0XIJz4R26bsRsQkt8wNBiBeuH5GOWPKIaBbs6AJvAoNRGCDCMgYF6L
         gb5MK7GbWVi3PkRD1cIBEkLRKjRRFLyebq0k0My13ES9bHuUJNQvd0vxiaRIxOlJs/y7
         CxSvBZZmVR9NxfRwTB6Tm0Y5A9B2o+hLDXinRE2R2CGxl7rHNN66Yzlbbof4RR+jMsET
         jpWal0YHdi4C7O+Hgr27/jQ5S1nILxgZAf3uRUhupoIZVvic243sMfxHQgsbtINJEliY
         +gk6f6G26fc19ng1k4wgIMaDxRmyN7/4tXjeSfxR2Kb8OEz7//HSTi/0sKCu3NM3xSMH
         SJdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781018423; x=1781623223;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7ep25mQRShZvtAoE+zhCOcr3eqQcangziKu+EpncKHU=;
        b=JxRFpKatA3Rib3FJx2i0knZBIR1UiIwUkLtFEydASCC0qaRPkaBFG9zbRXF6lft7ny
         +dxCypc5YOcapqI4WIuwSnQq53DhbmGLOdyonlf2SSS6aqtF9Ne0WCbqZLjc0dKzczbS
         VQDcXKZCE/W7IqPmDpoQVy7KbqTMidnm7CpwOfYWfAzq/7U63eImndcBlQ5IRxU6Xex0
         YbVz9k3wx3TPV6JQGlspmYCNkcpQGlZZNtztbdXabzU5m4IkTb2iTap2jikJ2RaqjcFq
         dwEI3GPzwPGJuFb7BgvA45axcsZY0PrlQqEM/xFriaEGJJTPGum5gu5Hledw3MVkClk7
         NeGg==
X-Forwarded-Encrypted: i=1; AFNElJ9CX/vhNaieryC5D0Tu64bVIvUv9GF58zLwzsZE9mnHqeEPlXFR4IgMzZeq1Oh6tkllXypPvIBPx9wn4g==@vger.kernel.org
X-Gm-Message-State: AOJu0YztVdIPcIf2xKHktL4wnoQFKNpZRFbdithZC2/cASkfO01V5xK4
	8IoQJPRPMlXs/dlsd02BXXbb5fkeCf0LIU13FLUw/HX7F5hlHJTU5fBf
X-Gm-Gg: Acq92OHWkK3POuIBIjBcHYq7zlxlL0Bz73Z6ru5QQFE7msRTS8WvNrP3IqS020OzXCa
	wjwp/sm5ak22U6WbytEcETIClmkGegAFDTMF5N9Qvs/+p1xgVPaGnBxmJSkVJ2MOu0wu53SbplH
	OUvZjfStLXYID0CQKwcT1js/PY3ZCrCZFNYb/iXTGseIhn0kJ9tCi03tR/W7GZHDNAsIr8DNagZ
	/CTZGR1SLza2/cFUMfB4lLVdACdwPGaECn6T/i+xoCkUrIdg2AtjDERkJRwRevsVHamoSO6kn1h
	iZqWRKwjfolY1jtgqIdFSCjvVBjeZMMTAAy0odQtqtdv3MVq3W/wDcNTZrM4VBnZDQ/M0HNol3+
	YYa/w1VYJ3+EwO1dCSO6ggEbOy9dfjy78OO7AommoSjveIdsIg4utz1TjSvkKtOJU+Xem2l4diX
	amLyDL/xrG56laPWDyZH3bEyE+
X-Received: by 2002:a17:903:90c:b0:2c0:b7e1:7f08 with SMTP id d9443c01a7336-2c1e859fc13mr248649055ad.28.1781018423135;
        Tue, 09 Jun 2026 08:20:23 -0700 (PDT)
Received: from lgs.. ([152.32.133.247])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c16609e636sm218443755ad.51.2026.06.09.08.20.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 08:20:22 -0700 (PDT)
From: Guangshuo Li <lgs201920130244@gmail.com>
To: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Guangshuo Li <lgs201920130244@gmail.com>
Subject: [PATCH v2] btrfs: fix zoned sub_group leak on space_info sysfs failure
Date: Tue,  9 Jun 2026 23:20:15 +0800
Message-ID: <20260609152015.1586599-1-lgs201920130244@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On zoned filesystems, create_space_info() creates space_info sub_groups
for the primary DATA and METADATA space infos.

Before this change, the sub_group was created before registering the
parent space_info in sysfs. If the sub_group registration succeeded but
the parent btrfs_sysfs_add_space_info_type() call failed, the parent
space_info was released through its kobject release path while the
already published sub_group was left behind. The sub_group also kept its
logical parent pointer, which then pointed at freed memory.

Fix this by making btrfs_sysfs_remove_space_info() responsible for
removing any sub_groups before removing the space_info itself. Then
register the parent space_info before creating zoned sub_groups. With
that order, a parent registration failure has no sub_groups to unwind;
if sub_group creation fails, btrfs_sysfs_remove_space_info() can tear
down the parent and any sub_groups created so far.

This also keeps check_removing_space_info() as a pure checker by moving
sub_group removal into the common sysfs removal helper.

Fixes: f92ee31e031c7 ("btrfs: introduce btrfs_space_info sub-group")
Suggested-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
v2:
  - Make btrfs_sysfs_remove_space_info() remove sub_groups before removing
    the space_info itself, as suggested by Naohiro.
  - Register the parent space_info before creating zoned sub_groups in
    create_space_info().
  - Use btrfs_sysfs_remove_space_info() to unwind the parent when sub_group
    creation fails.
  - Remove sub_group removal from check_removing_space_info(), keeping it as
    a pure checker.
  - Use ARRAY_SIZE(space_info->sub_group) instead of
    BTRFS_SPACE_INFO_SUB_GROUP_MAX.

 fs/btrfs/block-group.c |  5 +----
 fs/btrfs/space-info.c  | 14 +++++++-------
 fs/btrfs/sysfs.c       | 16 ++++++++++++++++
 3 files changed, 24 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index b611c64119db..ad8e0a27101a 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -4615,11 +4615,8 @@ static void check_removing_space_info(struct btrfs_space_info *space_info)
 	if (space_info->subgroup_id == BTRFS_SUB_GROUP_PRIMARY) {
 		/* This is a top space_info, proceed with its children first. */
 		for (int i = 0; i < BTRFS_SPACE_INFO_SUB_GROUP_MAX; i++) {
-			if (space_info->sub_group[i]) {
+			if (space_info->sub_group[i])
 				check_removing_space_info(space_info->sub_group[i]);
-				btrfs_sysfs_remove_space_info(space_info->sub_group[i]);
-				space_info->sub_group[i] = NULL;
-			}
 		}
 	}
 
diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index f0436eea1544..42179d89e52b 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -304,6 +304,10 @@ static int create_space_info(struct btrfs_fs_info *info, u64 flags)
 
 	init_space_info(info, space_info, flags);
 
+	ret = btrfs_sysfs_add_space_info_type(space_info);
+	if (ret)
+		return ret;
+
 	if (btrfs_is_zoned(info)) {
 		if (flags & BTRFS_BLOCK_GROUP_DATA)
 			ret = create_space_info_sub_group(space_info, flags,
@@ -315,21 +319,17 @@ static int create_space_info(struct btrfs_fs_info *info, u64 flags)
 							  0);
 
 		if (ret)
-			goto out_free;
+			goto out_remove;
 	}
 
-	ret = btrfs_sysfs_add_space_info_type(space_info);
-	if (ret)
-		return ret;
-
 	list_add(&space_info->list, &info->space_info);
 	if (flags & BTRFS_BLOCK_GROUP_DATA)
 		info->data_sinfo = space_info;
 
 	return ret;
 
-out_free:
-	kfree(space_info);
+out_remove:
+	btrfs_sysfs_remove_space_info(space_info);
 	return ret;
 }
 
diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 0d14570c8bc2..ce1109e47cc7 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -1885,6 +1885,22 @@ void btrfs_sysfs_remove_space_info(struct btrfs_space_info *space_info)
 {
 	int i;
 
+	for (i = 0; i < ARRAY_SIZE(space_info->sub_group); i++) {
+		struct btrfs_space_info *sub_group;
+
+		sub_group = space_info->sub_group[i];
+		if (!sub_group)
+			continue;
+
+		/*
+		 * Remove sub-groups before removing their parent space_info.
+		 * Clear the pointer first so recursive removal cannot leave a
+		 * stale child pointer behind.
+		 */
+		space_info->sub_group[i] = NULL;
+		btrfs_sysfs_remove_space_info(sub_group);
+	}
+
 	for (i = 0; i < BTRFS_NR_RAID_TYPES; i++) {
 		struct kobject *kobj;
 
-- 
2.43.0

