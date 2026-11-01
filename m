Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793525835;
	b=4bQ41k8pT3x7XmvUxGSpQOp9vzZ+v/d3Vk4X0IKaFrAFkoIeohr+Ial8ExfflILo70C9
	 Fw3LaBRtLnh/odPIK9vpSG4avBK6xSXKLg+cqsy2DXGqyj33g370smPxW9Gsli/WXYs1a
	 5ozxlmwkA0FQEmlGfxATCUem3WSAEYKyQCx8KMWMAHcxij5WtDAVVGyoI1y9IPPVX9dkS
	 SwfurcqgDV0RvXEXmKLeNrcPvJ2JFO4Q4mjXPvQaOvdFUx1dM2xr3hOKfvxnHNHzpb1dl
	 vLBhM5QF5JQGD+C8pczCFXEL+hyXAJHaVBO6SKWDLr1RbYqjCGdSt4OhLZnQHCp6yDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793525835;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Spamd-Result:X-Spam-Score:X-Spam-Level:
	 X-Spam-Flag;
	bh=oAuXqskh3w8hor+D7i0zdrNC1q4j9wC/L5yFChg5CtM=;
	b=SaT1GczH9ffPCXFT7CFlaHJdYen6T4GV+NowrE/oXzcSuyuzmACOWVLSRxbTeRrPzd7W
	 059WiwUYUzPwCDQG4MYCjm5T/mMlZfKJMKRt+G+n8vLUIb9lzYXcSvIL12jcAni7VYI4k
	 kCnjTplxn2uhMXuju5E1oytqbdPPJq1R7R+7aF8oLno+d8k9xxQmpp3kFpttT4tQ+Nqhz
	 bKn/JF9PSQ2pe6G1URARUochk6hrMix26nQ5BrE8NF3U0A7ZJJzRrmR+37iLaO5Whym23
	 edK/LQmgP27HZmrjgcKZyS5lm0ieHQhrm9Ca2HOyr4sjvv7bldHejBlVqEaCLkdzjBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b="AUocP4v/";
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b="AUocP4v/";
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E97C606A324
	for <linux-btrfs@vger.kernel.org>; Sun,  1 Nov 2026 09:37:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5E97C606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=AUocP4v/;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=AUocP4v/
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7B2281F445
	for <linux-btrfs@vger.kernel.org>; Sun,  1 Nov 2026 09:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793525832; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=oAuXqskh3w8hor+D7i0zdrNC1q4j9wC/L5yFChg5CtM=;
	b=AUocP4v/Ythv5/ecL3gBPb+tpksrW/7CuPwEO7VjELxDuAZUVA22hN5pWBEKqhzkxHd+ZP
	xidrJxirxDd3zF8hgJTKsKBsifa3AGzhmlLnxDgWmblxXVwb2Mv9/5y5nDMG8sUsqc59xG
	8kCmpXiFGlfDg69tBzOcmbrhRuFdIeE=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793525832; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=oAuXqskh3w8hor+D7i0zdrNC1q4j9wC/L5yFChg5CtM=;
	b=AUocP4v/Ythv5/ecL3gBPb+tpksrW/7CuPwEO7VjELxDuAZUVA22hN5pWBEKqhzkxHd+ZP
	xidrJxirxDd3zF8hgJTKsKBsifa3AGzhmlLnxDgWmblxXVwb2Mv9/5y5nDMG8sUsqc59xG
	8kCmpXiFGlfDg69tBzOcmbrhRuFdIeE=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5FFC713314
	for <linux-btrfs@vger.kernel.org>; Sun,  1 Nov 2026 09:37:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id odilLEYI52qESgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sun, 01 Nov 2026 09:37:11 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs-progs: speed up "btrfs subvolume sync"
Date: Sun,  1 Nov 2026 20:06:50 +1030
Message-ID: <cover.1793525519.git.wqu@suse.com>
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
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -11.80
X-Spam-Level: 
X-Spam-Flag: NO

Unlike the name, "btrfs subvolume sync" doesn't sync the fs, but only
wait for unlinked subvolumes to be fully deleted.

But that wait completely depends on when the cleaner is woken up, and by
default it takes 30s.

That's why a lot of fstests cases are remount with "commit=1" mount
option to speed "btrfs subvolume sync" up.

To speed things up, and reduce the confusion on the command name, do a
proper BTRFS_IOC_SYNC before waiting for unlinked subvolumes.
That's done in the 2nd patch.

The first patch is minor fix to an uninitilized access, exposed by LLM
during the review of the 2nd patch.

Qu Wenruo (2):
  btrfs-progs: subvolume: fix an uninitialized access
  btrfs-progs: trigger a sync before waiting for subvolumes to be
    dropped

 Documentation/btrfs-subvolume.rst | 7 +++++++
 cmds/subvolume.c                  | 6 +++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

--
2.56.0

