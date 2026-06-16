Received: from mail.synology.com (mail.synology.com [211.23.38.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 216922D12EC
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Jun 2026 10:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.23.38.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781606432; cv=none; b=V+AxUgBcWY1IvKtuGcktQNjFpKWaK+FYZ9fMCFh3BM2BgHN8DmMU1vGNsPZxKcstRcrEdzAe0CzDkkuQa6ZfyCE0RXkuKLBh57+BPMyxz6r2XN+r+j0H1mA4LHiLRMvhFVQXUmHtl1FXiGu6xoYiJ9bgjXOn8mZEG9AzZgi1UAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781606432; c=relaxed/simple;
	bh=ub9KDz2RNJsaDY+CCZKB7WjV7YZ56F8Lv0bOIe6irxU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=XV4DtLlgMbXW7BJdJJ5shoqIM7UlSN/SOBJJgHm4e/PCbcKujn8MoVTbVcOZRrUg8plxb4TQ0mYZNGOsDFS1OLC+ajFmkuFGqpCl0K0hW8y7peMO7m7rlSQ8FRHihzqYXNzpe4M8dVS3F3gGFGGJ7nYU3N+/h/xb1DiUiLgPJ4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com; spf=pass smtp.mailfrom=synology.com; dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b=c1oGdKp1; arc=none smtp.client-ip=211.23.38.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=synology.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="c1oGdKp1"
Received: from 97097ad21e24 (unknown [10.17.41.35])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.synology.com (Postfix) with ESMTPSA id 4gfk640B6VzK6sSRY;
	Tue, 16 Jun 2026 18:40:28 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synology.com;
	s=123; t=1781606428;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=kDsBJ5Gk8QrttOqQSHolWUR5Jq2qJYEv4bLADrzXV/4=;
	b=c1oGdKp1SmJjyCWF/WToY3HauK6pCoD5CFbwP8J1Fkt9jvRfUIkMFTVplg1AhvIaA+SSo/
	11dujUx4bM7EapXHWmf+SgLSXF0lKK7DE6XUqjxegKatsU9u+BxE21DFfV9+fIJUusEKD/
	hZsVbSxQx4GEnO4GGeujYvmwhRUKr38=
From: You-Kai Zheng <ykzheng@synology.com>
To: linux-btrfs@vger.kernel.org
Cc: Qu Wenruo <wqu@suse.com>,
	You-Kai Zheng <ykzheng@synology.com>
Subject: [PATCH] btrfs: declare btrfs_ioctl_search_args_v2::buf as __u8
Date: Tue, 16 Jun 2026 18:39:07 +0800
Message-ID: <20260616103907.2157960-1-ykzheng@synology.com>
X-Mailer: git-send-email 2.54.0
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

The variable-sized buffer buf in struct btrfs_ioctl_search_args_v2 is
declared as __u64[], but it holds a packed byte stream of search results,
where all offsets into the buffer are in bytes.

Declaring buf as __u64[] makes it easy for user space to write incorrect
pointer arithmetic: adding a byte offset directly to a __u64 pointer
scales the offset by 8, landing at byte position offset*8 instead of
offset.

This recently caused an infinite loop in btrfs-progs: the accessor read
all-zero data from misaddressed items, which fed zeroed search keys back
into the ioctl loop and spun forever. The issue was worked around at the
time by disabling TREE_SEARCH_V2 entirely in btrfs-progs (d73e69824854:
"btrfs-progs: temporarily disable usage of v2 of search tree ioctl").

The kernel side already treats buf as a byte buffer, so change the
declaration to __u8[] to match the actual semantics and prevent similar
misuse in user space. The change is ABI compatible: both the structure size
and alignment are unchanged.

Suggested-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: You-Kai Zheng <ykzheng@synology.com>
---
 include/uapi/linux/btrfs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index 9165154a274d..16ff7beab9ca 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -598,7 +598,7 @@ struct btrfs_ioctl_search_args_v2 {
 	__u64 buf_size;		   /* in - size of buffer
 					    * out - on EOVERFLOW: needed size
 					    *       to store item */
-	__u64 buf[];                       /* out - found items */
+	__u8 buf[];                        /* out - found items */
 };
 
 /* With a @src_length of zero, the range from @src_offset->EOF is cloned! */
-- 
2.54.0


Disclaimer: The contents of this e-mail message and any attachments are confidential and are intended solely for addressee. The information may also be legally privileged. This transmission is sent in trust, for the sole purpose of delivery to the intended recipient. If you have received this transmission in error, any use, reproduction or dissemination of this transmission is strictly prohibited. If you are not the intended recipient, please immediately notify the sender by reply e-mail or phone and delete this message and its attachments, if any.
