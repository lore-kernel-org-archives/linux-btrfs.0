Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793090160;
	b=RkHuWRhkW5SxIchvhshye2OR5EevMyhdFNkkvojBygY8DA802SAXa5a1VDjhA2kp44v/
	 rc5HFMhR58RJgeXI8QNQWDNVegXKXZwrppQOVDJWdthQavFsWngTmqopoziGHII0ZaJTM
	 lG4FD9Nb/MLTRbqNwNlaUZCJhHY6eflmIo3MLxFJPLyBXimkZQlgOCx5jVLDFiFpDvued
	 6TlJMCay2Ju958eBD/pL27oq2CqeO21V2+Ch8+jZ4TGMP31pwQPeU+EhzIxr+rWAQgbBp
	 NuDZiIP5j7dPHbOTBY++xNzz1tJfgS9Y7RyJ5h+kRnUTCrHbAbOf6AooAu7KleM41Zw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793090160;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Rspamd-Queue-Id:X-Spam-Level:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spamd-Result:
	 X-Spam-Score;
	bh=rV4xCe0QAIrvI1d0dSldl/bWk5uEzT+EMlv2zKu0oeg=;
	b=3lxkwKiemQJzBmwMdc1GVjiEU3SnskaUIj10oxTecncrOJBT2K6srK40pW1n+9nEDIx+
	 +B6Pn8TeN5uJCzc7JCBLE18RLXeXl7Nu4XJMqY3COcOdQ0uyYzYdTKxS7QX+5EmuLop4T
	 q/Gr2Ga0LPJvJTNrZGp3XdwWSFxG9/ApTet7QJ+LxfidZdt5VXCHk37yXwiJ4XTt6OGwa
	 q3TpqnQRPM5a/HM+UHXOc2Ske7P4J6AnFF8RrCEk2z2EiJT1ODMcCruFeQtqcYcFVEnRk
	 4wTUte0BlWdfCZ7H3qhQvMDsp41YPVXYi0L04RLt6R7Vsc8ryHrrNBNonfCNNbX4DEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=NYu9n18C;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=PglUmECH;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB09606A321
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 08:35:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5BB09606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=NYu9n18C;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=PglUmECH
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1CB831FBAE
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 08:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793090157; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=rV4xCe0QAIrvI1d0dSldl/bWk5uEzT+EMlv2zKu0oeg=;
	b=NYu9n18C6ie0uI1msJm5hL5Q3wlYvSG8WcM9fvcOlWO3spAD5E8sd8Fpxpkpl97fPffU2q
	+rFoZ+l1JW/VtgSX/u7uLJPmwUpsIgeGVryJ1O8tY3ICeeCzFk6+IsTGLppfpK0rChTKsq
	wMEfYXPuz2RB6yhMGxEeAGt590oOL2I=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=PglUmECH
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793090156; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=rV4xCe0QAIrvI1d0dSldl/bWk5uEzT+EMlv2zKu0oeg=;
	b=PglUmECHFGI+teEzf72ijAI3ZNjx+tpKaEz+y6omI1CccslpWlQQnYLevUl9ZlPX+Peybm
	W8BePFA1t8Vc1fzclrQiWMVCm6L3uq32i9JnQ82h8+vWqNCNusbEVIoOgB76bryQrLuQ+X
	wHwbWZvioa7UOfqi7Xm7CaNGgJoRdUI=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E544B1321C
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 08:35:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id bsDdEGpi4GqbGgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 08:35:54 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs-progs: simple cleanup related to LLVM (not LLM)
Date: Tue, 27 Oct 2026 19:05:30 +1030
Message-ID: <cover.1793090084.git.wqu@suse.com>
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
X-Rspamd-Queue-Id: 1CB831FBAE
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
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
	FROM_HAS_DN(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim]
X-Spam-Score: -12.01

When using LLVM to compile btrfs-progs, two unused global variables are exposed.
Fix them.

Secondly recently I move to use `GNUmakefile` to customize the make behavior,
e.g. add "-j12" make flags, without modifying the existing Makefile.

Also add GNUmakefile to gitignore.

Qu Wenruo (2):
  btrfs-progs: remove set but unused variables
  btrfs-progs: gitignore: add GNUmakefile

 GNUmakefile                     | 2 ++
 cmds/inspect-tree-stats.c       | 3 ---
 cmds/rescue-fix-data-checksum.c | 2 --
 3 files changed, 2 insertions(+), 5 deletions(-)
 create mode 100644 GNUmakefile

--
2.56.0

