Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 861F73803FA
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Jul 2026 08:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783414799; cv=none; b=hgdxKmmqYjynJhfaq5YtqwzY4h9rsHXKSHn00HVQ3QhQShQ2R8JS9yTnfIeT9JlMxh8Ix0OTFxPzNiD3VYoXXhmGdM0IKTMgvIc562YxrNQZpu6Ads9IkpNBvBzK+PWXC2UYMC+1G3IMprrlJV3OmopZa/TTzWSmPYXY/n9xpbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783414799; c=relaxed/simple;
	bh=dqlydHl6tLmKxsvx24AZyidNMsYpvNaK0NYMj0TQBUE=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=UYQW0WprNUQE6RiDKBo8sdWoyzJxZkw1YtC7gizdDK0589M3CRiGIb6m+G8cXpcZ8EBMhJtwrzm86VGdpv4qBqNlzgNsk7q0nJXPC/DcvG0CZMaD+SimJtfajOM9vpDwETiYQwGAWa6QpYJBCGDHeGFaeSQz5GRLmZZiOA6DSQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=UX1nuoSR; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=s3yv8vf6; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="UX1nuoSR";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="s3yv8vf6"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E66F973FBD;
	Tue,  7 Jul 2026 08:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783414791; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=FAW+yzKWV/bSihK1ssmvWLyaAxvQlbwY4IhsccwgptQ=;
	b=UX1nuoSR+LNwOnoZ1Xd1Ogsm4I7FQ88cQ4tb0Dmbq3oA7du0UG0Piiw4Xq8QZ61EES7wyB
	z7QHnOR6s2ntC3JjU+p+H1KFAKzqFZGThRokpPhG5xP8A8l75VLjAWRLWEWdORbWPhV72W
	tw8Yto0H8Nx3ybQoyNYYK9q+Lwqz+OM=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=s3yv8vf6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783414790; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=FAW+yzKWV/bSihK1ssmvWLyaAxvQlbwY4IhsccwgptQ=;
	b=s3yv8vf6aojCZw9/AEhTajpF0EZN5bZlvKtFIfOc89/rc+ZoX6HrQvJs1tFQTXffkfa6gZ
	R8qZrRy3Za0So8vr58U0bt0LY2z0VJchsPfXmJOUsE2DASNnRw7Cv7v4a8lzof25KvtcKr
	Wd7H8YAlZOCL2UcTwmsWJKrPeFUvBVM=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 99B98779AE;
	Tue,  7 Jul 2026 08:59:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4fo+EgXATGpIJAAAD6G6ig
	(envelope-from <wqu@suse.com>); Tue, 07 Jul 2026 08:59:49 +0000
From: Qu Wenruo <wqu@suse.com>
To: fstests@vger.kernel.org,
	linux-btrfs@vger.kernel.org
Subject: [PATCH] fstests: generic/062: avoid warning from polluting the golden output
Date: Tue,  7 Jul 2026 18:29:30 +0930
Message-ID: <7df0f6d0323abed08ffb1f40775474e4b39fef19.1783414762.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: E66F973FBD
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim,suse.com:email,suse.com:mid];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

[FAILURE]
With the latest setfattr (provided by attr 2.6.0), the test case
generic/062 will fail like the following:

 FSTYP         -- btrfs
 PLATFORM      -- Linux/aarch64 btrfs-aarch64 7.2.0-rc1-custom-64k+ #22 SMP PREEMPT_DYNAMIC Tue Jul  7 16:05:57 ACST 2026
 MKFS_OPTIONS  -- -O bgt -K /dev/mapper/test-scratch1
 MOUNT_OPTIONS -- /dev/mapper/test-scratch1 /mnt/scratch

 generic/062  1s ... - output mismatch (see /home/adam/xfstests-dev/results//generic/062.out.bad)
     --- tests/generic/062.out	2024-04-25 18:13:45.101553098 +0930
     +++ /home/adam/xfstests-dev/results//generic/062.out.bad	2026-07-07 18:22:12.384539920 +0930
     @@ -649,6 +649,7 @@
      SCRATCH_MNT/lnk
      SCRATCH_MNT/reg
      *** restore everything
     +Warning: option --restore=file is unsafe without option -P (--physical) as it traverses symbolic links in pathnames
      *** compare before and after backups

      *** unmount
     ...
     (Run 'diff -u /home/adam/xfstests-dev/tests/generic/062.out /home/adam/xfstests-dev/results//generic/062.out.bad'  to see the entire diff)
 Ran: generic/062
 Failures: generic/062
 Failed 1 of 1 tests

[CAUSE]
That output is a warning from the latest attr, introduced by attr commit
3fb06b9ba314 ("harden setfattr --restore").

There is also a compile time flag to toggle that warning.

[FIX]
Since we have no way to know if the setfattr command from the running
environment has that hardening or not, and the way to disable that
warning is to use "-P" option, which does not exist in older versions,
just redirect the stdout into seqres.full to avoid pollution.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 tests/generic/062 | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tests/generic/062 b/tests/generic/062
index 896590403fda..faeb9650c608 100755
--- a/tests/generic/062
+++ b/tests/generic/062
@@ -186,7 +186,9 @@ _create_test_bed
 _extend_test_bed
 
 echo "*** restore everything"
-setfattr -h --restore=$tmp.backup1
+# For attr 2.6.0, --restore= without -P will output a warning.
+# Redirect it to avoid polluting the golden output.
+setfattr -h --restore=$tmp.backup1 >> $seqres.full
 _backup $tmp.backup2
 
 echo "AFTER RESTORE" >>$seqres.full
-- 
2.54.0

