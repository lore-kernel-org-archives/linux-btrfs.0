Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 146E24204E
	for <linux-btrfs@vger.kernel.org>; Sun,  7 Jun 2026 23:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780875512; cv=none; b=sXAhyfx3fCY0/iRKI5rAzkx33rLFTv/dj2Sw8uW6dexn0miwxc44uSlkeRZurGLZ0DLABgO3IkinHv9vzT+UVC4Cb2YOHKpdku4BCXOCXxCHYOdOrtHNbeEePBzuL470cbadvr724EZ023F8WwRunqe+T0tvpdQ9tvS8eiWlRpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780875512; c=relaxed/simple;
	bh=EZTkA0hvXYsPluLa/VlzTIwEg6DrPFsVlovq4QdqUnA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=qnF052dl/VKxeW7l1J9XX80s0V8wucHIQRdQaI2mb9lJ64+D01TM1422hRpn/7T4Kzx19WhW3YvIkp+CHjh1VH+tC1YlaWPKwf63b88e2cL4XlA8dhMudyyVu0vNPLBM3QH0xEyOCYD0uz+q2kcW8yycgd8y5wjywn+gSjiD3nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=pxTxRZkB; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=pxTxRZkB; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="pxTxRZkB";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="pxTxRZkB"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7021C6A93B;
	Sun,  7 Jun 2026 23:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1780875509; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=fawGLGEhqzxZD8pBHImPRmNV1DinKe4G/1LGNGvUdg0=;
	b=pxTxRZkBOpL27CbcZ7lAuCsbJ4YStQ+dtgfvQU7TaUbycmKnkaYcadAoBRMyV+7vH9IqHt
	uJtR8BsLb7W+JSQn0uvu3ORrx/FeUyxXCixLeQJCcYWYox5Za8hCPPQ/8EZ2QC9jiKySgV
	IvvZX9fYgzKX6m/Hmj1vPcd/XEF9wwM=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1780875509; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=fawGLGEhqzxZD8pBHImPRmNV1DinKe4G/1LGNGvUdg0=;
	b=pxTxRZkBOpL27CbcZ7lAuCsbJ4YStQ+dtgfvQU7TaUbycmKnkaYcadAoBRMyV+7vH9IqHt
	uJtR8BsLb7W+JSQn0uvu3ORrx/FeUyxXCixLeQJCcYWYox5Za8hCPPQ/8EZ2QC9jiKySgV
	IvvZX9fYgzKX6m/Hmj1vPcd/XEF9wwM=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1A841779A7;
	Sun,  7 Jun 2026 23:38:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qSg6LvMAJmrAPAAAD6G6ig
	(envelope-from <wqu@suse.com>); Sun, 07 Jun 2026 23:38:27 +0000
From: Qu Wenruo <wqu@suse.com>
To: fstests@vger.kernel.org,
	linux-btrfs@vger.kernel.org
Subject: [PATCH] fstests: btrfs/138: add requirement for datacsum
Date: Mon,  8 Jun 2026 09:08:01 +0930
Message-ID: <20260607233801.18453-1-wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -2.79
X-Spamd-Result: default: False [-2.79 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.19)[-0.973];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 

[FALSE ALERT]
If one has specified "-o nodatasum" as mount options, the test case
btrfs/138 will fail with the following error:

 MOUNT_OPTIONS -- -o nodatasum /dev/mapper/test-scratch1 /mnt/scratch

 btrfs/138    34s ... - output mismatch (see /home/adam/xfstests/results//btrfs/138.out.bad)
    --- tests/btrfs/138.out	2022-05-11 11:25:30.743333331 +0930
    +++ /home/adam/xfstests/results//btrfs/138.out.bad	2026-06-08 09:04:30.627143086 +0930
    @@ -1,2 +1,5 @@
     QA output created by 138
    +ERROR: failed to set compression for /mnt/scratch/zlib: Invalid argument
    +ERROR: failed to set compression for /mnt/scratch/lzo: Invalid argument
    +ERROR: failed to set compression for /mnt/scratch/zstd: Invalid argument
     Silence is golden
    ...

[CAUSE]
Btrfs compression requires both datacow and datasum, thus nodatasum
mount option will reject compression completely, causing the above
failures.

[FIX]
Add _require_btrfs_no_nodatasum for the test case, so that for nodatasum
mount option the test case can be properly skipped other than causing
false failure.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 tests/btrfs/138 | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/btrfs/138 b/tests/btrfs/138
index 17bbe28e..57ab1bd3 100755
--- a/tests/btrfs/138
+++ b/tests/btrfs/138
@@ -15,6 +15,7 @@ _begin_fstest auto compress
 _require_scratch
 _require_btrfs_command property
 _require_btrfs_no_nodatacow
+_require_btrfs_no_nodatasum
 
 algos=($(_btrfs_compression_algos))
 
-- 
2.51.2

