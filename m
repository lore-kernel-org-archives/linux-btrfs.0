Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86AE0369992
	for <linux-btrfs@vger.kernel.org>; Wed, 10 Jun 2026 22:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781130396; cv=none; b=bCYiQwp7PdemmFY8mgjUdRw6pvEiS8VaI43Kx4T3BjH7YB6uKNmHc8D1wWjMWduh7VqvKJi1MvuTtaEhGOtUKmK7mmmwJCkzVhtaY/zalIpCP+uHr0r1FtMSxO4Ahalv61NGhKBWabLYAyvd+Entapgvi+jcSGWP9G1Vc13FnSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781130396; c=relaxed/simple;
	bh=oaluVsM9ZrJjrqkY93bssQX0ZOOXU9GaMbxhUG/KkYg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AzxHX/6qLYkNzk+KORDEx0laAXPgBuLt5MR6spGHy5UQcLEtckUxNpxITRkONe31uu4FkjQzIePrb93RvLH0gb+23H7Rh+xhV8SgLZfH6Sa23rEJk4KV5cA5hFIz3wUDVn0TC7j+hqyLNKwSv7xH5Onea/ZQs6TFJKMar2j/Suc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=iayu1c0/; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=gTvcvrdI; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="iayu1c0/";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="gTvcvrdI"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C0BBB759F8;
	Wed, 10 Jun 2026 22:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1781130393; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=H1+x5xxTSjZLgvq4mZCegUaVcGnwLb8G2R5scTy1LKI=;
	b=iayu1c0/CK0gVlM4J3Ys6f2O3tSPDrcg+1cXOaiPCZJ8dRRGvDaTnsx0E4ffTr+mAijw35
	dIOSXYgFrZntbC1ohhNqL/yaKmxObsP4LXyD3MS1VdZ4Bj8QuTPH/qZUXUcQWzcnoHfo5H
	4AjySM+QNQhiWUl5EFUCVdZumh4tmpA=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1781130392; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=H1+x5xxTSjZLgvq4mZCegUaVcGnwLb8G2R5scTy1LKI=;
	b=gTvcvrdIOKJ5JUgKGkd4n4DtSAWWOwab6BBoTZvtCOzQQWbG2P+JRefoH9nNB/J0CQxuzK
	6q/KR/XmmQ9SiC1mgPjiztxjwD0lsVI9EjU1HIf3FhO3q6iCqswNpBLG+xDY5C/n8pSFRw
	bAcGIQ+ZmQwJbpZ2EeOuavHt6+m8u74=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 223AE779A7;
	Wed, 10 Jun 2026 22:26:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sht2MJbkKWqdKwAAD6G6ig
	(envelope-from <wqu@suse.com>); Wed, 10 Jun 2026 22:26:30 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>
Subject: [PATCH] btrfs: tree-checker: validate INODE_REF's namelen
Date: Thu, 11 Jun 2026 07:56:12 +0930
Message-ID: <581e4f2fddc1a4cbf1ba6954ece973c36da60dd1.1781130368.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,asu.edu];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:mid,asu.edu:email];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Level: 

From: Weiming Shi <bestswngs@gmail.com>

[BUG]
A crafted btrfs image can trigger the following crash:

 BUG: unable to handle page fault for address: ffffd1dc42884000
 #PF: supervisor write access in kernel mode
 #PF: error_code(0x0002) - not-present page
 CPU: 9 UID: 0 PID: 1034 Comm: poc Not tainted 7.1.0-rc4-custom+ #383 PREEM=
PT(full)  46af0a92938a63be7132e0dfd71e62327c51d5c2
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS unknown 02/02/2022
 RIP: 0010:memcpy+0xc/0x10
 Call Trace:
  <TASK>
  read_extent_buffer+0xe4/0x100 [btrfs 3cf0785dd58fec8c5ff84633b772f17ce1f9=
2a8f]
  btrfs_get_name+0x15e/0x1e0 [btrfs 3cf0785dd58fec8c5ff84633b772f17ce1f92a8=
f]
  reconnect_path+0x165/0x390
  exportfs_decode_fh_raw+0x337/0x400
  ? drop_caches_sysctl_handler+0xb0/0xb0
  </TASK>
 ---[ end trace 0000000000000000 ]---
 RIP: 0010:memcpy+0xc/0x10
 Kernel panic - not syncing: Fatal exception

[CAUSE]
The crafted image has the following corrupted INODE_REF item:

	item 9 key (258 INODE_REF 257) itemoff 11544 itemsize 4106
		index 2 namelen 4096 name: d\000\000\000\000\000\000\000\000\000\000\000\=
000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000=
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\00=
0\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\0=
00\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\=
000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000=
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\00=
0\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\0=
00\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\=
000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000=
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\00=
0\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\0=
00\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\=
000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000

The itemsize matches the namelen, but the namelen is 4096, way larger
than normal name length limit (BTRFS_NAME_LEN, 255).

Meanwhile the memory of the @name is only 255 byte sized, this will cause
out-of-boundary access, and cause the above crash.

[FIX]
Add extra namelen verification for INODE_REF, just like what we have
done in ROOT_REF checks.

Now the crafted image can be rejected gracefully:

 BTRFS critical (device dm-2): corrupt leaf: root=3D5 block=3D30572544 slot=
=3D14 ino=3D259, invalid inode ref name length, has 4096 expect [1, 255]
 BTRFS error (device dm-2): read time tree block corruption detected on log=
ical 30572544 mirror 2

Link: https://lore.kernel.org/linux-btrfs/aik0hEV6ehKx6Ldv@Air.local/
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
[ Rebase, add a Link: tag, add an simple cause analyze ]
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/tree-checker.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index b7ff3e3d3a63..9452414e2164 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1896,6 +1896,12 @@ static int check_inode_ref(struct extent_buffer *lea=
f,
=20
 		iref =3D (struct btrfs_inode_ref *)ptr;
 		namelen =3D btrfs_inode_ref_name_len(leaf, iref);
+		if (unlikely(namelen =3D=3D 0 || namelen > BTRFS_NAME_LEN)) {
+			inode_ref_err(leaf, slot,
+				"invalid inode ref name length, has %u expect [1, %u]",
+				namelen, BTRFS_NAME_LEN);
+			return -EUCLEAN;
+		}
 		if (unlikely(ptr + sizeof(*iref) + namelen > end)) {
 			inode_ref_err(leaf, slot,
 				"inode ref overflow, ptr %lu end %lu namelen %u",
--=20
2.54.0

