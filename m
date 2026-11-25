Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617280;
	b=uPwy4rv8Symgm9g2chJKJ1Y2Jc4HQZ8EjsbDcnOVYMYq9zJPEPxnS/UMrTgu45Pn0CZ4
	 BpelydHrrzqtstfCEImohtp+9phImjgUm1zjOO2i7qbKRvExd35wwT643JNz9q/O/a51g
	 4wbaauj8ow8zkeqA4YZ3AIVc5Ha7wWh7w/gNKmc1v5f7GuEFOxaKVdK6s5o10ONFUWn8L
	 2rT7l2rVBlCUvUSy1iI5qDvFR/iF/6EL6br41ImQT2r/DGCGI/srk/SpPEdPSmpbHDYlR
	 4J+QsIEmS+J42YigfYh7Bm74WIfGQsPLTBL6lT3ABx891bH9DcnEDp54F6zJKtIxKsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617280;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=mhLYOMnl9962TiXgxuHKr67nXpe3NbwFxQ9c7lj7uDo=;
	b=GAWHbF0lU2ttMSYk4Z7V97nZ17gwXYheVQFxXpolsF69iAvc7tdrfX8o6NPnKQsegULu
	 yw4IyzxcXeORs4dKiJBPI7fHPB1jKaiWDDv5S2e6mbWFP/eR5N2UHCtpoPA+pJBxkzBBZ
	 TtvzXLpfcw+KP0YlOs5CMLBSa0/TIAEObdMHabPezsV1t+YC+mAEWWHrvMYY8Bj+vv46M
	 Z0IwXjq9TuPeT0L2P7seY+Yf6T75lYFTa4rCvBjoefwKUwzMrrKoRzqPLfD2OEInVNwDK
	 85gSk7c/m22R7RSB+W/Gw1vAdW8QNoTbNmVUu8sYQjaj4QsBTZMBqBS+cpJtJI44yYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=khqQkzoK;
	arc=none smtp.remote-ip=74.125.82.48
Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B03F606A321
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 14:34:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8B03F606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=khqQkzoK
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-1b50a4bd2f3so3493256c88.1
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 06:34:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795617278; x=1796222078; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=mhLYOMnl9962TiXgxuHKr67nXpe3NbwFxQ9c7lj7uDo=;
        b=khqQkzoK3i49QvuxBB8aoDqY/FOxKxIUPKWVwNMScKVQ3oPs9+hAqq8wzHZE8QhUCz
         0CpYiXjDWbQWnV5tZgLfz8ZDPFG/EyNUnQKaDBm6HVITJbUJ8G7i2w+M2ce0ESgT37Lz
         ezGXCNPjOuIgA6ZseKbBB/bkdzebw5Y1PgFu+ykNkXmBj60Uw+CTwvUhR5AB/iC5LeP8
         z687nn8GD1IBw8p+0hgnolMGeEIZzFpJc95CnfW5/aMhtfa0vGo4e1xKJDd21n/oBWaq
         RJkx21KY/o61MKul89Z6dhgKXEecULiXET93rdS3JOm8HErCqMFSK9rkq/iIK3bd9kbn
         UoXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795617278; x=1796222078;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mhLYOMnl9962TiXgxuHKr67nXpe3NbwFxQ9c7lj7uDo=;
        b=GVLIuvJb382VMeMaN9ZnH+tGymAhvzNv1ziD64HPrFXdg9NfOj1maqJM52xL5ADb6p
         nk4jdclImKgXnMUKMd/qdgB2DufpPklQk5LJeOQ0cIu8r1d1WDlG/cIslvBE6Zor1LD5
         DCkh6g7pwk6gShKJJxXJ7RFMPwFT+GNi0ld1wuIntbKxB+P5fRVzj2rmKYSB4j/Gp0v0
         l7xFeLx6co2Jc7PWLdTq/G/k7MLPDLZKYztnSiuD2DDA/aYJVk0cTJgynzBBkt8p/0GU
         iM9ksCxGnqA1Y/jnqbqaWYob8db2Hv74UJw8f+e+2B6PTcJSMJhlah/KB06jb/Y680sU
         nxOA==
X-Forwarded-Encrypted: i=1; AL+hErFIqEbA5QY/Jl/WWNY7U/f5deMqG5luv5Ju+QQeAWF7BEToUc5uQuN2g/XUqheymswNxCRq6IiH4siuaA==@vger.kernel.org
X-Gm-Message-State: APuU4Z+OvIn7YxfgI/0vchHKTZet//q/IowoGvPtS0BXRt/Nt07Pp++Z
	AOy64vgzVG76k2a/bhr0tNWSfNkvPyOmuu2hzv3b4w+/6OUTPOxtPoBz
X-Gm-Gg: AZFdTZdMlYd5/9Gdyzu2ReHwY9x7B+XHPovP59ybACV911/c3tnxOvwYzt/6hL6iB2V
	HfPEEBD1c9Z5O9UTQfM/n6F8goCr5CdvdzDK1c7e3zu2TSNBdmzd3gbsj3GmNMvmCETs7EXq4Tw
	KsF3do2sXyqPZ1c0XroqAKixHUkDCEc9charcYzW9DUI3t+9aXmBKQR8evuogSL99FRN83gW+N/
	nJSElqyzvq7wJl+KVaIjevgmwU60ldtRUeQpqy/Cjhr6g+fYYv3vRyD6Ys62w7U9bH0j1iuKEHr
	b7/yudS3ZJS8dlNzqsMdnZmekt/Wim6ANFT6wgTiC+nO3PwLWsk0eHL4Qmt5aGVXDp6cnwhn+dI
	2+5mivCXrRmXVKF8vG3o7jfw+xrn6K3qoIEyHBC9HvZBs6IX732EP9W8mQ+XIDIv+U1CIZClEWY
	O1zKJwf2tULxG9LneVMZF15w+9P21WAvY0iRei0R7qVkwJJNEqOda7q2NshHO5+uIEcuKqIHgJC
	vBHV3ASsN84Dyh58UwWo/eNATL/wuD9Hij+zHr5MqdXaFlrp1hmZBxQpRXl1PNtSLsxgYl5bfVK
	KetVCDEmyxO/6JC8fbCKPEt38vukW64vhZ0RGkQqzL8Q3F/t+SO3EqEzXzIIlZUwHc8O
X-Received: by 2002:a05:7022:b051:20b0:1b4:e533:ff50 with SMTP id a92af1059eb24-1b556912ca9mr20265727c88.40.1795617278266;
        Wed, 25 Nov 2026 06:34:38 -0800 (PST)
Received: from youngkk-vm.localdomain (67.216.200.102.16clouds.com. [67.216.200.102])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b556847fdasm48606523c88.13.2026.11.25.06.34.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 06:34:37 -0800 (PST)
From: Cheng Yongkang <teel4res@gmail.com>
To: David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>,
	Qu Wenruo <wqu@suse.com>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v6] btrfs: tree-checker: add more checks for file extent items
Date: Wed, 25 Nov 2026 06:34:31 -0800
Message-Id: <20261125143431.3035562-1-teel4res@gmail.com>
X-Mailer: git-send-email 2.34.1
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

check_extent_data_item() only checks the alignment of most members of a
regular or preallocated file extent. Add the following checks, based on
what btrfs writes:

- An explicit hole (disk_bytenr == 0) must be an uncompressed regular
  extent with zero disk_num_bytes. Its offset is not checked, as
  btrfs_drop_extents() can trim the front of a hole extent.

- A preallocated extent must not be compressed.

- An extent with data on disk must have a non-zero disk_num_bytes. If it
  is compressed, disk_num_bytes must not exceed BTRFS_MAX_COMPRESSED and
  ram_bytes must not exceed BTRFS_MAX_UNCOMPRESSED, as compression and
  encoded writes never create larger ones. Otherwise both must not
  exceed U32_MAX. Uncompressed extents can be larger than 256MiB, for
  example preallocated extents from kernels before v3.9, but they should
  never get close to U32_MAX.

- offset + num_bytes of an extent with data on disk must not exceed its
  ram_bytes if it is compressed, or its disk_num_bytes otherwise, as
  btrfs_extent_item_to_extent_map() uses disk_num_bytes as the ram_bytes
  of uncompressed extents.

Suggested-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Cheng Yongkang <teel4res@gmail.com>
---
Note that before v3.9, __btrfs_prealloc_file_range() reserved the whole
fallocate range at once, so on a RAID0 or RAID10 filesystem with five or
more data stripes a preallocated extent can be up to the 10G data chunk
limit, above U32_MAX. Such a filesystem would fail the new check. If it
should still be accepted, BTRFS_MAX_DATA_CHUNK_SIZE could be used as the
uncompressed limit instead, as a data extent never crosses a chunk.

Changes in v6:
- Check offset + num_bytes of uncompressed extents against
  disk_num_bytes instead of ram_bytes, as pointed out by Sashiko on v5.
  btrfs_extent_item_to_extent_map() ignores the ram_bytes of uncompressed
  extents, so disk_num_bytes is what reads are bound by. This also keeps
  accepting uncompressed extents from older kernels with ram_bytes
  smaller than disk_num_bytes.

Changes in v5:
- Drop the crash reports from the commit message, the patch is a
  tree-checker hardening.
- Add a dedicated check for explicit holes: they must be uncompressed
  regular extents with zero disk_num_bytes, as Sashiko pointed out on
  v4 that a hole bypassed all the new checks.
- Reject compressed preallocated extents, also pointed out by Sashiko.
- Check offset + num_bytes against ram_bytes for uncompressed extents
  too.
- Only use preallocated extents from kernels before v3.9 as the example
  of uncompressed extents larger than 256MiB. A direct I/O write
  reserves its whole range, but each bio gets its own ordered extent, so
  its file extents are only as large as its bios.
- Change the subject, as the patch no longer only checks disk_num_bytes.

Changes in v4:
- Also check ram_bytes of uncompressed extents against U32_MAX, with
  max_ram_bytes picked the same way as max_disk_num_bytes.
- Reject a zero disk_num_bytes for extents with data on disk, and an
  offset + num_bytes beyond ram_bytes for compressed extents, as
  Sashiko pointed out on v2 and v3.
- Skip holes for the new checks, as their ram_bytes is the hole size
  without NO_HOLES.
- Correct the commit message: direct I/O writes can also create
  uncompressed extents larger than 256MiB.
- Rebase onto misc-next.

Changes in v3:
- Relax the uncompressed disk_num_bytes limit from 256MiB to U32_MAX,
  as preallocated extents created before v3.9 can be larger.
- Also check ram_bytes of compressed extents against
  BTRFS_MAX_UNCOMPRESSED.

Changes in v2:
- Use SZ_256M directly instead of adding a new macro, and leave
  inode.c alone.
- Shorten the comment.

 fs/btrfs/tree-checker.c | 72 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index f021ac14babf..1a8e5b997493 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -244,7 +244,11 @@ static int check_extent_data_item(struct extent_buffer *leaf,
 	struct btrfs_file_extent_item *fi;
 	u32 sectorsize = fs_info->sectorsize;
 	u32 item_size = btrfs_item_size(leaf, slot);
+	u32 max_disk_num_bytes;
+	u32 max_ram_bytes;
 	u64 extent_end;
+	u64 data_end;
+	u64 data_len;
 	u8 fi_type;
 
 	if (unlikely(!IS_ALIGNED(key->offset, sectorsize))) {
@@ -377,6 +381,74 @@ static int check_extent_data_item(struct extent_buffer *leaf,
 		     CHECK_FE_ALIGNED(leaf, slot, fi, num_bytes, sectorsize)))
 		return -EUCLEAN;
 
+	if (!btrfs_file_extent_disk_bytenr(leaf, fi)) {
+		if (unlikely(fi_type != BTRFS_FILE_EXTENT_REG ||
+			     btrfs_file_extent_compression(leaf, fi) != BTRFS_COMPRESS_NONE ||
+			     btrfs_file_extent_disk_num_bytes(leaf, fi))) {
+			file_extent_err(leaf, slot,
+"invalid hole file extent, have type %u compression %u disk_num_bytes %llu expect type %u compression 0 disk_num_bytes 0",
+					fi_type, btrfs_file_extent_compression(leaf, fi),
+					btrfs_file_extent_disk_num_bytes(leaf, fi),
+					BTRFS_FILE_EXTENT_REG);
+			return -EUCLEAN;
+		}
+	} else {
+		if (unlikely(fi_type == BTRFS_FILE_EXTENT_PREALLOC &&
+			     btrfs_file_extent_compression(leaf, fi) != BTRFS_COMPRESS_NONE)) {
+			file_extent_err(leaf, slot,
+		"invalid compression for preallocated file extent, have %u expect 0",
+					btrfs_file_extent_compression(leaf, fi));
+			return -EUCLEAN;
+		}
+
+		/*
+		 * Compressed extents are at most 128K both on disk and
+		 * uncompressed. Uncompressed extents should never get close to
+		 * U32_MAX.
+		 */
+		if (btrfs_file_extent_compression(leaf, fi) != BTRFS_COMPRESS_NONE) {
+			max_disk_num_bytes = BTRFS_MAX_COMPRESSED;
+			max_ram_bytes = BTRFS_MAX_UNCOMPRESSED;
+		} else {
+			max_disk_num_bytes = U32_MAX;
+			max_ram_bytes = U32_MAX;
+		}
+		if (unlikely(btrfs_file_extent_disk_num_bytes(leaf, fi) == 0 ||
+			     btrfs_file_extent_disk_num_bytes(leaf, fi) > max_disk_num_bytes)) {
+			file_extent_err(leaf, slot,
+		"invalid disk_num_bytes for file extent, have %llu expect (0, %u]",
+					btrfs_file_extent_disk_num_bytes(leaf, fi),
+					max_disk_num_bytes);
+			return -EUCLEAN;
+		}
+		if (unlikely(btrfs_file_extent_ram_bytes(leaf, fi) > max_ram_bytes)) {
+			file_extent_err(leaf, slot,
+		"invalid ram_bytes for file extent, have %llu expect <= %u",
+					btrfs_file_extent_ram_bytes(leaf, fi),
+					max_ram_bytes);
+			return -EUCLEAN;
+		}
+		/*
+		 * btrfs_extent_item_to_extent_map() uses disk_num_bytes as the
+		 * ram_bytes of uncompressed extents.
+		 */
+		if (btrfs_file_extent_compression(leaf, fi) != BTRFS_COMPRESS_NONE)
+			data_len = btrfs_file_extent_ram_bytes(leaf, fi);
+		else
+			data_len = btrfs_file_extent_disk_num_bytes(leaf, fi);
+		if (unlikely(check_add_overflow(btrfs_file_extent_offset(leaf, fi),
+						btrfs_file_extent_num_bytes(leaf, fi),
+						&data_end) ||
+			     data_end > data_len)) {
+			file_extent_err(leaf, slot,
+	"invalid offset + num_bytes for file extent, have %llu + %llu expect <= %llu",
+					btrfs_file_extent_offset(leaf, fi),
+					btrfs_file_extent_num_bytes(leaf, fi),
+					data_len);
+			return -EUCLEAN;
+		}
+	}
+
 	/* Catch extent end overflow */
 	if (unlikely(check_add_overflow(btrfs_file_extent_num_bytes(leaf, fi),
 					key->offset, &extent_end))) {

base-commit: 10b0e58070dc350f3e47a87bb4a584050f32ef18
-- 
2.34.1

