Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4ED1AD4B
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Mar 2026 05:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774245119; cv=none; b=Y0H3wXJkqq972nSVxTkKemX0oI68+vGED2mw6EdPbFv74CuHMwZhuP50NtBg/J7YgBbBhnnBLHC39/IYx9gg+qNFZdgN8K0R3ANgh4uTEb60OT7PMNDGTTFgQocgf0qLxwq29bAhd3zU3fnhbiAl1FBBU0alKaXbxXzo59rxmwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774245119; c=relaxed/simple;
	bh=aV08D3nlQzwpV/FNir6NIrNGahqlqufQr09FXy+IeAw=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=RgU12o08f9oVwZ6YvIHPaimeEL+rbJB9b7Pad3+L+jjllh2F/DPAy5DJ+XwfHrS45Lm12WGv0mXyXGXDCvKqYqcT7HGG08JVyUMbF9Sxxir3I43XZDZbTRYBRBYSQTCpbj0erB1lVh/Ksq0u5YmXafU/xUOg5gyGZtzsZqwaxC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=olMBKXC9; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=olMBKXC9; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="olMBKXC9";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="olMBKXC9"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2EB855BDB4
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Mar 2026 05:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1774245116; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=aTIglAlkF3DT83Rja2u9cjOlcoaSH4s3ISbKl+G6c4k=;
	b=olMBKXC9MAuXmpvciZefJqJZ2o9Hvu8PKOCCFiB/6z5WuCBwifatx7HWprg+QyxLblxJJ7
	kfJXpKuRu/2O5XTDP0sAOeZbIUdKCvdxEjI691R7B69zIo9geuZeOlaFyJgPW6pwVkDhy2
	kSVKdxB1ckNn+9LkFQ/yfjqILUR1iQU=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1774245116; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=aTIglAlkF3DT83Rja2u9cjOlcoaSH4s3ISbKl+G6c4k=;
	b=olMBKXC9MAuXmpvciZefJqJZ2o9Hvu8PKOCCFiB/6z5WuCBwifatx7HWprg+QyxLblxJJ7
	kfJXpKuRu/2O5XTDP0sAOeZbIUdKCvdxEjI691R7B69zIo9geuZeOlaFyJgPW6pwVkDhy2
	kSVKdxB1ckNn+9LkFQ/yfjqILUR1iQU=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6867843704
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Mar 2026 05:51:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id TWHCCvvUwGlCAQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Mar 2026 05:51:55 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs-progs: mkfs/rootdir: add hole detection
Date: Mon, 23 Mar 2026 16:21:35 +1030
Message-ID: <cover.1774244873.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	URIBL_BLOCKED(0.00)[suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO

This patchset is already submitted as a github PR, this is mostly for
tracking purposes:

 https://github.com/kdave/btrfs-progs/pull/1097

Currently mkfs.btrfs --rootdir will always read out the content from
rootdir, and write them into the target fs.

This is IO consuming as we need to read out the data from host fs, and
write them into the target btrfs, and also CPU consuming as we need to
generate the data checksum.

With hole detection we can not only skip the IO and csum generation, but
also result less space usage for the target fs.

The first patch is implementing the new hole detection, and the second
one is the test case for it.

There is a small note for the test case. As I mentioned the 2GiB hole
size problem in the first place, I should put the test case to include a
huge hole (>=2GiB), but unfortunately that will greatly slow down the
test case since md5sum doesn't have any shortcut to handle large holes.

Considering the CI machine time increase, I intentionally limited the
hole size in the test case.

If one day we're not limited by the free machine time from github CI or
have a local CI worker, I'm definitely fine to add a new large hole into
the test case.

Qu Wenruo (2):
  btrfs-progs: mkfs/rootdir: add hole detection
  btrfs-progs: mkfs-tests: add a test case for mkfs hole detection

 mkfs/rootdir.c                              | 36 ++++++++++-
 tests/mkfs-tests/041-hole-detection/test.sh | 70 +++++++++++++++++++++
 2 files changed, 103 insertions(+), 3 deletions(-)
 create mode 100755 tests/mkfs-tests/041-hole-detection/test.sh

--
2.53.0

