Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794350028;
	b=5lLaP57fdr9+poM/nFusn2IM/9zFMzuoXjIJKRGCtc3bf2AaVmYVHhBFzl37U5TuL/fx
	 4O3NZwq/P51Mq4byJ3nnL0Ve9SKxt8hw+E4r3qkerj+BoXK24y0STcF0wiRQ1yuCBVv/m
	 i4+/1MdyiblifbjPjnktuvpJ6X2APAvgdByJqlSLve3HqlcobVGPwIcSGqTO4Grc/a16z
	 3g7WHZs+PH+WHiEbFpG2hRHY2L6YhyV/jPEmXfsLenUJTFOAt/p9t9b663SBT7h74HXzz
	 p6MTAgusyWIT2HMSTUvGG3tROXi/EaLql4P44JV8oefAi27k9EzX7P+FuGN3Op2b5kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794350028;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Spamd-Result:X-Rspamd-Server:
	 X-Rspamd-Action:X-Spam-Flag:X-Spam-Score:X-Spam-Level:
	 X-Rspamd-Queue-Id;
	bh=LYi52fHRrUwpfCo3I18O9gimlArt2PV+RQHum1r2UEE=;
	b=KHHK4nTp2/4YOOFzONDP5d49GolHn+4jffJLFjnsJol9UXG8VwdDYIw/n4S4q/eWtKwI
	 jd+8w/mwyctqkeVGUSMcAfQFxJUgSypMf7TU5LhM1YiVDIr4Ol+h/6TL2pzuAU5ndxi+M
	 B+Vcb+lzT7Q20O6scxocOaJgkFHh8SWhZo//3F/kykNGFCiJDI7EJyGTKGqVXZUuPGTON
	 tgL5h0yu3REs2vjXPMGxrXOGuKy1Vl7s/SkFpHhSTEcrWW6fT4kpsB9vKiNpWAc/XmaGR
	 ZmM8w4GsIXjEKAFcXZ7FENK4Y+RAjtuYG20Uizv7ClCDOtbAVx+NvY2A877SgSq6++g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=SrAidA6Z;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=SrAidA6Z;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C48C606A31C
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 22:33:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7C48C606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=SrAidA6Z;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=SrAidA6Z
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8DF6421EEC
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 22:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794350025; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=LYi52fHRrUwpfCo3I18O9gimlArt2PV+RQHum1r2UEE=;
	b=SrAidA6ZktafaL5tM+tCIIU6tb2ExRllrCMeB2Vs9YilHvZo12f7fgzVXAByPmYtutY0lo
	RdnKZ1FVz/BoabB6dJqOpiQUMfZ2tbvo59vN1FQf7nVVGMa38auiWwPtK7KYwdRUpzD3OO
	TWWwkWWbpr8MdmXm1EmwtVMCxw//eCg=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=SrAidA6Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794350025; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=LYi52fHRrUwpfCo3I18O9gimlArt2PV+RQHum1r2UEE=;
	b=SrAidA6ZktafaL5tM+tCIIU6tb2ExRllrCMeB2Vs9YilHvZo12f7fgzVXAByPmYtutY0lo
	RdnKZ1FVz/BoabB6dJqOpiQUMfZ2tbvo59vN1FQf7nVVGMa38auiWwPtK7KYwdRUpzD3OO
	TWWwkWWbpr8MdmXm1EmwtVMCxw//eCg=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5D2C513693
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 22:33:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id bA6vKceb82r5DgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 22:33:44 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs-progs: mkfs: fix garbage in QGROUP_LIMIT
Date: Wed, 11 Nov 2026 09:03:23 +1030
Message-ID: <cover.1794349527.git.wqu@suse.com>
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
X-Spamd-Result: default: False [-12.01 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[99.99%];
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
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -12.01
X-Spam-Level: 
X-Rspamd-Queue-Id: 8DF6421EEC

Running "mkfs.btrfs -O quota" will result garbage values in QGROUP_LIMIT
items.

This is inspired by recent tree-checker changes to check QGROUP_LIMIT
and QGROUP_INFO.

And a new test case for it.

Qu Wenruo (2):
  btrfs-progs: mkfs: fix garbage in the QGROUP_LIMIT item
  btrfs-progs: tests: add test for zeroed QGROUP_LIMIT item from mkfs

 mkfs/main.c                                   |  6 ++++
 .../046-qgroup-limit-zeroed/test.sh           | 30 +++++++++++++++++++
 2 files changed, 36 insertions(+)
 create mode 100755 tests/mkfs-tests/046-qgroup-limit-zeroed/test.sh

--
2.56.0

