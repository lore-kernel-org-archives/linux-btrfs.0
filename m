Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795466275;
	b=nSX4le7FbeyM+/AQUJzIPhxzSkYTtRm79tTcPtOUqu726/I98un82s+nMF4jA8sVVMwL
	 p6Eaky3L56V/nWNZMrd5kUGgQC6w/v6AKZu0Uai0avcj+rIadSOI9W0EdIBkeIGZTOT7T
	 SrqEd7bLTmzTfRtzImxX5sYBozZxWQoC6mAxYYsR2AKT+QuoQixmW8qcLE52+YQzVNfFv
	 MZ+Gv6xgUjFV0TBuP1nQTH0F2zHqJfBOGiwIkWd4ExJZrnGElswYjiQ2ecIQhbrlUkilk
	 tmgmg7YCXEoPlBAXBq4xn4T5aCyThdQA3UjAPhIAcFOt7EbloC8tgBHJm0mVNFro6eA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795466275;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Rspamd-Queue-Id:X-Spam-Level:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spamd-Result:
	 X-Spam-Score;
	bh=8HmEVtSkIcs55r/J5sZJ6pcCAJfc+RTKMxVtQ6HToPg=;
	b=fI6q33GudLE+NjkEwpIu1EuNu7OokhkTwuKsp6inFBU6+CRpZ4zTIApH7N9FUcgmJC88
	 MlmP8AkvA5CB+3NbZo9+r+fxW0ARAPwUvyRq/5AT1T/7Z8YznGSqfDDUVo1NOfv5IAuvu
	 HShHJs9mKIwu07/Yhnmob3OkcgNMWc6CkiQiJfBXhgdozEF0+MYYApVvtp1ONoNUt7ry8
	 ijumP/XQa0jxDuG2rHyAArKnjB34xRDpcqJpgsWcsEhsMzDMnPmmlTq+WdwD0VHOba9+Y
	 uEEdP9oaJLYbJjl0GaSDG4fqLOWTJVct3PZRitRLlDx2+2OhnZDuktJeCCDoUPSCmvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=jHjQnJ4o;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=jHjQnJ4o;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9421606A321
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 20:37:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A9421606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=jHjQnJ4o;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=jHjQnJ4o
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B1A8622076
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 20:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795466272; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=8HmEVtSkIcs55r/J5sZJ6pcCAJfc+RTKMxVtQ6HToPg=;
	b=jHjQnJ4o9csLrhqqKC+WMFO6lhO02vQP05xNfxbnecvMDBhtLciSmNOy7/zJnPBrn0dyF9
	xLY8daNlNsOKprNxQ2DaB7SO3SqAO1OahQQWwxCW8XWgnXUjyCKhl7JVIAk0j22SaZH0+q
	WqM7F4By8/8JjoRa7D7m7Gi0o/UZEpA=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=jHjQnJ4o
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795466272; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=8HmEVtSkIcs55r/J5sZJ6pcCAJfc+RTKMxVtQ6HToPg=;
	b=jHjQnJ4o9csLrhqqKC+WMFO6lhO02vQP05xNfxbnecvMDBhtLciSmNOy7/zJnPBrn0dyF9
	xLY8daNlNsOKprNxQ2DaB7SO3SqAO1OahQQWwxCW8XWgnXUjyCKhl7JVIAk0j22SaZH0+q
	WqM7F4By8/8JjoRa7D7m7Gi0o/UZEpA=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7F5CA13505
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 20:37:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3J8WMh6kBGuQTwAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 20:37:51 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/2] btrfs: minor fixes in handle_indirect_tree_backref()
Date: Tue, 24 Nov 2026 07:07:30 +1030
Message-ID: <cover.1795466145.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.1
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
X-Rspamd-Queue-Id: B1A8622076
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
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	URIBL_BLOCKED(0.00)[suse.com:dkim];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim]
X-Spam-Score: -12.01

[CHANGELOG]
v2:
- Add unlikely() for both patches

The first one is reported by Sashiko, the second one is another bug
exposed during fixing the first one.

Qu Wenruo (2):
  btrfs: reject too high tree level during backref walk
  btrfs: avoid NULL-ptr-dreference after a lowest_level search

 fs/btrfs/backref.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

-- 
2.56.1

