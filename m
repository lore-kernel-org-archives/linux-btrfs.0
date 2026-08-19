Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75122450401;
	Wed, 19 Aug 2026 10:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787135326; cv=none; b=en+v0823l+QaFqMB3SSLYW7/ONVKrTGJPv4ZLG1sgGAnWSh81htFCzqESfo3vdsOmXJHqXTplSoXk/EXRmxoS4I8sLuSemm1ZjgNijfypUQaRgWwh580TlRjDaVfwTOR73lLfpNQxTTLdA2ZnJvxCXHhHj1QegXQMoqyQVCeNyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787135326; c=relaxed/simple;
	bh=zVmSDHdE5JKqVkvjCLePnlTV8G+0E9VGzB9XqAWQYWo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CEfp4cVvtErv7JAqT52LxNy/Jkw4IB7PN+g4H6n1Yl1QugXZfGjZrrhVI1bWMEYMjNQ4R7De23bnApb+xLlWZD70+J8t6cTQ1PhGhWnch+hBlQLDRRCH0mNcffzi30FiAxbBiTZEHTHPjur3Ak1gCmADNh8ONrX9tdc5yVFiOd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=h7YZ8Qnw; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=NDB3kHs0; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="h7YZ8Qnw";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="NDB3kHs0"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 59EEF3E54;
	Wed, 19 Aug 2026 10:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1787135317; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=L3KF3faTKdChT02SsHQBOObW0E5A9vzaaClcNuc09aE=;
	b=h7YZ8Qnw2pABbze5Cevt4ZhGcKN3VUpszqnodWZysOOlHdyD0hsJcCvuzp3RgbwXfYlwir
	aIw1Bn++7PYyswtMWBz4vGWneMTw47gc8CC4UqRSRIMsT1h/BZndYT69JLjZ33pzz7ODj4
	ezp76RuvgV0VILttRdWu/AmtHsfMKFQ=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1787135313; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=L3KF3faTKdChT02SsHQBOObW0E5A9vzaaClcNuc09aE=;
	b=NDB3kHs0QliJk7O25ejKNTmOVxF0hugRKyPtSh2O2OKRxOO86/8NjFCJraeHSrv5MGDRGl
	UblRUalJ+bm3rWkx1CqhwunUvz4dWNPYLVrrRWi0ltmeGTx2LztAlD6rdd1dJcNZIRZPx+
	C+NBK1rQTx3/0s0gFf4GVvn8kbCZ32w=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4EEC7362E;
	Wed, 19 Aug 2026 10:28:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wyE+E1GFhWomFwAAD6G6ig
	(envelope-from <dsterba@suse.com>); Wed, 19 Aug 2026 10:28:33 +0000
From: David Sterba <dsterba@suse.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	David Sterba <dsterba@suse.com>
Subject: [PATCH] MAINTAINERS: update btrfs git tree entries
Date: Wed, 19 Aug 2026 12:28:27 +0200
Message-ID: <20260819102828.3220130-1-dsterba@suse.com>
X-Mailer: git-send-email 2.55.0
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
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[btrfs.readthedocs.io:url,imap1.dmz-prg2.suse.org:helo,suse.com:mid,suse.com:email];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

Add new entry pointing to the development branch so e.g. sashiko can
pick it as the baseline. The other entry is for linux-next and slightly
behind.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 MAINTAINERS | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 58a0875d4f01..c9ee9dbb657d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5623,7 +5623,8 @@ S:	Maintained
 W:	https://btrfs.readthedocs.io
 Q:	https://patchwork.kernel.org/project/linux-btrfs/list/
 C:	irc://irc.libera.chat/btrfs
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git
+T:	git https://github.com/btrfs/linux.git for-next
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-next
 F:	Documentation/filesystems/btrfs.rst
 F:	fs/btrfs/
 F:	include/linux/btrfs*
-- 
2.55.0

