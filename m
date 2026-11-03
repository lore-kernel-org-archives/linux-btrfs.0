Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793686233;
	b=ANh0Btr7pkOJwZjaztg9c2yu/LYlpws4q7r31DUPfRvaM+yB72u1OEhUjrdaEiHlZno0
	 It6SYWUWSqEAeAf++F7u7w9VEiepMwo6SuSovJuI5AdG/daDcenNaIdQBOXZUi+zHQG4H
	 xAiU8KNMkzryh4qn9DFXcr/3l3RCcEPyLBXUVks88nlXchtp0sKnesfxb0DkQy06OuhXd
	 emoL8yswx2EU5JN8rav/cjw3pViRkqs/TF8X+sZZe/GyzgnHhc4tKJYVRQrajyV1qAejt
	 RucSn8o/ws8octD8eN+SgPTazzvwavXK1W1U5YMSYJRdi6by5yzaxVQ9Md0t+4WykzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793686233;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EROaWjdO6oYboqJP5qDVlNq8HvD3vjgSVaQkzFo8u90=;
	b=ZWahbwVVFgB+XDmk1LUZ7o+IkGTrE3pB1asLKI4kmDBPvz8IPJUISwygbsnQb+dixJD6
	 QV7vBdhzytrCEu9/PT8MI2ryzH3t6wOWE6vWBamvPR7ffD5VD8Rj4f1pA9Qmr2GLcKiTR
	 GvrCxOOVsZ7A71WToA0TWOfbVN59iEDF2OiV65oF9QRc+FM3Sy+xyJgJH5DtS9EDU56+u
	 bHg0eRWGHUAFV38mB9A+/E0DkhL/yRUobq8YMX7qmKPoUzmmcMV/vRSU36inzxWZN21Of
	 ltKCj2ijlXZwfrPhNsL1x1/2sMQ9Xtcj6VDSYoskNHXMH00wh8jy/dlMk89h/g8FbJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=asu.edu;
	spf=pass smtp.mailfrom=asu.edu;
	dkim=pass header.d=asu.edu header.i=@asu.edu header.a=rsa-sha256 header.s=google header.b=LzSRVlfL;
	arc=none smtp.remote-ip=209.85.160.178
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CEB2606A331
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Nov 2026 06:10:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4CEB2606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=asu.edu header.i=@asu.edu header.a=rsa-sha256 header.s=google header.b=LzSRVlfL
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-53fdd2fb171so48242861cf.2
        for <linux-btrfs@vger.kernel.org>; Mon, 02 Nov 2026 22:10:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1793686231; x=1794291031; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EROaWjdO6oYboqJP5qDVlNq8HvD3vjgSVaQkzFo8u90=;
        b=LzSRVlfLP02uU5/OGyMmh7EMgSSCvlUlAHpyAIrdp6PgekhyJ4SLqtwBm+Tu7XWkXq
         Wn/9PEqz1enAH5uBbk+LjvkM9YMRSgdOkh7N1G+ktJIYVP3bC6yG65ntwZe9R7SPCN2V
         8phR+NPCSn5LVpqxONSOL19z4PUzXeRcvj4CgJ56gE/f6cpELDOaX3ehKBw3IYRzLyZz
         Xl9CF1Gj1vF49f0kEadKzr93Rv7KMGqbZy1ZrnAeuPk5ieXkdIVcYV9h/03zJnrz1K8D
         RxUorEqH/VjbK7TA23miHWIeN9ZEvZCtgWuU59J3HeE4httG8GAZ9INTfyxOAxZKH96m
         nn4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793686231; x=1794291031;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=EROaWjdO6oYboqJP5qDVlNq8HvD3vjgSVaQkzFo8u90=;
        b=Qu8f0xhOcEoCaxzBKL/9aK7ZIvkEOsEaja5pt6zwX8TYBM4Y0FYoxDN1GfLwqfc3zA
         Es0l873jWC/dWjWWSlOmF5siF0GH5UbuQRXpJdTNu1DcdENBDBdPK5wquBtiVoDGOq9N
         hEOKqHDT3KP0T/7vchthVXJ5iUYR89sDZzu7xhsB0jFSdMp95667tSf14U4Byq+NMyUx
         076rMECSM0m+QKcET/HICYJSBnYRnNH4x1ZzA6CVL/695ePxbi+bWP2xkwwJjCLvnoEP
         /dwAmlF8etbdOQeb4Ag6BOdOGZfCphCSVurgoT+LBTV6uEUC4iDpJQmduKyIBopw2v3p
         Q/jw==
X-Forwarded-Encrypted: i=1; AKwUvBzX8DJQlE44O8codKLJX6hxd8OqYcAzPzyfzOIh4U3FbjNSu2DNphziykX+D55xX/64/28jph1o1+Hvuw==@vger.kernel.org
X-Gm-Message-State: APuU4Z+WNQxYiDWY/muAiJVBruMDk5h9Y/mNsYVp6FqP7cMrM7Q24BuL
	DF1UoyOId7Ggv12ABI3ye243ijMFXsgiYh5wWYYZv5/IMLc1xe0TOsxduaQbV/F57Q==
X-Gm-Gg: AYBFou1sG2947TxzibZq6U6agpCySEZJ4wZXXlJeL/C0b3QrQAK37+wmNBbIl51BNM+
	kXOPNt4IaEWB43Rw03IjsgCnebhC1AfIlTSure8t88xe9367dhpBt5rEQ59WeIO1zwK6tJqvA5e
	uwVxGj9iHEHMUIPxOg1ueXODC8Sd6fuccUnYwwG2ZBL/ayid9+fQ1x+SvtDYdxJ6bfZMORf2cRy
	9StZz/YcR6eoWypHFSDA32+YulZa7khIO/i21S82VbM3iWnwjHC4Ji8+Z9chhDCCpwOuGsV7AFF
	jJv910ClVnInLSCytscjRixe66crvtnN010Nn1p1qogLdlstMwmRCmGNxOWL7+Rr7O3pVy69cWs
	S0qtbLm2a1ANvwB6ZUW7kqRbESakBFE9kfhpQgnNotZjcMiQ3uagz862uW7ZOzMBUvsG6DrDy4M
	EQniUdmvb3f/I+t0USGV0JWXe9tObsxmWQ7TOUH7u6jJmlAaCxWjJ8aTg8q1cTCE2VjDANWBHsI
	NTRcuEIjMFEOxcriKeJC3YdO9BzNkiJWUiQXTqBPKNx8PjbPFGs14X0fvy3QYglWE1VUfZoNnqS
	VXZ6ZtC6syWlGpDqMvKBDOfZIMrniG+YxiXmEOHfEA==
X-Received: by 2002:a05:622a:1f90:b0:536:6378:c804 with SMTP id d75a77b69052e-542b83f7efamr173986521cf.73.1793686231189;
        Mon, 02 Nov 2026 22:10:31 -0800 (PST)
Received: from localhost.localdomain ([2600:1011:b1ae:f075:aa26:e161:414d:7ec7])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ca807d8fasm109173076d6.41.2026.11.02.22.10.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 22:10:30 -0800 (PST)
From: Siddharth Mishra <smish149@asu.edu>
To: dsterba@suse.com
Cc: wqu@suse.com,
	boris@bur.io,
	mason@kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Siddharth Mishra <smish149@asu.edu>,
	stable@vger.kernel.org
Subject: [PATCH v2 1/2] btrfs: tree-checker: validate qgroup status item
Date: Mon,  2 Nov 2026 23:10:20 -0700
Message-ID: <20261103061021.2213691-2-smish149@asu.edu>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261103061021.2213691-1-smish149@asu.edu>
References: <20261103061021.2213691-1-smish149@asu.edu>
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

[BUG]
An image can have a status item with SIMPLE_MODE and a super block
without the SIMPLE_QUOTA bit.  On a kernel with CONFIG_BTRFS_ASSERT=y,
the mount of this image causes a BUG :

  assertion failed: btrfs_fs_incompat(fs_info, SIMPLE_QUOTA),
  in fs/btrfs/qgroup.c:411
  kernel BUG at fs/btrfs/qgroup.c:411!
  Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
  RIP: 0010:btrfs_read_qgroup_config.cold (fs/btrfs/qgroup.c:411)
  Call Trace:
   open_ctree (fs/btrfs/disk-io.c:3789)
   btrfs_get_tree.cold (fs/btrfs/super.c:2133)
   vfs_get_tree (fs/super.c:1943)
   fc_mount (fs/namespace.c:1282)
   path_mount (fs/namespace.c:4337)
   __x64_sys_mount (fs/namespace.c:4542)

Without CONFIG_BTRFS_ASSERT, the mount is successful in simple quota
mode.  The first data write then adds an owner ref.  The write-time
tree-checker sees the owner ref without the SIMPLE_QUOTA bit and gives
a WARN_ON() (tree-checker.c:1782).

[CAUSE]
The super block does not have the SIMPLE_QUOTA bit, but the status item
has SIMPLE_MODE :

  incompat_flags  0x361
                  ( MIXED_BACKREF |
                    BIG_METADATA |
                    EXTENDED_IREF |
                    SKINNY_METADATA |
                    NO_HOLES )

  item 0 key (0 QGROUP_STATUS 0) itemoff 16243 itemsize 40
          version 1 generation 12 flags ON|SIMPLE_MODE scan 0
                                           ^^^^^^^^^^^

The tree-checker does not examine the status item.
btrfs_read_qgroup_config() reads the flags of the status item.  For
SIMPLE_MODE, it calls qgroup_read_enable_gen().  This function ASSERT()s
that the SIMPLE_QUOTA bit is set and that the item contains enable_gen.
Since commit f2363e6fcc79, the kernel does not write SIMPLE_MODE without
the SIMPLE_QUOTA bit.  Thus only a damaged or crafted image has this
state.

[FIX]
Add a tree-checker rule for the status item :
- The item must contain the four members of all versions : version,
  generation, flags and rescan.
- With SIMPLE_MODE, the super block must have the SIMPLE_QUOTA bit, and
  the item must also contain enable_gen.
If a rule fails, the tree-checker rejects the leaf with -EUCLEAN.  Then
btrfs_read_roots() cannot read the quota root.  It ignores the error, as
before, and btrfs mounts the filesystem without quotas.

Cc: stable@vger.kernel.org # 6.7+
Signed-off-by: Siddharth Mishra <smish149@asu.edu>
---
 fs/btrfs/tree-checker.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 61ea8f42c..bb86c30a2 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -2083,6 +2083,36 @@ static int check_raid_stripe_extent(const struct extent_buffer *leaf,
 	return 0;
 }
 
+static int check_qgroup_status_item(const struct extent_buffer *leaf, int slot)
+{
+	const u32 item_size = btrfs_item_size(leaf, slot);
+	const u32 min_size = offsetof(struct btrfs_qgroup_status_item, enable_gen);
+	struct btrfs_qgroup_status_item *ptr;
+
+	if (unlikely(item_size < min_size)) {
+		generic_err(leaf, slot,
+		"invalid qgroup status item size, have %u expect at least %u",
+			    item_size, min_size);
+		return -EUCLEAN;
+	}
+	ptr = btrfs_item_ptr(leaf, slot, struct btrfs_qgroup_status_item);
+	if (!(btrfs_qgroup_status_flags(leaf, ptr) & BTRFS_QGROUP_STATUS_FLAG_SIMPLE_MODE))
+		return 0;
+
+	if (unlikely(!btrfs_fs_incompat(leaf->fs_info, SIMPLE_QUOTA))) {
+		generic_err(leaf, slot,
+	"qgroup status item has SIMPLE_MODE but SIMPLE_QUOTA incompat bit unset");
+		return -EUCLEAN;
+	}
+	if (unlikely(item_size < sizeof(*ptr))) {
+		generic_err(leaf, slot,
+	"invalid qgroup status item size for simple quota, have %u expect at least %zu",
+			    item_size, sizeof(*ptr));
+		return -EUCLEAN;
+	}
+	return 0;
+}
+
 static int check_remap_key(const struct extent_buffer *leaf,
 			   const struct btrfs_key *key, int slot)
 {
@@ -2475,6 +2505,9 @@ static enum btrfs_tree_block_status check_leaf_item(struct extent_buffer *leaf,
 	case BTRFS_FREE_SPACE_BITMAP_KEY:
 		ret = check_free_space_bitmap(leaf, key, slot, prev_key);
 		break;
+	case BTRFS_QGROUP_STATUS_KEY:
+		ret = check_qgroup_status_item(leaf, slot);
+		break;
 	case BTRFS_IDENTITY_REMAP_KEY:
 	case BTRFS_REMAP_KEY:
 	case BTRFS_REMAP_BACKREF_KEY:
-- 
2.54.0

