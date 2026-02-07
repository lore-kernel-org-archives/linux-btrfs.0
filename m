Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02FC72BE657
	for <linux-btrfs@vger.kernel.org>; Sat,  7 Feb 2026 04:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770438944; cv=none; b=RYUMt8KHyNGhWIVpfqvSQ3QTohkIeAqMk7KJr9T48eFLQsJx+Fr22AKxNLoc60+KeUerqkWh+mkpP75BPJMbLFJ2W7IMDghCNRClEXpMUXCVfFJZ1DiMjbqWbmXm6CfwY1IFMV0AXD92MvTANjm4uScsx66k34mmdxypTn1dSpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770438944; c=relaxed/simple;
	bh=HAWrRRNryCnBR1QVFH39aNpxKZfVCxqJdFDy0gzXQtE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VwZURBJ2cEobzVJQQKr/OsKjYGPi/U+YFhUTPDlYQRtPCpQLBi/QWK4tl+Hj3l/SFONRbtucsvJqVhj3YHL/jyY28Rt9zAsS2PYejCImvBU/nvM93LDYXpMWLcO/g7aB+8VrJeWlg/91GFOP0INABMSvY1VR2+GG4cT/ZVBFHsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=DcoJRwz/; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=DcoJRwz/; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="DcoJRwz/";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="DcoJRwz/"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 20DB83E6CD;
	Sat,  7 Feb 2026 04:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1770438942; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=1yHClctTzv367wW03OQKcVlDjfI0sotwdQk6C+RKPgg=;
	b=DcoJRwz/ejULz+GTIm9f1822sfsXMVcnruUnYhy8Ou7lfCpbSno7L23nOEPUwGTutlZcpH
	mkqznhzpQc/QjJUPi7Ufc7Paky3k/25ScVsVCEDaEp5FarEWWDe4tILmi/GErQBmdMYcFs
	Ij/NC26K6T406hBa84Kt3wHPRsq840k=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1770438942; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=1yHClctTzv367wW03OQKcVlDjfI0sotwdQk6C+RKPgg=;
	b=DcoJRwz/ejULz+GTIm9f1822sfsXMVcnruUnYhy8Ou7lfCpbSno7L23nOEPUwGTutlZcpH
	mkqznhzpQc/QjJUPi7Ufc7Paky3k/25ScVsVCEDaEp5FarEWWDe4tILmi/GErQBmdMYcFs
	Ij/NC26K6T406hBa84Kt3wHPRsq840k=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 100EC3EA63;
	Sat,  7 Feb 2026 04:35:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id RDZ2MBzBhmm0LQAAD6G6ig
	(envelope-from <wqu@suse.com>); Sat, 07 Feb 2026 04:35:40 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Christoph Anton Mitterer <calestyo@scientia.org>
Subject: [PATCH] btrfs-progs: docs: add a note for clear_cache mount option
Date: Sat,  7 Feb 2026 15:05:22 +1030
Message-ID: <bac89ac52147344ab6244beef8c0085552a3aacb.1770438921.git.wqu@suse.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[scientia.org:email,imap1.dmz-prg2.suse.org:helo,suse.com:mid,suse.com:email];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

There is a report that "clear_cache,space_cache=v2" mount option didn't
rebuild the free space tree.

It turns out that the reporter was relying on the fstab to do the mount,
and the fstab has specified "ro" mount option. This prevents btrfs to
enter btrfs_start_pre_rw_mount() thus no free space tree rebuilding.

Add such note to avoid future confusion.

Reported-by: Christoph Anton Mitterer <calestyo@scientia.org>
Link: https://lore.kernel.org/linux-btrfs/f094ddbb70cabd2e329615269519b1844f786629.camel@scientia.org/
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 Documentation/ch-mount-options.rst | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/ch-mount-options.rst b/Documentation/ch-mount-options.rst
index 60f8570e9d1a..8f65b8311e7e 100644
--- a/Documentation/ch-mount-options.rst
+++ b/Documentation/ch-mount-options.rst
@@ -73,6 +73,7 @@ barrier, nobarrier
 clear_cache
         Force clearing and rebuilding of the free space cache if something
         has gone wrong.
+        This option only takes effect on the first read-write mount.
 
         For free space cache *v1*, this only clears (and, unless *nospace_cache* is
         used, rebuilds) the free space cache for block groups that are modified while
-- 
2.52.0

