Received: from out203-205-221-231.mail.qq.com (out203-205-221-231.mail.qq.com [203.205.221.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D364E175A72;
	Mon, 10 Aug 2026 10:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786359597; cv=none; b=EkK/7OD7BPZhsRkibUk4kNs8O+KoGYchj5XIqX4IJsWayvN57VwVw1HBmhzA5klK0IIL/pQDHtrkyPwHDo7o4xrHYqsKx33k8wLWh031Npd/3kjYpsz17MIryRK5L6uk3bbhZflRCaQs9jF4QZuhaZhnkq9oeDFJtlPesZ7RJrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786359597; c=relaxed/simple;
	bh=W91Dl6CH+Q/KjwknQFpZbLL0SWbem2935ARH1EnvlKQ=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=ML1BtV7SZJcIKbVVA1boFPWpayOcEFUhQEYOBmSkjTiviwd+PCl3RgOkIDxoqXGViDcYZ4WLv0p+e0eHtOqEQ5WOr15G4aU7aK6BDqY7NjretzlR9NZhfYpvi4v3+Fsz/hblkfxpWaEMYCjQaqd5jcu0JlH6a00YXorOcqd2AAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=Lh0qHPDH; arc=none smtp.client-ip=203.205.221.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="Lh0qHPDH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1786359592; bh=FV8xSRqKZ04Qm5zi6F8Q8Wm4z7aDpFYqpnEzHoNC/rU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lh0qHPDHEg/3V/14zD52ZdzY1oO2WcnXXU+YMnbl2IB/FtCpyZXGIph3/yGX16Kx1
	 K/qTfxr4NY/I2/fil3iHGm/YJ63mApnCyAl+i5aAV47Wyx7Bbf1r0CtrME4Zm3ckCY
	 coBKf0aac0zK5dZ13cFnzDM3JAP5ph0XNxeXAkco=
Received: from ikun-VMware-Virtual-Platform.localdomain ([223.65.85.45])
	by newxmesmtplogicsvrszc43-0.qq.com (NewEsmtp) with SMTP
	id EE8AE615; Mon, 10 Aug 2026 18:59:40 +0800
X-QQ-mid: xmsmtpt1786359590tl39ykc71
Message-ID: <tencent_B95E31C5733BA4D28D132225269BEA8AE705@qq.com>
X-QQ-XMAILINFO: NPa98HB0c72N0vLedpZOkvWx/3uAg+ZsB6MjtFh06txSptQpD00HwgXtVl+hoW
	 KWI+EvHMG+E8oLxHa2gZc5JNjk3zzWtWnztyfJye2XjnW2HRWpaNWYjVMkPhw4f4QaE+k18hfMu6
	 kDmqnis+/zU8wiJOedlDXQZSg4WwPG1oDniKj/OJdFuoZ+id8iLnNQuGQROL2csalRdRaFDt6rCX
	 AAJRxEjOpRvkhAF+0ma4JAvbYhvN4J70oMMQ25vcuAOZORAr4j8f4ETyQTP0Ercxc2lWAYK/Rw+j
	 AV8YDZQP+sEHDhvaXfbnh8riT/GM05Av5bRDUOyuVVCw5UZQJ8ZAjLOG7QJ4GsO9pYJRScCGh074
	 8UKkFgXfERDyHXSSK7VY0S9cfmvcy0IN5uj/im86HRx+wQQQno9Zmg8aJtpakJ656ZFMv+SSE2ub
	 a8N1sU2dGw0w0ETzEDjje6DWerPn77sT/AjzAWj+Dt2uwtH5mDU9F8W2fYI48SazVrG9g0RXil1Q
	 UT5wDBVWbi9KGCg7fkoT7IGu/PThXaKTL/D/aBYaNaDpupimXG6B0zVr4SRA4T1R0LtJW+WFQVeS
	 xjGs3njxgUphjUgYXYMAuA9OYXYsVKq8hlMTt5rOeRb9YYRM78+cA8DTsO9lzvwgEFqae23MFh8c
	 zuVC5LsYti+LWr8I3r7phEO85qivS279/w8pte5+lmrkuqaZ/bDH5LBWxMcMEYKAtSHXvyZGy5Dv
	 AAoVrjYkYy2Y66OBL0YR1JcrW+yGFEXXYPTvd2Sj9Kyv/3qxxp+Gv1SQdHl12lgI5+oKz22ngM5O
	 x3fwEq8YlyoIXFNP3jroQFMD+Npfvm0qcG4LnLrpvs5mpjv7fB1ROb9uXXdcBQVDhelHnDBgdjuQ
	 gKb+nUOfanJHnl8TKfAZejxhz5YwVb1k4eW+h4N70r+JOI0JlOS3uAR+kiFQBOZ5rem90BGV8vcg
	 jp/aV2kSZtYQHCLhuL41VHutSqF7ykHzhc6jMKnfAyXrH2jUM9cUSyx4hq3ISc1Q/tIO02WTalnn
	 tuPEHRqpCtXrOWpfAH2A94s69SNiCSULZXA3rtEipesbENBzLy3VGTAe4DL2A=
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
From: Guanghui Yang <3497809730@qq.com>
To: linux-btrfs@vger.kernel.org
Cc: Guanghui Yang <3497809730@qq.com>,
	clm@fb.com,
	dsterba@suse.com,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v2 1/3] btrfs: detach failed sprout device from transaction update list
Date: Mon, 10 Aug 2026 18:59:14 +0800
X-OQ-MSGID: <52afe633e485d69ec377bb161da65427f369ac84.1786358930.git.3497809730@qq.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1786358930.git.3497809730@qq.com>
References: <cover.1786358930.git.3497809730@qq.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When creating the first metadata chunk for a sprout filesystem,
create_chunk() adds the new device to the transaction dev_update_list
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

