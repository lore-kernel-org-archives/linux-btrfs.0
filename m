Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93EC93C2F
	for <linux-btrfs@vger.kernel.org>; Sun, 22 Feb 2026 23:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771802015; cv=none; b=niJ9Awdd+HtgfvhyCM2pm6Ee3LvE25uRqGUZf6dHZIm5OyDl3Hyvg9QfbhG+zbGLJmm0whp7I78MJ0n1VOB2XMQ3Eb8vzORGE4+vFC13kmm1VeWXiSSAbEWw7BLrfGak0MshuKvPkCV4tKUgGFYjTWk73jcSVuoHruXWLvdZSeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771802015; c=relaxed/simple;
	bh=1Sr8vAgHffPsPcDhFMRggh9AvNDffcMeS4IPHjjADGk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fR+TCxNMIMkSEHSwtt9LF+zM7+t7Yb3XAgNMztuEXAsauROuSnVa9VBy7AUae0wxFyAgTquFPBkJuZDqrI1BKnm3zO99PTi392GWP01VyRbnEIxvES5wAqGsdwOzml3QOl8LKb0Nwgp3rAbOeUQt1mKyHQnOjqIyW0h8i3kWM2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=QOmLkIrp; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Rf9jSlbP; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="QOmLkIrp";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Rf9jSlbP"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EE7EA3E962
	for <linux-btrfs@vger.kernel.org>; Sun, 22 Feb 2026 23:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1771802011; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+fu3muSX3Fp1RZzYmjDQ8arf2jObpNVHAPGemrE56ns=;
	b=QOmLkIrpBiRZX1cALOfGHTeDsf0JjG7WFZRQL45lpaYtu0vjKGWzATIMDkLB9/2/nonCTZ
	CltTGkydnA88WeQBSgtTpTTVnaiSMbhrO9ej45MZneZWqNwJGuzvWcMapvTLpZqqZsvY/H
	wHfdpTmGPwen4TyaZWBaxNSqklZhX/0=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1771802010; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+fu3muSX3Fp1RZzYmjDQ8arf2jObpNVHAPGemrE56ns=;
	b=Rf9jSlbPwPRoJTYHT7XjVhHO4wwIsUZDlcefhAtaZ9yG75b8gPviTlGo1xj/sAghMhUtLP
	GvHNs1fs6qdQGJUMC95qz51759SI1R+8/DcdT5N0OTkcjpOKfqG+MfRlhPOfZhM5sxJbdp
	Zq+xvNz7zo6+Vwe5C3PyxHVROH/Fv5M=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2B49A3EA68
	for <linux-btrfs@vger.kernel.org>; Sun, 22 Feb 2026 23:13:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iNmJN5mNm2n0NwAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sun, 22 Feb 2026 23:13:29 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] btrfs-progs: drop the 'const' qualifier from bconf_save_param()
Date: Mon, 23 Feb 2026 09:43:00 +1030
Message-ID: <3627dacff11c0f84b269cd0c7d07a3bdf4843c91.1771801832.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1771801832.git.wqu@suse.com>
References: <cover.1771801832.git.wqu@suse.com>
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
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:email,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

[BUG]
The latest GCC (15.2.1) will report the following warning:

 common/utils.c: In function 'bconf_save_param':
 common/utils.c:975:13: warning: assignment discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
   975 |         tmp = strchr(str, '=');
       |             ^

[CAUSE]
I believe the latest GCC has a more strict const qualifier checks, that
any returned pointer that points into a const pointer should also
have a 'const' qualifier.

But in this particular case, we're even modifying the content of the
original const string.

This means we shouldn't really have 'const' qualifier for
bconf_save_param() in the first place.

[FIX]
Drop the 'const' qualifier from @str parameter, as we're going to modify
the string in that function.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 common/utils.c | 2 +-
 common/utils.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/common/utils.c b/common/utils.c
index f183705edb8f..59e318282918 100644
--- a/common/utils.c
+++ b/common/utils.c
@@ -968,7 +968,7 @@ const char *bconf_param_value(const char *key)
 	return NULL;
 }
 
-void bconf_save_param(const char *str)
+void bconf_save_param(char *str)
 {
 	char *tmp;
 
diff --git a/common/utils.h b/common/utils.h
index 1419850df387..d0bd062b75a5 100644
--- a/common/utils.h
+++ b/common/utils.h
@@ -118,7 +118,7 @@ void btrfs_config_init(void);
 void bconf_be_verbose(void);
 void bconf_be_quiet(void);
 void bconf_add_param(const char *key, const char *value);
-void bconf_save_param(const char *str);
+void bconf_save_param(char *str);
 void bconf_set_dry_run(void);
 bool bconf_is_dry_run(void);
 const char *bconf_param_value(const char *key);
-- 
2.53.0

