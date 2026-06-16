Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C273A3DB304;
	Tue, 16 Jun 2026 11:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781610116; cv=none; b=d7COxT9v6r6nqHN40X3PMblltepVe4Sugu/KY3LpU/MyLqMecofvx49ty7F7cGhhtHXxhKjlCLcjOJpZC7ajRV5iGo7PDr7PDU7ShUMdS9E+rRHvmW/qQGxB8UWdePGKI2VkOxiSe5UUHlD3yGmhvYfUKImz8xuxdku588vY3NY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781610116; c=relaxed/simple;
	bh=AnR9jmjvgISKuU4ZtkIpSyTsQtkiX18O4R0vWIUdJLo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=rI5nd7yirJNg2Z5r6HvI9tXW9rQb7rhkiS82OWuE6Pdc+H9mzT4ecqoEEaVbwWrH9lzsaBDAy9DRruvhxeaVJKsT/2lDqjyyH+O/AvlbYOyxwbzWQKcIMWMzL3pbe6KihcR4jb0yJur6jeMbznt2ssA2jVDO1tJUuW2beZHDXWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=buKLXysw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="buKLXysw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACF3C1F00A3A;
	Tue, 16 Jun 2026 11:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781610115;
	bh=htxqPZmavq89GjzI9LiJH8qt6fd+zx3mYHCyaGSbTJE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=buKLXyswJhUxy59Zocb6qeQZtF6mkcq2XRzvA2DC/IeZLjuJ8sJm4Iaqzoy7n4RKj
	 8Z2IF+aTqpFqCy2Jt33Q7/11fjPXH7A7qNLSUKvdFSEX3E89cRNFQcnZmEvKFpW7Xp
	 GprOCs/ij2ViGrDqVEVv7mODO2xspvkBwu4/CKGvZ5MKcgut+BXYcJIEjkXTADjnhH
	 7dBdsJKiaCupIRMnbIdG1W7avSs23DnreA743wuNBjVC9rFRjhmFq99vPhy88e3syn
	 hfujoNJkorAUAv+v/J+dAG0vE1chw5UQvraMPCASxw9IunMEZhJPGehyzpBNcdq5aM
	 3EA7C7sb9ECJA==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 16 Jun 2026 13:41:15 +0200
Subject: [PATCH 6/7] btrfs: destroy the target device when
 mark_block_group_to_copy() fails
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260616-work-btrfs-preexisting-fixes-v1-6-c4abe2f6d4f0@kernel.org>
References: <20260616-work-btrfs-preexisting-fixes-v1-0-c4abe2f6d4f0@kernel.org>
In-Reply-To: <20260616-work-btrfs-preexisting-fixes-v1-0-c4abe2f6d4f0@kernel.org>
To: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
 Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Filipe Manana <fdmanana@suse.com>, Naohiro Aota <naota@elisp.net>, 
 linux-btrfs@vger.kernel.org, Anand Jain <anand.jain@oracle.com>, 
 Stefan Behrens <sbehrens@giantdisaster.de>, linux-fsdevel@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-4090c
X-Developer-Signature: v=1; a=openpgp-sha256; l=1247; i=brauner@kernel.org;
 h=from:subject:message-id; bh=AnR9jmjvgISKuU4ZtkIpSyTsQtkiX18O4R0vWIUdJLo=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQZmmV/vyLqdi7PRsJa/6mcvozxv5y5z81dD7UVbnKpP
 G3grP6go5SFQYyLQVZMkcWh3SRcbjlPxWajTA2YOaxMIEMYuDgFYCIJZgz/HeSuWtRazgoPuzD1
 /KU7vQVzeZKqehL4pDlK0r6d5avkZfhnbKmzKPO+qHUIty7vuWURjgr7Wjh6fPZZms5cxyO6YyM
 /AA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

btrfs_dev_replace_start() opens the replacement target with
btrfs_init_dev_replace_tgtdev(), which adds it to the device list and opens
its block device.  Every error path after that point reaches the 'leave'
label to tear the target back down with btrfs_destroy_dev_replace_tgtdev() -
except the mark_block_group_to_copy() failure, which returns directly.  The
target is then leaked: it stays on the device list with its block device
held until the filesystem is unmounted.

Goto leave like the other post-open error paths so the target is destroyed.

Fixes: 78ce9fc269af ("btrfs: zoned: mark block groups to copy for device-replace")
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/btrfs/dev-replace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 13badbdee06b..6420f235ccd7 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -628,7 +628,7 @@ static int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
 
 	ret = mark_block_group_to_copy(fs_info, src_device);
 	if (ret)
-		return ret;
+		goto leave;
 
 	down_write(&dev_replace->rwsem);
 	dev_replace->replace_task = current;

-- 
2.47.3

