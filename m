Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794697429;
	b=r4MuGYvQX275v+fPAlnCiHjtdnxgXDXuGUngctWqfiP6e0wNAtiBO56nHOmJF+ih3t9l
	 c0sKXtOm+PaPN8FMMfuRnwpngtRgbGhksSAAbm53aWwk145q6Vdb4B/uOwNnXDY/rV2dy
	 zcuh8nE6BwfIGGScdiTrGvUFsf1gDvgZij8+dz6iKCMbMeFgKctQM8He6KzvxNSuWwT9s
	 WRIY7nk22XX3r/+xylmDwf6YSpmITmQWBiSYEJzJYvYjc8RSclZQ+ia88Q7comIH4V5Ah
	 8xFYmMjlMr4CEp4R+qA2ERBjLmyD2fG7Fa7O89xf9UAoVuGtsGl27gVBaGEo1yNfITA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794697429;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Spamd-Result:X-Spam-Score:X-Spam-Level:
	 X-Spam-Flag;
	bh=RWxd7BozEcMLFhrYsXmE2oTpPeFxyIo4x1Sm4u2WBsc=;
	b=X3mVCgzQgMGmCFp5WegxXaF67GRZEYotd92KoL9/qIfqAWa2wBL3Z/Wh9fo0YKEnoUVX
	 /IANX8YLv3tBno6LK+pe5zEDk0VhqzpeSaMcNGor0W2aHe6Pn1HOknRI8zpXNASW1IWpX
	 YUK6cgVqIP0mJKlsYiVQozxgqV0wzFjmFGeFVRnkpDnc29/3M0kW9Oog+3AYlmIFXXyID
	 gFAgk+rxe2Yf/a5JHKbn+n450+wlwi0ck2Efr35CS9KHCx4cfHyqHsRg5lmKkJ7ZOe1MY
	 hnSWNY1CW2v7FXTDL0E/3H0RyknQhja4cNSnxt0cqVTACm26X1j5YrAwHno+w7IT5bw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=AwoIf1iF;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=AwoIf1iF;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17991606A327
	for <linux-btrfs@vger.kernel.org>; Sat, 14 Nov 2026 23:03:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 17991606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=AwoIf1iF;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=AwoIf1iF
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3FFD721FDB
	for <linux-btrfs@vger.kernel.org>; Sat, 14 Nov 2026 23:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794697421; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=RWxd7BozEcMLFhrYsXmE2oTpPeFxyIo4x1Sm4u2WBsc=;
	b=AwoIf1iFN9kqu1a/1IVngJGREf/0j2/BDWOLDxi5vH/K/BQS7wOcSilFUY2Gd+lILzDZob
	EEiB0VFX84FPlkfv2LhNkNJdj3t4g9NoM5BkzVmZyzQ7rLY/Kd3s3F+ESEt/nUOyITpFh4
	dCi++AS6A7gwebFYz5u1dan4NI7/qHM=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794697421; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=RWxd7BozEcMLFhrYsXmE2oTpPeFxyIo4x1Sm4u2WBsc=;
	b=AwoIf1iFN9kqu1a/1IVngJGREf/0j2/BDWOLDxi5vH/K/BQS7wOcSilFUY2Gd+lILzDZob
	EEiB0VFX84FPlkfv2LhNkNJdj3t4g9NoM5BkzVmZyzQ7rLY/Kd3s3F+ESEt/nUOyITpFh4
	dCi++AS6A7gwebFYz5u1dan4NI7/qHM=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E1C3613408
	for <linux-btrfs@vger.kernel.org>; Sat, 14 Nov 2026 23:03:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Sn6dDcvo+Go0GAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sat, 14 Nov 2026 23:03:39 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs-progs: tests: fix false alerts on github CI
Date: Sun, 15 Nov 2026 09:33:19 +1030
Message-ID: <cover.1794697359.git.wqu@suse.com>
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
X-Spamd-Result: default: False [-11.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
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
X-Spam-Level: 
X-Spam-Flag: NO

After the CI workers updated to ubuntu 26.04, there are several new fail tests cases:

- convert/017
  There is not enough metadata space to support a convert.
  This test relies on both the mkfs.ext4 behavior and kernel ext4 write behavior.
  Change the test case to skip the run if there is not enough space left.

- mkfs/037
  There is no '/usr/lib/lib*` files anymore there on ubuntu 26.04.
  Use generated data instead.

Qu Wenruo (2):
  btrfs-progs: tests: fix false alerts on convert/017
  btrfs-progs: tests: fix github CI failure on mkfs/037

 tests/convert-tests/017-fs-near-full/test.sh  | 12 +++++--
 .../mkfs-tests/037-basic-compression/test.sh  | 31 +++++++++----------
 2 files changed, 24 insertions(+), 19 deletions(-)

--
2.56.0

