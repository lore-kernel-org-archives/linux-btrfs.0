Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793658338;
	b=pUilYBnFMDeCu/ngJ06/YTZOO94t/2GSUghx2nry2Xf+vsf3+/QdzXvxUTszcJxFjw5o
	 JblH19TGHnEdXr6s/B7npqRGEn0wUmk1PH0wKuaR7+OpB3ECwJUDweUOzTbVH861W/GUf
	 BVndatvxwjQSZJNdZ9lJqUc5xlbEs1IoI05K0TbNGB3EObPpjpG6iRjRqyKqPHDeGgavG
	 D+65T+qaab3bJq9r8yMXBO4SSx1d/88RWxnwn0GIvOtg9F5Wc+gHV9wOOLkTslxGM8KYT
	 MWupdERU8hHd81thwmET+Ju2TL8XzIyxcxKoRD47t9pDPBRoF50XMJlZy6B5mmS9RMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793658338;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Rspamd-Queue-Id:X-Spam-Level:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spamd-Result:
	 X-Spam-Score;
	bh=/ZeEpCN5gbtt1cD2CXbSoucaWGLKFm5/lzUmKUBr+io=;
	b=S+RbO7l6Se+cPR3GXc67tyRXRTYyr2oMUiHKVEoJvefqkupMujJLm30QhNOqz+Pa73rF
	 dVW69PYTCpXKOO1cc/DOmRHRGe8WWsmREOMBYCzV4/MOEyndv8P+LqwiPHRrPJbulF4OR
	 b2V8RwgYvM0Kkf+uJvmXi3PEAhEnMU7FSI3bnAufKr8mdQu0Whqt4aikSj9DOdlBV7YRy
	 l4331FpciCV6jzg7gEZpmn6frbiczg4nlb94734vqWjDv7BmbCjDx1692Grh6WzwIWKIL
	 wYXgoNhCronwGGdJ3PUmdHHwUqMxJI1Lvrj+7ZS6K48ksrs4eVLXWG191ScmMmVN3JQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=Cef+dBa0;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=Cef+dBa0;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 882B1606A324
	for <linux-btrfs@vger.kernel.org>; Mon,  2 Nov 2026 22:25:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 882B1606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=Cef+dBa0;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=Cef+dBa0
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 782071F82A
	for <linux-btrfs@vger.kernel.org>; Mon,  2 Nov 2026 22:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793658335; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=/ZeEpCN5gbtt1cD2CXbSoucaWGLKFm5/lzUmKUBr+io=;
	b=Cef+dBa0yp9yzBsSlcAqH76/LfpqnTAPzgN++McAvm2xOvL+NZi4fpW+D8Ikg1DxPb4tjt
	Cswrj27UGZRS+sJcPPMUf5JMeut/6nPY3bX81WEBLzY1b6r8mnAeRqAmoLi1TJl2B84gfW
	9G6SeKfaXZLW0j1+M291jcxRfWtkBL8=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=Cef+dBa0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793658335; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=/ZeEpCN5gbtt1cD2CXbSoucaWGLKFm5/lzUmKUBr+io=;
	b=Cef+dBa0yp9yzBsSlcAqH76/LfpqnTAPzgN++McAvm2xOvL+NZi4fpW+D8Ikg1DxPb4tjt
	Cswrj27UGZRS+sJcPPMUf5JMeut/6nPY3bX81WEBLzY1b6r8mnAeRqAmoLi1TJl2B84gfW
	9G6SeKfaXZLW0j1+M291jcxRfWtkBL8=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5F148134B3
	for <linux-btrfs@vger.kernel.org>; Mon,  2 Nov 2026 22:25:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7rihLN0N6Wr8JwAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 02 Nov 2026 22:25:34 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs-progs: enhance device preparation for discard=ignore cases
Date: Tue,  3 Nov 2026 08:55:15 +1030
Message-ID: <40f08ffabe8de460c6da4c6c67b2e5767f436908.1793658275.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 782071F82A
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-12.01 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FROM_HAS_DN(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -12.01

[BUG]
For qemu/KVM guests where the storage has 'discard=ignore' set,
mkfs.btrfs won't properly wipe out any existing super blocks from other
filesystems:

  # mkfs.ext4 -F /dev/vdc
  # mkfs.btrfs -f /dev/vdc
  # wipefs  /dev/vdc
  DEVICE OFFSET  TYPE  UUID                                 LABEL
  vdc    0x438   ext4  19b84ba1-e783-406d-a2f0-269aca433892
  vdc    0x10040 btrfs 8ab186d0-9f11-4132-a815-5397b99fcd1f

Note that the ext4 super block is still there.

[CAUSE]
With 'discard=ignore' setting, the discard operation is accepted but no
data will be wiped out.

Furthermore, mkfs.btrfs do the zero write before discard, but that zero
write itself is buffered write, and discard will drop any page cache of
the block device, so such zero write never reaches the storage.

[FIX]
Fix the problem and hardening the data wipe out by:

- Re-order the device preparation
  Instead of zero-write then discard, change it to discard then
  zero-write.

  So even if discard did nothing, the zero writes won't be discarded.

- Use BLKZEROOUT ioctl when possible
  This ioctl will ensure the content is zeroed out.
  If the device supports WRITE_ZEROS and can do it cheaply, this will
  not take up extra space.

  Although this ioctl is only supported on block device.
  So the zero-buffered write is still needed as a fallback

- Sync after the zero writes
  Although the zero writes are already after discard, be extra safe to
  make sure the zeros reach the storage.

Issue: #1198
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
Changelog:
v2:
- Fix the return value if fsync() failed
  fsync() always return -1, but populates errno.
---
 common/device-utils.c | 36 ++++++++++++++++++++++++++++++++----
 1 file changed, 32 insertions(+), 4 deletions(-)

diff --git a/common/device-utils.c b/common/device-utils.c
index 6c81183887d3..31364bd7a2f3 100644
--- a/common/device-utils.c
+++ b/common/device-utils.c
@@ -48,6 +48,10 @@
 #define BLKDISCARD	_IO(0x12,119)
 #endif

+#ifndef BLKZEROOUT
+#define BLKZEROOUT	_IO(0x12,127)
+#endif
+
 /*
  * Discard the given range in one go
  */
@@ -127,6 +131,15 @@ int device_zero_blocks(int fd, off_t start, size_t len, bool direct)

 #define ZERO_DEV_BYTES SZ_2M

+static int device_zeroout_range(int fd, u64 start, u64 len)
+{
+	u64 range[2] = { start, len };
+
+	if (ioctl(fd, BLKZEROOUT, &range) < 0)
+		return -errno;
+	return 0;
+}
+
 /*
  * Zero blocks in the range from start but not after the given device size.
  * (On SPARC the disk labels are preserved too.)
@@ -135,6 +148,7 @@ static int zero_dev_clamped(int fd, struct btrfs_zoned_device_info *zinfo,
 			    off_t start, ssize_t len, u64 dev_size)
 {
 	off_t end = max(start, start + len);
+	int ret;

 #ifdef __sparc__
 	/* Don't overwrite the disk labels on SPARC. */
@@ -148,7 +162,17 @@ static int zero_dev_clamped(int fd, struct btrfs_zoned_device_info *zinfo,
 	if (zinfo && zinfo->model == ZONED_HOST_MANAGED)
 		return zero_zone_blocks(fd, zinfo, start, end - start);

-	return device_zero_blocks(fd, start, end - start, false);
+	if (!device_zeroout_range(fd, start, end - start))
+		return 0;
+
+	ret = device_zero_blocks(fd, start, end - start, false);
+	if (ret < 0)
+		return ret;
+
+	ret = fsync(fd);
+	if (ret < 0)
+		return -errno;
+	return 0;
 }

 /*
@@ -279,6 +303,13 @@ int btrfs_prepare_device(int fd, const char *file, u64 *byte_count_ret,
 		}
 	}

+	/*
+	 * Discard drops the page cache and may not zero the data (e.g. QEMU
+	 * discard=ignore), so it must come before zeroing.
+	 */
+	if (!(opflags & PREP_DEVICE_ZONED) && (opflags & PREP_DEVICE_DISCARD))
+		prepare_discard_device(file, fd, byte_count, opflags);
+
 	ret = zero_dev_clamped(fd, zinfo, 0, ZERO_DEV_BYTES, byte_count);
 	for (i = 0 ; !ret && i < BTRFS_SUPER_MIRROR_MAX; i++)
 		ret = zero_dev_clamped(fd, zinfo, btrfs_sb_offset(i),
@@ -293,9 +324,6 @@ int btrfs_prepare_device(int fd, const char *file, u64 *byte_count_ret,
 		goto err;
 	}

-	if (!(opflags & PREP_DEVICE_ZONED) && (opflags & PREP_DEVICE_DISCARD))
-		prepare_discard_device(file, fd, byte_count, opflags);
-
 	ret = btrfs_wipe_existing_sb(fd, zinfo);
 	if (ret < 0) {
 		error("cannot wipe superblocks on %s", file);
--
2.56.0

