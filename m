Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794952133;
	b=oOvmzS/QiCewcTLmasK8WfGOAV+5scRv6QptDDIC74ikF9WKc0YV8ltnaeS4XgdTqX4V
	 JhULxobf/UbB5uy9cbnhmNfRTgrv/CdwwvdS7ri6uVbyNtxbKw/s0z8MHZospalGHf/lX
	 81rZ96rrL2ki+fOS/iGJfeONVyfaZrrlEw4g7VF78UVShdIPZOwNS8DKilYYVlJY3LQVr
	 RGtt5yp15VdHU0Zue74SXIMDWnXHhCA3I0Iwz185tEzld/ce8ReIZSackkjLA04G0BJ6Z
	 NX33UtiotC/LrxyufAzz+6NFQdu9lURScVvETraecyQZJhy5a6tK7oa4PoC/rfj2ICw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794952133;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Flag:X-Spam-Level:X-Spamd-Result:
	 X-Spam-Score;
	bh=p8s+RYI/sHMw8I3vnjNrLbhTAtRf7xNgELV8LS8XePc=;
	b=t1xPiUjJ3YZgBa0OJDBGNu56cKvrBUCe18p+TNxNiCHu73CeUNq45SMGNhFPzrsq5fbO
	 1cLmYpT8ceHDgwcdf3MuyQEjTrM46rS63ZuWANDF3sppYwg43VKZ+Tl6kAoKu92WVP2ZJ
	 tBKVMmZLZL0LI+gP9DT5ixLq9r6VH2UdgoD5JEweat40zuwhSUgG4I/RbOoUFOixkTGtK
	 3g4CfGvEnnlfanL1rN3oEc0aSGtC3K52+TBXPF3sfEt2tDaRmvCoaxOquvyJ9o1QjKFk0
	 HLur4F+TCbtCapAmLxTNghViOuHuTfdbXmVlYt7oxT+TRQi9ZVwSlkhkI1FHmQgQKPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b="tVj5c/4P";
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b="tVj5c/4P";
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3416F606A31C
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 21:48:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3416F606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=tVj5c/4P;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=tVj5c/4P
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 663F21F803
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 21:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794952130; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=p8s+RYI/sHMw8I3vnjNrLbhTAtRf7xNgELV8LS8XePc=;
	b=tVj5c/4PLla9n8ryHY9KLkuy+b9KpDlJ37WvBy5f9s47s4oaQukgMw//oG0D9J32+Fy6b5
	HB6K652appBwcytqcA2vSoNwWnS9Md53d8y9eZOn8mVxK43devwQ82LV+JpdFkJCXEmu1l
	vzwws0ZC9IuOmbcYqfunMdaxPZR4Uto=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794952130; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=p8s+RYI/sHMw8I3vnjNrLbhTAtRf7xNgELV8LS8XePc=;
	b=tVj5c/4PLla9n8ryHY9KLkuy+b9KpDlJ37WvBy5f9s47s4oaQukgMw//oG0D9J32+Fy6b5
	HB6K652appBwcytqcA2vSoNwWnS9Md53d8y9eZOn8mVxK43devwQ82LV+JpdFkJCXEmu1l
	vzwws0ZC9IuOmbcYqfunMdaxPZR4Uto=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1BC7413302
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 21:48:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id FVJTGcDL/GoEBwAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 21:48:48 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/2] btrfs: scrub: fix several races which can lead to UAF
Date: Wed, 18 Nov 2026 08:18:28 +1030
Message-ID: <cover.1794951798.git.wqu@suse.com>
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
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-11.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
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

[CHANGELOG]
v2:
- Fix the race charts where the sequence is incorrect
  All functions are shown when there is enough space.

  Also re-order the functions to properly represent their correct time
  sequence.

- Do not use non-upstream commit number in the commit message

This is inspired by the fix in raid56:
https://lore.kernel.org/linux-btrfs/20261116001903.63524-1-mc@raidlab.org/

And there are two similar cases inside scrub.c:
- scrub_stripe::repair_wait
- scrub_stripe::io_wait

The only difference is, the window is much smaller compared to RAID56,
as most scrub_stripe structure have a very long lifespan, as long as the
scrub/replace ioctl. Only the RAID56 data stripes has a shorter
lifespan.

But still it's possible in theory, so here comes the same fix for scrub.

For repair_wait it's pretty straight foward.

For io_wait we have several locations that we submit a batch of bios in
one go, and pending_io may drop to zero during IOs.
Follow the existing behavior by grabbing one extra ref to ensure the
pending_io won't reach zero during IOs.

Qu Wenruo (2):
  btrfs: scrub: fix use-after-free when waking up the repair waiter
  btrfs: scrub: fix use-after-free when waking up the stripe I/O waiter

 fs/btrfs/scrub.c | 116 +++++++++++++++++++++++++++++++----------------
 1 file changed, 77 insertions(+), 39 deletions(-)

-- 
2.56.0

