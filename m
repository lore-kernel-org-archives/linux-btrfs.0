Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792917729;
	b=0pVo5fPV4r3PaJddlsEaoyQYSgvVIReeFfkfyxftJKNRozc1KtrTh/3Kyk3JjEx4RzNr
	 wR/K1l8pOTluFtMWaFMTVG6moWFBtrXk1h+RGIcn1bndvmQenWvnZgGPJiMH2B5yQiiXs
	 Sh05j/0Cayqpv6NTyoqpk6zgy9X0jCb5lXx5xVbLTkKhoULMK/BWSDSWyh+u8eLU6/CSe
	 lss/WTbzFJcvJMQyayqtqLGOjFOne/SWeV6heIkdDUV6Mqh7tbpX6ZP2VdDJvLC+HzlIN
	 xakkubLBpzW3tNgihcGOveBhw/OfF157OherlXdR2C77JNl7FJGIQ/POIeZbmJ6yTWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792917729;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Spamd-Result:X-Spam-Score:X-Spam-Level:
	 X-Spam-Flag;
	bh=/ISovdAvKZhRji/WWmdZvcVIKakjMbSQRRo2Kiai6C0=;
	b=Y+z1vZHqpiJrrILC5Hlp6EpUGgeoQuLnR+ga4stqabDt570at2HaJ+ayxZ8iw6ATxYxz
	 yq2lzmxau/oQbrkz8Nw/9PCKE0ht+9q0Ul1jQAKscBaqOAoSzWtrujphrIYi05zsStA/4
	 EklAjLIFu7dhJ2GM+0Mh4y1tUpypOzCY1m2NZwT4AysRrTHgK04A+LMeEvtoV6fWPfpsd
	 jNkgj74SnEHQCNX03tYDMp4kIHUqUsICDe3KHe6qPFWElO0KQHYAGNbxWp0SYFk1Wf+7G
	 /VF3tf8uPRFmFCctTHiwpVrrpUiO/wD4e57xgFJe0rJ4kIFl7dcMFHgM+DdAuXs8k3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b="ooT/TZod";
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=cotfhGpY;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D99B606A31A
	for <linux-btrfs@vger.kernel.org>; Sun, 25 Oct 2026 08:42:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4D99B606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=ooT/TZod;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=cotfhGpY
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 739E21F38A
	for <linux-btrfs@vger.kernel.org>; Sun, 25 Oct 2026 08:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792917727; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=/ISovdAvKZhRji/WWmdZvcVIKakjMbSQRRo2Kiai6C0=;
	b=ooT/TZodpaVQZEGzNB8dUculmTj/d2Pd8SkDK2cFI3EGctBUGdF3ahcBnGtwLbFU4ggLT7
	CrS+Nr8Z5UA3UsDjBAPqygxNT/VQMiiuFLtAXrfTemW/cy70bHlwzi3eutueFDxBhwhpxm
	uGILoeFn5jHQbotNEHWyhLDKSUX6evQ=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792917726; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=/ISovdAvKZhRji/WWmdZvcVIKakjMbSQRRo2Kiai6C0=;
	b=cotfhGpYXKELTW6x0h4HomCEhMcvoVnZ1CO0W/01paFnOdk9ciSgyIsRzpLY0sXaO0CZJ6
	XmNVN9ZBSX55KcGCXfcuWX8f9qGyp/9RpbpSxNVe/EmN/KeuBzXwlA6cWGEb0IEl5JfoMR
	3JdeqmQLqc7wY8qIWAqWOLuJM7aV96U=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3156713314
	for <linux-btrfs@vger.kernel.org>; Sun, 25 Oct 2026 08:42:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mglvH9zA3Wq5HgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sun, 25 Oct 2026 08:42:04 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 00/12] btrfs-progs: image: various LLM found memory
Date: Sun, 25 Oct 2026 19:11:34 +1030
Message-ID: <cover.1792914402.git.wqu@suse.com>
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
X-Spamd-Result: default: False [-11.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
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
X-Spam-Score: -11.80
X-Spam-Level: 
X-Spam-Flag: NO

The btrfs-image code base is pretty old (and to be honest, not written to
be read easily), and some stupid LLM-script-kiddies are reporting those
as security problems.

I don't want to argue with those guys, so just fix obvious memory related
problems for now.

There are still some left, mostly related to the corrupted tree
blocks handling, those will be addressed later, as I'm still trying to
figure out what's the best way to address them (e.g. tree-checker or
adhoc fixes).

There is also a problem in the filename image/sanitize.c, but that only
affects the filename sanitization, thus it's a very low priority item.

Qu Wenruo (12):
  btrfs-progs: image: destroy chunk tree after all pthreads finished
  btrfs-progs: image: only remove a chunk map from physical tree if
    non-empty
  btrfs-progs: image: cleanup pending ordered works after an error
  btrfs-progs: image: do not cleanup the thread that failed to be
    created
  btrfs-progs: image: free the buffer if output allocation failed
  btrfs-progs: image: avoid NULL-ptr-deref in build_chunk_tree()
  btrfs-progs: image: fix the error handling of build_chunk_tree()
  btrfs-progs: image: fix memory leak on async_work for restore
  btrfs-progs: image: fix overwritten ret in restore_metadump()
  btrfs-progs: image: validate the nritems before reading the content
  btrfs-progs: image: reject incorrect super block size
  btrfs-progs: image: properly error out when fseek() failed

 image/image-create.c  |  22 ++++++---
 image/image-restore.c | 109 +++++++++++++++++++++++++++++++++---------
 image/metadump.h      |   7 ++-
 3 files changed, 108 insertions(+), 30 deletions(-)

--
2.56.0

