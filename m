Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C0723EAB8
	for <linux-btrfs@vger.kernel.org>; Wed, 27 May 2026 05:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779858439; cv=none; b=lNWaB3f72pHnIqWdqWgISoAVD/oFJhXbdCoQ73I/F9bT1MbzEl+MzppWm3gntu/Wg3W8Tk7+56mttiaX0uVF3jr0WiU8GXVvl+a4qWmj68HpLIPhh94ALSniOSIeSQoXHy7qIe3zLFt7kO/3e2mxJqcFyBdecvZ10DHyZiofm9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779858439; c=relaxed/simple;
	bh=8P799xqu0DoZ4WPsdDu6gUqHDUAhZIi9ZIQ/ONxtyNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R2Q5TVvBxxgTyp8t6hVKwU1c75OFKxOCNQo+/4zj5mIk7tEbkKSErCFEO+/IXk9IvMhg2ctguYFHnK7z585Yhbqucx1fY2DIeINXmuhg9N57JGAKG+7qb/+6NWQkQVgu0W+iv5vom9HZ7baWfTWz2OEvqH38EYGpfh8R4udeOnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Oxs1ZmK1; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Oxs1ZmK1; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Oxs1ZmK1";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Oxs1ZmK1"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 633E166D38;
	Wed, 27 May 2026 05:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1779858431; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cqTxkhIMns6e4/Efe4/okuVsS4xNtEl7R1V1ajgzomg=;
	b=Oxs1ZmK1JolTnfWRdGxamFIO+6OE6Cs3PZuiGlDTHUORAn5bOGXzokwCLxPXeHeg3dpnTU
	3vs6JJlRsWcFlS9I76Ee3vUwxPQ21h5vKxar8///7PUEfjK5aPN7cVrbEpz6oxyDF3U6G7
	vjf4PThbTrkVdj97dbB4p1UKAv+eD3o=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=Oxs1ZmK1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1779858431; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cqTxkhIMns6e4/Efe4/okuVsS4xNtEl7R1V1ajgzomg=;
	b=Oxs1ZmK1JolTnfWRdGxamFIO+6OE6Cs3PZuiGlDTHUORAn5bOGXzokwCLxPXeHeg3dpnTU
	3vs6JJlRsWcFlS9I76Ee3vUwxPQ21h5vKxar8///7PUEfjK5aPN7cVrbEpz6oxyDF3U6G7
	vjf4PThbTrkVdj97dbB4p1UKAv+eD3o=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 66CE45A653;
	Wed, 27 May 2026 05:07:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MIe7Cv57Fmo4AQAAD6G6ig
	(envelope-from <wqu@suse.com>); Wed, 27 May 2026 05:07:10 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH 2/2] btrfs: fix incorrect buffered IO fallback for append direct writes
Date: Wed, 27 May 2026 14:36:45 +0930
Message-ID: <54b90ef99f59d9a787e121779ad82b2c77d68466.1779846117.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1779846117.git.wqu@suse.com>
References: <cover.1779846117.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 633E166D38
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:dkim,suse.com:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	RCPT_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Flag: NO
X-Spam-Score: -3.01

[BUG]
With the previous bug of short direct writes fixed, test case
generic/362 (*) will still fail with the following error with nodatasum
mount option:

 generic/362  0s ... _check_dmesg: something found in dmesg (see /home/adam/xfstests/results//generic/362.dmesg)
 - output mismatch (see /home/adam/xfstests/results//generic/362.out.bad)
    --- tests/generic/362.out	2024-08-24 15:31:37.200000000 +0930
    +++ /home/adam/xfstests/results//generic/362.out.bad	2026-05-27 10:13:09.072485767 +0930
    @@ -1,2 +1,3 @@
     QA output created by 362
    +Wrong file size after first write, got 8192 expected 4096
     Silence is golden
    ...

*: If the test case has been executed before with default data checksum,
the failure will not reproduce. Need the following fix to make it
reliably reproducible:
https://lore.kernel.org/linux-btrfs/20260526070055.60193-1-wqu@suse.com/

[CAUSE]
Btrfs disables page fault in during direct IO write, to avoid a specific
deadlock that is only specific to btrfs.

So for the test case generic/362, it will make the direct IO to fail
with -EFAULT, then we fallback to buffered IO.

However at btrfs_dio_iomap_begin() -> btrfs_get_blocks_direct_write(),
we have already updated the isize during extent allocation.
And if we failed the direct IO, the isize is still the updated one.

So it means the buffered write will respect the IOCB_APPEND flag and
write the new data at the update isize, resulting the above failure.

[FIX]
Introduce btrfs_dio_data::updated_isize and btrfs_dio_data::old_isize,
so that if btrfs_get_blocks_direct_write() enlarged the inode size, we
can know the old inode size.

Then if we got a short write, and btrfs_dio_data::updated_isize is set,
then revert to the old isize, so the buffered fallback can write into
the correct location.

Cc: stable@vger.kernel.org # 6.1+
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/direct-io.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
index 598480b77002..24163a4bcfb0 100644
--- a/fs/btrfs/direct-io.c
+++ b/fs/btrfs/direct-io.c
@@ -15,10 +15,16 @@
 
 struct btrfs_dio_data {
 	ssize_t submitted;
+	/*
+	 * If we got a short dio write and @updated_isize is set,
+	 * revert to the old isize.
+	 */
+	loff_t old_isize;
 	struct extent_changeset *data_reserved;
 	struct btrfs_ordered_extent *ordered;
 	bool data_space_reserved;
 	bool nocow_done;
+	bool updated_isize;
 };
 
 struct btrfs_dio_private {
@@ -341,8 +347,11 @@ static int btrfs_get_blocks_direct_write(struct extent_map **map,
 	 * Need to update the i_size under the extent lock so buffered
 	 * readers will get the updated i_size when we unlock.
 	 */
-	if (start + len > i_size_read(inode))
+	if (start + len > i_size_read(inode)) {
+		dio_data->old_isize = i_size_read(inode);
+		dio_data->updated_isize = true;
 		i_size_write(inode, start + len);
+	}
 out:
 	if (ret && space_reserved) {
 		btrfs_delalloc_release_extents(BTRFS_I(inode), len);
@@ -634,6 +643,10 @@ static int btrfs_dio_iomap_end(struct inode *inode, loff_t pos, loff_t length,
 			 */
 			btrfs_mark_ordered_extent_truncated(ordered, 0);
 			btrfs_finish_ordered_extent(ordered, pos, length, true);
+			if (dio_data->updated_isize) {
+				i_size_write(inode, dio_data->old_isize);
+				dio_data->updated_isize = false;
+			}
 		} else {
 			btrfs_unlock_dio_extent(&BTRFS_I(inode)->io_tree, pos,
 						pos + length - 1, NULL);
-- 
2.54.0

