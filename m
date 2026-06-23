Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28C5929ACC6
	for <linux-btrfs@vger.kernel.org>; Tue, 23 Jun 2026 11:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782214658; cv=none; b=iI+wXaoF0zaIC8t7PFkddIOokkHmGeNOKAUR/taFrcdzojLS3qITB3wj+gK1JTjO2OFUsdK5kEAY1ahV0QeElTyyFoFZXXDFnCdiEaN4I9FidBfp5gxn4+hW56hyIDls7zrInJ5EEOspeQHINddsLw+03Ob+V42bTr4C+Ir/1NY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782214658; c=relaxed/simple;
	bh=HloEVeqNzgsbnHuqe0biBcv1M5AFa1wTbHQuZUrEBsM=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=mqTAYbvofYnBLROQZMeNaVOI8/ASx8xEON4B1gWxmzatUyrnljpdcXTRibJ1bF88ZJX+7BpV/lC1Dwx3ZvMYC0GVOuLsdF6+25xMBApQ8Hehp96fEykJOVmNlcfou5kCEnAmFWwTHPPw86stYzUvnb+njxofoQRn7TqH6TGGAOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=dG2HrJkt; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=dG2HrJkt; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="dG2HrJkt";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="dG2HrJkt"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 655FD75E78
	for <linux-btrfs@vger.kernel.org>; Tue, 23 Jun 2026 11:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1782214655; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=q+ujLuEJrFEHTfv1e0eodePZZ2+R/2Id2toRBkHwzk4=;
	b=dG2HrJktMUgxW6aJr6ial7hN+dXyiExYv2ilzV+cLzIHT5YYAh+2ht886ga3zjNK4lrovH
	PSrdy1FUv28iwtIsoaqdpioSBwZlayCkZ+6rFhPJBnZyZkaau6AoWNbcjDvJS+f7zay4ET
	5iDqehJCb2LwkRZFY5XIy8Ne3XkM+6o=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1782214655; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=q+ujLuEJrFEHTfv1e0eodePZZ2+R/2Id2toRBkHwzk4=;
	b=dG2HrJktMUgxW6aJr6ial7hN+dXyiExYv2ilzV+cLzIHT5YYAh+2ht886ga3zjNK4lrovH
	PSrdy1FUv28iwtIsoaqdpioSBwZlayCkZ+6rFhPJBnZyZkaau6AoWNbcjDvJS+f7zay4ET
	5iDqehJCb2LwkRZFY5XIy8Ne3XkM+6o=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6A9E8779A8
	for <linux-btrfs@vger.kernel.org>; Tue, 23 Jun 2026 11:37:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id lfc/B/5vOmqDBAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 23 Jun 2026 11:37:34 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 0/2] btrfs: fix inlined file extent items in data reloc
Date: Tue, 23 Jun 2026 21:07:13 +0930
Message-ID: <cover.1782214614.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.994];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 
X-Spam-Score: -2.80

[CHANGELOG]
v3:
- Use btrfs_is_data_reloc_root()

- Reword the cause analyze to avoid confusion

- Expand the [FIX] section to explain why disabling compression will
  avoid inlined extents

v2:
- Add more explanation on why we can created inlined extents even if
  relocation is preallocating space

- Add the fixes: tag since the behavior is caused by a specific commit

There is a syzbot report that an inlined file extent item in a data
reloc inode triggered a sanity check in get_new_location().

It turns out that we can create inlined file extents for data reloc
inodes in the first place after commit 3eaf5f082c4c ("btrfs: extract
inlined creation into a dedicated delalloc helper").

So the first patch will avoid compression for data reloc inodes first,
then the second patch to reject inlined file extent items in
get_new_location(), making the checks more robust.

Qu Wenruo (2):
  btrfs: do not try compression for data reloc inodes
  btrfs: reject inline file extents item in get_new_location()

 fs/btrfs/btrfs_inode.h | 2 ++
 fs/btrfs/relocation.c  | 7 +++++++
 2 files changed, 9 insertions(+)

-- 
2.54.0

