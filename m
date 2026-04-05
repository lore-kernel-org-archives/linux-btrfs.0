Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD1A3815ED
	for <linux-btrfs@vger.kernel.org>; Sun,  5 Apr 2026 19:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775418648; cv=none; b=sLkcWAv7c0p9/jJtNH2W3vLuJ5bt2UWk+P8hOMJ27aq/kvhwf4/7pa9dqwFtvqWk0vV5ZthtUUnS1qfPyYK1ExJo4mOADA3EsBbgujrwwbpDkQPwDY2krFCbzGXfME6ACpyH0Grs4NO1bCqgBoH48FexgOCfYSZ8/YgkUA4W8jA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775418648; c=relaxed/simple;
	bh=Y0VePmfDKqj2Wr4uBDtOu+PZcxWOL70k8AGZMMUQvs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TfUVY7k3Md6X0MBRhzjLVn14DZIi5hnbiTphsqJOvhFiqWnW4xHLiot7N/bdQD29sU9nxInuHtn4qjGtMOsWv2ew4UDhCNvlkoCqoIFc1DsFUAaBlIwFYxfTGFgkViGesud4uhzKW6J0eQLNgHoxz9fMJp20SHrG1EwtnkbgYbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XdDrRQQ5; arc=none smtp.client-ip=209.85.167.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XdDrRQQ5"
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-470145d7e6fso433609b6e.2
        for <linux-btrfs@vger.kernel.org>; Sun, 05 Apr 2026 12:50:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775418646; x=1776023446; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K8lGtdviJ/yNeFObSgzOPOsYD9zf1PXG9ZhAjN6EY4Q=;
        b=XdDrRQQ5qPYkH9zR2x/+NtoWTga+XHyaTfGu1QNncVF0j2P77Okxr4pSiPY5tVZ1XK
         2eV4SZrhm1H7mdLog/K+3uJqJ8MwfupaNM0WfLwj0hV6rwZzzGKUv5gq+7j4dn1J1rRG
         Lx+PUov62S0/fA0CNBAT+tn5RjkXh+UarmL6Nj40U+N5kYOp+Z2fsSjLtMUBbS3RmLVv
         zsHg78reMJJuXVPkHgVXT/jF0GyodEaZCMktPIBj4wCWdrB+Hf/s3w7hNhFS3vjI7UQ3
         EZRt4JkHYq/34JFuYw0TKcAog1ZpCcLAVCD3CTPUajc5sl6NAIsdyJnpZSAccg4KNZDz
         LxvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775418646; x=1776023446;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=K8lGtdviJ/yNeFObSgzOPOsYD9zf1PXG9ZhAjN6EY4Q=;
        b=ahxgnasVjcgVugfZ7w9ZzCpO1dLHsjdCnAXahIddW6yltVkn82cy6S2S4nk0KjE7dZ
         1ADRSJehPvnqrIq+N/jGulYjAQfC82V3SdaF+w84lqMELsf1yYRpMKYkc6kbwCYK8EVd
         S3qigz04cVqG57iN5p2SrTA5G2ov9EWulYNnOQJPCcTplb0XeuFYu7efhAPooa6176Yn
         TH7+oBmEClK9AXR4XeEzEWZ8eDncTFD5x22bmotjwfPjKMc35eu0DQqInRUI64YZ1W9j
         D8R74P3uSX6vR0JCGyg4Bbo7534xcIEpEKio+TMJj6gxto+VMoxyzJE5nhNaGty8vy+J
         wNpA==
X-Forwarded-Encrypted: i=1; AJvYcCV4NzL1jRgzsQFzd61OFyXSrlCj7HsLGAcy+CPohm+I87Oc6xpweIStWwza/0RPLU1cd3hPDtYENlaaPA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyyWmI11CEaaouVtSw/tDaoR5euTkS5RC5L+vppzIBILCkakaD7
	xVwWo+w7FppW6f2b96HoZbAWJD2+uswUqdlztrh3eYEkPP8LzSjODj6cB20STYui
X-Gm-Gg: AeBDietl7r0HUET5JqFTtzLF7p0UHelUrbACeg5JzYAnDY5af8JaC4CNTbYXZPHrsZx
	fAaS/uloHHpMYVDxGRhY9L0mV9xYkkdQMo0GoirUn7X0Tlko/OUL3lAKq4cdHuCPHqOR9zeLgV7
	CoFkPDdSvAPaf+bg1tk5Vet5Dwh9rudR81pEaqHq8KZF+xHsH1DvStoeH7AFe2OcMpu79b6ixxr
	aYHvzqXK9jLq10mjUXQ2SC2vRryESp1jWg5rDOM/PJiI6+14Q6KAur0PTc2qJCpKOnthmjTUniO
	NZYR4p4/Gku7hRifS7MkbC7IKMyMy2JewduykT5/dWORdVAAojvLRJvfzRV90bF+GpKuCTpPG8L
	4ob2BmY/oQ0Vhf4vasrVtBGIjBbYzUPbPLGdrQ/1ateieW5gs+cPl06opN0wVdPs+RliYE5Ek4f
	Cag8sEtgTKrDR2KzHPRoRLIaXCZFjNhuzNfq98VbLiNaAq982Zx9O8gQoI3hDiUWmOvV8supWsx
	NwkiH7T5cjpy4s=
X-Received: by 2002:a05:6808:1511:b0:46a:738f:7666 with SMTP id 5614622812f47-46ef7a12be7mr5024308b6e.36.1775418645800;
        Sun, 05 Apr 2026 12:50:45 -0700 (PDT)
Received: from localhost.localdomain (c-73-5-99-191.hsd1.la.comcast.net. [73.5.99.191])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-46f46160155sm4547428b6e.17.2026.04.05.12.50.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2026 12:50:44 -0700 (PDT)
From: Sean Smith <defendthedisabled@gmail.com>
X-Google-Original-From: Sean Smith <DefendTheDisabled@gmail.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	tytso@mit.edu,
	dsterba@suse.com,
	david@fromorbit.com,
	brauner@kernel.org,
	osandov@osandov.com,
	almaz@kernel.org,
	hirofumi@mail.parknet.co.jp,
	linkinjeon@kernel.org,
	Sean Smith <DefendTheDisabled@gmail.com>
Subject: [PATCH 5/6] fat: map ptime to FAT creation time with rename-over
Date: Sun,  5 Apr 2026 14:50:01 -0500
Message-ID: <20260405195007.1306-6-DefendTheDisabled@gmail.com>
X-Mailer: git-send-email 2.51.0.windows.1
In-Reply-To: <20260405195007.1306-1-DefendTheDisabled@gmail.com>
References: <20260405195007.1306-1-DefendTheDisabled@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Map ptime to the FAT/VFAT creation time field. Only active on VFAT
(long filename) mounts since plain FAT12/FAT16 lack creation time.
FAT32 creation time has 2-second precision.

Getattr: report creation time as ptime (VFAT only, via isvfat check).
Setattr: write ptime to i_crtime.
Rename-over: save target creation time before detach, restore to
  source after attach. Preserves creation time across atomic saves.

Signed-off-by: Sean Smith <DefendTheDisabled@gmail.com>
---
 fs/fat/file.c       |  6 ++++++
 fs/fat/namei_vfat.c | 20 ++++++++++++++++++--
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/fs/fat/file.c b/fs/fat/file.c
index 4fc49a614..9d1fcc554 100644
--- a/fs/fat/file.c
+++ b/fs/fat/file.c
@@ -413,6 +413,10 @@ int fat_getattr(struct mnt_idmap *idmap, const struct path *path,
 		stat->result_mask |= STATX_BTIME;
 		stat->btime = MSDOS_I(inode)->i_crtime;
 	}
+	if (sbi->options.isvfat && (request_mask & STATX_PTIME)) {
+		stat->result_mask |= STATX_PTIME;
+		stat->ptime = MSDOS_I(inode)->i_crtime;
+	}
 
 	return 0;
 }
@@ -564,6 +568,8 @@ int fat_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 		fat_truncate_time(inode, &attr->ia_mtime, S_MTIME);
 	attr->ia_valid &= ~(ATTR_ATIME|ATTR_CTIME|ATTR_MTIME);
 
+	if (attr->ia_valid & ATTR_PTIME)
+		MSDOS_I(inode)->i_crtime = attr->ia_ptime;
 	setattr_copy(idmap, inode, attr);
 	mark_inode_dirty(inode);
 out:
diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index 47ff083cf..f1e2eadf8 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -975,8 +975,24 @@ static int vfat_rename(struct inode *old_dir, struct dentry *old_dentry,
 	}
 	inode_inc_iversion(new_dir);
 
-	fat_detach(old_inode);
-	fat_attach(old_inode, new_i_pos);
+	/* ptime rename-over: save target creation time */
+	{
+		struct timespec64 saved_crtime = {};
+		bool inherit_crtime = false;
+
+		if (new_inode && S_ISREG(old_inode->i_mode) &&
+		    S_ISREG(new_inode->i_mode) && old_inode->i_nlink == 1) {
+			saved_crtime = MSDOS_I(new_inode)->i_crtime;
+			inherit_crtime = true;
+		}
+
+		fat_detach(old_inode);
+		fat_attach(old_inode, new_i_pos);
+
+		if (inherit_crtime)
+			MSDOS_I(old_inode)->i_crtime = saved_crtime;
+	}
+
 	err = vfat_sync_ipos(new_dir, old_inode);
 	if (err)
 		goto error_inode;
-- 
2.53.0

