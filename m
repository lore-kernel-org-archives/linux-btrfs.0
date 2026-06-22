Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A219F283FE6
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Jun 2026 22:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782168970; cv=none; b=uB2wJOXh8XmOk+q2RBgcm7GScJK+3z9+9mq+ZwPwInoP4tbrqO7IWh+OYXeNB+kO4wmDwIlt6qtMpMFuIebLsTtJ7Hz+XaU0dpVC6KD30wKofBw3+QeIunCCYFAaad+89DGmbZVaXClKzj0geGwKEK6e/ZnDLWfSmZP3cdOMtmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782168970; c=relaxed/simple;
	bh=hhM9TVmD8TUIUHX6GnOglzxp7Qwel59R5ToCYuzYuss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gBzW4g5cN9WanZfAVBC2SWSFA7k13zRprzmB3yGtN8sKv5+j+aYhuZwVraOJgMStAxOyk37tPuLR2be++Wro1p5X39moz5fJLClHb6izsdFXUa8Vwxev72o91rTWf8mdM0EOf3e15e5lF9Iqpx9NJVNkoaJJqUQczuJ1Dq2q9ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=SstuOnl7; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=SstuOnl7; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="SstuOnl7";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="SstuOnl7"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 76FEC70AD5;
	Mon, 22 Jun 2026 22:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1782168963; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jdm2jwrJU3Fpc1+eCtb2ZSLHrtQTCh3r+TUZqhO56Xw=;
	b=SstuOnl7I7efFc8ZGIL2d6jP95w4BCrU3BDwyZrrpir08oVwaE+nf5JLq+++/zvFfRmMQE
	OosBbJLaJdNlisTf40SqTp1tor78yzp1wjgGrDsxL0ML6s95X12XQ+lCDQS/OCycHJ4fsj
	K0xkw8fJFx/0jae6PfOycWrnmPpOuCU=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1782168963; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jdm2jwrJU3Fpc1+eCtb2ZSLHrtQTCh3r+TUZqhO56Xw=;
	b=SstuOnl7I7efFc8ZGIL2d6jP95w4BCrU3BDwyZrrpir08oVwaE+nf5JLq+++/zvFfRmMQE
	OosBbJLaJdNlisTf40SqTp1tor78yzp1wjgGrDsxL0ML6s95X12XQ+lCDQS/OCycHJ4fsj
	K0xkw8fJFx/0jae6PfOycWrnmPpOuCU=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D963C779A8;
	Mon, 22 Jun 2026 22:56:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +HZLIoG9OWq0OQAAD6G6ig
	(envelope-from <wqu@suse.com>); Mon, 22 Jun 2026 22:56:01 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: syzbot+d950c6ba09b79f6e1864@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: [PATCH v2 1/2] btrfs: do not try compression for data reloc inodes
Date: Tue, 23 Jun 2026 08:25:39 +0930
Message-ID: <4191bde54303559d0065213f7970ec1ad9790e02.1782168847.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1782168847.git.wqu@suse.com>
References: <cover.1782168847.git.wqu@suse.com>
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
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	TAGGED_RCPT(0.00)[d950c6ba09b79f6e1864];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[appspotmail.com:email,suse.com:email,suse.com:mid];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 

[BUG]
There is a syzbot report that the check inside get_new_location()
triggered:

 BTRFS info (device loop0): found 31 extents, stage: move data extents
 BTRFS info (device loop0): leaf 8908800 gen 16 total ptrs 28 free space 1676 owner 18446744073709551607
        item 0 key (256 INODE_ITEM 0) itemoff 3835 itemsize 160
                inode generation 5 transid 0 size 0 nbytes 0
                block group 0 mode 40755 links 1 uid 0 gid 0
                rdev 0 sequence 0 flags 0x0
                atime 1669132761.0
                ctime 1669132761.0
                mtime 1669132761.0
                otime 0.0
        item 1 key (256 INODE_REF 256) itemoff 3823 itemsize 12
                index 0 name_len 2
        item 2 key (258 INODE_ITEM 0) itemoff 3663 itemsize 160
                inode generation 1 transid 16 size 733184 nbytes 106496
                block group 0 mode 100600 links 0 uid 0 gid 0
                rdev 0 sequence 24 flags 0x18
        item 3 key (258 EXTENT_DATA 0) itemoff 3595 itemsize 68
                generation 16 type 0
                inline extent data size 47 ram_bytes 4096 compression 1
 [...]
        item 27 key (18446744073709551611 ORPHAN_ITEM 258) itemoff 2376 itemsize 0
 BTRFS error (device loop0): unexpected non-zero offset in file extent item for data reloc inode 258 key offset 0 offset 9277520992061368337
 ------------[ cut here ]------------
 btrfs_abort_should_print_stack(__error)

[CAUSE]
The above dump tree shows the first file extent item is inlined, which
should make no sense for data reloc inodes, as such inodes are just
representing where the data extents are in the relocation destination chunk.

However the relocation path is just preallocate space for each block,
then dirty them, cluster by cluster.
It's possible to have a single block at the beginning of the block
group, and no other block in the same cluster.

Then relocation will preallocate a file extent for that block, dirty the first block.
Then memory pressure forces the data reloc inode to be written back, before
any other blocks being dirtied/allocated.

Finally commit 3eaf5f082c4c ("btrfs: extract inlined creation into a dedicated
delalloc helper") changed the timing of delalloc, before that commit we
always try NOCOW first, so that dirtied block will be written back into
the preallocated space.

But with that commit, we always try inline first, and since compression
is forced, we try compressing the first block, and then inline the
compressed data, resulting in the above inlined file extent in data
reloc tree.

Then the check in get_new_location() will check the file offset, without
checking if the file extent is inlined or not, resulting the above
failure.

[FIX]
Do not allow compression for data reloc inodes in the first place.

Reported-by: syzbot+d950c6ba09b79f6e1864@syzkaller.appspotmail.com
Link: https://lore.kernel.org/linux-btrfs/6a373dc5.764cf64f.168fbe.0001.GAE@google.com/
Fixes: 3eaf5f082c4c ("btrfs: extract inlined creation into a dedicated delalloc helper")
Cc: stable@vger.kernel.org
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/btrfs_inode.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index d5d81f9546c3..fff72f6cc1e8 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -476,6 +476,8 @@ static inline bool btrfs_inode_can_compress(const struct btrfs_inode *inode)
 	if (inode->flags & BTRFS_INODE_NODATACOW ||
 	    inode->flags & BTRFS_INODE_NODATASUM)
 		return false;
+	if (btrfs_root_id(inode->root) == BTRFS_DATA_RELOC_TREE_OBJECTID)
+		return false;
 	return true;
 }
 
-- 
2.54.0

