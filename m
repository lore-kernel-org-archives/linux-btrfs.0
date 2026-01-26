Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44C9D298CBE
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Jan 2026 03:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769397883; cv=none; b=Z+65wJItG2+jqBK4CoLgjUGPzMvbYkH6BuYzh37clLRwaqp9AMG1/L0C6HnMsR56DlU201HbFg1VHo/WUFF2/9b5eEixKwzkR2qjxxz7G54OKTE/Y8rgyj1jgDy7Bd0g2dPmnkhNSNETRb2bbW2ZWaFF+/tb08oM8+xMwjYV1i8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769397883; c=relaxed/simple;
	bh=2s3LNdcqdh96O8uYOGWMhjXCPN+2imerUf5lDwgPzq0=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=F9Ynm+1dvpeGUHJyoytW3Y5mKOUTNcT8OPayAFvb/AG3e6uDbQoH1q5T5jSAP/qaT6n1xH6FYyHfsF8Z00HFAFuzrx5MSz2pu/wpzHtpIcaVnbyezFUvQByyqedW3FrGtNJGE5UrC/Vmau0xJ5imwjeRXSdvQ6LMPlg9WSxO3r8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=XDXbw9d0; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=XDXbw9d0; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="XDXbw9d0";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="XDXbw9d0"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 27A4533683
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Jan 2026 03:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1769397880; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=gnBIVFrdlgmm23w8CMhhAN+uZWpIEKfqUXlgsWdKt9Y=;
	b=XDXbw9d0entB74Ghvkph23IXB7a4eZwtOU69qk6milOoSfZ/CEY+VPGhTndro5ZkCrw1jn
	JjQbsaJPy691W7zfiKyEH0hnKrfJuSJGCfsvmjbf1ulRTQil7//XNZV2dTW8/ayMs9U85k
	oFKzBuyg9+NUhRHHG/9qTRgtGQcUt50=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=XDXbw9d0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1769397880; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=gnBIVFrdlgmm23w8CMhhAN+uZWpIEKfqUXlgsWdKt9Y=;
	b=XDXbw9d0entB74Ghvkph23IXB7a4eZwtOU69qk6milOoSfZ/CEY+VPGhTndro5ZkCrw1jn
	JjQbsaJPy691W7zfiKyEH0hnKrfJuSJGCfsvmjbf1ulRTQil7//XNZV2dTW8/ayMs9U85k
	oFKzBuyg9+NUhRHHG/9qTRgtGQcUt50=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1A50F139E9
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Jan 2026 03:24:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id XQIeLnbedmneXgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Jan 2026 03:24:38 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/9] btrfs: used compressed_bio structure for read and write
Date: Mon, 26 Jan 2026 13:54:07 +1030
Message-ID: <cover.1769397502.git.wqu@suse.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCPT_COUNT_ONE(0.00)[1];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_TRACE(0.00)[suse.com:+];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:dkim,suse.com:mid]
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Rspamd-Queue-Id: 27A4533683
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Level: 

[CHANGELOG]
v2:
- Fix an error in error path of of compress_file_range()
  If btrfs_compress_bio() returned an error, we should reset @cb to NULL
  before doing error handling, or cleanup_compressed_bio() can be called
  on an error pointer.

- Fix several bugs in zstd_compress_bio() which causes compression
  failure
  There are several different bugs in the mostly copy-n-pasted code:

  * Uncommon @start and @len usage
    The old code allows @start and @len to be modified, which is against
    the more common practice nowadays.

  * Fix a incorrect input buffer check
    Which cause us to incorrectly end the compression early and fallback
    to uncompressed write.

I was never a huge fan of the current btrfs_compress_folios() interface:

- Complex and duplicated parameter list

  * A folio array to hold all folios
    Which means extra error handling.

  * A @nr_folios pointer
    That pointer is both input and output, representing the number of max
    folios, but also the number of compressed folios.

    The number of input folios is not really necessary, it's always no
    larger than DIV_ROUND_UP(len, PAGE_SIZE) in the first place.

  * A @total_in pointer
    Again an pointer as both input and output, representing the filemap
    range length, and how many bytes are compressed in this run.

    However if we failed to compress the full range, all supported
    algorithms will return an error, thus fallback to uncompressed path.

    Thus there is no need to use it as an output pointer.

  * A @total_compressed point
    Again an pointer as both input and output, representing the max
    number of compressed size, and the final compressed size.

    However we do not need it as an input at all, we always error out
    if the compressed size is larger than the original size.

- Extra error cleanup handling

  We need to cleanup the compressed_folios[] array during error
  handling.

Replace the old btrfs_compress_folios() interface with
btrfs_compress_bio(), which has the following benefits:

- Simplified parameter list

  * inode
  * start
  * len
  * compress_type
  * compress_level 
  * write_flags

    No parameter is sharing input and output members, and all are very
    straightforward (except the last write_flags, which is just an extra
    bio flag).

- Directly return a compressed_bio structure

  With minor modifications, that pointer can be passed to
  btrfs_submit_bio().

  The caller still needs to do proper round up and fill the proper
  disk_bytenr/num_bytes before submission.

  And for error handling, simply call cleanup_compressed_bio() then
  everything is cleaned up properly (at least I hope so).

- No more extra folios array passing and error handling

Qu Wenruo (9):
  btrfs: introduce lzo_compress_bio() helper
  btrfs: introduce zstd_compress_bio() helper
  btrfs: introduce zlib_compress_bio() helper
  btrfs: introduce btrfs_compress_bio() helper
  btrfs: switch to btrfs_compress_bio() interface for compressed writes
  btrfs: remove the old btrfs_compress_folios() infrastructures
  btrfs: get rid of compressed_folios[] usage for compressed read
  btrfs: get rid of compressed_folios[] usage for encoded writes
  btrfs: get rid of compressed_bio::compressed_folios[]

 fs/btrfs/compression.c | 205 +++++++++++++++++--------------------
 fs/btrfs/compression.h |  40 ++++----
 fs/btrfs/inode.c       | 219 ++++++++++++++++++++--------------------
 fs/btrfs/lzo.c         | 223 +++++++++++++++++++++++++++--------------
 fs/btrfs/zlib.c        |  64 ++++++------
 fs/btrfs/zstd.c        |  98 +++++++++---------
 6 files changed, 450 insertions(+), 399 deletions(-)

-- 
2.52.0

