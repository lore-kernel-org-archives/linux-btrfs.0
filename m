Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793701133;
	b=jeZRcPoxQJvoAs8nRS71QR+pbvIDslinBreSXPnw4JXSCyx+gV2eI74YN9QvJPysdyKP
	 jZxJgDWTZosbgnA3IavZjEwamC/41J1ExfTdFEleGJCpXvIuF91SSOLuynJ04wKJ8GtQV
	 702b9pL/XAojOAxlBBuIOUcjuObs8f1f+3CnDocwQWhsP5AHyzLgnpKaWT+7IV/7hDaLL
	 nf7Nwm0yO+kUbT6sz2/zWbgrSDRzmWPKdEQscnZdTl/kxX78zfLDRlRZWdWG4Yyrcfr7i
	 kiSr/eeHqr5p/v9gaxstNRJV5RPrUpd0PxJ9IwFZ6KnSnIbkbZ6y+meEjbjqTsdF7nA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793701133;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Rspamd-Queue-Id:X-Spam-Level:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spamd-Result:
	 X-Spam-Score;
	bh=2IPcmlyRvJ8iRYg3OBZQsI2txnzbEhL9u59SEH/RRu0=;
	b=UwLGG5u3Q+CAj1j34Lq4N2rhjqvmuyooWN1GEeGpnrxM8ym6bHA6uTZ8iSD1C+/YTbHp
	 ncYX7Hv8VWFZe3ymEUsZWGab/zJVf0+/krLuUZX06kRzr8kz+UpIl9Bsbe/6eBy6CLG0u
	 POJlhCdxCdAdM1mON4iRyljVSU2jyWBYP5sbgVMIRgJRDcIEpdByaJuc0icu5aPc74OAm
	 qJelTGqSyLnzIZF1Z8gsjVMvIq5lAYX/GB3bfe+/f/pw2/ovR+1RCrF18kDQ20AfWP//3
	 xFhZoH7Vp9tKAEKD2YmKtfLSQKOzyTtR7DKXw2Eplv/tI9pfYe3jYjN2RjpQa6YM4XQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=E0thsF6C;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=G95N2tCH;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD1F86085080
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Nov 2026 10:18:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CD1F86085080
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=E0thsF6C;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=G95N2tCH
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D735E1FCBC
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Nov 2026 10:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793701131; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=2IPcmlyRvJ8iRYg3OBZQsI2txnzbEhL9u59SEH/RRu0=;
	b=E0thsF6CEXtFHkcDNDQtffWD/QK+N+0RxGRGOqBaSkBuviUHke9+PrC6mjBR7LQAo9QUZH
	H1sV783zyb28o9uTe4KAeFSjkc9kFFd8TESBy+Z9qg8EpoU63T6c5saytmgcAsgVHaq5TP
	h5ghpwfdbKB3uttdV+HpLip6XpS0bZk=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=G95N2tCH
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793701130; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=2IPcmlyRvJ8iRYg3OBZQsI2txnzbEhL9u59SEH/RRu0=;
	b=G95N2tCHX4FE9xokH1eq5t/VJJpV8P1VdoVKc0hTGSikvGLnS2nLew3TC3dztRwxf7izeL
	Ryxn+t1mUg+YUvfrVHe/7WHQr0d/T8Qtw82n1mMlQzA1o9DiM5KQ3KG+XEpsZTCAIL7m/4
	+ZtOR7Q1Lbd1mdCbpIhif58KSEqCtAQ=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B25B41350A
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Nov 2026 10:18:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CiFWBQm16WpTewAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 03 Nov 2026 10:18:49 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: misc-tests/041: fix the false failure on fast machines
Date: Tue,  3 Nov 2026 20:48:31 +1030
Message-ID: <525911b78fa0219b2460e99d5eea38b0cb0855c8.1793701108.git.wqu@suse.com>
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
X-Rspamd-Queue-Id: D735E1FCBC
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-12.01 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FROM_HAS_DN(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim,suse.com:email]
X-Spam-Score: -12.01

[BUG]
On my VM, the test misc/041 always fails, but it never fails on github
CI:

    [TEST/misc]   041-subvolume-delete-during-send
unexpected success: deleting default subvolume by path succeeded
test failed for case 041-subvolume-delete-during-send

[CAUSE]
The root problem is my VM is a little too fast for send.

Sending 2.7G won't even take 2 seconds here.

Secondly, the "ps faux" check will always pass, as the command
`grep "btrfs send -f $steam"` will match the grep command.
So it never detects such too fast send runs.

[FIX]
Instead of relying on the file size to delaye the send, use a blocked
pipe instead.

The pipe read will sleep for 4 seconds before draining it into
/dev/null.

And we only sleep 2 seconds, so the send should still be blocked, and
we can do the test properly.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 .../041-subvolume-delete-during-send/test.sh  | 20 +++++++------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/tests/misc-tests/041-subvolume-delete-during-send/test.sh b/tests/misc-tests/041-subvolume-delete-during-send/test.sh
index b76cbb78b411..9b779fff7f49 100755
--- a/tests/misc-tests/041-subvolume-delete-during-send/test.sh
+++ b/tests/misc-tests/041-subvolume-delete-during-send/test.sh
@@ -13,29 +13,23 @@ run_check_mkfs_test_dev
 run_check_mount_test_dev
 
 run_check $SUDO_HELPER "$TOP/btrfs" subvolume create "$TEST_MNT/subv1"
-# Generate 2.7G of data to send, should be slow enough to let the subvolume
-# deletion catch send in progress
-for i in {1..10}; do
-	run_check $SUDO_HELPER dd if=/dev/zero of="$TEST_MNT/subv1/file$i" bs=50M count="$i"
-done
+# Generate 128M of data to send, far more than the pipe buffers can hold
+run_check $SUDO_HELPER dd if=/dev/zero of="$TEST_MNT/subv1/file" bs=1M count=128
 run_check $SUDO_HELPER "$TOP/btrfs" subvolume snapshot -r "$TEST_MNT/subv1" "$TEST_MNT/snap1"
 
-stream="stream$RANDOM.out"
-_mktemp_local "$stream"
 run_check "$TOP/btrfs" filesystem sync "$TEST_MNT"
-# Output to file must be slow
-run_check $SUDO_HELPER "$TOP/btrfs" send -f "$stream" "$TEST_MNT/snap1" &
+# Send blocks on a full pipe until the reader starts draining it, which is
+# later than the subvolume deletion below
+$SUDO_HELPER "$TOP/btrfs" send "$TEST_MNT/snap1" 2>> "$RESULTS" |
+	{ sleep 4; cat > /dev/null; } &
 # Give send time to start
 run_check sleep 2
-# If this fails, send was fast
-ps faux | run_check grep "btrfs send -f $stream"
 
-# Fail if send is still in progress, may not work on a really fast device
+# Fail if send is still in progress
 run_mustfail "deleting default subvolume by path succeeded" \
 	$SUDO_HELPER "$TOP/btrfs" subvolume delete "$TEST_MNT/snap1"
 
 # Wait for send
 wait
-rm -f -- "$stream"
 
 run_check_umount_test_dev
-- 
2.56.0

