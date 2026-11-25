Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795582006;
	b=Lbr1XMQVPojUZj/NyBLSO1j19h2DiR9dDKnbh+uhddxTt++KgkOw8tLZChosobS/FzDP
	 j7Rvjf2FLQauKVmgcscuwE2O1holjsS3Sxt1h3TUKORTNu0XGqDwO9gglSp8/w4zXB501
	 v9AiJwhYOwqFPB1PQU4c6RQaJ45Wz1n5Oi1HjruVpei6T62baB5ujgVy6RC1AxqvIpm/L
	 WudrPHSxEGAcSKXfbEDEYeJGXBvwbrX2IqvCgQSqt1XHhfuLo4Fqs/SGLq1asB+/alBMh
	 2zHmyMmubRj7bnr39TMZ6G5TtEPTLr/CpRXEc22CjSBAEF+XN2/fPa7eIc4zy43SJsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795582006;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Flag:X-Spam-Level:X-Spamd-Result:
	 X-Spam-Score;
	bh=pANba8wl/OyGTtYYVOpmrlRZMgySE6JCgtNDwnH0y/k=;
	b=ZZ8g0xZgbazTxzszk5HTvGL9xAhhpOuaQmeNwdM6wAuXoZPVyP5t1Yo+ywiiCviJpt8l
	 2/W4hLT8yrCPowtipRne0NAGXcl1Vc/gz1QCmSU2ay4HF1yDukUOtpcXd5yvgBVksLz3H
	 r8gFtWT7FuZzjtMACHFtHOqTgsS059soFIrjyFXxCUIOfrbdxTx/mlspGCw7r/3Oh6Up+
	 oLhW+aSzjaRPTKeaExiUyuRjnFxKEPAnJYb9NzS4f2Oq3wf1CV2vCh3OoaIXte1qvOfb8
	 mIPG+HJ+kDjqkoo9mbTh26Gn61UqelL7UYWwQZK8BgsJSmNlUUfraZbUWB7EDECAw+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=UNMtE80R;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=M1BTdAXO;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57460606A31E;
	Wed, 25 Nov 2026 04:46:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 57460606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=UNMtE80R;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=M1BTdAXO
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3840E223A1;
	Wed, 25 Nov 2026 04:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795582003; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=pANba8wl/OyGTtYYVOpmrlRZMgySE6JCgtNDwnH0y/k=;
	b=UNMtE80RBUDC9kO2+x0EegfMLyZ5Yp5xQv60znaH2AbtAZrdr/u3vWJjLRuEmsHmlxFqUc
	QVpgY0DKWvi/6APbX07O/qrSJBoWLIctFePIqYDLJTBJG/+7L2uaLHU5yFrIac4f8ppZYg
	54lEtH2FO9yINrhGtV0N8EJrIp0Hy70=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795582002; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=pANba8wl/OyGTtYYVOpmrlRZMgySE6JCgtNDwnH0y/k=;
	b=M1BTdAXO/3vAaHaPJ2yJL6J4bQgRJhXW1CgSaINIPFMVBITqHjsXY2+/QHTzN8oz4EIWN3
	/5vNuDQcXh7UNYI3VCEw3Msz7AoZuP6l7fzfR7r6lmt3vgwQhN+Nd9XfGyNhpeJFcB/2ui
	4VwYHnxxPcQK5M+1Q1jeGSE+577IAeY=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 44548134CA;
	Wed, 25 Nov 2026 04:46:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id JCM2Iy9oBmuHDAAAD6G6ig
	(envelope-from <wqu@suse.com>); Wed, 25 Nov 2026 04:46:39 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org,
	workflows@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: [PATCH] btrfs: add a maintainer entry profile
Date: Wed, 25 Nov 2026 15:16:21 +1030
Message-ID: <0037554862c0d9dce3ddafd1238347e4b16a5079.1795581896.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.1
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
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-11.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.997];
	MIME_GOOD(-0.10)[text/plain];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sashiko.dev:url,btrfs.readthedocs.io:url,imap1.dmz-prg2.suse.org:helo,suse.com:email,agent.md:url];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -11.80

This new file is mostly based on my personal preferences, focusing on
how to improve the human readability in the LLM era.

The new file should also act as a guide for humans that want to be a
long term contributor to btrfs.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
Changelog:
RFC->v1:
- Use maintainer entry profile instead of agent.md

- Further simplfy the content for human readers

---
 Documentation/process/maintainer-btrfs.rst | 154 +++++++++++++++++++++
 MAINTAINERS                                |   2 +
 2 files changed, 156 insertions(+)
 create mode 100644 Documentation/process/maintainer-btrfs.rst

diff --git a/Documentation/process/maintainer-btrfs.rst b/Documentation/process/maintainer-btrfs.rst
new file mode 100644
index 000000000000..5170dd73e655
--- /dev/null
+++ b/Documentation/process/maintainer-btrfs.rst
@@ -0,0 +1,154 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+Btrfs patch guidelines
+======================
+
+Human readability comes first. A reviewer should be able to understand the
+problem and the fix from the message and code.
+
+Bloated LLM-generated information only wastes precious human time, no matter
+whether it is in a comment or a commit message.
+
+Code comments
+-------------
+
+* **Necessary comment only**
+
+  Comment is for things that are not obvious by itself, e.g. a locking
+  rule, an ordering requirement or a non-trivial reason for a workaround.
+
+  Keep the comment short if possible.
+
+  Don't repeat what the code does.
+
+* **Add kernel-doc only for complex and/or exported functions**
+
+  If the function and parameter names are self-explaining, don't waste words
+  on the kernel-doc.
+
+Commit messages and cover letters
+---------------------------------
+
+* **Keep it simple**
+
+  Use short and simple sentences, avoid long paragraphs.
+
+  Simple patch for simple bug. Don't write a full [BUG] [CAUSE] [FIX] analysis
+  for something like a simple error handling enhancement.
+
+  And we don't care how you or your LLM found the bug unless it's hit in the
+  real world, so don't put such information even after the "---" line.
+
+* **Prefer visual aids over long sentences**
+
+  See "Visual aids" section below.
+
+* **Follow the style of well-known btrfs developers**
+
+  Check ``git log -- fs/btrfs`` for recent examples before drafting.
+
+Visual aids
+-----------
+
+Prefer visual aids like an ASCII chart over words, e.g.:
+
+* A race. Show the race window, do not describe it in prose only.
+* An error handling bug in a function, seen from several call sites.
+* A call chain across layers, where the bug only shows on a certain path.
+
+Example, a race::
+
+   CPU0 (endio)                       CPU1 (fsync)
+   end_bbio_data_write()
+   |-btrfs_folio_clear_writeback()
+   |                                  btrfs_sync_file()
+   |                                  |-filemap_fdatawait_range()
+   |                                  | Returns after writeback finished
+   |                                  |
+   |                                  \-test_and_clear_bit(COW_WRITE_ERROR)
+   |                                    Still 0, skips waiting
+   \-set_bit(COW_WRITE_ERROR)
+     Too late.
+
+Example, an error handling bug, from commit c9583ada8cc4. The callee cleans up
+on error, then the caller cleans up again::
+
+   btrfs_do_readpage()
+   |-submit_extent_page()
+   | \-submit_one_bio()
+   |   \-btrfs_submit_data_bio()
+   |     \-bio_endio()
+   |       Calls end_page_read() and unlock_extent().
+   |
+   \-end_page_read() and unlock_extent()
+     Cleaned up again, the subpage reader count underflows.
+
+Versioned patches
+-----------------
+
+* **Full history**
+
+  Include all versions, not only the changes of the last version.
+
+* **Newest version first**
+
+  E.g.::
+
+    v3:
+    - Rename the helper to xxx()
+    - Add a missing lock in yyy()
+
+    v2:
+    - Fix the build failure on 32-bit
+
+* **Changelog location**
+
+  Put it in the cover letter for a patch series, or after the "---" line for
+  a single patch.
+
+  Don't put it in the commit message body.
+
+Review
+------
+
+* **Follow the review**
+
+  Don't send a patch and just forget it. If you're not a well known developer,
+  it's uncommon to get merged on the first try.
+
+  One will need to communicate with the reviewers to get at least one review
+  from a well known btrfs developer, before getting the patch merged.
+
+* **Check Sashiko**
+
+  Sashiko posts AI-generated review for patches sent to the mailing list. The
+  btrfs list is at https://sashiko.dev/#/?list=org.kernel.vger.linux-btrfs
+
+  If a report is valid, address it in a newer version.
+
+  If a report is obviously wrong, it can be ignored. If the report is wrong but
+  the reason is not obvious, explaining it on the mailing list can help.
+
+Testing
+-------
+
+* **Run full fstests**
+
+  That's the main test suite we use.
+
+* **Testing procedures and results are only for complex patches**
+
+  Simple fixes shouldn't need a long paragraph on how to verify the fix.
+  Those simple fixes should be explained well by the commit message and code.
+
+  Bloated LLM-generated test procedures and results only waste human time.
+
+Before sending a patch
+----------------------
+
+* **Check the development branch**
+
+* **Check the mailing list**
+
+If your bug was found by an LLM, someone else may have already found, or even
+fixed, it.
diff --git a/MAINTAINERS b/MAINTAINERS
index 44540a1eb2b8..55f0b3dca133 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5838,9 +5838,11 @@ S:	Maintained
 W:	https://btrfs.readthedocs.io
 Q:	https://patchwork.kernel.org/project/linux-btrfs/list/
 C:	irc://irc.libera.chat/btrfs
+P:	Documentation/process/maintainer-btrfs.rst
 T:	git https://github.com/btrfs/linux.git for-next
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-next
 F:	Documentation/filesystems/btrfs.rst
+F:	Documentation/process/maintainer-btrfs.rst
 F:	fs/btrfs/
 F:	include/linux/btrfs*
 F:	include/trace/events/btrfs.h
-- 
2.56.1

