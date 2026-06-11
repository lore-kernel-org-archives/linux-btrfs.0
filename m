Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C8101A6811
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Jun 2026 01:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781140456; cv=none; b=i1JIbmn5YyjvMDGRNghO2pZbzeasqKre/+R92byT4WapYWW7xX00S5XN/l9J/pbL2I44nINw+7Wyd88KdGpQaMvW4gfUCN/fasbybtrBNEp27IRGFlwo7U/giogNFO3VRc0e8/d5eLdLkPOoZrPsNGubazttWNp0Z+Up3Gq2im8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781140456; c=relaxed/simple;
	bh=Hl4oalwF8IQck50MTD4LFjtvCmm09+NWnHG/VGQOV6o=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QqDPMHMTzP3cir3zkmr4nAZkSUidVXRmF5Jo2wB09OL+xG2j0f0LSh1t0HV1jDAznG0bTYGoGeNetUdqqLk62w7E0gPyNLmjt52O51KBa/+vXNqVklh+r44l+pW5veonF/dX6fFxjN5VwarF5z7ZUQ4FSknvl94pCqat1Xucwas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=ueHWT6bl; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=ueHWT6bl; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ueHWT6bl";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ueHWT6bl"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 874426AEFC
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Jun 2026 01:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1781140448; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CV6h7Eq0JjZia0mgJJE2vJMulLASWkQ8cvGRXEUfKho=;
	b=ueHWT6blkjDjAEdqfw+sufhhW6tcgFUyE374FSCl+Qoh/T/5OycPTQxNKAcZV10cOk+BAT
	GBzOdIj+Iv4CRkJYdPaq2rGn+J5MNM1xkSM9E/CktiaURDsIxXGNnGa077ynQQP6DrPYwu
	E4oxqJ2qdWOoxucNRvMvd0qfDYAKuSI=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=ueHWT6bl
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1781140448; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CV6h7Eq0JjZia0mgJJE2vJMulLASWkQ8cvGRXEUfKho=;
	b=ueHWT6blkjDjAEdqfw+sufhhW6tcgFUyE374FSCl+Qoh/T/5OycPTQxNKAcZV10cOk+BAT
	GBzOdIj+Iv4CRkJYdPaq2rGn+J5MNM1xkSM9E/CktiaURDsIxXGNnGa077ynQQP6DrPYwu
	E4oxqJ2qdWOoxucNRvMvd0qfDYAKuSI=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 86AE6779A7
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Jun 2026 01:14:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mPFPDd8LKmqFWwAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Jun 2026 01:14:07 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] btrfs-progs: fix a memory leak in btrfs_prepare_device() for zoned devices
Date: Thu, 11 Jun 2026 10:43:41 +0930
Message-ID: <36f7b522c5dce53fd7dca7c4b6888d6b2213cc20.1781140396.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1781140396.git.wqu@suse.com>
References: <cover.1781140396.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 874426AEFC
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_NONE(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

[BUG]
With D=asan compiling option enabled, the test case mkfs/025 fails with
the following asan report triggered:

====== RUN CHECK root_helper /home/adam/btrfs-progs/mkfs.btrfs -d single -m single /dev/nullb0 /dev/nullb1 /dev/nullb2 /dev/nullb3 /dev/nullb4 /dev/nullb5 /dev/nullb6 /dev/nullb7 /dev/nullb8 /dev/nullb9

=================================================================
==185235==ERROR: LeakSanitizer: detected memory leaks

Direct leak of 20480 byte(s) in 10 object(s) allocated from:
    #0 0x7ffa8d7205dd in calloc /usr/src/debug/gcc/gcc/libsanitizer/asan/asan_malloc_linux.cpp:74
    #1 0x55e960f93d53 in report_zones kernel-shared/zoned.c:365
    #2 0x55e960f9a9f1 in btrfs_get_zone_info kernel-shared/zoned.c:1465
    #3 0x55e960fa0d37 in btrfs_prepare_device common/device-utils.c:253
    #4 0x55e960eb14ee in prepare_one_device mkfs/main.c:1156
    #5 0x7ffa8d65e11a in asan_thread_start /usr/src/debug/gcc/gcc/libsanitizer/asan/asan_interceptors.cpp:239
    #6 0x7ffa8d29698a  (/usr/lib/libc.so.6+0x9698a) (BuildId: 2f722da304c0a508c891285e6840199c35019c8d)

Direct leak of 18432 byte(s) in 9 object(s) allocated from:
    #0 0x7ffa8d7205dd in calloc /usr/src/debug/gcc/gcc/libsanitizer/asan/asan_malloc_linux.cpp:74
    #1 0x55e960f93d53 in report_zones kernel-shared/zoned.c:365
    #2 0x55e960f9a9f1 in btrfs_get_zone_info kernel-shared/zoned.c:1465
    #3 0x55e960f9a847 in btrfs_get_dev_zone_info kernel-shared/zoned.c:1431
    #4 0x55e960f9a6d2 in btrfs_get_dev_zone_info_all_devices kernel-shared/zoned.c:1408
    #5 0x55e960eb9b7d in main mkfs/main.c:2383
    #6 0x7ffa8d227634  (/usr/lib/libc.so.6+0x27634) (BuildId: 2f722da304c0a508c891285e6840199c35019c8d)
    #7 0x7ffa8d2276e8 in __libc_start_main (/usr/lib/libc.so.6+0x276e8) (BuildId: 2f722da304c0a508c891285e6840199c35019c8d)
    #8 0x55e960ea8fa4 in _start (/home/adam/btrfs-progs/mkfs.btrfs+0x3cfa4) (BuildId: 3def50571e3d23304fbe357251f52f4428140607)

Direct leak of 2048 byte(s) in 1 object(s) allocated from:
    #0 0x7ffa8d7205dd in calloc /usr/src/debug/gcc/gcc/libsanitizer/asan/asan_malloc_linux.cpp:74
    #1 0x55e960f93d53 in report_zones kernel-shared/zoned.c:365
    #2 0x55e960f9a9f1 in btrfs_get_zone_info kernel-shared/zoned.c:1465
    #3 0x55e960f9a847 in btrfs_get_dev_zone_info kernel-shared/zoned.c:1431
    #4 0x55e960f9a6d2 in btrfs_get_dev_zone_info_all_devices kernel-shared/zoned.c:1408
    #5 0x55e960f0d0f0 in __open_ctree_fd kernel-shared/disk-io.c:1665
    #6 0x55e960f0d9d8 in open_ctree_fs_info kernel-shared/disk-io.c:1733
    #7 0x55e960eb88f2 in main mkfs/main.c:2254
    #8 0x7ffa8d227634  (/usr/lib/libc.so.6+0x27634) (BuildId: 2f722da304c0a508c891285e6840199c35019c8d)
    #9 0x7ffa8d2276e8 in __libc_start_main (/usr/lib/libc.so.6+0x276e8) (BuildId: 2f722da304c0a508c891285e6840199c35019c8d)
    #10 0x55e960ea8fa4 in _start (/home/adam/btrfs-progs/mkfs.btrfs+0x3cfa4) (BuildId: 3def50571e3d23304fbe357251f52f4428140607)
...

[CAUSE]
In btrfs_prepare_device(), we call btrfs_get_zone_info() which allocated
space for zinfo, then later report_zones() allocates zinfo::zones and
zinfo::active_zones.

But we only free zinfo itself, not the zones nor active_zones pointers,
leading to the above leak.

[FIX]
Introduce a helper, btrfs_free_zoned_device_info() to do the proper free
of a btrfs_zoned_device_info structure.

Fixes: 58ec59389263 ("btrfs-progs: zoned: support resetting zoned device")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 common/device-utils.c   |  4 ++--
 kernel-shared/volumes.c |  2 +-
 kernel-shared/zoned.c   |  2 +-
 kernel-shared/zoned.h   | 10 ++++++++++
 4 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/common/device-utils.c b/common/device-utils.c
index 9dfc50211955..63240c1f5130 100644
--- a/common/device-utils.c
+++ b/common/device-utils.c
@@ -302,12 +302,12 @@ int btrfs_prepare_device(int fd, const char *file, u64 *byte_count_ret,
 		goto err;
 	}
 
-	free(zinfo);
+	btrfs_free_zoned_device_info(zinfo);
 	*byte_count_ret = byte_count;
 	return 0;
 
 err:
-	free(zinfo);
+	btrfs_free_zoned_device_info(zinfo);
 	return 1;
 }
 
diff --git a/kernel-shared/volumes.c b/kernel-shared/volumes.c
index a54ea4dd1fbd..c3d113b6e3b1 100644
--- a/kernel-shared/volumes.c
+++ b/kernel-shared/volumes.c
@@ -648,7 +648,7 @@ again:
 		/* free the memory */
 		kfree(device->name);
 		kfree(device->label);
-		kfree(device->zone_info);
+		btrfs_free_zoned_device_info(device->zone_info);
 		kfree(device);
 	}
 
diff --git a/kernel-shared/zoned.c b/kernel-shared/zoned.c
index 18fb7eb511d3..1757b195560a 100644
--- a/kernel-shared/zoned.c
+++ b/kernel-shared/zoned.c
@@ -1464,7 +1464,7 @@ int btrfs_get_zone_info(int fd, const char *file,
 	/* Get zone information */
 	ret = report_zones(fd, file, zinfo);
 	if (ret != 0) {
-		kfree(zinfo);
+		btrfs_free_zoned_device_info(zinfo);
 		return ret;
 	}
 	*zinfo_ret = zinfo;
diff --git a/kernel-shared/zoned.h b/kernel-shared/zoned.h
index d004ff16f198..2d01da7d83e8 100644
--- a/kernel-shared/zoned.h
+++ b/kernel-shared/zoned.h
@@ -83,6 +83,16 @@ enum btrfs_zoned_model zoned_model(const char *file);
 u64 zone_size(const char *file);
 int btrfs_get_zone_info(int fd, const char *file,
 			struct btrfs_zoned_device_info **zinfo);
+
+static inline void btrfs_free_zoned_device_info(struct btrfs_zoned_device_info *zinfo)
+{
+	if (!zinfo)
+		return;
+	free(zinfo->zones);
+	free(zinfo->active_zones);
+	free(zinfo);
+}
+
 int btrfs_get_dev_zone_info_all_devices(struct btrfs_fs_info *fs_info);
 int btrfs_check_zoned_mode(struct btrfs_fs_info *fs_info);
 
-- 
2.54.0

