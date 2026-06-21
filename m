Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E1AC3B1B4
	for <linux-btrfs@vger.kernel.org>; Sun, 21 Jun 2026 06:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782022402; cv=none; b=EOiac0a/N19fkOcqXsUJvka+zbTaCOJZ1jrBxLo4WumqPYKvF7JlWUhrloTjM3S3XInsrNe4ZnQ8L4ea10E4wzXy6sfyRucK7bOOUeZWYIs4uTc0xqz/aszfn2+Vhw1S1kM85auWAbsqJt5E9uUtWRrPZ33Jiyup8h8rowz/w7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782022402; c=relaxed/simple;
	bh=8jn538n2kPXhT4k3AxeggW74mrrjL4U/HYwe3OpXKOo=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=VdlDWPd9F8uY4PsDs3dWI4W9wAkiiPpGpiTFgl16eOTDFL8LNigW6IzP2A4vEFz2APMdYAFajCxV5ZGAA0bMKPc92rGtAn/GAhJ5GEJ3PLhi0+zaH3FLXq3R6+Yfw4/1zLrJLgfz3zU7VqIud0MYYvfJid2YNFSypgNR6JnrVOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=VD8oLzBf; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=VD8oLzBf; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="VD8oLzBf";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="VD8oLzBf"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 00B7F7004B
	for <linux-btrfs@vger.kernel.org>; Sun, 21 Jun 2026 06:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1782022399; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=KRGUrKEmNt4upKNGc6czWVIlCjolRwhdPI4hbQ7Pvss=;
	b=VD8oLzBfUkEmY/mdKuIxmgHfu9vxODumct0NAsVMFwO4kI2qhVBjaxue3TGLiAtDkpvoER
	lX1eGFnR76GPtlKWStB0DC6QADjakPnKdo1qDY3jFYGGwhurwTPgPvZQsDc7EtTHzDYaAv
	FNN8Jqiu70+ssVljcisFykRLAXKcth4=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=VD8oLzBf
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1782022399; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=KRGUrKEmNt4upKNGc6czWVIlCjolRwhdPI4hbQ7Pvss=;
	b=VD8oLzBfUkEmY/mdKuIxmgHfu9vxODumct0NAsVMFwO4kI2qhVBjaxue3TGLiAtDkpvoER
	lX1eGFnR76GPtlKWStB0DC6QADjakPnKdo1qDY3jFYGGwhurwTPgPvZQsDc7EtTHzDYaAv
	FNN8Jqiu70+ssVljcisFykRLAXKcth4=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E7C9F779A8
	for <linux-btrfs@vger.kernel.org>; Sun, 21 Jun 2026 06:13:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BbHSJP2AN2oJSAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sun, 21 Jun 2026 06:13:17 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs: fix inlined file extent items in data reloc
Date: Sun, 21 Jun 2026 15:42:57 +0930
Message-ID: <cover.1782022263.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 00B7F7004B
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

There is a syzbot report that an inlined file extent item in a data
reloc inode triggered a sanity check in get_new_location().

It turns out that we can create inlined file extents for data reloc
inodes in the first place, which should not happen.

So the first patch will avoid compression for data reloc inodes first,
then the second patch to reject inlined file extent items in
get_new_location(), making the checks more robust.

Qu Wenruo (2):
  btrfs: do not try compression for data reloc inodes
  btrfs: reject inline file extent item in get_new_location()

 fs/btrfs/btrfs_inode.h | 2 ++
 fs/btrfs/relocation.c  | 7 +++++++
 2 files changed, 9 insertions(+)

-- 
2.54.0

