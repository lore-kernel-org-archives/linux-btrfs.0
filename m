Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE7E426694
	for <linux-btrfs@vger.kernel.org>; Mon,  5 Oct 2026 09:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791190912; cv=none; b=HYQWXYcHc8jcQZV0n5L6mcFD1B0vodWYvF7r9bBVG3+4wNDGk/cKQszGrLnRH5ywAcV8ec+4uD22HSiEdKe1sp4353sUziUU1TjbOCUc9ZX5EhRsF2IJzABpAp6xL9EDaR3g4JuhWbtjdQmj9Wguewwmi5RB3a/hD95+xaW93lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791190912; c=relaxed/simple;
	bh=IisHSeeh4PFq8iqaklNnKnOO5Wiw1sE46RriBY5WxUA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QcKt+27c4r36oumLEjyX9B4vYnVBg/C2QV7LRQLerYOHa6ZXh/WZSXr853bwsjgYsKi2KmVL4P5M9UnYsztNxUr2cjZdUQBVXQKf8IUXuVJODd1OKxpb0VNKTsM5T6lDjwf7c2iD5pLB8nojiO9iaHkH7m7JUkz77t8O4H7NOhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=GtOMtndr; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=UgMc1jVW; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="GtOMtndr";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="UgMc1jVW"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 52BEA21E8D
	for <linux-btrfs@vger.kernel.org>; Mon,  5 Oct 2026 09:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1791190904; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=omXfvF5pHfGw1ngW8/o1Gouq2Ws/vNbskePns4D8sqE=;
	b=GtOMtndrUMLWUV1Ala1GY1f3JEYX45rHJu05OSXUZAS7QY98JS9ezTHXAX/Q6eZTd9D+s3
	znSleptsmKA6d58u5JDF0I1wQhO+1jKftzfI8ssBwwLXXX7w8pPjCN1S5o3hRqBaIdUcPh
	gvrkJCDOdwjtpB7H1z5xmYZXiCVQmp8=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1791190900; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=omXfvF5pHfGw1ngW8/o1Gouq2Ws/vNbskePns4D8sqE=;
	b=UgMc1jVWRnrKjVUWAf4zz1NnSqfVenSUCaEdBXbMqk3WScUbPrvcyyskbGZ/hJx5VOAbnj
	NVEfWKUWXUeyPdGHuxxoV2XXNoh2mRCWCvw0c40hwL9RvGfxNv7P4/X9n+b+Gm0tpQTByw
	VeCyNeCm8QlgtzOFFH6rOwd7RqTGlQY=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0AEE713A20
	for <linux-btrfs@vger.kernel.org>; Mon,  5 Oct 2026 09:01:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ngyMK2tnw2qpRwAAD6G6ig:T5
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 05 Oct 2026 09:01:38 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/4] btrfs-progs: fsck-tests: add a new test case for qgroup tree check
Date: Mon,  5 Oct 2026 19:31:13 +1030
Message-ID: <e1fbd6af461300d7ab8c5316544f4aa9b80ee374.1791190852.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1791190852.git.wqu@suse.com>
References: <cover.1791190852.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.984];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

The workload is straight forward:

- Create a btrfs with qgroup full mode

- Create 512 subvolumes
  This should cause at least 2 leaves, even using 64K nodesize.

- Create qgroup 1/1 and assign 0/5 to it

- Run btrfs-check on the fs
  Unpatched progs will load the last leaf first, add the qgroup relation
  item without loading the qgroups in the previous leaf.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 tests/fsck-tests/076-large-quota-tree/test.sh | 28 +++++++++++++++++++
 1 file changed, 28 insertions(+)
 create mode 100644 tests/fsck-tests/076-large-quota-tree/test.sh

diff --git a/tests/fsck-tests/076-large-quota-tree/test.sh b/tests/fsck-tests/076-large-quota-tree/test.sh
new file mode 100644
index 000000000000..0697fa06795b
--- /dev/null
+++ b/tests/fsck-tests/076-large-quota-tree/test.sh
@@ -0,0 +1,28 @@
+#!/bin/bash
+#
+# Make sure "btrfs check" can properly handle a quota tree whose level
+# is larger than 0.
+
+source "$TEST_TOP/common" || exit
+
+check_prereq btrfs
+check_prereq mkfs.btrfs
+
+setup_root_helper
+prepare_test_dev
+
+run_check_mkfs_test_dev -O quota
+run_check_mount_test_dev
+# Create 512 subvolumes, which should cause at least 2 leaves even for 64K nodesize.
+for ((i = 0; i < 512; i++)); do
+	run_check $SUDO_HELPER "$TOP/btrfs" subvolume create "$TEST_MNT/subv_$i"
+done
+
+# Create qgroup 1/1 and add 0/5 to it, which should cause unpatched
+# btrfs-check to only load the last leaf for relation items, without
+# loading the involved qgroups.
+run_check $SUDO_HELPER "$TOP/btrfs" qgroup create 1/1 "$TEST_MNT"
+run_check $SUDO_HELPER "$TOP/btrfs" qgroup assign 0/5 1/1 "$TEST_MNT"
+run_check_umount_test_dev
+
+run_check $SUDO_HELPER "$TOP/btrfs" check "$TEST_DEV"
-- 
2.55.0

