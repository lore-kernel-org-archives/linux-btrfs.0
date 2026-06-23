Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE29337BE7C
	for <linux-btrfs@vger.kernel.org>; Tue, 23 Jun 2026 11:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782214664; cv=none; b=RWnC6b82KTPG4t1DOM+EDiNgZyX8r2QeDnd4/itTEODvsct4L8TrevzYygk+zR39/dLX0R9XhR7ed1kP2UQhiAHn6RKc7pgxDfXIkqOM+W9VPN9c60wXiiumbmS3jZvW8wDn+AkAovj+FhGu0ETdV44tNEmUb0oih2IA5T/5JUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782214664; c=relaxed/simple;
	bh=Xu7t+cKPF+EwjZAZnjajT4xCj7gmPCUbCUxOgtEcujE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S/biYT1JjW1kZ8QCz5yyS6hQGeFSxezVc01mkE3Ub4bPf3yuVY+oPBjJwdF26PAaezxLXmF8bvxdQ3xa27FEIbgRx4x5ILLBLXi6NXVFNCtzr9zP/r+Q0EbWurXy2uaSlGjvbCfbGS9rNqpeF6K2qFw3pz+ZZJStIkUpnzNr1rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=GRK4WUuN; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Lop63WGT; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="GRK4WUuN";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Lop63WGT"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9674275E5C;
	Tue, 23 Jun 2026 11:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1782214658; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CL9yxumRVnFYgGhnjKnvnigfROZ5GpbLesj5lSlnaVo=;
	b=GRK4WUuNFGU/cx5GdD2K+oEtF9kFr6A6GGZb4qn5Nwn0++9EpNBpIIsHIMD3haXI+hFQr0
	rGmslD0hVayRayXIBddtXSFC83imupDhnpbG6Ni4M0k5kfNSidc3CO9LvNZSsRYioOs5YB
	f8n3emNbPG1N22YeWk0Xkb+emvzRakQ=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=Lop63WGT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1782214657; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CL9yxumRVnFYgGhnjKnvnigfROZ5GpbLesj5lSlnaVo=;
	b=Lop63WGTZwE/8aGPEJkiywLU2Jbgl+oDpbrtpaNhP8c/5BUs6CXPz37tlyTZUbksxA2RTm
	zHYS7YnE/VaF7bIi0JFoa/v4YcEu5LsHIMK9SHDWlW7DIRFNHDzuu3zEWyxsU5U3QERoi5
	+TpbmW0jbZqwAnzjeJoMQG7YYBrRESM=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 04447779A8;
	Tue, 23 Jun 2026 11:37:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oIfqKf9vOmqDBAAAD6G6ig
	(envelope-from <wqu@suse.com>); Tue, 23 Jun 2026 11:37:35 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: syzbot+d950c6ba09b79f6e1864@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: [PATCH v3 1/2] btrfs: do not try compression for data reloc inodes
Date: Tue, 23 Jun 2026 21:07:14 +0930
Message-ID: <48f22f6de55d47522ef1a0b9865eebe8a2aa7088.1782214614.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1782214614.git.wqu@suse.com>
References: <cover.1782214614.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Rspamd-Action: no action
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
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	TO_DN_NONE(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[d950c6ba09b79f6e1864];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email,suse.com:dkim,suse.com:mid,appspotmail.com:email]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 9674275E5C
X-Spam-Score: -3.01

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
should make no sense for data reloc inodes, as such inodes just
represent where the data extents are in the relocation destination chunk.

However the relocation path preallocates space for each block,
then dirties them, cluster by cluster.
It's possible to have a single block at the beginning of the block
group, and no other block in the same cluster.

So relocation will preallocate a file extent for that block and dirty
the first block.
Then memory pressure forces the data reloc inode to be written back, before
any other blocks are dirtied/allocated.

Finally commit 3eaf5f082c4c ("btrfs: extract inlined creation into a dedicated
delalloc helper") changed the sequence of delalloc. Before that commit we
always tried NOCOW first, so that dirtied block will be written back into
the preallocated space, and appear as a regular extent.

But with that commit, we always try inline first, and since compression
is forced, we try compressing the first block, and then inline the
compressed data, resulting in the above inlined file extent in the data
reloc tree.

Then the check in get_new_location() will check the file offset, without
checking if the file extent is inlined or not, resulting in the above
failure.

[FIX]
Do not allow compression for data reloc inodes.

Since data reloc inode sizes are always block aligned, as long as we do
not compress, @data_len will always be at least one block, and
that will cause can_cow_file_range_inline() to return false, thus no
inlined extent will be created.

Reported-by: syzbot+d950c6ba09b79f6e1864@syzkaller.appspotmail.com
Link: https://lore.kernel.org/linux-btrfs/6a373dc5.764cf64f.168fbe.0001.GAE@google.com/
Fixes: 3eaf5f082c4c ("btrfs: extract inlined creation into a dedicated delalloc helper")
Cc: stable@vger.kernel.org
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/btrfs_inode.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index d5d81f9546c3..7fdc6c3fd066 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -476,6 +476,8 @@ static inline bool btrfs_inode_can_compress(const struct btrfs_inode *inode)
 	if (inode->flags & BTRFS_INODE_NODATACOW ||
 	    inode->flags & BTRFS_INODE_NODATASUM)
 		return false;
+	if (btrfs_is_data_reloc_root(inode->root))
+		return false;
 	return true;
 }
 
-- 
2.54.0

