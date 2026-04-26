Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4321C2BEFFF
	for <linux-btrfs@vger.kernel.org>; Sun, 26 Apr 2026 20:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777234572; cv=none; b=WIfScV/MOwY20WRYWTksgp4iU4C79UYkWtuVHqcgWdWMawxTfU3kWSHvLCKnnXTXlrFzbuW/EpL+UeJajp0PPhmNOmA7ySWPvZQqJt8WhmWVSDjSMFvWmVVonSTJ0CRhMH8Z6Gonsg8wsUhpIqhDXfwCj5XI0EsU5lpfRs6SM0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777234572; c=relaxed/simple;
	bh=0cBDJDVsverrJm5TX4gD92HaBBqI7XiWHStBQDqbsKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gObVI1FnxPpXlht9Zw7qF5a8YhuUbHK05phbdlKI51/0DLDHRviVILycrRfRZvupJej9skWf8CSYuoh7h1knuby3p43ATnhjGkiDAyutVfyc+lqPggGMeuODDt/Gj+twkBAqpaq+yB1gjhNQ8mdt8Uc4tkkGNAKhSqzmTlw5Ku0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hKEQMjLh; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hKEQMjLh"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4891c00e7aeso68902025e9.2
        for <linux-btrfs@vger.kernel.org>; Sun, 26 Apr 2026 13:16:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777234569; x=1777839369; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YEG1xBF5/17YlnXXV6ISynHTyhtqMCuuiWpFweQNv/U=;
        b=hKEQMjLhqvnSoBhDdrqyQPRukKLdNV73u9KYv81wGHKfjRlTGibD8sPeqYx3lgkN/e
         Ya2B1kInDpBVhEWGaf4/U6I3nYF5WBVhOTG7DQ4dy8ZkWuGbJinrkvo8H8Yi51Zj7OEO
         UxfYmBm7RP3lnXrA+2/DP+81yCXM+GTn8mKd26cQiWcQIcgYoSlOpoBKPvVxJ74b5umW
         tyvnrmzRRvmZZ07tBu6JsLehOqKUv9fGtie6DsB+ZxPQejrW9a2nbx1rs/6+9nJOdUy6
         TmRUKZ8GZL3gJ5cTzkkReFDal3EB5k/N6ChP/v9dpR9Ixx2ho0iX38GBSo6Ata0Pk3/S
         oWpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777234569; x=1777839369;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YEG1xBF5/17YlnXXV6ISynHTyhtqMCuuiWpFweQNv/U=;
        b=kXUUwmLEfakbMofTKPw8VcmpnRViOOwi614uV2lxZuZdhMlR7Yo7uVu7H1rgRQXLoW
         XO9luRLzqYMfeTu7axm3ZSjocP9LrJGzMNp8ZHZQWyLmfiwzT/El4UmIJ+hBGVBCFEZT
         VvknP1ha6n7Snukyj8H/54etSaQO6TNYcV1d05E/eRKVAAkgM1ZpYSrq0RUVElUHX3Ok
         o5FjlD6EdlaCcrdAeMW9Ba691TjZgUhCAWifsmF3SLbsMmC/y8z+SyUXTuE2h0s0GoA6
         /njFoQAlqCi1th/KEACl0mEqsNpuhrEQFU13EiMXzDuttfTfg1ao/zt72AKGAOJ1EZ7e
         KTYQ==
X-Gm-Message-State: AOJu0YzOYYisec7wMCI0WNf6jTdA8wwwLEGMYl3MjBTkO6UbH0M4sqB8
	AofAzqsj6oWJxEZzBsqpB0jEyRBlMEFblGRSgj9HvvklToFYALMvgJfCePlcIVCP
X-Gm-Gg: AeBDietAggSiPCIk+/t77EuqH77rY5zBrV9QZq87XcnmR3EtdORU/hi6SbD6Fpw/EJy
	InV1BYM/yigS2KhEPT+oAEAG6ws4740mb1IEXSeBjuFqkH/KX2NJclW367Syn0yqAmoW1lcbnl1
	C91x9MFkh+FSrZZvYE/9TU2KuJBy4R9cefky69OkLCowXeoOJz5FeK9tCY3F2c1g0svagyxFMEh
	4dsKV7uB4BxpsjV2cIqICmFEbMJteMbL7ojTRj7CFvDrdNweYwwV8ebuLBeATbZ9D5flgxcEr8E
	IhTPdl9D4mG53eXFPJUbFucmyapx3/TJUjs82/Vs7o5AOyGNWlHAYXSBRf6Mk2UlqsSkMq4Kbau
	+y8a/0nUeC+J4YSyYkMuhCO6Ixi3gJusEUoTpZM1NXBR5QXidZ6tcmF17Se3huc/a/KRW5pWHSp
	wAH/bicXmIFfshj0oNQkUKJ4bojDJA6uqo
X-Received: by 2002:a05:600c:3213:b0:489:149a:f9e6 with SMTP id 5b1f17b1804b1-489149afa07mr257254935e9.28.1777234569033;
        Sun, 26 Apr 2026 13:16:09 -0700 (PDT)
Received: from localhost ([145.40.214.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fc0f82bbsm1272653495e9.3.2026.04.26.13.16.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 13:16:08 -0700 (PDT)
From: Teng Liu <27rabbitlt@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com,
	clm@fb.com,
	wqu@suse.co,
	linux-kernel@vger.kernel.org,
	syzbot+3e20d8f3d41bac5dc9a2@syzkaller.appspotmail.co,
	Teng Liu <27rabbitlt@gmail.com>,
	wqu@suse.com,
	syzbot+3e20d8f3d41bac5dc9a2@syzkaller.appspotmail.com
Subject: [PATCH v2] btrfs: replace BUG_ON() with error return in get_new_location()
Date: Sun, 26 Apr 2026 22:16:00 +0200
Message-ID: <20260426201605.36626-1-27rabbitlt@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260425061214.235982-1-27rabbitlt@gmail.com>
References: <20260425061214.235982-1-27rabbitlt@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In get_new_location(), BUG_ON() crashes the kernel if the looked up
file extent item has any of offset, compression, encryption, or other
encoding set. The data reloc inode this lookup targets is populated
solely by relocation's own prealloc and writeback paths:

  - insert_prealloc_file_extent() memsets the stack item to 0 and only
    sets type/disk_bytenr/disk_num_bytes/num_bytes, so the four checked
    fields stay 0.
  - insert_ordered_extent_file_extent() copies oe->compress_type into
    file_extent compression, but the data reloc inode is created with
    BTRFS_INODE_NOCOMPRESS, so compress_type is always 0; encryption
    and other_encoding are reserved-and-zero per the comment in that
    function.

So observing non-zero compression, encryption or other_encoding here
should on-disk corruption. A malformed image can reach this code
through a balance operation and panic the kernel.

Replace the BUG_ON() with a return of -EUCLEAN, the established error
code in fs/btrfs/relocation.c for filesystem corruption, and pair it
with btrfs_print_leaf() and btrfs_err() as suggested by Qu allowing dmesg
to log the necessary information. The caller in replace_file_extents() 
already handles errors from get_new_location() by breaking out of the loop 
without aborting the transaction, so no caller changes are needed.

Reported-by: syzbot+3e20d8f3d41bac5dc9a2@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=3e20d8f3d41bac5dc9a2
Signed-off-by: Teng Liu <27rabbitlt@gmail.com>
---
Changes in v2:
 - Pair the -EUCLEAN return with btrfs_print_leaf() and btrfs_err() so
   the offending leaf is dumped to dmesg, per Qu's review:
   https://lore.kernel.org/linux-btrfs/6c54901d-5e07-4c46-9553-997b28c93b86@suse.com/
 - Expand the changelog to argue why non-zero compression/encryption/
   other_encoding in the data reloc inode imply on-disk corruption
   rather than a kernel bug.

 fs/btrfs/relocation.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 1c42c5180bdd..bba28866df1c 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -814,6 +814,7 @@ static int get_new_location(struct inode *reloc_inode, u64 *new_bytenr,
 			    u64 bytenr, u64 num_bytes)
 {
 	struct btrfs_root *root = BTRFS_I(reloc_inode)->root;
+	struct btrfs_fs_info *fs_info = root->fs_info;
 	BTRFS_PATH_AUTO_FREE(path);
 	struct btrfs_file_extent_item *fi;
 	struct extent_buffer *leaf;
@@ -835,10 +836,16 @@ static int get_new_location(struct inode *reloc_inode, u64 *new_bytenr,
 	fi = btrfs_item_ptr(leaf, path->slots[0],
 			    struct btrfs_file_extent_item);
 
-	BUG_ON(btrfs_file_extent_offset(leaf, fi) ||
-	       btrfs_file_extent_compression(leaf, fi) ||
-	       btrfs_file_extent_encryption(leaf, fi) ||
-	       btrfs_file_extent_other_encoding(leaf, fi));
+	if (unlikely(btrfs_file_extent_offset(leaf, fi) ||
+		     btrfs_file_extent_compression(leaf, fi) ||
+		     btrfs_file_extent_encryption(leaf, fi) ||
+		     btrfs_file_extent_other_encoding(leaf, fi))) {
+		btrfs_print_leaf(leaf);
+		btrfs_err(fs_info,
+"unexpected non-zero fields in file extent item for data reloc inode %llu offset %llu (offset/compression/encryption/other_encoding must all be 0)",
+			  btrfs_ino(BTRFS_I(reloc_inode)), bytenr);
+		return -EUCLEAN;
+	}
 
 	if (num_bytes != btrfs_file_extent_disk_num_bytes(leaf, fi))
 		return -EINVAL;
-- 
2.54.0

