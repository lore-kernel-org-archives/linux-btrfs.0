Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51E62E3FE
	for <linux-btrfs@vger.kernel.org>; Thu,  1 Oct 2026 05:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790831817; cv=none; b=JmOXzQcglXmXVXWJ4IiDFBoEJYOz3hNISLJjM2tOv+JjXpBXaIfazcJnZLMMG/vVovLNTWk95uf/A+xXjjKANjq0Ixx4NxFE0Ed8kseJJUMDX7S8+WAJqwooWsOUzr1YP5qrGF9x/wQPabRc2GfKLEDzPInZArJcNaP+mQH1dTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790831817; c=relaxed/simple;
	bh=W+iXnsr4nBVb3SurRD88do4wMGxLHfvq2l8CLxOppTE=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=W/soCgOihRkH39xjYS2C4C3VDB2yokjeVgYoPUjleG5aJKwzQbAigRymIstP+WPc2c6//IWHejCwGgLdRQ2rbaF9mJCfsOrhtLTYZxv3QhXYohBRd/I4TI+nNZJVkV/CBvrd6ayTKC5ycj5VMoru221IS8YUaaCL1fBq+gd0sCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=JxzYgqwN; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=NqaZld8H; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="JxzYgqwN";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="NqaZld8H"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4A7041FD01
	for <linux-btrfs@vger.kernel.org>; Thu,  1 Oct 2026 05:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1790831809; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Nj9ehN4RUMdxWMgQAvuhHofM45tO1GDyK7lInwGKiow=;
	b=JxzYgqwNsCIWBlampQf/UD+3yIcqR11LAEr9BAIVXokL/tnhV8uFlPdXs8TOJZqKp5MGMG
	PxDyZLJKjYjlt1RPky6nOCObDNaqJs8XC8qG+rilNFZJIdSjb1a3B+/SJe7wLKYxJwHNHm
	OePb1dWoeAEioZwopOxMQqxZ20gHFAk=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=NqaZld8H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1790831805; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Nj9ehN4RUMdxWMgQAvuhHofM45tO1GDyK7lInwGKiow=;
	b=NqaZld8HabsVnIZs8jyCFLCx0hwYNgcS4Tg4rRfF9Inh0D9gUDzRT4xxGuu6U0fJvSrfJx
	+Ta3NPyFSHuDw6Wi9w3vlOrK9B+F5ZO245BDzwjrWn46wofwGPj5AiAIiWHqBhaLq5Lgv5
	2ZlY3/t6JFSjdmj1qVBQeh3w2lQX6jA=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F2A3F13699
	for <linux-btrfs@vger.kernel.org>; Thu,  1 Oct 2026 05:16:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aRXOE7vsvWrVGwAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 01 Oct 2026 05:16:43 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/3] btrfs: small fixes related to qgroup deletion
Date: Thu,  1 Oct 2026 14:46:14 +0930
Message-ID: <cover.1790831600.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 4A7041FD01
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-0.997];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	URIBL_BLOCKED(0.00)[suse.com:mid,suse.com:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	TO_DN_NONE(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 

There is a recent bug report that when deleting a qgroup that is not
fully exclusively owned, it can make all future qgroup operations to
fail.

It turns out to be a problem handling "ret > 0" cases when deleting a
qgroup.
The first patch is the root fix.

The seconds patch is to improve the error reporting of
quick_update_accounting().

Finally there is a pre-existing problem exposed by that "ret > 0"
handling, that if we use btrfs_remove_qgroup() on a qgroup that only
exists in the rb-tree, it will return -ENOENT meanwhile still deletes
the in-memory qgroup.

Fix that -ENOENT leak in the last patch.

Qu Wenruo (3):
  btrfs: qgroup: do not treat "ret > 0" as error when deleting a qgroup
  btrfs: qgroup: use qgroup_mark_inconsistent() in
    quick_update_accounting()
  btrfs: qgroup: do not leak -ENOENT from btrfs_remove_qgroup()

 fs/btrfs/qgroup.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

-- 
2.55.0

