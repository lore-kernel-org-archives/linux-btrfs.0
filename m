Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 673DE330662
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Jun 2026 16:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782319914; cv=none; b=UEut23AKNfvbenE1PyMN7FoMdvama6EFMQWAOH8ESKAsjxXaC0ERogLXd3APcFKEUGI7Mkp1usYo38DG1/nwgZLGfHHsstkX0MhcbMRVcXFjo9eEu6P/nRiPEyvmYc16cE5z229nPOUJgV3FQYAay7ZA5sLq9QP3bpxow/77r+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782319914; c=relaxed/simple;
	bh=zTgx3ilLxt2zM0S75KL0awkTRUIONWc3w8EXdSQL7k4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bbsc+V5TsSE4/GUaTJyAXj//evSGLRnUk5Q9neygs9T97lqRyZ0kN+GU+cGSDQKi+0JKL5WcJetR4Pc3HvlcNDo5q4ZC6qVs+ES7gotGVZozQD9tgIQb19sBaW4R/gt3KoH0d2DZlihirJich3L3OSxyh8FCTd8sbbItoSE8F44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=jhMmKh+1; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=jhMmKh+1; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="jhMmKh+1";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="jhMmKh+1"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BC2C76D657;
	Wed, 24 Jun 2026 16:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1782319910; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=cW4XPqgvFkNAMKr0y0hEImXwCMZOOqLQtgYYlU3ouvI=;
	b=jhMmKh+1cgk0M9IlN/MOVkD2B5jKydedZLcQe7kKz2Kgz7BroQ1Nln4FVQO7PT5nkMrJ+S
	CpdU9pLpKTAGbeKd1KJIkNnQEBijrm8MaF2vMF+4bruiXj6cHeiQEVp07GW36bCb5bU/iu
	LgVYqnjw+CItHbQ6MY+Qt5GMw5wqJec=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1782319910; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=cW4XPqgvFkNAMKr0y0hEImXwCMZOOqLQtgYYlU3ouvI=;
	b=jhMmKh+1cgk0M9IlN/MOVkD2B5jKydedZLcQe7kKz2Kgz7BroQ1Nln4FVQO7PT5nkMrJ+S
	CpdU9pLpKTAGbeKd1KJIkNnQEBijrm8MaF2vMF+4bruiXj6cHeiQEVp07GW36bCb5bU/iu
	LgVYqnjw+CItHbQ6MY+Qt5GMw5wqJec=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A8560779A8;
	Wed, 24 Jun 2026 16:51:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4euYKCYLPGrUTgAAD6G6ig
	(envelope-from <neelx@suse.com>); Wed, 24 Jun 2026 16:51:50 +0000
From: Daniel Vacek <neelx@suse.com>
To: David Sterba <dsterba@suse.com>
Cc: Daniel Vacek <neelx@suse.com>,
	linux-fscrypt@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/8] btrfs-progs: fscrypt updates
Date: Wed, 24 Jun 2026 18:51:36 +0200
Message-ID: <20260624165144.556908-1-neelx@suse.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -2.79
X-Spamd-Result: default: False [-2.79 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.19)[-0.964];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 

This series is a rebase of an older set of fscrypt related changes from
Sweet Tea Dorminy and Josef Bacik found here:
https://github.com/josefbacik/btrfs-progs/tree/fscrypt

Since then the on-disk format changed and parts of the series had to be
reworked. Now it works with the v7 of kernel changes.

Particularly the encryption context is now stored as dedicated item and
not glued onto extent data item.

Also it was missing to recognize the ENCRYPT inode item flag. So now
it's properly parsed.

It passed all my tests. Hopefully nothing blows. Enjoy testing.

Daniel Vacek (1):
  btrfs-progs: recognize ENCRYPT inode item flag

Josef Bacik (1):
  btrfs-progs: check: fix max inline extent size

Sweet Tea Dorminy (6):
  btrfs-progs: add new FEATURE_INCOMPAT_ENCRYPT flag
  btrfs-progs: start tracking extent encryption context info
  btrfs-progs: add inode encryption contexts
  btrfs-progs: print encryptin type field of file extents
  btrfs-progs: handle fscrypt context items
  btrfs-progs: check: update inline extent length checking

 check/main.c                    | 29 +++++++++++++++--------------
 kernel-shared/ctree.h           |  1 +
 kernel-shared/print-tree.c      | 23 +++++++++++++++++++++++
 kernel-shared/tree-checker.c    | 17 ++++++++++-------
 kernel-shared/uapi/btrfs.h      |  1 +
 kernel-shared/uapi/btrfs_tree.h | 11 +++++++++++
 libbtrfsutil/btrfs.h            |  1 +
 7 files changed, 62 insertions(+), 21 deletions(-)

-- 
2.53.0

