Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792795628;
	b=QQTAKH2PMX1eqwR7OTNn7uCjcJXT2HJfYJz26zOkxxpkPfQhuHAFqyyLkkmfY80vwOP0
	 LEEvd7OnSexeApXX0ZWho4y7bYwIi8glJgcnAxnohCrUSGZPWF2sjcNIgz0Hv2UVV7rV0
	 fILGj16bLMZjywfKcP8YFvu7OB1BSlu6RJxFB+RSFjfgfV3Ni1FTkbIpTSRRwLFbA6hov
	 tofiI2/pAjZTmwvCjM06BhCfKUK9JQSJxLFrFtkdksJqlIRTuAqk8Hw/uIprsIKUMkopl
	 gzTjFTOllbKlI6BQpbkAJTps5E+tKhsCG3wH8LRbnS5rBR0kdMQX/3y/Oxc6GqAqJ/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792795628;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Spamd-Result:X-Spam-Score:X-Spam-Level:
	 X-Spam-Flag;
	bh=Oy32MtsIWkftnfhOzryF+xR7P3rweLd9CEHps30lgds=;
	b=pXnTkqa6wnNH3pqg+htg5XOF0u8uH0BZJe5GA9c5oMge9mYwMby4Yq5DrOMkrX0OkgWe
	 BbTaPkglESOaOPGHLH8DLt3+eZzD/X+dKlDF/pLrPjReSodtX2Q+bnwfmi81fw/DAG/mK
	 Xa/F17MBBPzorvGK4HubWSC+95HmuMHfGwak0rdRh/rOryT2i9t6YNqemD3Ca/anl99VR
	 JKJIWRUuPMcbsmnq+/lImLzjdGTbrNcS4wjCw4H8BFN63rAIl9FIIblT07ArOzUNznNue
	 1PXQXF6dTF47foMG+Q+mJYf/YtNraMg8rT9hrNoYDdoCQrV5aXbYKPjM6cnhG8x4esw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=oVuDlcQc;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=bjlYVD0u;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59FC606A31A
	for <linux-btrfs@vger.kernel.org>; Fri, 23 Oct 2026 22:47:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C59FC606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=oVuDlcQc;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=bjlYVD0u
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B9F9521F58
	for <linux-btrfs@vger.kernel.org>; Fri, 23 Oct 2026 22:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792795625; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Oy32MtsIWkftnfhOzryF+xR7P3rweLd9CEHps30lgds=;
	b=oVuDlcQcahXAM/47Xn6aXAmLJOM2oVN+QvAVs/WPt0CRC9Aay6d73cuPLwm70wFdAkHlyp
	8Um1oH2beWgS7wnFm72fdqat+kwxlWljtLBLncSYG/MvbyTQ78cuQemsNcNa3F13SAFL95
	kPr/6X2fd3UE+1x59VUdt6jN87q/sZI=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792795624; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Oy32MtsIWkftnfhOzryF+xR7P3rweLd9CEHps30lgds=;
	b=bjlYVD0uZFmDltn4jEg18xmxn2TgowaXlbULpWBLsMvHPe5haMqZMCjjZdbGoq+7JamT9+
	jpTSqNeNlL1lhab9tZ6FF9mLMk8twxsbJF7Fst5S/JLizpvJwc1wt42natAqYi0WiqRvve
	NvSJfUQsfdqJi+NigVg4M4Zn1jPMBtg=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 96083133F3
	for <linux-btrfs@vger.kernel.org>; Fri, 23 Oct 2026 22:47:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id nXmMHOjj22rhDgAAD6G6ig
	(envelope-from <dsterba@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 23 Oct 2026 22:47:04 +0000
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: Btrfs progs release 7.3
Date: Sat, 24 Oct 2026 00:46:58 +0200
Message-ID: <20261023224700.103333-1-dsterba@suse.com>
X-Mailer: git-send-email 2.55.0
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
X-Spamd-Result: default: False [-11.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[pypi.org:url,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -11.80
X-Spam-Level: 
X-Spam-Flag: NO

Hi,

btrfs-progs version 7.3 have been released (version 7.2 was skipped).

I've received several security reports, fixes will be in a future release. The
codebase is old and if you run AI scanners you will find bugs, probably the
same ones. The security policy and threat model is WIP.

Changelog:

* zoned mode: open host-managed devices with direct io, page cache cannot be
  used for synchronization due to ordering
* convert: set creation and change time of the root subvolume
* mkfs:
  * set creation and change time of the created subvolumes
  * make -O mixed work same as --mixed, so it does not create split block
    groups by mistake
  * for reproducible builds, honor SOURCE_DATE_EPOCH, SEED and for --rootdir
    order the files deterministically
* corrupt-block: allow inode and dir item corruption to use option --value
* check:
  * detect file extents for wrong inode types
  * on zoned filesystem, detect leaked active zones
* restore: handle inline extents larger than 4KiB, e.g. created on systems with
  64KiB pages
* build:
  * minimal version of util-linux is 2.31
* scrub limit: set to the original limit only after all devices finish
* other
  * new and updated tests
  * documentation updates

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git
Release: https://github.com/kdave/btrfs-progs/releases/tag/v7.3
Python: https://pypi.org/project/btrfsutil/
