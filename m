Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795849705;
	b=F7GaN+FCurX0KBUs0L/uKcPOwxClKpCCsDPKLHRfgd3vlSqaDxAMbcrCjpuIa3XwivMk
	 pMqmGBUk8OVs+vy5VmYSerhMEJjzdicLlFWPdEk2z3g05rTJPEjaMG7hO7mMMZcmu0vfA
	 OQ8luWW/yUb6+Z+cbFmWBsTfpQtflUUvDhOIkfCjhybuzLgx2AsGIZLZ8MSRS4pzfFXA8
	 veAtHRKQT/kP1xu2yVFkpiFGwSJlo3ste656Xk5b23GAahiSpQPjFMJwYovTsW99PbR8G
	 WDEed3ZgioETxwoZGMtgZ3v6HiRqZbENoLvTQBMjBVn9gMBAM+6wFOYMGR/wkTy4Mew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795849705;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Spamd-Result:X-Rspamd-Server:
	 X-Rspamd-Action:X-Spam-Flag:X-Spam-Score:X-Spam-Level:
	 X-Rspamd-Queue-Id;
	bh=XfEEoSJFgzMetF57SCANOcGdqV62ZCpl7CbllG9K30Q=;
	b=Et0FAklr4BnNFoxc0yrkcaSzEVapquZ4/tspuAPxcH4zo+oTu++h3/It3sF4PAZCE/O5
	 kzuCdlvqwsDeQMqLfKdLdYxQPizuPaHgIl2umWcsp2L4/TuDpVDyS9EjlEdAIPPXpCw4o
	 R0KUFzB9g/lwzVjop9rMEL2MZWx/ZiD+XUp/OWfz7GZFd4l0w5QR/lSps3gV/Ar5yc+8E
	 pwKHvDrg1h5pDtMLlz0nb9UXsVPGXyjqPoBZStlutdUMjNy6fVlxRLtLxOeafd4bGv41Q
	 +Z7fXULLFaxKcVb2r1Lw9N+zZua7XNrDKS7Q/j9Ubm3N6jDpxz99omuIEK6bsZ1NNHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b="QyWl2/tH";
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b="QyWl2/tH";
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D657606A31F;
	Sat, 28 Nov 2026 07:08:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4D657606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=QyWl2/tH;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=QyWl2/tH
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 47FA71F7A9;
	Sat, 28 Nov 2026 07:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795849703; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=XfEEoSJFgzMetF57SCANOcGdqV62ZCpl7CbllG9K30Q=;
	b=QyWl2/tHZ7T42S4o4gBrnisd/R2qtd5aMMxjaH3UXk+h2eSo9S2C1lLCkEGEFd/1oTKmxU
	FktpxmnH88zN2FBPDklY6go3Mfv6KUlOTClskXl86hd2Cc5/Ngth07ComNrkTaE/TmFXZw
	kc+ScqbVkS7EGlg5aSL46ksN3Prig6U=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b="QyWl2/tH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795849703; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=XfEEoSJFgzMetF57SCANOcGdqV62ZCpl7CbllG9K30Q=;
	b=QyWl2/tHZ7T42S4o4gBrnisd/R2qtd5aMMxjaH3UXk+h2eSo9S2C1lLCkEGEFd/1oTKmxU
	FktpxmnH88zN2FBPDklY6go3Mfv6KUlOTClskXl86hd2Cc5/Ngth07ComNrkTaE/TmFXZw
	kc+ScqbVkS7EGlg5aSL46ksN3Prig6U=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7E8D613432;
	Sat, 28 Nov 2026 07:08:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Ktc7M+R9Cmu9OgAAD6G6ig
	(envelope-from <wqu@suse.com>); Sat, 28 Nov 2026 07:08:21 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org,
	workflows@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: [PATCH v2] btrfs: add a maintainer's profile
Date: Sat, 28 Nov 2026 17:37:58 +1030
Message-ID: <ad3da11045fe4a98239a5ad04325b53efa1bc42b.1795849581.git.wqu@suse.com>
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
X-Spamd-Result: default: False [-12.01 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:dkim];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -12.01
X-Spam-Level: 
X-Rspamd-Queue-Id: 47FA71F7A9

Since btrfs already has its own development notes and quick start FAQ
for developers, it's easier to redirect human developers and agents
to there.

It's also easier for us to update the guides based on future feedbacks.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
Changelog:
v2:
- Use the existing developer's FAQ and development notes directly
---
 Documentation/process/maintainer-btrfs.rst | 20 ++++++++++++++++++++
 MAINTAINERS                                |  1 +
 2 files changed, 21 insertions(+)
 create mode 100644 Documentation/process/maintainer-btrfs.rst

diff --git a/Documentation/process/maintainer-btrfs.rst b/Documentation/process/maintainer-btrfs.rst
new file mode 100644
index 000000000000..96cccfa683e3
--- /dev/null
+++ b/Documentation/process/maintainer-btrfs.rst
@@ -0,0 +1,20 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+Btrfs development guide
+=======================
+
+
+There is a quick start FAQ for developers that should always be followed:
+
+  https://btrfs.readthedocs.io/en/latest/dev/Developer-s-FAQ.html
+
+
+For more detailed instructions, see:
+
+  https://btrfs.readthedocs.io/en/latest/dev/Development-notes.html
+
+For humans who want to contribute to btrfs consistently, it's strongly
+recommended to also read the development notes.
+
+An AI agent *MUST* read and follow both documents above before submitting
+a patch.
diff --git a/MAINTAINERS b/MAINTAINERS
index c72a281a8167..26540b018ec1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5838,6 +5838,7 @@ S:	Maintained
 W:	https://btrfs.readthedocs.io
 Q:	https://patchwork.kernel.org/project/linux-btrfs/list/
 C:	irc://irc.libera.chat/btrfs
+P:	Documentation/process/maintainer-btrfs.rst
 T:	git https://github.com/btrfs/linux.git for-next
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-next
 F:	Documentation/filesystems/btrfs.rst
-- 
2.56.1

