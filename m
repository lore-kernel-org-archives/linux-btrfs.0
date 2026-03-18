Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D7933D4E1
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Mar 2026 20:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773864308; cv=none; b=sFv3MmbNENAk0TSX5Ct6267ju4qrKwW4Sv50kIK3MglTZLQSP23TYSgXrMuqWYSGkA+KBc7FrBaY9uUTv0NzUX8taGQg3I6g8adexT3CzijFf4peYz01rQGMx59RvApcv94egnXRk9nrDncy9RbjlJBMESmCEERQcRDMJH/VcgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773864308; c=relaxed/simple;
	bh=q65ai55pVDNUotjJgnqfPaE2nmaSNgl8ZMAeuIycSVw=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=eMhrHFmKo5e4o+dF1FJesrWCe25B9mqCq4xo7HInmbQG516cD4qfY+p1E1JJ/fP0f8/jZ6Coe45egu+jPgqRAhpHZ4P296oItO/0riOfIyRF4mNHBIgN1WLthobNMnmDUThEcjphV+/qvChBKxJywQnBTnL8AFR31H91R0zEYa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Cp2BJDyT; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Cp2BJDyT; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Cp2BJDyT";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Cp2BJDyT"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5E7144D1C3
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Mar 2026 20:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1773864305; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=tI3eUBCu6ANHM5G+mnNO92tdAj3HF71ZO11iSYA/QCE=;
	b=Cp2BJDyT+pefYqXi6rCwnVgLcTWIKAUVP58ObRusfY1j//WRc2+/huZWYKkXOkbnIMj7JY
	mcNrIEl24sdt3w4ikFjPTSK1u45aAY8rCM2T8b8D0FPvNJbVCnC9NPVqxSC4aRinfOEb4R
	ieh2LlhQztsvi47gm0iY+v1lrLXlofA=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1773864305; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=tI3eUBCu6ANHM5G+mnNO92tdAj3HF71ZO11iSYA/QCE=;
	b=Cp2BJDyT+pefYqXi6rCwnVgLcTWIKAUVP58ObRusfY1j//WRc2+/huZWYKkXOkbnIMj7JY
	mcNrIEl24sdt3w4ikFjPTSK1u45aAY8rCM2T8b8D0FPvNJbVCnC9NPVqxSC4aRinfOEb4R
	ieh2LlhQztsvi47gm0iY+v1lrLXlofA=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 57C714273B
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Mar 2026 20:05:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hn1iFXEFu2lSQwAAD6G6ig
	(envelope-from <dsterba@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Mar 2026 20:05:05 +0000
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: Btrfs progs release 6.19.1
Date: Wed, 18 Mar 2026 21:05:03 +0100
Message-ID: <20260318200505.22729-1-dsterba@suse.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.98%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

Hi,

btrfs-progs version 6.19.1 have been released. This is a bugfix release.

Changelog:

* fix balance filter 'usage' that was incorrectly used for ranged usage
* core:
  * fix tree-checker vararg format print
  * stability fixes
  * compiler warning fixes
* other:
  * CI updates, action version updates, more build targets
  * cleanups, refactoring
  * minor documentation updates

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git
Release: https://github.com/kdave/btrfs-progs/releases/tag/v6.19.1
