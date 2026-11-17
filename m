Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794895128;
	b=mGjHN+2KabErfTchL+Z2SLFTRoRf4TBi/kc30iQiXlcTzph5mjfeZOD0p/aVS2NyN2dA
	 JWe1psj/F10pNbOHSMJu2YtpHVDyYm/kK6/hG3asEJ6qSyXSFCAKwVNCEM2NVL1tsIznK
	 Eml2bI6OepkpP0dpMq5QENEPvcuXrlkmXjQAGsaplaUMEFGhgdmsTwAdC+GObwSI7jUEZ
	 eAYuEokKfVkA1AsjfE4sLBIfxumQR5TeIFMDsMpLu+REqcdwG3F1CQsbxfbTJe67kenqZ
	 IigQ7JVFapXrymuYLqnSfhaeN7QTfoFBMZr4+5rM/gOFS0aB3B1nIIOwGW5wNLZermA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794895128;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Spamd-Result:X-Spam-Score:X-Spam-Level:
	 X-Spam-Flag;
	bh=eWyiJtFXT9YSFf9KIFExZuZIeXWnvK+oaOE1JwdHLEk=;
	b=v1XMqwNjJmYVxkKuGk2antfwvRauYKNy7yeGm4DmFSEkXrh8M5gEBQ4+Cc05D/yYG5S6
	 Q6H9cfwcRCkElxT6WR3id94NLP/wCdzPy3AdqrCym8JmF5IE/zx6X5D45cbWAJZzoSvEm
	 l5Wl1TEfBsXLd/raz4y2rPmdN+Vue24uupe+5J7jyh6T0rJnpMtpF0u7BbHdk2nK7+RfD
	 SVqdi/bXf1O/xRkAbyHrYQ6MhWCcN/kBCKjOQZ7keaAxYTzB1Hl1t03HGgoQlLhc6zRkI
	 0Vgv8dGEulFM/UqrHi2gZo7wTekjb7rVgXISazqzKWDqSRi1USjtOfdONDd3kGWIxxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=OhhsPDYA;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=OhhsPDYA;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E93606A31C;
	Tue, 17 Nov 2026 05:58:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 52E93606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=OhhsPDYA;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=OhhsPDYA
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4225022330;
	Tue, 17 Nov 2026 05:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794895119; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=eWyiJtFXT9YSFf9KIFExZuZIeXWnvK+oaOE1JwdHLEk=;
	b=OhhsPDYAo7Mob2DRKuNV08jQcslAIjY79md6KqZwpy7PW8YmLI8FeRQkAzTVzx8opOpSL4
	djV+3piWkVn3hx8pNh1IQXC7b2v6ZDd73ztbu7M5NsyOlGIWbcBWh6ToTDhG7E6lYClEve
	b3GuCtf7vcpku3fa43VfzRDzB+jSRSA=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794895119; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=eWyiJtFXT9YSFf9KIFExZuZIeXWnvK+oaOE1JwdHLEk=;
	b=OhhsPDYAo7Mob2DRKuNV08jQcslAIjY79md6KqZwpy7PW8YmLI8FeRQkAzTVzx8opOpSL4
	djV+3piWkVn3hx8pNh1IQXC7b2v6ZDd73ztbu7M5NsyOlGIWbcBWh6ToTDhG7E6lYClEve
	b3GuCtf7vcpku3fa43VfzRDzB+jSRSA=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 23DF713302;
	Tue, 17 Nov 2026 05:58:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0iMMHQzt+2piJwAAD6G6ig
	(envelope-from <wqu@suse.com>); Tue, 17 Nov 2026 05:58:36 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org,
	workflows@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: [PATCH] btrfs: add a per-subsystem agent file
Date: Tue, 17 Nov 2026 16:28:18 +1030
Message-ID: <df1c1fa031ba7e66486348dc37d1a7be53c18e43.1794894953.git.wqu@suse.com>
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
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,sashiko.dev:url,suse.com:email];
	URIBL_BLOCKED(0.00)[suse.com:email,sashiko.dev:url,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -11.80
X-Spam-Level: 
X-Spam-Flag: NO

I believe btrfs is not the most affected sub-system, but a lot of
newbies without common senses are doing more harm than help.
E.g. wasting a lot of human review time on very low value fixes, filled
with long paragraphs and useless test steps/results.

So it would be better to let those agents to stop being stupid and
follow the more common practices here, and hopefully those newbies can
build some common sense.

I hope the agent file is clear and short enough, that is not only
readable for LLMs, but also for humans who want to be long term
contributers.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
Reason for RFC:

Some practices are my personal preferences, like prefer ASCII charts
over long paragraphs, and short sentences/paragraphs.

But I guess some of btrfs developers may not even agree on my
preferences.

Thus feed back from well known btrfs developers are always appreciated.
---
 fs/btrfs/AGENTS.md | 136 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 136 insertions(+)
 create mode 100644 fs/btrfs/AGENTS.md

diff --git a/fs/btrfs/AGENTS.md b/fs/btrfs/AGENTS.md
new file mode 100644
index 000000000000..d527b862d9bc
--- /dev/null
+++ b/fs/btrfs/AGENTS.md
@@ -0,0 +1,136 @@
+Btrfs patch guidelines
+======================
+
+These rules apply to any code, commit message or cover letter touching
+fs/btrfs. They come on top of the top-level AGENTS.md and
+Documentation/process/coding-assistants.rst.
+
+Code comments
+-------------
+
+* Add a comment only when the code is not obvious by itself, e.g. a locking
+  rule, an ordering requirement or a non-trivial reason for a workaround.
+* Keep it as short and simple as possible, but do not cut the reasoning a
+  reader needs, e.g. for locking rules or races.
+* Do not restate what the code does. Do not narrate the change, and do not
+  add comments like "fix for ..." or "new helper to ...".
+* Remove any comment that does not carry information, but only in the lines
+  being added or touched. Do not drop unrelated existing comments.
+* Add kernel-doc only for complex functions. Do not bother for simple helpers
+  whose function and parameter names are self-explaining.
+
+Commit messages and cover letters
+---------------------------------
+
+Human readability comes first. A reviewer should be able to understand the
+problem and the fix from the message.
+
+* Use short and simple sentences. One idea per sentence.
+* Skip filler and long background.
+* Prefer a small chart or call trace over a long paragraph, see "Visual aids"
+  below.
+* Drop any sentence the reviewer does not need to understand the change.
+* Do not use the [BUG], [CAUSE] and [FIX] section tags for simple bugs. Write
+  plain paragraphs instead. Keep the tags only for complex bugs, where the
+  symptom, the cause and the fix each need several paragraphs.
+* Follow the style of well-known btrfs developers:
+  * The subject starts with "btrfs: ", is lower case after that, and is
+    imperative and specific, e.g. "btrfs: fix use-after-free when ...".
+  * Keep lines within 75 columns. Quoted text (dmesg, error messages, stack
+    traces) has no limit and must not be folded.
+  * Check `git log -- fs/btrfs` for recent examples before drafting.
+
+Visual aids
+-----------
+
+Prefer anything that makes the message easier for a human to read. An ASCII
+chart is a good choice when it explains the problem faster than prose, e.g.:
+
+* A race. Show the race window, do not describe it in prose only.
+* An error handling bug in a function, seen from several call sites.
+* A call chain across layers, where the bug only shows on a certain path.
+* The order of steps in a transaction commit or a log replay.
+
+Chart rules:
+
+* Function names only, no file paths or line numbers.
+* Show only the functions that matter.
+* Describe a state or outcome with plain text under the function name.
+* For a race, use one column per racing context (CPU, task, endio), side by
+  side.
+
+Follow the style of the examples below.
+
+Example, a race:
+
+```
+ CPU0 (endio)                       CPU1 (fsync)
+ end_bbio_data_write()
+ |-btrfs_folio_clear_writeback()
+ |                                  btrfs_sync_file()
+ |                                  |-filemap_fdatawait_range()
+ |                                  | Returns after writeback finished
+ |                                  |
+ |                                  \-test_and_clear_bit(COW_WRITE_ERROR)
+ |                                    Still 0, skips waiting
+ \-set_bit(COW_WRITE_ERROR)
+   Too late.
+```
+
+Example, an error handling bug, from commit c9583ada8cc4. The callee cleans up
+on error, then the caller cleans up again:
+
+```
+ btrfs_do_readpage()
+ |-submit_extent_page()
+ | \-submit_one_bio()
+ |   \-btrfs_submit_data_bio()
+ |     \-bio_endio()
+ |       Calls end_page_read() and unlock_extent().
+ |
+ \-end_page_read() and unlock_extent()
+   Cleaned up again, the subpage reader count underflows.
+```
+
+Versioned patches
+-----------------
+
+* Always provide the full history, not only the changes of the last version.
+* List every version, newest first, e.g.:
+
+  ```
+  v3:
+  - Rename the helper to xxx()
+  - Add a missing lock in yyy()
+
+  v2:
+  - Fix the build failure on 32-bit
+  ```
+
+* Put the history in the cover letter, or after the "---" line for a single
+  patch. Do not put it in the commit message body.
+* For a series, keep the cover letter history complete. For a patch changed
+  in a later version, also keep that patch's own history after its "---" line.
+
+Sashiko review
+--------------
+
+Sashiko posts AI-generated review for patches sent to the mailing list. The
+btrfs list is at https://sashiko.dev/#/?list=org.kernel.vger.linux-btrfs
+
+* The submitter should check Sashiko for bug reports on the posted patches.
+* If a report is valid, address it in a newer version.
+* If a report is wrong, it can be ignored. A reply on the mailing list only
+  makes sense when the report is complex or the reason is not obvious.
+
+Testing steps
+-------------
+
+* For minor and simple bugs, there is no need to add any testing steps. This
+  applies to the commit message and to the text after the "---" line.
+* A minor bug is one that does not affect normal use cases, e.g. an
+  unlikely error path, a corner case that needs fault injection, a tracepoint
+  or a debug-only problem.
+* Testing steps are only appropriate for a complex bug that can be hit in
+  normal use or have a deep impact, and also when they help the reviewer to
+  reproduce it.
-- 
2.56.0

