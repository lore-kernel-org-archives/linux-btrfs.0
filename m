Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793701227;
	b=gGLi0kSKcdFLTlLi6bxQcsTrS7mfl9KQfQ4+gz1w9AOr+Qdty/1WXKqAAHSHMigPlNj5
	 bFXjVhljIxiMee5D8ec6jI2+wU57/cN2hsLi35mGZrZ1gE8BR6VJ5pbQhFxUHj1KqneYy
	 SxnFhMfXpf9zjGA6Tj3nhPZEglORfoxHY1vUuNM+K6MdlY0evnKq8LM0jEYp3Gtw7Vvrb
	 HLtYGF7s73ak7+3zVbIte+TBKzxoPWSkVmcGcn3y1Z2QrPXCipuTdLmRIPQqzhoa2qLVm
	 XHdVOxTDVYa0vpeqoS40BPQP2IKuMeyBjCkwFxcMfWKPm4v2h3wsFXyMWi0f6OQWr5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793701227;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Flag:X-Spam-Level:X-Spamd-Result:
	 X-Spam-Score;
	bh=iXSW+7B7SdQ9kukXpA6zNMH2geM8SCVf5r0qpHqV0Aw=;
	b=im0pXvQyLTBLgpW48LXDjgGePq0HSbFa9jW8X/ww0OGSmGqWmEw53P0opSLRc134arAB
	 47wOQXz4Es4bf+r6nGLt7GOMgbC9cHnszb99euctkWAahM8LAF+r1Sa0MGop768YNubdS
	 xZSCzZETomL0h6rAgVVkWSzCC9c9WMWyCYdTAZyYz6eNXW2WPbckPI2Ku9IrY5m4LyZ6R
	 g0fYBWeP+Wxcb4gG/mLB7Cu/aHihYZBQ8TfNDuC1va6aHxQVVvg3iOBN7Wp5MYnVgqUlk
	 1//W/Rgy8lG1Q2QUqLJ5wOa+g+fL8epnr3UQCFRn3eW0zNihg5QR6izvIiYwdhnVV6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=NFwKus7c;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=NFwKus7c;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F30606A334
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Nov 2026 10:20:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 17F30606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=NFwKus7c;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=NFwKus7c
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6C13222419
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Nov 2026 10:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793701225; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=iXSW+7B7SdQ9kukXpA6zNMH2geM8SCVf5r0qpHqV0Aw=;
	b=NFwKus7c63gPKEA4qjcIHqFNvWcHhE44gGJ6RwC1jkCv5JE7ub9NupPXJVBvM5VL1a6mbw
	QpOOqPN0aAmaqZleeZX2N3Ztk51/DwWAJJvPqN4XW0GC58wqYUmq5y37nJOC9YwqwsJQC2
	1abfXzudKQrY7W2zzRMm9j5KF1vr8Ak=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793701225; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=iXSW+7B7SdQ9kukXpA6zNMH2geM8SCVf5r0qpHqV0Aw=;
	b=NFwKus7c63gPKEA4qjcIHqFNvWcHhE44gGJ6RwC1jkCv5JE7ub9NupPXJVBvM5VL1a6mbw
	QpOOqPN0aAmaqZleeZX2N3Ztk51/DwWAJJvPqN4XW0GC58wqYUmq5y37nJOC9YwqwsJQC2
	1abfXzudKQrY7W2zzRMm9j5KF1vr8Ak=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 555541350A
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Nov 2026 10:20:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id LthdKme16WpgfAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 03 Nov 2026 10:20:24 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/3] btrfs-progs: fix btrfs_root_item related memory bugs
Date: Tue,  3 Nov 2026 20:50:02 +1030
Message-ID: <cover.1793701174.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
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
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -11.80

https://github.com/kdave/btrfs-progs/pull/1201

There is a security researcher, that exposeed a bug in btrfs root item
reading code, and that bug itself is valid.

So here we're fixing it mostly by introducing a dedicated helper to
handle the possible different sizes of btrfs_root_item.

Unfortunately we can not benefit from tree-checker, as a lot of tools
are designed to skip tree-checker, e.g. btrfs-check --repair can repair
certain item size related bugs, so it must skipping tree-checker or it
can not even open the fs.

The first patch is a small fix noticed during development.
The second one is the main fix related to btrfs_root_item reading.
The last one is two minor fixes related to btrfs_root_item writing.

Qu Wenruo (3):
  btrfs-progs: return error if btrfs_next_leaf() failed in
    do_list_roots()
  btrfs-progs: fix root_item reads which can cause memory bugs
  btrfs-progs: fix two sites that may write beyond root item size

 check/main.c               | 57 ++++++++++++++++++++++++++++----------
 cmds/inspect-dump-tree.c   | 12 +++++---
 cmds/restore.c             | 18 ++++++++----
 kernel-shared/disk-io.c    | 21 +++++++++-----
 kernel-shared/extent_io.c  | 34 +++++++++++++++++++++++
 kernel-shared/extent_io.h  |  3 ++
 kernel-shared/print-tree.c | 16 +++++++++--
 kernel-shared/root-tree.c  |  8 ++++--
 8 files changed, 133 insertions(+), 36 deletions(-)

--
2.56.0

