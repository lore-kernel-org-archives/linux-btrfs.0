Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0126515E5DC
	for <linux-btrfs@vger.kernel.org>; Sun, 21 Jun 2026 06:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782022408; cv=none; b=RKtgACFRDZZM+6wrOsd6aUEg5zMW5UJ6dxSBO0yfVCkzRC1y4FQHG69jkXtpwRZb7x3zIfuZGFHZrYcPv9wI1Lp4L6GQtL6j/grMR9wb3F5zr841tzUFPDqPEvBpgh5dyTSpLr14vkJrjnQ1hEdSIU+eRVqeKYUBr/nQfoF/POE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782022408; c=relaxed/simple;
	bh=Sf9Qhgv5BIIHUJKZDmbLFk4tD7O72sGTTGD1beZGI6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nLnf8XIfXwKLTPxvAxJaEc+MT1oOZk77w4g3Invj7oIkNbE+CqYp/mOL9xD+EEZ4hSbL8ZrRLSA01JBYe+VlJ329+SYdiv33gaYR136+qTVpOJMDiaeSJQZMdCnPVnUk9TB1hDbuBsTXVaBRN8L7NP0f5HqcBpByJ8GgzmyGiUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=qzYbK8Us; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=kq+1zOEY; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="qzYbK8Us";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="kq+1zOEY"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 494757004C;
	Sun, 21 Jun 2026 06:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1782022402; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ot+VitVJEGEihPO+jDIhholQPX5oNZlUYL03ni0fiMo=;
	b=qzYbK8Us+qDwo7vS2UqOuew9sbXMsFQlw4P7IvWdM2JUly81A1Wo7pOrmsniJ2SJDvAx+D
	dbdMuAVBrn40vCgWiRIdIJ6m65dRo/VsKQPKMtHSW5RUGMvYe0b7FKNTu0K6EDg/pcd64U
	pitr9N4uWisg5LhyVeJyluDOBCuLOA4=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1782022401; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ot+VitVJEGEihPO+jDIhholQPX5oNZlUYL03ni0fiMo=;
	b=kq+1zOEYjuhHQg8poKvJNwWuUQqlfG22cOI3f1S7pr6f+ORxRsjH5va7fpDIh0kYS8j8VC
	+aAdnQwAt1vDalDXC449zUr1eJJ86IVjV0Ml1CsZxjqKLrfAPbEWWK+PmgsJ+RRQz6N9na
	FgPdk9oNk0y3iEtPDi9wqQ/0pg+NDME=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9AED3779A8;
	Sun, 21 Jun 2026 06:13:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iDRKEv+AN2oJSAAAD6G6ig
	(envelope-from <wqu@suse.com>); Sun, 21 Jun 2026 06:13:19 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: syzbot+d950c6ba09b79f6e1864@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: [PATCH 1/2] btrfs: do not try compression for data reloc inodes
Date: Sun, 21 Jun 2026 15:42:58 +0930
Message-ID: <9206a06ed48a4dc40d50909dddf3daa9b17965eb.1782022263.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1782022263.git.wqu@suse.com>
References: <cover.1782022263.git.wqu@suse.com>
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
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	TAGGED_RCPT(0.00)[d950c6ba09b79f6e1864];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:helo]
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

However the relocation path is just dirtying the data reloc inode
cluster by cluster. It's possible to have a single block, not adjacent
to any other data extents.

Then relocation will dirty the first block of the data reloc inode, then
memory pressure forces the data reloc inode to be written back.

In that case, since the syzbot has forced compression, we try to
compress the first block and if it can be compressed and inlined, an
inlined extent will be created.

Then the check in get_new_location() will check the file offset, without
checking if the file extent is inlined or not, resulting the above
failure.

[FIX]
Do not allow compression for data reloc inodes in the first place.

Reported-by: syzbot+d950c6ba09b79f6e1864@syzkaller.appspotmail.com
Link: https://lore.kernel.org/linux-btrfs/6a373dc5.764cf64f.168fbe.0001.GAE@google.com/
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

