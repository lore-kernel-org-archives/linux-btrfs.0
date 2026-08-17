Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA81252917
	for <linux-btrfs@vger.kernel.org>; Mon, 17 Aug 2026 02:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786932815; cv=none; b=ilQJYmbNPiISdjsiq8Ka9/r5ZqBDVlbvrWXaROjdzDJ5XqYTLpLAtUfgk8/QmCDqyK9ODInsTVuIhVqMraL1oj6HWxz2C7ua0Oo+HQdYSBUApOL/bFxPvkYVWCuNWdoDqMu7OrUzZbZ/c6LjdsiHOV6BGIBDf063hscLMo+58do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786932815; c=relaxed/simple;
	bh=V611fPKAht4oKWZCZVnoxi0k8aHF4FdM3cPk7rAaXUg=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=raBuko7NPXHSfmyMgFSLKxaVJXqyLF7QS3Mi5hqD1Yc19B7IkihoV7JGRoUsW02PJ4DmU0CJJEqBELNzsPEUSIgg+4JB5qeukBtir9EWoXw+qBcitgB9vcM9BrKY4NA3J/4PAoKl2GB3CaD0vZtqTVvBLKNiUBTVyiUxvC7gjD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Dob01epH; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=WnJsvj28; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Dob01epH";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="WnJsvj28"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E59FF83D7F
	for <linux-btrfs@vger.kernel.org>; Mon, 17 Aug 2026 02:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1786932802; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=k2teW1/t0fWAL4KSdKU59QWKAVHU82CYNadHDEFbZss=;
	b=Dob01epHhVns3n0q0e4m1l7HSV0XKouxibCxOupYaN7/yJh9zdQQOD3cc1vXUT1wWqHUQU
	Hx6cMmNHBPEgWJ0HuSafsNc7+D1wFHTIE/mKE41Nmosg3Ddx+ZitUqnVWZ43d3MWe4u6E1
	7GrNUiCKnVx9dpBDseWq17BUV7RXqPM=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=WnJsvj28
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1786932797; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=k2teW1/t0fWAL4KSdKU59QWKAVHU82CYNadHDEFbZss=;
	b=WnJsvj28Q06GZkoafda9Ro2kBRxyyRa3se6+4RndSrtYX2xPhlAeecvRivm8dSuc5cZq6p
	FUR9c4ti+r3KlqjcjyMsyDLon4D1wHj9EyuZSxaW4RGXoL6n7uUbUG4cZH/t9m5CZKcfCW
	G7ScoGDCsJTiE3byW+XEv0Zs90MkwPc=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CE8737920A
	for <linux-btrfs@vger.kernel.org>; Mon, 17 Aug 2026 02:13:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ZgsOHTxugmqFKQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 17 Aug 2026 02:13:16 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: docs: add extra LLM disclosure following kernel guidelines
Date: Mon, 17 Aug 2026 11:42:57 +0930
Message-ID: <705d903a42cea12a09f0e25e8f7bd817c89a9937.1786932754.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: E59FF83D7F
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_EQ_ENVFROM(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:email,suse.com:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

There are increased LLM assisted bug fixes in the mailing list, and I
have a very strong feeling that most of the new bug fixes from unknown
developers are at least assisted of LLM, and they never properly
disclose the usage of LLM.

I don't know much difference such updated docs will make, but at least
let's try to make them disclose the LLM usage.

Assisted-by: LLM (grammar fixes)
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 Documentation/dev/Developer-s-FAQ.rst | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/dev/Developer-s-FAQ.rst b/Documentation/dev/Developer-s-FAQ.rst
index f258a6cca879..e8febb7af9da 100644
--- a/Documentation/dev/Developer-s-FAQ.rst
+++ b/Documentation/dev/Developer-s-FAQ.rst
@@ -36,6 +36,10 @@ highlight the most frequently used tags and their expected meaning. This only
 briefly mentions the commonly used tags. You're encouraged to read the whole
 document and get familiar with it.
 
+With the recent increased flow of LLM-assisted bug fixes, please also follow the
+kernel documentation at https://docs.kernel.org/process/coding-assistants.html to
+properly disclose LLM usage for every patch.
+
 Signed-off-by:
 ^^^^^^^^^^^^^^
 
-- 
2.54.0

