Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAFFC4534A2
	for <linux-btrfs@vger.kernel.org>; Thu,  7 May 2026 18:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778176804; cv=none; b=uHAVMM7ahTHDzZgq/ztIsp2ROGudH/QGb+ZlCcz547xWvcLtEB5pZitcupcdGFMG2ht7MKAl8MMz3kkTltqNBIERCky2y9Udnb9gyTL6qtpHbxccbt/tSI6zuLyi4MSzNcVxVoQcGqednEPhl497LyhNimZseCTS1dvO3FK0gJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778176804; c=relaxed/simple;
	bh=bXQ89AHkVyK+B0PCeA8iNWn3QMVh3eLJlGS8usybm7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PwMPvBK3YbW7IzDKhrVI4wIKoGhZxGO4f0d8I54efKY6HyPaEanvn9qn/EPvkh+RtzapVrHpfJkODwErpuQx9gY2hccOsy8hjiW9uoaHrTtEJ8dPb1FqXXfCiUgHwV3nkrFs28B+R+/1lSnXSqH/DeGl/7l0hq8tJq6scMINHB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=a4SKFGdv; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=a4SKFGdv; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="a4SKFGdv";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="a4SKFGdv"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AE2F55C724;
	Thu,  7 May 2026 18:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778176800; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a1cSD5aT6UBCIOyBQp993EV7VXkHzn73rYcfgYITV7E=;
	b=a4SKFGdvydC7fLZMj/8sXjwkSd9ykWVA4kr/ys7XATkkGz6z+RJyM3BTQ+UFoP2RFNaTgH
	vBddyQi9JOjrfHuyF4i2xDNkNQjXL5Qf49WIVr4iga9wnq/+PsVw5CcIaA+Z/1kKAytvCq
	kgpkZBwkjeUI6MqkR3Z+ufw+DKRogVI=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=a4SKFGdv
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778176800; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a1cSD5aT6UBCIOyBQp993EV7VXkHzn73rYcfgYITV7E=;
	b=a4SKFGdvydC7fLZMj/8sXjwkSd9ykWVA4kr/ys7XATkkGz6z+RJyM3BTQ+UFoP2RFNaTgH
	vBddyQi9JOjrfHuyF4i2xDNkNQjXL5Qf49WIVr4iga9wnq/+PsVw5CcIaA+Z/1kKAytvCq
	kgpkZBwkjeUI6MqkR3Z+ufw+DKRogVI=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A77EE593A7;
	Thu,  7 May 2026 18:00:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ehHgKCDT/GkKCQAAD6G6ig
	(envelope-from <dsterba@suse.com>); Thu, 07 May 2026 18:00:00 +0000
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH v2 1/2] btrfs: validate negative error number passed to btrfs_abort_transaction()
Date: Thu,  7 May 2026 19:59:31 +0200
Message-ID: <922da1b5b5bb4daaa55df0be99e48b2685c67751.1778176579.git.dsterba@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1778176579.git.dsterba@suse.com>
References: <cover.1778176579.git.dsterba@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Queue-Id: AE2F55C724
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Score: -3.51

In preparation to encode more information to the error value add a step
that verifies if the value is valid (i.e. < 0). This works for
compile-time and runtime (in debugging mode).

The compile-time check recognizes direct constants and defines an array
type. An invalid condition leads to negative array size which is caught
by compiler.

The runtime check constructs the array type from the condition and only
verifies the correct size, as we don't need to tweak the size to be
negative.

The sizeof() expressions do not generate any code. In the debugging
config the warning adds about 9KiB of btrfs.ko code size.

The array size trick is needed as we can't use static_array(), not even
with __builtin_constant_p().

Sample error message:

In file included from inode.c:40:
inode.c: In function ‘__cow_file_range_inline’:
transaction.h:261:26: error: size of unnamed array is negative
  261 |         (void)sizeof(char[-!(__builtin_constant_p(error) ? (error) < 0 : 1)]);  \
      |                          ^
transaction.h:275:9: note: in expansion of macro ‘VERIFY_NEGATIVE_ERROR’
  275 |         VERIFY_NEGATIVE_ERROR(error);                           \
      |         ^~~~~~~~~~~~~~~~~~~~~
inode.c:665:17: note: in expansion of macro ‘btrfs_abort_transaction’
  665 |                 btrfs_abort_transaction(trans, 17);
      |                 ^~~~~~~~~~~~~~~~~~~~~~~

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/transaction.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index f1cb05460cec..72ab32c8ddca 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -242,6 +242,29 @@ static inline bool btrfs_abort_should_print_stack(int error)
 	return true;
 }
 
+/*
+ * Compile-time and run-time verification of error passed to transaction abort.
+ * Direct constants will be caught at compile time, errors read from variables
+ * can be caught only at run-time and will warn under debugging config.
+ *
+ * How verification works:
+ * - accepted builtin constants are all -EIO and such
+ * - for compile-time check, invalid condition produces a negative-sized array
+ *   type, valid zero-sized
+ * - when a variable is passed as error the first check is a no-op
+ * - with enabled debugging, the second array type size is constructed from the
+ *   real variable value, valid condition produces array of size 1
+ * - sizeof(type) does not generate any code
+ */
+#define VERIFY_NEGATIVE_ERROR(error)						\
+do {										\
+	(void)sizeof(char[-!(__builtin_constant_p(error) ? (error) < 0 : 1)]);	\
+	if (IS_ENABLED(CONFIG_BTRFS_DEBUG)) {					\
+		if (sizeof(char[(error) < 0]) != 1)				\
+			DEBUG_WARN("error >= 0 passed to btrfs_abort_transaction()"); \
+	}									\
+} while(0)
+
 /*
  * Call btrfs_abort_transaction as early as possible when an error condition is
  * detected, that way the exact stack trace is reported for some errors.
@@ -249,6 +272,7 @@ static inline bool btrfs_abort_should_print_stack(int error)
 #define btrfs_abort_transaction(trans, error)		\
 do {								\
 	bool __first = false;					\
+	VERIFY_NEGATIVE_ERROR(error);				\
 	/* Report first abort since mount */			\
 	if (!test_and_set_bit(BTRFS_FS_STATE_TRANS_ABORTED,	\
 			&((trans)->fs_info->fs_state))) {	\
-- 
2.53.0

