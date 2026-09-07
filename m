Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E160C61FCE
	for <linux-btrfs@vger.kernel.org>; Mon,  7 Sep 2026 05:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788757717; cv=none; b=d9xzEtcXyD25wdMX6OyvBPPm9fV2W2nY1BWBnvXysX/5RQvDwDUSf0pP/k0jOSCEW++GBvo2XkQ8yaonO1u/CRKLJWvEv5fEYuuH8T/aud1u2LbJtuKrJjHD5RWROnITP7q0xAv7MHO3dMqfY3n84YR1UhcxorJ28JDl84Iiibs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788757717; c=relaxed/simple;
	bh=bbLb2AWdZqxMuOJvpAvyrTjfzzYlYsgue/ucsXuKSIQ=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=GmIxAZKz6ByVDQszRhr9h8pUoNwnow7dsfSfbEoXoyL0DrrgiXHJmCyGFSGEL8Ss9pWmolID06avfsk7yEm4W4tKr7voFIhg8PMBVh6Ml8guVSto+/59K1MuawF+EZKxq4FuRf56HLsHScbB3S9MgVG1o4waNqZ1amj1ixiThIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=cT7xMmiy; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=biPclqpp; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="cT7xMmiy";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="biPclqpp"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1BCB921AE1
	for <linux-btrfs@vger.kernel.org>; Mon,  7 Sep 2026 05:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1788757704; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=FF06gm6G+eI7500mFlzTkcTvFnNrQUs5ed13yd8j6XU=;
	b=cT7xMmiyniF/5N6GjWYBQSNqTLGm/P2TDfhG4qcoARl+SweWOWsmml2hc0YG459eT9qQ35
	74fVnGVNPQL5d1nggYNj8wo0lx0F5cOGUfzi6BE9oZXG2wKtvBVmjFW+F+Afh69iZw7fy4
	KrAZqPFtU+W/OSagPf38gNviz4+FmdI=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=biPclqpp
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1788757700; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=FF06gm6G+eI7500mFlzTkcTvFnNrQUs5ed13yd8j6XU=;
	b=biPclqppbXiycjSOWmwSygpfLAcgiDy2Cs7EL9xLEM+ZXe5nCjQi7k7h7NDKo1MpaXV0gL
	qpKihyCgT+1Dw6FYpDlJRBox9RODLEOVM7F1jxb/7HpkgH6MhQ5dlNBGpg9prJgKmq3ExE
	OlpMZ3v6TYyPAn4pmR7yrqgiNVlIe68=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DA5161339B
	for <linux-btrfs@vger.kernel.org>; Mon,  7 Sep 2026 05:08:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tD2PIcJGnmoDBAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 07 Sep 2026 05:08:18 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/4] btrfs-progs: enhance the backup root behavior
Date: Mon,  7 Sep 2026 14:37:51 +0930
Message-ID: <cover.1788743334.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 1BCB921AE1
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Flag: NO
X-Spam-Score: -3.01

The first one is a doc update to co-operate with the recent
"rescue=usebackuproot_*" mount option changes.

The second one is a simple unexport found during the development.

The third one is to fix false warnings when --tree-root option
is utilized.

The last one introduces new "--backup-slot <n>" option to allow end
users to specify which backup slot to use, giving them more control on
certain corrupted fses.

Qu Wenruo (4):
  btrfs-progs: docs: update the rescue=usebackuproot option
  btrfs-progs: unexport btrfs_setup_chunk_tree_and_device_map()
  btrfs-progs: check: use correct generation when -r option is provided
  btrfs-progs: check: introduce --backup-slot option

 Documentation/btrfs-check.rst      | 12 +++--
 Documentation/ch-mount-options.rst | 16 ++++++
 check/main.c                       | 58 ++++++++++++++++++++--
 kernel-shared/disk-io.c            | 80 +++++++++++++++++++++++-------
 kernel-shared/disk-io.h            | 12 +++--
 5 files changed, 150 insertions(+), 28 deletions(-)

--
2.55.0

