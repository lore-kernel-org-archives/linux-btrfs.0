Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794004898;
	b=WGEIgT1NnfvXr7RitHrtQbSaEp2LpGCXFWDRfT410TL48v+HylOpTPNcv6BpFtGcoH7t
	 9v3VVobZadOk/CDkJh+cNtKeve7zWsKCl/d8bsmeZACekMwef+RDv2fIQd6RRCIJJa4jw
	 V5J2+kM7HFUyonmqWHeTM/v9Mie2mTE/c0b2DAf2JW2qu0fTBUvENZpZ+bUiqzJAgh5YX
	 ep4kKUcv4a2JrYRkpLC4s+HsJSap8q5OOm/EyFohCVoCcRJBLnk9pMuiBmRffA7WmxPG4
	 Ysq80KaikFoLpijDNUgdS7qsAI0wZUl0Tbj7Zn9yMrxjo7sYDDRF4oCtRIC5f3nsRsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794004898;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-Spamd-Result:X-Rspamd-Server:
	 X-Rspamd-Action:X-Spam-Flag:X-Spam-Score:X-Spam-Level:
	 X-Rspamd-Queue-Id;
	bh=6BjTgIhGUAPhfigNdAuNWtPKBlkT32K3JoRDGgq2eLU=;
	b=c1dIEcDG2MdQ5AadDZdmr66eZUbnHRfEILKKwR4UF0NDCaeYG9ExZjwtpH5axRQXUgPq
	 pHeyJli9QYjoZ2CzNSMaH63IiJuOGNXM8+ljjt4H9tzZ4np+/HBPDTf9VxKr0NOCEYqvJ
	 Rm20Q7x751+Ps55LlWIayLeV04biIZUMfsB7/cI6DHI0rh47R52bIXMaa5lODmS0utQlB
	 7h9i09WdAhdq9CikyNl/SFZ1WjyA1OoA+/cr5/0tRxrpY1yBnPsQ07CIL7tgdZggEBCYt
	 0IheYNd1zblEAZCKSnZmBtBLNApzhG3u6tPq9dAU5NWdcgj5cG7DMQmn5XkufOmnGfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=rhtAfG6L;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=rhtAfG6L;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7F17606A326
	for <linux-btrfs@vger.kernel.org>; Fri,  6 Nov 2026 22:41:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C7F17606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=rhtAfG6L;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=rhtAfG6L
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B440E21F9D
	for <linux-btrfs@vger.kernel.org>; Fri,  6 Nov 2026 22:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794004894; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=6BjTgIhGUAPhfigNdAuNWtPKBlkT32K3JoRDGgq2eLU=;
	b=rhtAfG6LuCVLqr7FwaMU8NZAzlyGTnU1RaBbC1AxmIi5lFivaoiOzMZs+rlZKypJBZ1znt
	qXv4PRo6qaoPekh1VSYzpEqXNATgQNXl8CRJJf6ASRfx+v3wWWpeBspald0PPemRO4gMKb
	c3QH3zCyZQRj7MfZ+UvcaheHHvg3cZ0=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=rhtAfG6L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794004894; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=6BjTgIhGUAPhfigNdAuNWtPKBlkT32K3JoRDGgq2eLU=;
	b=rhtAfG6LuCVLqr7FwaMU8NZAzlyGTnU1RaBbC1AxmIi5lFivaoiOzMZs+rlZKypJBZ1znt
	qXv4PRo6qaoPekh1VSYzpEqXNATgQNXl8CRJJf6ASRfx+v3wWWpeBspald0PPemRO4gMKb
	c3QH3zCyZQRj7MfZ+UvcaheHHvg3cZ0=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 653AE132C9
	for <linux-btrfs@vger.kernel.org>; Fri,  6 Nov 2026 22:41:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id NBMWKpxX7moVbQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 06 Nov 2026 22:41:33 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs-progs: crypto/crc32c: cleanup and reimplementation to reduce asm usage
Date: Sat,  7 Nov 2026 09:11:12 +1030
Message-ID: <cover.1794003341.git.wqu@suse.com>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-12.51 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -12.51
X-Spam-Level: 
X-Rspamd-Queue-Id: B440E21F9D

Although kernel is using a lot of ASM files for hardware acceleration,
we also have projects like google's crc32c
(https://github.com/google/crc32c) which doesn't have any inlined or
dedicated asm file.

The idea is that we have compiler wrappers for those instructions
already, considering how rare modern developers read/write asm code,
reducing asm code will improve readability in the long run.

The first patch is remove the inline asm usages, the second one is to
remove the only asm file for crc32-pcl optimization, and replace it with
a C function.

Qu Wenruo (2):
  btrfs-progs: cleanup inline asm usage
  btrfs-progs: crypto/crc32c: port crc32c-pcl optimization to C

 Makefile                         |  14 --
 common/cpu-utils.c               |  31 +--
 crypto/crc32c-pcl-intel-asm_64.S | 370 -------------------------------
 crypto/crc32c.c                  | 282 +++++++++++++++++++++--
 crypto/hash-speedtest.c          |  14 +-
 libbtrfs/crc32c.c                |  43 +---
 6 files changed, 284 insertions(+), 470 deletions(-)
 delete mode 100644 crypto/crc32c-pcl-intel-asm_64.S

--
2.56.0

