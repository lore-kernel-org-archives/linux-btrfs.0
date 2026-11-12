Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794461220;
	b=S/XPETNHvcfpS1LdI8lFAl564opk7T1bU90Tmo4L7HENKisQ8j+Rk/Rp/FlN7Bs0ZCsa
	 8o1HMmHODJ+Sepov31TIM0QGpjqHU3HWUNbILw48t2yK0ltkl9r1hD5VmNnERDE163Svn
	 z25HHBI8oiBCab56bceHUGd2pJ5z4laHkMwM4d///3rILWLekqs1aju8nPKx6BtRDH3DJ
	 5k6Ys86FJRTyrwvpAuzfJGGB9ANrGuw8cb5FLDLxGOn8kdZVYqCh0Ee7FXT04kd/y1K/v
	 Jc8CU3ltYJt0Elr2ZqvpUlSwngw8o1xUtTZ2Jr8MOv0PPWAXAnbYM8nAWgMov0dZEow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794461220;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Rspamd-Queue-Id:X-Spam-Level:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spamd-Result:
	 X-Spam-Score;
	bh=xFkT2jW9cJ6zAfB3/sYbEFl2RbJxVChlbaTQIZu69/g=;
	b=Ie4CxQnPtxHAWYJRFRsDls/NYWKf5+CxbZDuZADO5vQmkKV8lkn97fmPDwfMFTfAlqYL
	 WuxOD+xIUoxw7pQN8BbUEK7SUJ9805rBSy1gWE1F9Z3Sm7erBX+bzvT3PMcvLUlaqRR6P
	 KtIinhH80OCy34QeRKu/FhA1K/KQipBHVAXn5go553QbTGXaTw2chQg0r7KlqAmUcdoVk
	 fWzPckS61sz8F9QI9A6+QC4fC78GYPM+iNYhjolNUzmsF4aDkGvJojZHtc6QWIyV8DvrI
	 cvb8md3dYl1X8sBeQtP3rOmvTGNaYKRi7e4RF6mYAa8H7ZSWlSmly3WSzMI4SiG09KA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b="MYnKc/id";
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b="MYnKc/id";
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D460606A327
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2026 05:26:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0D460606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=MYnKc/id;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=MYnKc/id
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 005B521E82
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2026 05:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794461218; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=xFkT2jW9cJ6zAfB3/sYbEFl2RbJxVChlbaTQIZu69/g=;
	b=MYnKc/idVAQE2UMKkTF/AJaiw7/tZb6YkvBmnpSW2inaw/6E234+rkGDqLlbDofb0tnqew
	hifr/EGCNeEuqd6rNEhPyChEakNh/AfA8ykYe/NZG9CyPcWnICg0+iK7GekyLPgJRmzRfQ
	OuTsF2zUcPrRUaa23ACUBiBJDMKhud8=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b="MYnKc/id"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794461218; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=xFkT2jW9cJ6zAfB3/sYbEFl2RbJxVChlbaTQIZu69/g=;
	b=MYnKc/idVAQE2UMKkTF/AJaiw7/tZb6YkvBmnpSW2inaw/6E234+rkGDqLlbDofb0tnqew
	hifr/EGCNeEuqd6rNEhPyChEakNh/AfA8ykYe/NZG9CyPcWnICg0+iK7GekyLPgJRmzRfQ
	OuTsF2zUcPrRUaa23ACUBiBJDMKhud8=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C5BE2134A0
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2026 05:26:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id buNLCCBO9WrVDwAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2026 05:26:56 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs: anon_dev related fixes
Date: Thu, 12 Nov 2026 15:56:32 +1030
Message-ID: <cover.1794461116.git.wqu@suse.com>
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
X-Rspamd-Queue-Id: 005B521E82
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-12.01 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Score: -12.01

The first one is a Sashiko bug report, that we have a very narrow window
to hit an anon_dev ID leak.

The second one is another small bug related to double freeing the same
anon_dev ID, exposed by LLM.

Qu Wenruo (2):
  btrfs: fix anon_dev leak when snapshot creation races with a root read
  btrfs: fix double free of anon_dev in btrfs_get_root_ref() on -EEXIST

 fs/btrfs/disk-io.c | 13 +++++++++++++
 fs/btrfs/ioctl.c   |  8 +-------
 2 files changed, 14 insertions(+), 7 deletions(-)

-- 
2.56.0

