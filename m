Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0853329CE1
	for <linux-btrfs@vger.kernel.org>; Sat, 23 May 2026 15:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779548655; cv=none; b=Qx1Ksdls0AJJpfXOMCsrNjCEmTw4x48ke89H1KXPZCOEd4ReYsDUAF/CSEMKiEj9dd4zLNFcH0dNM5RrB+wSW3/3N4x+DTJld09SKEvbWiYP9m5DZiH+1Je/inUVIFOrs9oz36YSj1m6OJ3PmtJzzMajUocwBNiSyoHNyfxjiaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779548655; c=relaxed/simple;
	bh=HH+3NsC9wx9eIP4HJoxDA7EyZIF3iTjto5sOymwmEGY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Lhz8bOVQtl0Iyi2DD44tKs5am9YXaxjDJdGpqmsdnsSIBGct0viOrxqs4gzFj1V0n38BJ3/LFNvUJ4hcuSG5oFK8zV+7m+nXlt310EqwB7wj3GkU8Ooq4fHTnY/j5VjYtY6H3I4fyxyNrYU/9xPeJv9D3NICpJRV2hjw67hhT78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=r1gHNdeb; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=r1gHNdeb; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="r1gHNdeb";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="r1gHNdeb"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6CB7E6AC18;
	Sat, 23 May 2026 15:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1779548652; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=uaUfY06g/QDFaCWtKQpFHCFAjdFgL85fIES8QOWHXIE=;
	b=r1gHNdebv4yKhrnlwn0sXXMzguEHG+TZYhZkyMPuLOXDsr+O1LVt0iuS4LMLQ0guBq99PM
	q+D8U2FlgLyH7az2Gub4XZqPPEKCB8PCXYYNkvlHrZ/uRHHystEjBFScOYRYgpodYOKg3o
	HVNBsEl+xucmVg93Je4NGBT0bsKHwJY=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1779548652; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=uaUfY06g/QDFaCWtKQpFHCFAjdFgL85fIES8QOWHXIE=;
	b=r1gHNdebv4yKhrnlwn0sXXMzguEHG+TZYhZkyMPuLOXDsr+O1LVt0iuS4LMLQ0guBq99PM
	q+D8U2FlgLyH7az2Gub4XZqPPEKCB8PCXYYNkvlHrZ/uRHHystEjBFScOYRYgpodYOKg3o
	HVNBsEl+xucmVg93Je4NGBT0bsKHwJY=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 61219593A8;
	Sat, 23 May 2026 15:04:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uw0wF+zBEWqnUgAAD6G6ig
	(envelope-from <dsterba@suse.com>); Sat, 23 May 2026 15:04:12 +0000
From: David Sterba <dsterba@suse.com>
To: torvalds@linux-foundation.org
Cc: David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs fixes for 7.1-rc5
Date: Sat, 23 May 2026 17:04:09 +0200
Message-ID: <cover.1779547014.git.dsterba@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
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
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 
X-Spam-Flag: NO

Hi,

please pull a batch of fixes to simple quotas and one fix to inode size
handling. Thanks.

- simple quota fixes:
  - add conditional rescheduling point not dependent on the lock during
    inode iterations to avoid delays with PREEMPT_NONE enabled
  - fix subvolume deletion so it does not break the squota invariants
  - properly handle enabling squota, tracking extents in the initial
    transaction
  - catch and warn about underflows, clamp to zero to avoid further
    problems

- fix handling of preallocated extents beyond i_size when not using the
  no-holes feature

----------------------------------------------------------------
The following changes since commit c562ba61fc5e11798720acc1b172862158f1fa0b:

  btrfs: fix incorrect i_size after remount caused by KEEP_SIZE prealloc gap (2026-05-08 00:32:08 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.1-rc4-tag

for you to fetch changes up to f13342e15deafb7538a7a8577ed5f4c33c56f64e:

  btrfs: swallow btrfs_record_squota_delta() ENOENT (2026-05-16 03:08:40 +0200)

----------------------------------------------------------------
Boris Burkov (5):
      btrfs: always drop root->inodes lock before cond_resched()
      btrfs: check for subvolume before deleting squota qgroup
      btrfs: fix squota accounting during enable generation
      btrfs: clamp to avoid squota underflow
      btrfs: swallow btrfs_record_squota_delta() ENOENT

Robbie Ko (1):
      btrfs: mark file extent range dirty after converting prealloc extents

 fs/btrfs/extent_map.c |   4 +-
 fs/btrfs/file.c       |  11 ++++--
 fs/btrfs/fs.h         |   1 +
 fs/btrfs/inode.c      |   4 +-
 fs/btrfs/qgroup.c     | 101 +++++++++++++++++++++++++++++++++-----------------
 5 files changed, 83 insertions(+), 38 deletions(-)
