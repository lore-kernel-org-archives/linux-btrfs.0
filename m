Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8738D2F8E86
	for <linux-btrfs@vger.kernel.org>; Sun, 10 May 2026 00:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778372246; cv=none; b=CR7uPmaQVrmeTRRGBP19gNj1Cc7QZLpQg/GAk3+8ELotTsbego9ta9E7F6squLG911+Gi4hMGVQN86K3xLlT69IQBeYXNNFKgBwrAGoGlGLcSlFhrUQ4CS9nJx75i5LJfTmNPF67jmaj0zfPQ22SYWBJoQIwkjBLp45Pzh68pbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778372246; c=relaxed/simple;
	bh=JEgN0leWv1WeEdVf/VCrj3w6tZN5nfnZq+JstSXWCZE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Y7Vq66laOFby3+IzAaEC42HqDZRkkhPAQONzqagrSIQwBBTlzPMUb99Jv3+R7z38EHmMBK0iCp3VfUlzF0vXYBR8BWrCEONKzF+iC9FK80V44cg6K1XS+xTwOdhtcU0fpwPUuZLbN8bZWyunzYpadOFLNsxEUey9CT6OkITqVFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=JpGeemo9; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=JpGeemo9; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="JpGeemo9";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="JpGeemo9"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 63F4066F4B;
	Sun, 10 May 2026 00:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778372243; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=GQbiWNn8kxJXEIayBl+XM92BXEuRZaseK8H/ghNoWSA=;
	b=JpGeemo9P8VJTQ9MbbLbxuVe1wxvhXCow36zDYnvAHVjIHWnHY8N759QMVTu24VqXb1Dde
	LeLiTpK5uvKftYhZdoNVitcIJsR+B88ImGqXgdgSfV/ruzPgqlYhHvE5Ry4ZHvJxL0LxBv
	5ePE9BprB7LOlQ2/00PACc7Ld5ovqnk=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778372243; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=GQbiWNn8kxJXEIayBl+XM92BXEuRZaseK8H/ghNoWSA=;
	b=JpGeemo9P8VJTQ9MbbLbxuVe1wxvhXCow36zDYnvAHVjIHWnHY8N759QMVTu24VqXb1Dde
	LeLiTpK5uvKftYhZdoNVitcIJsR+B88ImGqXgdgSfV/ruzPgqlYhHvE5Ry4ZHvJxL0LxBv
	5ePE9BprB7LOlQ2/00PACc7Ld5ovqnk=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 29B44593A3;
	Sun, 10 May 2026 00:17:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sx/oNpHO/2lBTwAAD6G6ig
	(envelope-from <wqu@suse.com>); Sun, 10 May 2026 00:17:21 +0000
From: Qu Wenruo <wqu@suse.com>
To: fstests@vger.kernel.org,
	linux-btrfs@vger.kernel.org
Cc: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH] fstests: support new mkfs.btrfs help string
Date: Sun, 10 May 2026 09:47:04 +0930
Message-ID: <20260510001704.68396-1-wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:mid];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 

[BUG]
The latest btrfs-progs release v7.0 breaks a lot of tests, e.g.
btrfs/003:

btrfs/003    55s ... [failed, exit status 1]- output mismatch (see /home/kts/kernel-test-suite/src/xfstests/results//btrfs/003.out.bad)
    --- tests/btrfs/003.out     2026-05-09 03:07:52.952213772 +0900
    +++ /home/kts/kernel-test-suite/src/xfstests/results//btrfs/003.out.bad     2026-05-09 23:32:17.595751435 +0900
    @@ -1,2 +1,3 @@
     QA output created by 003
    -Silence is golden
    +mkfs failed
    +(see /home/kts/kernel-test-suite/src/xfstests/results//btrfs/003.full for details)
    ...
    (Run 'diff -u /home/kts/kernel-test-suite/src/xfstests/tests/btrfs/003.out /home/kts/kernel-test-suite/src/xfstests/results//btrfs/003.out.bad'  to see the entire diff)

[CAUSE]
Commit ec8324cc4b8b ("btrfs-progs: help: adjust alignment of text") from
btrfs-progs changed the helpe string output format, the previous help
string for "-f" option of mkfs.btrfs looks like this:

    -f|--force                force overwrite of existing filesystem

There were 4 spaces before the "-f", thus can be matched by
"[[:space:]]-f[[:space]|,]".

But now the help string looks like:

-f, --force               force overwrite of existing filesystem

Which removed the spaces at the beginning.

The existing regex to catch "-f" requires at least one space before
"-f", now it doesn't match the new btrfs help string, and cause mkfs
failure because we can not overwrite an existing scratch device without
"-f" option.

[FIX]
Change the regex to allow no space before "-f".

Reported-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Link: https://lore.kernel.org/linux-btrfs/af9EHC5b-aBdr1zn@shinmob/
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 common/config | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/common/config b/common/config
index 1420e35d..339f7767 100644
--- a/common/config
+++ b/common/config
@@ -103,7 +103,7 @@ set_mkfs_prog_path_with_opts()
 	# Note: mkfs.f2fs doesn't support the --help option yet, but it doesn't
 	# matter since it also prints the help when an invalid option is given.
 	if [ "$p" != "" ] && \
-		$p --help |& grep -q "[[:space:]]-f[[:space:]|,]"; then
+		$p --help |& grep -q "[[:space:]]*-f[[:space:]|,]"; then
 		echo "$p -f"
 	else
 		echo $p
-- 
2.51.2

