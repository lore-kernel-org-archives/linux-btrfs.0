Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F24AA3C2F
	for <linux-btrfs@vger.kernel.org>; Sun, 22 Feb 2026 23:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771802010; cv=none; b=fTDQrzAd1ohl29Si6A4532z/Iywbvl5oWt+t9M1gln9C6FzY9/GqORcako5ZuEuh889nmCJLOHd7XYYwH4xCJ0WcHEAddwgCLMnSdFooo+wVEeOzBRk9qlNZoF9OLDZtAKxLBDI/Dlipre3L8artG34NXLXcMD6o4TMyJJPdxPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771802010; c=relaxed/simple;
	bh=f9W6v1qRmuCh7d6CkLPD7V6x2bnsccY++gqvdCziuH4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=PpBi2XjUnBW4ENg6+CVU1kQ1XudSSfQUf9JSwzk6J9vHF/kBr1K22wKIhqg4FptKqVKa2RsCIXZPdRVPjPuRRBXDMOrP6AlUu9JZg5U8V0dKM+cuzpHNEu87XJqmpGNRerFFg6JCZjpV4ffOCKco+LM1BF5itduTbr3zfMwu7V8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=c3hzdEA4; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=c3hzdEA4; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="c3hzdEA4";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="c3hzdEA4"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 48A133E962
	for <linux-btrfs@vger.kernel.org>; Sun, 22 Feb 2026 23:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1771802007; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=gOhbKA4J9ggp0FMraxyJYbFnuXCT1CBLJ+ldFO1chp4=;
	b=c3hzdEA4Z/VqRSqnRX7sNpdGkh9KKRe1HGyAHz1F3Kcz7SrCVDyGXdKTcdxdWw5kdy5kVT
	Rw30xegk4xBSc1DYTcbdYBrM0aYXlcn3eqA1EIxIJG4iby09lc5W96NnfdfKE0x2MXxpEo
	nsvp57Oc801qmVrU+xED4c0YwZqygh8=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1771802007; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=gOhbKA4J9ggp0FMraxyJYbFnuXCT1CBLJ+ldFO1chp4=;
	b=c3hzdEA4Z/VqRSqnRX7sNpdGkh9KKRe1HGyAHz1F3Kcz7SrCVDyGXdKTcdxdWw5kdy5kVT
	Rw30xegk4xBSc1DYTcbdYBrM0aYXlcn3eqA1EIxIJG4iby09lc5W96NnfdfKE0x2MXxpEo
	nsvp57Oc801qmVrU+xED4c0YwZqygh8=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 791FE3EA68
	for <linux-btrfs@vger.kernel.org>; Sun, 22 Feb 2026 23:13:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id dj3zDpaNm2n0NwAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sun, 22 Feb 2026 23:13:26 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/3] btrfs-progs: fix dropped 'const' qualifiers exposed by the latest GCC (15.2.1)
Date: Mon, 23 Feb 2026 09:42:57 +1030
Message-ID: <cover.1771801832.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO

It looks lile the latest gcc has taken the 'const' qualifier checks one
step further, a char pointer that points into a string that has 'const'
qualifier should also has 'const'.

This will expose unexpected modification like the following:

 void my_func(const char *options)
 {
         char *dot;

         dot = strchr(options, '.');
         if (!dot)
                 *dot = '\0';
 }

In above example, @dot is either NULL or points to a location inside
@options. For the later case, since @dot itself is not const, we can
modify the content, resulting modification of the content of @options.
The latest GCC is able to detect such proxy modification and gives us
warning on them.

And in fact, btrfs-progs has exactly such proxied modification in
bconf_save_param(), fixed in the last patch by dropping the 'const'
quailifer.

Other than that, most are just false alerts and we can fix them by
adding a const quailifer.

Qu Wenruo (3):
  btrfs-progs: enhance find_option()
  btrfs-progs: constify the @dots variable inside parse_range_u64()
  btrfs-progs: drop the 'const' qualifier from bconf_save_param()

 common/parse-utils.c |  4 ++--
 common/utils.c       | 24 ++++++++++++++++++------
 common/utils.h       |  2 +-
 3 files changed, 21 insertions(+), 9 deletions(-)

--
2.53.0

