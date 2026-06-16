Received: from mail.synology.com (mail.synology.com [211.23.38.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A503C413622
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Jun 2026 10:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.23.38.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781606695; cv=none; b=i4ED7UXWhrvteE3JtmJ4/paxFcEteBOUPzzPZWuPW65ayc2qbMabNx1kEbIvUwOOMSXw958tMjZ73th1Rsql54m8LVW2BcoTmK5SKGTpV43ESTeqhJUST7bzV2ikaBlgM+txRUA59I2JmABqP17Wp+ITeZo4I76YAikIlhwuC0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781606695; c=relaxed/simple;
	bh=ezllmD/A+3sht6FTBQMcRXPLHWpgJvWirfXpLDO5XSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f/TQLaSQNuWt++pNZCbI4fOgR/qU8VDK+7114c/SVwDyYMmoTbTPggF4TSQf/f5P+Qa95aWsHqUIaA2RXMUufAENc7l6xZHdbGvUbWikHIg2JTnCgzNsMUCraYNPAoCUniYSNEK+ife6FkEyH9XsooMriEK5VEZYE0WHaKLvH0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com; spf=pass smtp.mailfrom=synology.com; dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b=Gq09CZal; arc=none smtp.client-ip=211.23.38.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=synology.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="Gq09CZal"
Received: from 97097ad21e24 (unknown [10.17.41.35])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.synology.com (Postfix) with ESMTPSA id 4gfkC72x0zzK6sgb9;
	Tue, 16 Jun 2026 18:44:51 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synology.com;
	s=123; t=1781606692;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eGnxLQwuKN167mJgZkFwiS0wQDQHEXXR9JAHTw+I7nk=;
	b=Gq09CZalBO1owrm6XGsvuVGhz1LPc3wKeVruWG1EcO0NRfPIyK+7w1rERqtN9FrVDJJxHf
	eHX7tQ7mv8BNPB+cv7tLnVaI3lFF75KEaLkKfZZiF4mrygq+QRzIlULbVLSfJlhLC/EWff
	jvAiG3DaOfPFgNNPITGg0LCJJeBbJhM=
From: You-Kai Zheng <ykzheng@synology.com>
To: wqu@suse.com
Cc: linux-btrfs@vger.kernel.org,
	quwenruo.btrfs@gmx.com,
	ykzheng@synology.com
Subject: [PATCH v2] btrfs-progs: re-enable tree search v2 ioctl
Date: Tue, 16 Jun 2026 18:43:08 +0800
Message-ID: <20260616104308.2159912-1-ykzheng@synology.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <780847cd-3fa7-4b17-af33-0b84bd125cbc@suse.com>
References: <780847cd-3fa7-4b17-af33-0b84bd125cbc@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Synology-MCP-Status: no
X-Synology-Auth: pass
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
X-Synology-Spam-Flag: no
X-Synology-Virus-Status: no
Content-Type: text/plain

Commit d73e69824854 ("btrfs-progs: temporarily disable usage of v2 of
search tree ioctl") turned off TREE_SEARCH_V2 detection because it led
to an infinite loop in load_chunk_info() (reachable via 'btrfs
filesystem usage', reproducible by mkfs-tests/001): from the second
item in the returned buffer the data read back as all zeros while
nr_items was non-zero, so the search key never advanced.

The root cause is the type of the variable-sized buffer buf in struct
btrfs_ioctl_search_args_v2: it is declared as __u64[], but the buffer
holds a packed byte stream addressed by byte offsets. Adding such an
offset to a __u64 pointer in btrfs_tree_search_data() scaled it by 8,
so every item after the first landed past the valid data and read
zeros, which fed a zeroed key back into the search and spun forever.

Declare buf as __u8 in all in-tree copies of the struct so the offset
arithmetic is in bytes, and restore the tree search autodetection so
callers use the v2 ioctl when supported. The struct size is unchanged:
buf stays 8-byte aligned after the __u64 buf_size.

Tested on Linux 7.1.0; the whole mkfs-tests group passes with the v2
ioctl enabled.

Suggested-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: You-Kai Zheng <ykzheng@synology.com>
---
v2:
- Fix at the UAPI level by declaring buf as __u8 instead of casting in
  btrfs_tree_search_data(), per Qu Wenruo's review, and update all
  in-tree copies of the struct.

A corresponding kernel patch has been sent separately:

  "btrfs: declare btrfs_ioctl_search_args_v2::buf as __u8"

 common/fsfeatures.c        | 6 ------
 kernel-shared/uapi/btrfs.h | 2 +-
 libbtrfs/ioctl.h           | 2 +-
 libbtrfsutil/btrfs.h       | 2 +-
 4 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/common/fsfeatures.c b/common/fsfeatures.c
index 2b19bd6e..9dcd237e 100644
--- a/common/fsfeatures.c
+++ b/common/fsfeatures.c
@@ -708,14 +708,8 @@ int btrfs_tree_search_ioctl(int fd, struct btrfs_tree_search_args *sa)
 {
 	/* On first use check the supported status and save it. */
 	if (!tree_search_v2_initialized) {
-#if 0
-		/*
-		 * Keep using v1 until v2 is fully tested, in some cases it
-		 * does not return properly formatted results in the buffer.
-		 */
 		if (btrfs_tree_search2_ioctl_supported(fd) == 1)
 			tree_search_v2_supported = true;
-#endif
 		tree_search_v2_initialized = true;
 	}
 	sa->use_v2 = tree_search_v2_supported;
diff --git a/kernel-shared/uapi/btrfs.h b/kernel-shared/uapi/btrfs.h
index 33dc1ae4..a765fbc4 100644
--- a/kernel-shared/uapi/btrfs.h
+++ b/kernel-shared/uapi/btrfs.h
@@ -626,7 +626,7 @@ struct btrfs_ioctl_search_args_v2 {
 	__u64 buf_size;		   /* in - size of buffer
 					    * out - on EOVERFLOW: needed size
 					    *       to store item */
-	__u64 buf[];                       /* out - found items */
+	__u8 buf[];                        /* out - found items */
 };
 _static_assert(sizeof(struct btrfs_ioctl_search_args_v2) == 112);
 
diff --git a/libbtrfs/ioctl.h b/libbtrfs/ioctl.h
index 7b53a531..66cdd739 100644
--- a/libbtrfs/ioctl.h
+++ b/libbtrfs/ioctl.h
@@ -385,7 +385,7 @@ struct btrfs_ioctl_search_args_v2 {
         __u64 buf_size;			   /* in - size of buffer
                                             * out - on EOVERFLOW: needed size
                                             *       to store item */
-        __u64 buf[0];                      /* out - found items */
+        __u8 buf[0];                       /* out - found items */
 };
 
 /* With a @src_length of zero, the range from @src_offset->EOF is cloned! */
diff --git a/libbtrfsutil/btrfs.h b/libbtrfsutil/btrfs.h
index 29320b5c..47d9ebf8 100644
--- a/libbtrfsutil/btrfs.h
+++ b/libbtrfsutil/btrfs.h
@@ -590,7 +590,7 @@ struct btrfs_ioctl_search_args_v2 {
 	__u64 buf_size;		   /* in - size of buffer
 					    * out - on EOVERFLOW: needed size
 					    *       to store item */
-	__u64 buf[0];                       /* out - found items */
+	__u8 buf[0];                        /* out - found items */
 };
 
 /* With a @src_length of zero, the range from @src_offset->EOF is cloned! */
-- 
2.54.0


Disclaimer: The contents of this e-mail message and any attachments are confidential and are intended solely for addressee. The information may also be legally privileged. This transmission is sent in trust, for the sole purpose of delivery to the intended recipient. If you have received this transmission in error, any use, reproduction or dissemination of this transmission is strictly prohibited. If you are not the intended recipient, please immediately notify the sender by reply e-mail or phone and delete this message and its attachments, if any.
