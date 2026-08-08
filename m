Received: from out162-62-57-49.mail.qq.com (out162-62-57-49.mail.qq.com [162.62.57.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B2E32DEA75;
	Sat,  8 Aug 2026 06:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786169738; cv=none; b=jDJJvugnE2dDBJ++VqUgSXrC8hZVjaLFMAecVwXgQJAU1CYot9WRtHb1mT5Wyn5jaRW6vGY5+6YrltCuNQEDaxaWdSCSLshhmiY7BGfC/Tx1B+3loRidulZr3iKTjlFENz5cPeXUuHtGIrI0hPJwefvVSr08oT1CatH1BdPpMo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786169738; c=relaxed/simple;
	bh=IoIeFcb3tkuSUHt69yo8gXBhH0C8J/+e8I5rArD5MvM=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=nn3QbM+agkPr8G32TNVb9O8lPmjM2SgBfV5qfcvBNL1zF7/e7FwVDKSbiab12UP58tPCghsKzWhh7U7ycKbJgPPQa+v43FJIkCw8jJto1gsZi1M22qbdwd1FzZaq30WwY4hcmSnM9UNv81BNYggCwP4y7YAOH3qITsDGb3Zwph8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=LOs5zY8D; arc=none smtp.client-ip=162.62.57.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="LOs5zY8D"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1786169725; bh=lZ8fcG42eEQAjlr3OoFl2oJ6QvXvd4lBugctgOvo8zs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LOs5zY8DOx14dCaB3DvJvGk9+p/jzzfFtneQkrABDzSQ2cuF5FjLZmzsrAKlUcilj
	 myHTHqp991JcNo0oqUj0PREL4Ztk7JTyFxwz+eqRhbZT0y8D20DUtCo2a0JB0Ny5XY
	 NKy8Pg1ZiYHaPp7sSiyjkC674smJYgy1B2+d1S5s=
Received: from ikun-VMware-Virtual-Platform.localdomain ([2409:8a20:b30:4824:bd7c:c5a2:f149:1f65])
	by newxmesmtplogicsvrszc50-0.qq.com (NewEsmtp) with SMTP
	id 37B1C829; Sat, 08 Aug 2026 14:13:59 +0800
X-QQ-mid: xmsmtpt1786169639te50a4h0i
Message-ID: <tencent_7C7BBA87F8B9F1419CC7B05319F15C28FA0A@qq.com>
X-QQ-XMAILINFO: Ns+25EuXnYmw7iZAenUeeAzP427D6ddbsNzKNag9TjpBsoGO0Vf6shmsZfgjXK
	 WOlB9iokqgpgUvKon8ZJU493pSZLPGLIIxZjAdU1EyrvZc9gl3kuSN/1Hfy3NLWdNzZY/jXkKTFJ
	 TrmzqkoZPSGPz4JQX6MwzVuXlP74vPeKD+7RhKWH10KTrgqhrGGQIKmlnAIJ+rnSp7baPYMbZX7o
	 K7tUYLQyahLChmLGadCpIH/0p5mjXcYrHofocN/+qA3wQS9snx1ECkUmbCU4IxE+pCs6ISELAS0u
	 yQfUG62YHFxVlDtkz/4U7RSxqi04/xDtdeoiJENSXlSDjlrNl8lbfH8IXItliab2RuTW6tZtH2IB
	 Zk1mm3dlldUxjUoL/3kjEd4vcgNehNKUPiqPyB/dDURJVBAvCcJwVyn5rggt45g5rqFv4opZH9Km
	 46075R/ddOg5WohJLYyeCyiKrueI7+G+ifRD5CF5ej0QNP4JaO7uD1KjPORyoFsEPgjM4giyEAZJ
	 NbrvwyMARtjAAViGi1zHYdutSYfCTEjD4jAoEijgCicUnPTHMqBLNryc5+lrNitm62AiW3eGj1VW
	 VHQnMW1XDzQvE06VCyaA54+RP4d2awieCNQ3LIVSYB9mwa3j248v1+LfmNQvpUXn6V395qoQ5IxX
	 ko0TS8DDAcA+2UjwL/XC/+hIik0uJ9+8RC5w0pUl6IdXnxSQX0ddzjnPJRwjCWAwI/2naFGDoa35
	 4yZ1uHma/8unRFx8jCTxzJQTUzH3fjW9eUDDfwV97Yd3CO7r/kAxlNGIMTbAfxd6gIcdHYp88Vl7
	 F7xNmsuRcS5S0ycstl23pltCc57ymZ2DgMb6+i++hPxLFDfEky9Om2JqRH/hibq+TkSoNKAVSebI
	 B4i7sgywWrMhYLCloXQpursRCETY5KMdbIURzVdkJcVLlPaG3+5sBX3YTmNBOP9zRv+iRmg0dbUv
	 sgEeNT1u+4H2pB45bBTOIT/WTLBrLS1WTcTECrc0Hpc9kFrmQg3SINfklulWZkR+C7FFsCIB9/jn
	 RcUUTry5YLkYbyG33nUX7X2awUkymnBJqY7Yf0D6W6p5xZAOfn0dBU0UgO1g8=
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
From: Guanghui Yang <3497809730@qq.com>
To: Qu Wenruo <wqu@suse.com>
Cc: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Guanghui Yang <3497809730@qq.com>
Subject: [PATCH v2] btrfs: free unlinked replace target on initialization failure
Date: Sat,  8 Aug 2026 14:13:55 +0800
X-OQ-MSGID: <20260808061355.146153-1-3497809730@qq.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <47a4dbfb-906c-440c-999c-d6dba7981232@suse.com>
References: <47a4dbfb-906c-440c-999c-d6dba7981232@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

btrfs_init_dev_replace_tgtdev() allocates the replacement target
before looking up its dev_t and initializing its zoned device
information. If either lookup_bdev() or btrfs_get_dev_zone_info()
fails, the device has not been linked into fs_devices->devices yet,
but the error path only drops the block device file reference.

Free the allocated device on this error path to release its name,
allocation state, zone info, and the device itself.

The issue was found by a failure-path metadata residual analyzer and
verified with targeted failure injection on v6.14.

Assisted-by: Codex:gpt-5
Signed-off-by: Guanghui Yang <3497809730@qq.com>
---
 fs/btrfs/dev-replace.c | 10 +++++++---
 fs/btrfs/volumes.c     |  2 +-
 fs/btrfs/volumes.h     |  1 +
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 318ddb790..3762429b5 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -235,7 +235,8 @@ static int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 				  struct btrfs_device **device_out)
 {
 	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
-	struct btrfs_device *device;
+	struct btrfs_device *device = NULL;
+	struct btrfs_device *tmp_device;
 	struct file *bdev_file;
 	struct block_device *bdev;
 	u64 devid = BTRFS_DEV_REPLACE_DEVID;
@@ -264,8 +265,8 @@ static int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 
 	sync_blockdev(bdev);
 
-	list_for_each_entry(device, &fs_devices->devices, dev_list) {
-		if (device->bdev == bdev) {
+	list_for_each_entry(tmp_device, &fs_devices->devices, dev_list) {
+		if (tmp_device->bdev == bdev) {
 			btrfs_err(fs_info,
 				  "target device is in the filesystem!");
 			ret = -EEXIST;
@@ -285,6 +286,7 @@ static int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 	device = btrfs_alloc_device(NULL, &devid, NULL, device_path);
 	if (IS_ERR(device)) {
 		ret = PTR_ERR(device);
+		device = NULL;
 		goto error;
 	}
 
@@ -327,6 +329,8 @@ static int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 	return 0;
 
 error:
+	if (device)
+		btrfs_free_device(device);
 	bdev_fput(bdev_file);
 	return ret;
 }
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index a8e27db8e..c479f268a 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -402,7 +402,7 @@ static struct btrfs_fs_devices *alloc_fs_devices(const u8 *fsid)
 	return fs_devs;
 }
 
-static void btrfs_free_device(struct btrfs_device *device)
+void btrfs_free_device(struct btrfs_device *device)
 {
 	WARN_ON(!list_empty(&device->post_commit_list));
 	/*
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index eaf23c0dc..ecab3ce3c 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -795,6 +795,7 @@ int btrfs_run_dev_stats(struct btrfs_trans_handle *trans);
 void btrfs_rm_dev_replace_remove_srcdev(struct btrfs_device *srcdev);
 void btrfs_rm_dev_replace_free_srcdev(struct btrfs_device *srcdev);
 void btrfs_destroy_dev_replace_tgtdev(struct btrfs_device *tgtdev);
+void btrfs_free_device(struct btrfs_device *device);
 unsigned long btrfs_full_stripe_len(struct btrfs_fs_info *fs_info,
 				    u64 logical);
 u64 btrfs_calc_stripe_length(const struct btrfs_chunk_map *map);
-- 
2.53.0

