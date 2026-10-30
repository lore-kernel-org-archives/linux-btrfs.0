Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793348433;
	b=udc4hP7NIRF/wV8aMTxxyZuZ0ytdTvW1x/BvL4+FjdER6AC8+rOeFfqZVehphHJ7P5lI
	 EFcCBp6EcBT7IMg1nYJ3fEOUrOd7KTVvPqnG19Jxp7kY2lf70hWP9owHqwhHucgQlx+Zi
	 fQNtaUDGBF7pgjNAp+AcaROd81vaWPQ4D3O1atGvSpllwc81VFyiM59GoGyE16RJloHvn
	 LA3SBYf75uHELn1WAr4AZv+h+gzQJZeRaCIsCl3YZ7gwDVZH0A8iPoI2WtDNKPuJ2Yroj
	 H2NFH4wUbDMQjAZEusBeNr7ps8NiXJJ9xPMEjxVmaYmgNPn2NzbohAzF/RzDc8oxzNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793348433;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-Spam-Flag:X-Spam-Level:
	 X-Spamd-Result:X-Spam-Score;
	bh=S2cjQ2XCEZCxoOwFpYMR41B5e0rCfWYpVcHXQ8umHs0=;
	b=UiMflsKQRrzYP8dJRH6WmRTIzc85bUgpi+X++ZwwIH2BDxzLoibCDYcPdvRTymzfQ33d
	 pN8n3bF6mcuGdrq4BhL4HNTyRLikKSJPGopRU9hA+G6G70svYy2FsMFOtGruzQHN1wrbI
	 TPdfJCBlrYEHB3ONaNu9CO5No7JoKpoUHq2qKamGF+E9e9264MiDcXm+s/HbXQYw6t5RR
	 RhDk7xD7EPlBeSddtWpe6+MnuitmScWcqIo6yxY92RtRr3s1D4/YsEusH8HBdh9OsUjmr
	 9TqBT1HIXi8UQGiILVyWkzb4eYU1nQa4n9y5eHWRYwyao7AdzryfmjdccxVltY55ysw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=oiGgx2rJ;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=oiGgx2rJ;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A7D606A31A
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 08:20:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F0A7D606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=oiGgx2rJ;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=oiGgx2rJ
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 29F5C1F74B
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 08:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793348431; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=S2cjQ2XCEZCxoOwFpYMR41B5e0rCfWYpVcHXQ8umHs0=;
	b=oiGgx2rJ81Dmh4kcUGi75dho5GIIhRTnNo5JO802PN/zqN3mzQBYTZy3N4i3mSyM0eMcrH
	kdy1GLzXAn2DGPtHPkdMAd6F+1/20UuxbGm1zl5W6YaNHMTIWrbbMmZkq0f03KqpRmSosp
	BL5telEEhKf71c7SxbmColAi1NstG5g=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793348431; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=S2cjQ2XCEZCxoOwFpYMR41B5e0rCfWYpVcHXQ8umHs0=;
	b=oiGgx2rJ81Dmh4kcUGi75dho5GIIhRTnNo5JO802PN/zqN3mzQBYTZy3N4i3mSyM0eMcrH
	kdy1GLzXAn2DGPtHPkdMAd6F+1/20UuxbGm1zl5W6YaNHMTIWrbbMmZkq0f03KqpRmSosp
	BL5telEEhKf71c7SxbmColAi1NstG5g=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1647513419
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 08:20:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CqwMGk1T5GpOFgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 08:20:29 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs-progs: python-test: prevent unmount failure caused by forkserver
Date: Fri, 30 Oct 2026 18:50:07 +1030
Message-ID: <fea3dc1dc9564aa42e16df1d219e1cb132e8549b.1793348391.git.wqu@suse.com>
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
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-12.30 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Spam-Score: -12.30

[BUG]
The python-selftests always fail for the following race tests after
updating to the latest 3.14:

  test_subvolume_iterator_race (tests.test_subvolume.TestSubvolume.test_subvolume_iterator_race) ... umount: /tmp/tmp29d00fl3: target is busy.
  ERROR

  ======================================================================
  ERROR: test_subvolume_iterator_race (tests.test_subvolume.TestSubvolume.test_subvolume_iterator_race)
  ----------------------------------------------------------------------
  Traceback (most recent call last):
    File "/home/adam/btrfs-progs/libbtrfsutil/python/tests/__init__.py", line 106, in tearDown
      os.rmdir(mountpoint)
      ~~~~~~~~^^^^^^^^^^^^
  OSError: [Errno 16] Device or resource busy: '/tmp/tmp29d00fl3'

  ----------------------------------------------------------------------
  Ran 1 test in 0.128s

  FAILED (errors=1)

[CAUSE]
Python 3.14 changed the multiprocessing on Linux, from the old 'fork' to
the newer 'forkserver':

 From https://docs.python.org/3/whatsnew/3.14.html#multiprocessing

 On Unix platforms other than macOS, ‘forkserver’ is now the default
 start method (replacing ‘fork’).

 From: https://docs.python.org/3/library/multiprocessing.html#contexts-and-start-methods

 When the program starts and selects the forkserver start method, a
 server process is spawned. From then on, whenever a new process is
 needed, the parent process connects to the server and requests that it
 fork a new process.

However the problem is, for all those race tests, we enter the mount
point, then fork new workers to do the race.
And the forkserver is spawned from our cwd, so it stays in the mount
point.

This means the new fork server will always stay at the mount point,
preventing us from unmounting the mount point with -EBUSY.

[FIX]
Revert back to the old 'fork' behavior, so that no forkserver is spawned
at the mount point to prevent the unmount.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
[CHANGELOG]
v2:
- Fix the subjective line
  Which was using an old but failed solution due to the forkserver
  using 'nobody' user by default.
---
 libbtrfsutil/python/tests/test_subvolume.py | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/libbtrfsutil/python/tests/test_subvolume.py b/libbtrfsutil/python/tests/test_subvolume.py
index 8119d2137942..7922bfe1946c 100644
--- a/libbtrfsutil/python/tests/test_subvolume.py
+++ b/libbtrfsutil/python/tests/test_subvolume.py
@@ -850,11 +850,12 @@ class TestSubvolume(BtrfsTestCase):
     # Only the new API
     def _test_subvolume_iterator_race(self):
         procs = []
+        ctx = multiprocessing.get_context('fork')
         fd = os.open('.', os.O_RDONLY | os.O_DIRECTORY)
         try:
             for i in range(10):
                 procs.append(
-                    multiprocessing.Process(
+                    ctx.Process(
                         target=self._create_and_delete_subvolume,
                         args=(i,),
                         daemon=True,
--
2.56.0

