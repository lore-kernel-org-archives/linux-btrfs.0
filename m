Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BB0032B10D
	for <linux-btrfs@vger.kernel.org>; Fri,  3 Jul 2026 09:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783071998; cv=none; b=DsSGYJBaShAVptihW6EKJ+e7ZCASsQwD7HptYEVLLETJvhP+CBKVs+u/TrKPS5c5cTMmGEZ4bQpyNQdeT12ZevanvJV0NGWifHhSMHKg/DJcijs9Vf2SAUvSmMCpzAf9sOcDMytTA5NUISNrBsTxT9QBE9NPCAQtkQxebW4jRVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783071998; c=relaxed/simple;
	bh=e516ZHakdGeJITsqJmjj/1i8+Uu0a/u3WBAM4nYGBQY=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=SpTDBxaALMsMcvzbjT4hR5UhBeFoCnPMMvSl5aiGwyL9fojGNdOtxiZ16aThkenQca85WgbR5IfXX0bHuXg9EinZ/AzB3hzWyXG4/g//8kdHOZr3VIz7uXqh74p7g2YzTFI0zZ8fLqr78hOhLUSEEHDZL3OakYKnRUMjkjkgpQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=g4p/5gyJ; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=g4p/5gyJ; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="g4p/5gyJ";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="g4p/5gyJ"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 770E5747FF
	for <linux-btrfs@vger.kernel.org>; Fri,  3 Jul 2026 09:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783071995; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=J7A6IoBBUe+A60cp1NG8I3XdR8guKlRhIIZh4qZ6uLk=;
	b=g4p/5gyJsNjjFLmYvONOlZnWCK9/mylwMl3vwAg9jcm9t3DDWSw9r3EIHy+HAgVm3SAwsj
	YE5/aBF6ZX+QSVkfAekaAGRUT1Q8UzIbKMMiz3h9LLHaaSSF/QAxP5EJbzV5kDUTXXJmPh
	WCz6i5GyDowyLMijPsJn8pWhfgU0mVo=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b="g4p/5gyJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783071995; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=J7A6IoBBUe+A60cp1NG8I3XdR8guKlRhIIZh4qZ6uLk=;
	b=g4p/5gyJsNjjFLmYvONOlZnWCK9/mylwMl3vwAg9jcm9t3DDWSw9r3EIHy+HAgVm3SAwsj
	YE5/aBF6ZX+QSVkfAekaAGRUT1Q8UzIbKMMiz3h9LLHaaSSF/QAxP5EJbzV5kDUTXXJmPh
	WCz6i5GyDowyLMijPsJn8pWhfgU0mVo=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 80854779AA
	for <linux-btrfs@vger.kernel.org>; Fri,  3 Jul 2026 09:46:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Rx6eDPqER2rdBAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 03 Jul 2026 09:46:34 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 0/3] btrfs: small changes to "usebackuproot" mount option
Date: Fri,  3 Jul 2026 19:16:05 +0930
Message-ID: <cover.1783071857.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	DWL_DNSWL_BLOCKED(0.00)[suse.com:dkim];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:mid,suse.com:dkim]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 770E5747FF
X-Spam-Score: -3.01

[CHANGELOG]
v3:
- Add "rescue=usebackuproot" into full RO mount options
- Minor grammar updates

v2:
- Also include "rescue=usebackuproot" into "rescue=all" shortcut

"rescue=usebackuproot" mount option is not requiring a read-only mount,
which is different from all the other options in the "rescue=" group.
Address that in the first patch.

Then also include "rescue=usebackuproot" into "rescue=all" group, done
in the second patch.

Standalone "usebackuproot" mount option is already marked deprecated
since v5.9, I see no practical reason to keep supporting it in 2026.
Just remove it in the last patch.

Qu Wenruo (3):
  btrfs: add "rescue=usebackuproot" into forced read-only options
  btrfs: add "rescue=usebackuproot" into "rescue=all" shortcut
  btrfs: remove "usebackuproot" mount option

 fs/btrfs/fs.h    |  3 ++-
 fs/btrfs/super.c | 16 +++-------------
 2 files changed, 5 insertions(+), 14 deletions(-)

-- 
2.54.0

