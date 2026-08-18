Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4068B449EA6
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Aug 2026 09:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787045418; cv=none; b=k5TTug9xxOch1ppygqKk9NrRDRORlXOXl/LQa8wHLepCS7yKpAYrWFwoMRsqvl22d2tiDFMInNkSReP0vvYUMVeBeyFED2J8YTJHbF69DcAOMJ4SBAVcJkXN0o9QkeH+Lvdry3+PkdQ8V2JMRGbSDJAWSdEmPJ3OmCRLsK/sZ3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787045418; c=relaxed/simple;
	bh=4flyT+t9aCkFc5VM3EthUFy++ep+ygJY0MFte6Marj4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a4viQHzJTornWnKMVGir8HqvOdmbLfzhoYNucReSgR5bQmfqYZPC6FXLxyl+potrY5juW1M+4O7TFpCbTtvnxwoKdlPzDqu10xIDxc5UYJDnJoxHxm5za8Z2IZUDvyFEE+iMcaFP2WkRXg3efb9HgLBYO4NixnJpqy2UuNH4YPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=TXV9b5vj; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=lMYelspw; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="TXV9b5vj";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="lMYelspw"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id F198C3ED6
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Aug 2026 09:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1787045410; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W+r4o0u0GcbBQWot9xV6IO6x90y4jA/kpJL2JPX1GFg=;
	b=TXV9b5vj3DgjiBIH5GI+iEUgCUpQch2RECQ8j1RaTeNgA7rKl4otxFefAbw9v8sl77uFy9
	suwJQon+gVu6AWol8z1EWxSl4TnQ8GObONNI2ukykOkBGrJPxZOhBh4MUwCCEQ63Yw6W+7
	RLW4booookuElWYkTxYGLT3Q57/NHnk=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=lMYelspw
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1787045405; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W+r4o0u0GcbBQWot9xV6IO6x90y4jA/kpJL2JPX1GFg=;
	b=lMYelspwJdwjbdJBtQJzGnT5htIRxyTIXnd6l2XCEBVwJbMzOP+rf1+Si5xYmIAtQ3P0cx
	W5kDvcTdA3LCagJRbABIjJaAb84+Kvq9VhfT0ePdrgsqzvtFYL+ORsX9o0ZENBbLNJEgAQ
	gd5pzKs9XZgdHo+umb5cvu5JOjRTpwI=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2606D367B
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Aug 2026 09:30:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6OMOLxsmhGrKWQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Aug 2026 09:30:03 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 5/5] btrfs-progs: fsck-test: add a test case for unexpected file extent items
Date: Tue, 18 Aug 2026 18:59:35 +0930
Message-ID: <78b7903159fcdd2c6c506986b4f40fce0f7e517d.1787045341.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1787045341.git.wqu@suse.com>
References: <cover.1787045341.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	TO_DN_NONE(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Queue-Id: F198C3ED6
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action

The image is created using btrfs-corrupt-block, the fs tree leaf looks
like this:

	item 0 key (256 INODE_ITEM 0) itemoff 16123 itemsize 160
		generation 3 transid 9 size 12 nbytes 16384
		block group 0 mode 40755 links 1 uid 0 gid 0 rdev 0
		sequence 1 flags 0x0(none)
	item 1 key (256 INODE_REF 256) itemoff 16111 itemsize 12
		index 0 namelen 2 name: ..
	item 2 key (256 DIR_ITEM 496027801) itemoff 16075 itemsize 36
		location key (257 INODE_ITEM 0) type BLKDEV <<<
		transid 9 data_len 0 name_len 6
		name: foobar
	item 3 key (256 DIR_INDEX 2) itemoff 16039 itemsize 36
		location key (257 INODE_ITEM 0) type BLKDEV <<<
		transid 9 data_len 0 name_len 6
		name: foobar
	item 4 key (257 INODE_ITEM 0) itemoff 15879 itemsize 160
		generation 9 transid 9 size 8192 nbytes 8192
		block group 0 mode 60660 links 1 uid 0 gid 0 rdev 0 <<<
		sequence 2 flags 0x0(none)
	item 5 key (257 INODE_REF 256) itemoff 15863 itemsize 16
		index 2 namelen 6 name: foobar
	item 6 key (257 EXTENT_DATA 0) itemoff 15810 itemsize 53
		generation 9 type 1 (regular)
		extent data disk byte 13631488 nr 8192
		extent data offset 0 nr 8192 ram 8192
		extent compression 0 (none)

The image is generated by the following steps:

 # mkfs.btrfs -f $dev
 # mount $dev $mnt
 # xfs_io -f -c "pwrite 0 4k" $mnt/foobar
 # umount $mnt

 ## Change the inode's mode from REG to BLK
 # btrfs-corrupt-block -i 257 -f mode --value 25008 $dev

 ## Change the dir item's flag from REG to BLK
 # btrfs-corrupt-block -D 256,84,496027801 -f flags --value 4 $dev

 ## Change the dir index's flag from REG to BLK
 # btrfs-corrupt-block -D 256,96,2 -f flags --value 4 $dev

The inode's mode and dir flags all match, but there is one unexpected
file extent item there.

Both lowmem and original mode should detect such problem.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 .../075-blk-inode-with-data/default.img.xz      | Bin 0 -> 2104 bytes
 .../fsck-tests/075-blk-inode-with-data/test.sh  |  16 ++++++++++++++++
 2 files changed, 16 insertions(+)
 create mode 100644 tests/fsck-tests/075-blk-inode-with-data/default.img.xz
 create mode 100755 tests/fsck-tests/075-blk-inode-with-data/test.sh

diff --git a/tests/fsck-tests/075-blk-inode-with-data/default.img.xz b/tests/fsck-tests/075-blk-inode-with-data/default.img.xz
new file mode 100644
index 0000000000000000000000000000000000000000..7fc1c58b8a3d71dce36d0612fd8da52a6d586e87
GIT binary patch
literal 2104
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

literal 0
HcmV?d00001

diff --git a/tests/fsck-tests/075-blk-inode-with-data/test.sh b/tests/fsck-tests/075-blk-inode-with-data/test.sh
new file mode 100755
index 000000000000..a98310e9b29d
--- /dev/null
+++ b/tests/fsck-tests/075-blk-inode-with-data/test.sh
@@ -0,0 +1,16 @@
+#!/bin/bash
+#
+# Verify that check can detect unexpected file extent items for special inodes
+# which should not have any file extent.
+
+source "$TEST_TOP/common" || exit
+
+check_prereq btrfs
+
+check_image() {
+	# The image contains an BLK inode, with a file extent.
+	# The check should report an error.
+	run_mustfail "unexpected file extent not detected" "$TOP/btrfs" check "$1"
+}
+
+check_all_images
-- 
2.54.0

