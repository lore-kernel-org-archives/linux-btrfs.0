Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794864575;
	b=1OPAPxQhqa9YREyaJutjP6MQTpljOSx/xVYxycKSlgIe8edl1Au8C0GVCPDvl/hHp49f
	 kwOef5rRA2ZJIkROxArE8Je4Hb5lt+dVTnvqyZdPCMp15WWlDCPbdC6P31Vu3Db4d8Dqe
	 r0RARyjQlYvUC43C9/9Y5cOGp49EyA1jVdcqG7lBfpCHc1hirv4l5+cg5JGzoLAulQusH
	 nuRpIlypZ68G85FORR/1vK6+mVNOdBe48gWZ0NdiY/mO9RNU3zp/+bQm1sazcx6/YGPLV
	 Gv3yAJrzLky7J5OFt8RARtqJHqrmN1CulP5WS2XudCK4MeV2uKXBdDre+hUSpx7OBRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794864575;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Spamd-Result:X-Rspamd-Server:
	 X-Rspamd-Action:X-Spam-Flag:X-Spam-Score:X-Spam-Level:
	 X-Rspamd-Queue-Id;
	bh=1WYyvX2W1x0xQPUmVUadny3bxiCgfPvc4jySt5QMvFY=;
	b=eoABdGBXU3RiLVAlZuTJeKMusA4+QhgF1QPXdK6v5dh7iCuSsZ8prC5KBYmZ0MIVwfU5
	 X3kbsvMXX2O1rWAfZYN2HsiqgMLrjFr01KAV2rfDO88T6dMhzdFnkDNJIquMqwzYbdQLy
	 7gvDl/YoAsO9yc0+uR0c9Gxcgt3S2tUHdxJPmwn4cGVGpVB/Uv9gN03RrniGKRYs2I3Cc
	 9CZBxk+7DsFy2wjKxFZSPuKn8rNSIcH5aTgyRwe71mXPHOAST1kdkB64Y4xJ/f6lzjk6M
	 HwNs4zA6zBlHusRlvZhZAkVue6jJlTJbtQNqhTpleUjMIWToBF1ytAA6Z8zgm1P9Kew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=UdhgAsVB;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=UdhgAsVB;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97BF1606A31C
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2026 21:29:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 97BF1606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=UdhgAsVB;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=UdhgAsVB
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9A7261F461
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2026 21:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794864572; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=1WYyvX2W1x0xQPUmVUadny3bxiCgfPvc4jySt5QMvFY=;
	b=UdhgAsVBdELDYMkKzWw1XGQ3akcHvH3JiBjEH+xwpULyGXd4Ev5dGgtcNcSRhu/9qXWdIL
	Gg5ioMss9aOaHth1ATDGF9CmOOvVBFUhw1yzG9sc3L2vmaB2tN6D3mmEB6bw0hlOymkTfQ
	1pofmmH7Wb177ec390HjYJP7UsjKfVo=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=UdhgAsVB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794864572; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=1WYyvX2W1x0xQPUmVUadny3bxiCgfPvc4jySt5QMvFY=;
	b=UdhgAsVBdELDYMkKzWw1XGQ3akcHvH3JiBjEH+xwpULyGXd4Ev5dGgtcNcSRhu/9qXWdIL
	Gg5ioMss9aOaHth1ATDGF9CmOOvVBFUhw1yzG9sc3L2vmaB2tN6D3mmEB6bw0hlOymkTfQ
	1pofmmH7Wb177ec390HjYJP7UsjKfVo=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4C9AB13408
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2026 21:29:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ugL8Jbp1+2oUJgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2026 21:29:30 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs: defrag related to corncer case handling
Date: Tue, 17 Nov 2026 07:59:02 +1030
Message-ID: <cover.1794864101.git.wqu@suse.com>
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
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim];
	RCPT_COUNT_ONE(0.00)[1];
	DKIM_TRACE(0.00)[suse.com:+];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -12.01
X-Spam-Level: 
X-Rspamd-Queue-Id: 9A7261F461

The first one is a Sashiko report that we can step into the next inode
and continue looping unnecessarily. Fix it by re-ordering the checks.

The second one is another minor corner case where if the defrag range
starts inside the last extent, we may skip a valid defrag target.
Fix it by doing the backward search properly.

Qu Wenruo (2):
  btrfs: defrag: break the loop early in defrag_get_extent()
  btrfs: defrag: fix missed extent when the lookup lands on the next
    inode

 fs/btrfs/defrag.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

-- 
2.56.0

