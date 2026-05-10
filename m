Received: from mail-pf1-f193.google.com (mail-pf1-f193.google.com [209.85.210.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 192472F8E8E
	for <linux-btrfs@vger.kernel.org>; Sun, 10 May 2026 07:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778399400; cv=none; b=Thj8+9StmoJZtf/q4LlUpHMNjNqMzZeOcwhS3hIENr4ELNVA07PQjvgG7hnOiy1nC+Y44QWVtJcKlbCiMLrptJUQeWkbIXBlHupI7iAdfSDP12NBFOQBqLHQS4FmtEXnQAES5gNDqhwOMY82AJt2DbT/uemoWES+BvkJiiPpPXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778399400; c=relaxed/simple;
	bh=AIg9x2lfPIwckDC+mEZq+VzjbB4MupOlG5UaJHEoS1I=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=tjCmFfWr3gBYLMp4P3oFDhtnA28x3tknWLPIgqCyVCsG4PhO8zZ00oplPphrK6ThBTH25k2JD6dffC9d/GB5SLk9a2kh+BsamD7uGCibTPf5eSllbtvzT5atOCmF59+Djbq/pxEXHKHOdKzlTVtfiGCJYnhx861FmGSz9h0GaMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jw/tGjcn; arc=none smtp.client-ip=209.85.210.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jw/tGjcn"
Received: by mail-pf1-f193.google.com with SMTP id d2e1a72fcca58-8383fb7143aso1523267b3a.3
        for <linux-btrfs@vger.kernel.org>; Sun, 10 May 2026 00:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778399398; x=1779004198; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vXuOvJ5SdEAM6J850ghnF+cXkTqwFsQBsM2NMnN7HbY=;
        b=jw/tGjcnKMbJBMbYGAJL3RSTNMMGK2wQNX526wQidrqp3vCTulXEfPYLrDvq2LX1jg
         1l9fp8G5ZQbiYKkj3eS/6VFdfUnze9Q2dDe7yhvxB9mdRGyva57f5M7rdcoK3mO+hscQ
         Z7JjUG3u1qOjnbM0YVlCcnH80erYDU3bJSpFGmmyu1VL8lH6wFCfBORXGqHAhYx+gxdR
         1kV52gxrBtrdq06NpxlPx1El/G03reKNcheXAnzenqCw3IvzRMu8jxWL0U1roREKPBMS
         Mq51pk7ICzzJX5Rt5XYiyE/vnTJiYjBYKW5ZDUKqKQNWo35O7tEDE+zx40J+d+uqcta7
         WHtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778399398; x=1779004198;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vXuOvJ5SdEAM6J850ghnF+cXkTqwFsQBsM2NMnN7HbY=;
        b=nNZfxlen7oID3uy7PCtNcQR7wEeA/BnkS/nZ6mjCp9EaZEvJTEEmaotSv6D0Gco0IL
         q1EVYsVtIoWq7Pwi57cs8mRiClOf/OsasjWF8X9ZchcAVMALyMVDp+SPyvHmj0mlrsRs
         7zi2pss7fU1w6lrZXz2FhdEK4kN7+b2qoU9Fl/oK3vaDCxLy+JwLXm5CumnVHi1zBWge
         48nVNJ7jiqimApUqev2Ox9FQmD13lVg6o/PV4tAVwbAZwTuhl8UNXJyu2KzgclopgVSl
         6koFe1VMbQSUzTEQqKGS4ywl+9H9yzchPvQlWJn4CvTI7IZRXH7wK2vjzZrQfYoArmW1
         P09g==
X-Gm-Message-State: AOJu0Ywh/5HMRIt0BaN36gwt7N6GnoxoBNYLCCp9yUaYS0tpVVXhem6k
	ClcNhYE3rWh4KC68tNWm+mNwXt7pn3cD4yjEfDPSFaoZEf0/32vmHHu9H5X7PTalVvzdvg==
X-Gm-Gg: Acq92OEfndbzG82mONpjdgjGPNjYJlDEMHfQxnELBAFwAvB1IpTQnMpav4jyPvZL+Hk
	38TRcNCK8oIKv3+jKEQd44gdtrg8nn8UJ0enmwXZS87or1EJvPdwqGMaLsJM5fE+kt8TLpBvuKW
	fF4LgX3JvPnghEYt9QKsDfr12wXIzFvLbGYo+faWLJmzBGonqvWIUDovydTktYDGOiO6WGimUi3
	0AayC1bminlHVmUWEaUuXqT5XEorYDtzofff0N6xGOf4gNkh0zfTvNJob/gVXK7hGm8voiS6Kfa
	/2ll7eWrBg6mzuTZKqVLE+1x5Z14Iv3XOaM6TFx4KnVT8xn7WM/SOIpgJNfmB6Rwx3z8CBNypgr
	9PlbPbhHgfFm8MPIXjeGNeYXUStHthNQ6nsggidWKyV5J13jlVkyi6mm3ZbgP4i+IWMYGoRENBz
	Np4UyEx7p1V0uJh0X+1wlotEM6BPP5xvk=
X-Received: by 2002:a05:6a00:1307:b0:837:8b75:a5ac with SMTP id d2e1a72fcca58-83e3b8b22f6mr4746227b3a.34.1778399398272;
        Sun, 10 May 2026 00:49:58 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-839679c9293sm16662319b3a.33.2026.05.10.00.49.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 May 2026 00:49:57 -0700 (PDT)
From: Zhang Cen <rollkingzzc@gmail.com>
To: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org,
	zerocling0077@gmail.com,
	2045gemini@gmail.com,
	Zhang Cen <rollkingzzc@gmail.com>
Subject: [PATCH] btrfs: validate ROOT_BACKREF name before copying subvolume info
Date: Sun, 10 May 2026 15:49:43 +0800
Message-Id: <20260510074943.2644335-1-rollkingzzc@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

btrfs_ioctl_get_subvol_info() derives the copied subvolume name
length from btrfs_item_size() and copies it into subvol_info->name,
which is only BTRFS_VOL_NAME_MAX + 1 bytes long. A malformed
ROOT_BACKREF can therefore make the length underflow or exceed the
fixed ioctl buffer.

Validate that the item is large enough for struct btrfs_root_ref,
that the on-disk name_len fits inside the remaining payload, and that
the copied name does not exceed BTRFS_VOL_NAME_MAX. If any of those
checks fail, return -EUCLEAN instead of copying from corrupted
metadata. After validation, copy only name_len bytes and terminate the
result explicitly.

Sanitizer validation reported:
BUG: KASAN: slab-out-of-bounds in read_extent_buffer()
Write of size 505 at addr ffff88810936d608
Call trace:
  dump_stack_lvl() (?:?)
  print_address_description() (mm/kasan/report.c:373)
  read_extent_buffer() (?:?)
  print_report() (?:?)
  __virt_addr_valid() (?:?)
  srso_alias_return_thunk() (arch/x86/include/asm/nospec-branch.h:375)
  kasan_addr_to_slab() (mm/kasan/common.c:45)
  kasan_report() (?:?)
  kasan_check_range() (?:?)
  __asan_memcpy() (mm/kasan/shadow.c:103)
  btrfs_ioctl_get_subvol_info() (fs/btrfs/ioctl.c:2034)
  btrfs_get_32() (fs/btrfs/ioctl.c:?)
  btrfs_set_16() (fs/btrfs/ioctl.c:?)
  btrfs_test_get_subvol_info_name_oob() (fs/btrfs/ioctl.c:?)
  btrfs_run_sanity_tests() (fs/btrfs/ioctl.c:?)
  init_btrfs_fs() (fs/btrfs/super.c:2690)
  do_one_initcall() (init/main.c:1382)
  __kasan_kmalloc() (?:?)
  rcu_is_watching() (?:?)
  do_initcalls() (init/main.c:1457)
  kernel_init_freeable() (init/main.c:1674)
  kernel_init() (init/main.c:1584)
  ret_from_fork() (?:?)
  __switch_to() (?:?)
  ret_from_fork_asm() (?:?)
  kasan_save_stack() (mm/kasan/common.c:52)
  kasan_save_track() (mm/kasan/common.c:74)

Signed-off-by: Zhang Cen <rollkingzzc@gmail.com>

---
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a39460bf68a7..0647e672464a 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1956,7 +1956,8 @@ static int btrfs_ioctl_get_subvol_info(struct inode *inode, void __user *argp)
 	struct btrfs_root_ref *rref;
 	struct extent_buffer *leaf;
 	unsigned long item_off;
-	unsigned long item_len;
+	u32 item_size;
+	u16 name_len;
 	int slot;
 	int ret = 0;
 
@@ -2034,14 +2035,26 @@ static int btrfs_ioctl_get_subvol_info(struct inode *inode, void __user *argp)
 			subvol_info->parent_id = key.offset;
 
 			rref = btrfs_item_ptr(leaf, slot, struct btrfs_root_ref);
+			item_size = btrfs_item_size(leaf, slot);
+			if (item_size < sizeof(*rref)) {
+				ret = -EUCLEAN;
+				goto out;
+			}
+
+			name_len = btrfs_root_ref_name_len(leaf, rref);
+			if (name_len > item_size - sizeof(*rref) ||
+			    name_len > BTRFS_VOL_NAME_MAX) {
+				ret = -EUCLEAN;
+				goto out;
+			}
+
 			subvol_info->dirid = btrfs_root_ref_dirid(leaf, rref);
 
-			item_off = btrfs_item_ptr_offset(leaf, slot)
-					+ sizeof(struct btrfs_root_ref);
-			item_len = btrfs_item_size(leaf, slot)
-					- sizeof(struct btrfs_root_ref);
+			item_off = btrfs_item_ptr_offset(leaf, slot) +
+				   sizeof(*rref);
 			read_extent_buffer(leaf, subvol_info->name,
-					   item_off, item_len);
+					   item_off, name_len);
+			subvol_info->name[name_len] = '\0';
 		} else {
 			ret = -ENOENT;
 			goto out;
