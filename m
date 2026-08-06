Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C48873D9557
	for <linux-btrfs@vger.kernel.org>; Thu,  6 Aug 2026 09:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786010237; cv=none; b=mRGPAY/lAper9L3Bn39TvwMCQtKYvlZRZF6Tfvoc79h0Lzwpu7YSXwdOWKRux0SJMf3bXLFnlQW/Nvt+oyQj3wiQPUU57zudXRbfhROH5IO7oAMzWETqmYANaZ/RseFdkficgsJusqaqKWUXSiWccsTP81jcJ0fIyTiqdtBvsDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786010237; c=relaxed/simple;
	bh=PhKC/Nr3fltsoP4c/VANfIU6lhY+XeFP08jeXXSkod4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=GVBvhAMKdmtULW1ghH34xyiVcudlX3ab9UORI8RIE5MMnDLpoletsvUJSJBcptYmFb9qPVYbEzE47ATleNvJrBVkMhG+5Zr30RICCltCYAzGjHkURkfU09kQ42wiU00LevWUcq59JRO8SXp0gCa3YSZtOfTcu5TMejVZRBwBQzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=kgIR+H0o; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=qkNT3tUa; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="kgIR+H0o";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="qkNT3tUa"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 85F677FFBD
	for <linux-btrfs@vger.kernel.org>; Thu,  6 Aug 2026 09:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1786010228; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Y8eOk7XIZ2z/pPMEivbY3+1il9QUrT7dJK0lMOf9Hoo=;
	b=kgIR+H0oc9pcvBlbEL2TM6gr+KH+xG7T6ZpOKYG3+Gbx4LV58W7s/R7Neb2vLcQCGsC5HQ
	cwwdXJ5GaN73v92Vy0pYukRbDxHV7pqiB0PbfBVTqSnsWi3gGchomosbxWM2azs9fOlUuj
	RkbT7rEuWpII7Gu56wFg/jdN4gEQIWE=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1786010224; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Y8eOk7XIZ2z/pPMEivbY3+1il9QUrT7dJK0lMOf9Hoo=;
	b=qkNT3tUa8JgPKYg2xbuuJlgXN3Ia/F02JbCLXr7++c39Q+MzwzsubIRhze9vyTd/9uePJw
	M1a4LtcCZtv/mgjPlcM/ecTCEkVwZDfCzzEA7znO+UGDsYuCAuvvVLpgKm128DNQTeByLT
	4TJUnDtA0bxQXaRr+LsOCt2aXPkaxnQ=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C091B779BF
	for <linux-btrfs@vger.kernel.org>; Thu,  6 Aug 2026 09:57:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cEeIIG9adGovRwAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 06 Aug 2026 09:57:03 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: remove unnecessary forced type casting in print-tree.c
Date: Thu,  6 Aug 2026 19:26:38 +0930
Message-ID: <61fd5ab4b532ba3a7915dc629339db230cccd52f.1786007917.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid,suse.com:email];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

In kernel-shared/print-tree.c, we have a lot of forced type casting to
"(unsigned long long)" for the format "%llu", no matter if the original
value is really u64.

Change all those forced type casting used in printing functions, to use
the correct native type instead.

Assisted-by: LLM (coding)
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 kernel-shared/print-tree.c | 250 ++++++++++++++++++-------------------
 1 file changed, 125 insertions(+), 125 deletions(-)

diff --git a/kernel-shared/print-tree.c b/kernel-shared/print-tree.c
index cae5c6dfc263..290ab0390579 100644
--- a/kernel-shared/print-tree.c
+++ b/kernel-shared/print-tree.c
@@ -181,7 +181,7 @@ static void print_inode_ref_item(struct extent_buffer *eb, u32 size,
 		len = (name_len <= sizeof(namebuf))? name_len: sizeof(namebuf);
 
 		printf("\t\tindex %llu namelen %u ",
-		       (unsigned long long)index, name_len);
+		       index, name_len);
 		if (eb->fs_info && eb->fs_info->hide_names) {
 			printf("name: HIDDEN\n");
 		} else {
@@ -319,9 +319,9 @@ void print_chunk_item(struct extent_buffer *eb, struct btrfs_chunk *chunk)
 
 	bg_flags_to_str(btrfs_chunk_type(eb, chunk), chunk_flags_str);
 	printf("\t\tlength %llu owner %llu stripe_len %llu type %s\n",
-	       (unsigned long long)btrfs_chunk_length(eb, chunk),
-	       (unsigned long long)btrfs_chunk_owner(eb, chunk),
-	       (unsigned long long)btrfs_chunk_stripe_len(eb, chunk),
+	       btrfs_chunk_length(eb, chunk),
+	       btrfs_chunk_owner(eb, chunk),
+	       btrfs_chunk_stripe_len(eb, chunk),
 		chunk_flags_str);
 	printf("\t\tio_align %u io_width %u sector_size %u\n",
 			btrfs_chunk_io_align(eb, chunk),
@@ -350,8 +350,8 @@ void print_chunk_item(struct extent_buffer *eb, struct btrfs_chunk *chunk)
 			BTRFS_UUID_SIZE);
 		uuid_unparse(dev_uuid, str_dev_uuid);
 		printf("\t\t\tstripe %d devid %llu offset %llu\n", i,
-		      (unsigned long long)btrfs_stripe_devid_nr(eb, chunk, i),
-		      (unsigned long long)btrfs_stripe_offset_nr(eb, chunk, i));
+		      btrfs_stripe_devid_nr(eb, chunk, i),
+		      btrfs_stripe_offset_nr(eb, chunk, i));
 		printf("\t\t\tdev_uuid %s\n", str_dev_uuid);
 	}
 }
@@ -378,15 +378,15 @@ static void print_dev_item(struct extent_buffer *eb,
 	       "\t\tseek_speed %hhu bandwidth %hhu\n"
 	       "\t\tuuid %s\n"
 	       "\t\tfsid %s\n",
-	       (unsigned long long)btrfs_device_id(eb, dev_item),
-	       (unsigned long long)btrfs_device_total_bytes(eb, dev_item),
-	       (unsigned long long)btrfs_device_bytes_used(eb, dev_item),
+	       btrfs_device_id(eb, dev_item),
+	       btrfs_device_total_bytes(eb, dev_item),
+	       btrfs_device_bytes_used(eb, dev_item),
 	       btrfs_device_io_align(eb, dev_item),
 	       btrfs_device_io_width(eb, dev_item),
 	       btrfs_device_sector_size(eb, dev_item),
-	       (unsigned long long)btrfs_device_type(eb, dev_item),
-	       (unsigned long long)btrfs_device_generation(eb, dev_item),
-	       (unsigned long long)btrfs_device_start_offset(eb, dev_item),
+	       btrfs_device_type(eb, dev_item),
+	       btrfs_device_generation(eb, dev_item),
+	       btrfs_device_start_offset(eb, dev_item),
 	       btrfs_device_group(eb, dev_item),
 	       btrfs_device_seek_speed(eb, dev_item),
 	       btrfs_device_bandwidth(eb, dev_item),
@@ -469,20 +469,20 @@ static void print_file_extent_item(struct extent_buffer *eb,
 	}
 	if (extent_type == BTRFS_FILE_EXTENT_PREALLOC) {
 		printf("\t\tprealloc data disk byte %llu nr %llu\n",
-		  (unsigned long long)btrfs_file_extent_disk_bytenr(eb, fi),
-		  (unsigned long long)btrfs_file_extent_disk_num_bytes(eb, fi));
+		  btrfs_file_extent_disk_bytenr(eb, fi),
+		  btrfs_file_extent_disk_num_bytes(eb, fi));
 		printf("\t\tprealloc data offset %llu nr %llu\n",
-		  (unsigned long long)btrfs_file_extent_offset(eb, fi),
-		  (unsigned long long)btrfs_file_extent_num_bytes(eb, fi));
+		  btrfs_file_extent_offset(eb, fi),
+		  btrfs_file_extent_num_bytes(eb, fi));
 		return;
 	}
 	printf("\t\textent data disk byte %llu nr %llu\n",
-		(unsigned long long)btrfs_file_extent_disk_bytenr(eb, fi),
-		(unsigned long long)btrfs_file_extent_disk_num_bytes(eb, fi));
+		btrfs_file_extent_disk_bytenr(eb, fi),
+		btrfs_file_extent_disk_num_bytes(eb, fi));
 	printf("\t\textent data offset %llu nr %llu ram %llu\n",
-		(unsigned long long)btrfs_file_extent_offset(eb, fi),
-		(unsigned long long)btrfs_file_extent_num_bytes(eb, fi),
-		(unsigned long long)btrfs_file_extent_ram_bytes(eb, fi));
+		btrfs_file_extent_offset(eb, fi),
+		btrfs_file_extent_num_bytes(eb, fi),
+		btrfs_file_extent_ram_bytes(eb, fi));
 	printf("\t\textent compression %hhu (%s)\n",
 			btrfs_file_extent_compression(eb, fi),
 			compress_str);
@@ -536,8 +536,8 @@ void print_extent_item(struct extent_buffer *eb, int slot, int metadata)
 	extent_flags_to_str(flags, flags_str);
 
 	printf("\t\trefs %llu gen %llu flags %s\n",
-	       (unsigned long long)btrfs_extent_refs(eb, ei),
-	       (unsigned long long)btrfs_extent_generation(eb, ei),
+	       btrfs_extent_refs(eb, ei),
+	       btrfs_extent_generation(eb, ei),
 	       flags_str);
 
 	if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK && !metadata) {
@@ -617,8 +617,8 @@ static void print_root_ref(struct extent_buffer *leaf, int slot, const char *tag
 	namelen = btrfs_root_ref_name_len(leaf, ref);
 	read_extent_buffer(leaf, namebuf, (unsigned long)(ref + 1), namelen);
 	printf("\t\troot %s key dirid %llu sequence %llu name %.*s\n", tag,
-	       (unsigned long long)btrfs_root_ref_dirid(leaf, ref),
-	       (unsigned long long)btrfs_root_ref_sequence(leaf, ref),
+	       btrfs_root_ref_dirid(leaf, ref),
+	       btrfs_root_ref_sequence(leaf, ref),
 	       namelen, namebuf);
 }
 
@@ -649,7 +649,7 @@ static void print_timespec(struct extent_buffer *eb,
 	localtime_r(&tmp_time, &tm);
 	strftime(timestamp, sizeof(timestamp),
 			"%Y-%m-%d %H:%M:%S", &tm);
-	printf("%s%llu.%u (%s)%s", prefix, (unsigned long long)tmp_u64, tmp_u32,
+	printf("%s%llu.%u (%s)%s", prefix, tmp_u64, tmp_u32,
 			timestamp, suffix);
 }
 
@@ -670,14 +670,14 @@ static void print_root_item(struct extent_buffer *leaf, int slot)
 	root_flags_to_str(btrfs_root_flags(&root_item), flags_str);
 
 	printf("\t\tgeneration %llu root_dirid %llu bytenr %llu byte_limit %llu bytes_used %llu\n",
-		(unsigned long long)btrfs_root_generation(&root_item),
-		(unsigned long long)btrfs_root_dirid(&root_item),
-		(unsigned long long)btrfs_root_bytenr(&root_item),
-		(unsigned long long)btrfs_root_limit(&root_item),
-		(unsigned long long)btrfs_root_used(&root_item));
+		btrfs_root_generation(&root_item),
+		btrfs_root_dirid(&root_item),
+		btrfs_root_bytenr(&root_item),
+		btrfs_root_limit(&root_item),
+		btrfs_root_used(&root_item));
 	printf("\t\tlast_snapshot %llu flags 0x%llx(%s) refs %u\n",
-		(unsigned long long)btrfs_root_last_snapshot(&root_item),
-		(unsigned long long)btrfs_root_flags(&root_item),
+		btrfs_root_last_snapshot(&root_item),
+		btrfs_root_flags(&root_item),
 		flags_str,
 		btrfs_root_refs(&root_item));
 	btrfs_disk_key_to_cpu(&drop_key, &root_item.drop_progress);
@@ -722,9 +722,9 @@ static void print_free_space_header(struct extent_buffer *leaf, int slot)
 	btrfs_print_key(&location);
 	printf("\n");
 	printf("\t\tcache generation %llu entries %llu bitmaps %llu\n",
-	       (unsigned long long)btrfs_free_space_generation(leaf, header),
-	       (unsigned long long)btrfs_free_space_entries(leaf, header),
-	       (unsigned long long)btrfs_free_space_bitmaps(leaf, header));
+	       btrfs_free_space_generation(leaf, header),
+	       btrfs_free_space_entries(leaf, header),
+	       btrfs_free_space_bitmaps(leaf, header));
 }
 
 static void print_raid_stripe_key(struct extent_buffer *eb,
@@ -734,8 +734,8 @@ static void print_raid_stripe_key(struct extent_buffer *eb,
 
 	for (int i = 0; i < num_stripes; i++)
 		printf("\t\t\tstripe %d devid %llu physical %llu\n", i,
-		       (unsigned long long)btrfs_raid_stride_devid_nr(eb, stripe, i),
-		       (unsigned long long)btrfs_raid_stride_physical_nr(eb, stripe, i));
+		       btrfs_raid_stride_devid_nr(eb, stripe, i),
+		       btrfs_raid_stride_physical_nr(eb, stripe, i));
 }
 
 static void print_remap_key(struct extent_buffer *leaf, u32 item_size,
@@ -816,11 +816,11 @@ void print_objectid(FILE *stream, u64 objectid, u8 type)
 		if (objectid == BTRFS_DEV_STATS_OBJECTID)
 			fprintf(stream, "DEV_STATS");
 		else
-			fprintf(stream, "%llu", (unsigned long long)objectid);
+			fprintf(stream, "%llu", objectid);
 		return;
 	case BTRFS_DEV_EXTENT_KEY:
 		/* device id */
-		fprintf(stream, "%llu", (unsigned long long)objectid);
+		fprintf(stream, "%llu", objectid);
 		return;
 	case BTRFS_QGROUP_RELATION_KEY:
 		fprintf(stream, "%u/%llu", btrfs_qgroup_level(objectid),
@@ -828,7 +828,7 @@ void print_objectid(FILE *stream, u64 objectid, u8 type)
 		return;
 	case BTRFS_UUID_KEY_SUBVOL:
 	case BTRFS_UUID_KEY_RECEIVED_SUBVOL:
-		fprintf(stream, "0x%016llx", (unsigned long long)objectid);
+		fprintf(stream, "0x%016llx", objectid);
 		return;
 	}
 
@@ -923,7 +923,7 @@ void print_objectid(FILE *stream, u64 objectid, u8 type)
 		}
 		fallthrough;
 	default:
-		fprintf(stream, "%llu", (unsigned long long)objectid);
+		fprintf(stream, "%llu", objectid);
 	}
 }
 
@@ -946,7 +946,7 @@ void btrfs_print_key(struct btrfs_disk_key *disk_key)
 		break;
 	case BTRFS_UUID_KEY_SUBVOL:
 	case BTRFS_UUID_KEY_RECEIVED_SUBVOL:
-		printf(" 0x%016llx)", (unsigned long long)offset);
+		printf(" 0x%016llx)", offset);
 		break;
 
 	/*
@@ -972,7 +972,7 @@ void btrfs_print_key(struct btrfs_disk_key *disk_key)
 		if (offset == (u64)-1)
 			printf(" -1)");
 		else
-			printf(" %llu)", (unsigned long long)offset);
+			printf(" %llu)", offset);
 		break;
 	}
 }
@@ -990,7 +990,7 @@ static void print_uuid_item(struct extent_buffer *l, unsigned long offset,
 
 		read_extent_buffer(l, &subvol_id, offset, sizeof(u64));
 		printf("\t\tsubvol_id %llu\n",
-			(unsigned long long)le64_to_cpu(subvol_id));
+			le64_to_cpu(subvol_id));
 		item_size -= sizeof(u64);
 		offset += sizeof(u64);
 	}
@@ -1039,18 +1039,18 @@ static void print_inode_item(struct extent_buffer *eb,
 	printf("\t\tgeneration %llu transid %llu size %llu nbytes %llu\n"
 	       "\t\tblock group %llu mode %o links %u uid %u gid %u rdev %llu\n"
 	       "\t\tsequence %llu flags 0x%llx(%s)\n",
-	       (unsigned long long)btrfs_inode_generation(eb, ii),
-	       (unsigned long long)btrfs_inode_transid(eb, ii),
-	       (unsigned long long)btrfs_inode_size(eb, ii),
-	       (unsigned long long)btrfs_inode_nbytes(eb, ii),
-	       (unsigned long long)btrfs_inode_block_group(eb,ii),
+	       btrfs_inode_generation(eb, ii),
+	       btrfs_inode_transid(eb, ii),
+	       btrfs_inode_size(eb, ii),
+	       btrfs_inode_nbytes(eb, ii),
+	       btrfs_inode_block_group(eb,ii),
 	       btrfs_inode_mode(eb, ii),
 	       btrfs_inode_nlink(eb, ii),
 	       btrfs_inode_uid(eb, ii),
 	       btrfs_inode_gid(eb, ii),
-	       (unsigned long long)btrfs_inode_rdev(eb,ii),
-	       (unsigned long long)btrfs_inode_sequence(eb, ii),
-	       (unsigned long long)btrfs_inode_flags(eb,ii),
+	       btrfs_inode_rdev(eb,ii),
+	       btrfs_inode_sequence(eb, ii),
+	       btrfs_inode_flags(eb,ii),
 	       flags_str);
 	print_timespec(eb, btrfs_inode_atime(ii), "\t\tatime ", "\n");
 	print_timespec(eb, btrfs_inode_ctime(ii), "\t\tctime ", "\n");
@@ -1061,18 +1061,18 @@ static void print_inode_item(struct extent_buffer *eb,
 static void print_disk_balance_args(struct btrfs_disk_balance_args *ba)
 {
 	printf("\t\tprofiles %llu devid %llu target %llu flags %llu\n",
-			(unsigned long long)le64_to_cpu(ba->profiles),
-			(unsigned long long)le64_to_cpu(ba->devid),
-			(unsigned long long)le64_to_cpu(ba->target),
-			(unsigned long long)le64_to_cpu(ba->flags));
+			le64_to_cpu(ba->profiles),
+			le64_to_cpu(ba->devid),
+			le64_to_cpu(ba->target),
+			le64_to_cpu(ba->flags));
 	printf("\t\tusage_min %u usage_max %u pstart %llu pend %llu\n",
 			le32_to_cpu(ba->usage_min),
 			le32_to_cpu(ba->usage_max),
-			(unsigned long long)le64_to_cpu(ba->pstart),
-			(unsigned long long)le64_to_cpu(ba->pend));
+			le64_to_cpu(ba->pstart),
+			le64_to_cpu(ba->pend));
 	printf("\t\tvstart %llu vend %llu limit_min %u limit_max %u\n",
-			(unsigned long long)le64_to_cpu(ba->vstart),
-			(unsigned long long)le64_to_cpu(ba->vend),
+			le64_to_cpu(ba->vstart),
+			le64_to_cpu(ba->vend),
 			le32_to_cpu(ba->limit_min),
 			le32_to_cpu(ba->limit_max));
 	printf("\t\tstripes_min %u stripes_max %u\n",
@@ -1145,10 +1145,10 @@ static void print_extent_data_ref(struct extent_buffer *eb, int slot)
 	dref = btrfs_item_ptr(eb, slot, struct btrfs_extent_data_ref);
 	printf("\t\textent data backref root ");
 	print_objectid(stdout,
-		(unsigned long long)btrfs_extent_data_ref_root(eb, dref), 0);
+		btrfs_extent_data_ref_root(eb, dref), 0);
 	printf(" objectid %llu offset %llu count %u\n",
-		(unsigned long long)btrfs_extent_data_ref_objectid(eb, dref),
-		(unsigned long long)btrfs_extent_data_ref_offset(eb, dref),
+		btrfs_extent_data_ref_objectid(eb, dref),
+		btrfs_extent_data_ref_offset(eb, dref),
 		btrfs_extent_data_ref_count(eb, dref));
 }
 
@@ -1197,10 +1197,10 @@ static void print_dev_extent(struct extent_buffer *eb, int slot)
 		"\t\tchunk_objectid %llu chunk_offset %llu "
 		"length %llu\n"
 		"\t\tchunk_tree_uuid %s\n",
-		(unsigned long long)btrfs_dev_extent_chunk_tree(eb, dev_extent),
-		(unsigned long long)btrfs_dev_extent_chunk_objectid(eb, dev_extent),
-		(unsigned long long)btrfs_dev_extent_chunk_offset(eb, dev_extent),
-		(unsigned long long)btrfs_dev_extent_length(eb, dev_extent),
+		btrfs_dev_extent_chunk_tree(eb, dev_extent),
+		btrfs_dev_extent_chunk_objectid(eb, dev_extent),
+		btrfs_dev_extent_chunk_offset(eb, dev_extent),
+		btrfs_dev_extent_length(eb, dev_extent),
 		uuid_str);
 }
 
@@ -1214,13 +1214,13 @@ static void print_qgroup_status(struct extent_buffer *eb, int slot)
 	qgroup_flags_to_str(btrfs_qgroup_status_flags(eb, qg_status),
 					flags_str);
 	printf("\t\tversion %llu generation %llu flags %s scan %llu",
-		(unsigned long long)btrfs_qgroup_status_version(eb, qg_status),
-		(unsigned long long)btrfs_qgroup_status_generation(eb, qg_status),
+		btrfs_qgroup_status_version(eb, qg_status),
+		btrfs_qgroup_status_generation(eb, qg_status),
 		flags_str,
-		(unsigned long long)btrfs_qgroup_status_rescan(eb, qg_status));
+		btrfs_qgroup_status_rescan(eb, qg_status));
 	if (btrfs_fs_incompat(eb->fs_info, SIMPLE_QUOTA))
 		printf(" enable_gen %llu\n",
-			   (unsigned long long)btrfs_qgroup_status_enable_gen(eb, qg_status));
+			   btrfs_qgroup_status_enable_gen(eb, qg_status));
 	else
 		printf("\n");
 }
@@ -1233,11 +1233,11 @@ static void print_qgroup_info(struct extent_buffer *eb, int slot)
 	printf("\t\tgeneration %llu\n"
 		"\t\treferenced %llu referenced_compressed %llu\n"
 		"\t\texclusive %llu exclusive_compressed %llu\n",
-		(unsigned long long)btrfs_qgroup_info_generation(eb, qg_info),
-		(unsigned long long)btrfs_qgroup_info_rfer(eb, qg_info),
-		(unsigned long long)btrfs_qgroup_info_rfer_cmpr(eb, qg_info),
-		(unsigned long long)btrfs_qgroup_info_excl(eb, qg_info),
-		(unsigned long long)btrfs_qgroup_info_excl_cmpr(eb, qg_info));
+		btrfs_qgroup_info_generation(eb, qg_info),
+		btrfs_qgroup_info_rfer(eb, qg_info),
+		btrfs_qgroup_info_rfer_cmpr(eb, qg_info),
+		btrfs_qgroup_info_excl(eb, qg_info),
+		btrfs_qgroup_info_excl_cmpr(eb, qg_info));
 }
 
 static void print_qgroup_limit(struct extent_buffer *eb, int slot)
@@ -1248,7 +1248,7 @@ static void print_qgroup_limit(struct extent_buffer *eb, int slot)
 	printf("\t\tflags %llx\n"
 		"\t\tmax_referenced %lld max_exclusive %lld\n"
 		"\t\trsv_referenced %lld rsv_exclusive %lld\n",
-		(unsigned long long)btrfs_qgroup_limit_flags(eb, qg_limit),
+		btrfs_qgroup_limit_flags(eb, qg_limit),
 		(long long)btrfs_qgroup_limit_max_rfer(eb, qg_limit),
 		(long long)btrfs_qgroup_limit_max_excl(eb, qg_limit),
 		(long long)btrfs_qgroup_limit_rsv_rfer(eb, qg_limit),
@@ -1260,7 +1260,7 @@ static void print_persistent_item(struct extent_buffer *eb, void *ptr,
 {
 	printf("\t\tpersistent item objectid ");
 	print_objectid(stdout, objectid, BTRFS_PERSISTENT_ITEM_KEY);
-	printf(" offset %llu\n", (unsigned long long)offset);
+	printf(" offset %llu\n", offset);
 	switch (objectid) {
 	case BTRFS_DEV_STATS_OBJECTID:
 		print_dev_stats(eb, ptr, item_size);
@@ -1275,7 +1275,7 @@ static void print_temporary_item(struct extent_buffer *eb, void *ptr,
 {
 	printf("\t\ttemporary item objectid ");
 	print_objectid(stdout, objectid, BTRFS_TEMPORARY_ITEM_KEY);
-	printf(" offset %llu\n", (unsigned long long)offset);
+	printf(" offset %llu\n", offset);
 	switch (objectid) {
 	case BTRFS_BALANCE_OBJECTID:
 		print_balance_item(eb, ptr);
@@ -1304,14 +1304,14 @@ static void print_extent_csum(struct extent_buffer *eb,
 	 * don't have sectorsize for the calculation
 	 */
 	if (!fs_info) {
-		printf("\t\trange start %llu\n", (unsigned long long)offset);
+		printf("\t\trange start %llu\n", offset);
 		return;
 	}
 	csum_size = fs_info->csum_size;
 	size = (item_size / csum_size) * fs_info->sectorsize;
 	printf("\t\trange start %llu end %llu length %u\n",
-			(unsigned long long)offset,
-			(unsigned long long)offset + size, size);
+			offset,
+			offset + size, size);
 
 
 	/*
@@ -1385,15 +1385,15 @@ static void print_header_info(struct extent_buffer *eb, unsigned int mode)
 	if (btrfs_header_level(eb))
 		printf(
 	"node %llu level %d items %u free space %u generation %llu owner ",
-		       (unsigned long long)eb->start, btrfs_header_level(eb),
+		       eb->start, btrfs_header_level(eb),
 		       nr, (u32)BTRFS_NODEPTRS_PER_EXTENT_BUFFER(eb) - nr,
-		       (unsigned long long)btrfs_header_generation(eb));
+		       btrfs_header_generation(eb));
 	else
 		printf(
 	"leaf %llu items %u free space %d generation %llu owner ",
-		       (unsigned long long)btrfs_header_bytenr(eb), nr,
+		       btrfs_header_bytenr(eb), nr,
 		       btrfs_leaf_free_space(eb),
-		       (unsigned long long)btrfs_header_generation(eb));
+		       btrfs_header_generation(eb));
 	print_objectid(stdout, btrfs_header_owner(eb), 0);
 	printf("\n");
 	if (fs_info && (mode & BTRFS_PRINT_TREE_CSUM_HEADERS)) {
@@ -1584,7 +1584,7 @@ void __btrfs_print_leaf(struct extent_buffer *eb, unsigned int mode)
 
 			dlog = btrfs_item_ptr(eb, i, struct btrfs_dir_log_item);
 			printf("\t\tdir log end %llu\n",
-			       (unsigned long long)btrfs_dir_log_end(eb, dlog));
+			       btrfs_dir_log_end(eb, dlog));
 			break;
 			}
 		case BTRFS_ORPHAN_ITEM_KEY:
@@ -1906,8 +1906,8 @@ void btrfs_print_tree(struct extent_buffer *eb, unsigned int mode)
 		printf("\t");
 		btrfs_print_key(&disk_key);
 		printf(" block %llu gen %llu\n",
-		       (unsigned long long)blocknr,
-		       (unsigned long long)btrfs_node_ptr_generation(eb, i));
+		       blocknr,
+		       btrfs_node_ptr_generation(eb, i));
 		fflush(stdout);
 	}
 	if (!follow)
@@ -2239,7 +2239,7 @@ void btrfs_print_superblock(struct btrfs_super_block *sb, int full)
 		csum_size = btrfs_super_csum_size(sb);
 	}
 	printf(")\n");
-	printf("csum_size\t\t%llu\n", (unsigned long long)csum_size);
+	printf("csum_size\t\t%u\n", csum_size);
 
 	printf("csum\t\t\t0x");
 	for (i = 0, p = sb->csum; i < csum_size; i++)
@@ -2253,9 +2253,9 @@ void btrfs_print_superblock(struct btrfs_super_block *sb, int full)
 	putchar('\n');
 
 	printf("bytenr\t\t\t%llu\n",
-		(unsigned long long)btrfs_super_bytenr(sb));
+		btrfs_super_bytenr(sb));
 	printf("flags\t\t\t0x%llx\n",
-		(unsigned long long)btrfs_super_flags(sb));
+		btrfs_super_flags(sb));
 	print_readable_super_flag(btrfs_super_flags(sb));
 
 	printf("magic\t\t\t");
@@ -2279,52 +2279,52 @@ void btrfs_print_superblock(struct btrfs_super_block *sb, int full)
 	putchar('\n');
 
 	printf("generation\t\t%llu\n",
-	       (unsigned long long)btrfs_super_generation(sb));
-	printf("root\t\t\t%llu\n", (unsigned long long)btrfs_super_root(sb));
-	printf("sys_array_size\t\t%llu\n",
-	       (unsigned long long)btrfs_super_sys_array_size(sb));
+	       btrfs_super_generation(sb));
+	printf("root\t\t\t%llu\n", btrfs_super_root(sb));
+	printf("sys_array_size\t\t%u\n",
+	       btrfs_super_sys_array_size(sb));
 	printf("chunk_root_generation\t%llu\n",
-	       (unsigned long long)btrfs_super_chunk_root_generation(sb));
-	printf("root_level\t\t%llu\n",
-	       (unsigned long long)btrfs_super_root_level(sb));
+	       btrfs_super_chunk_root_generation(sb));
+	printf("root_level\t\t%u\n",
+	       btrfs_super_root_level(sb));
 	printf("chunk_root\t\t%llu\n",
-	       (unsigned long long)btrfs_super_chunk_root(sb));
-	printf("chunk_root_level\t%llu\n",
-	       (unsigned long long)btrfs_super_chunk_root_level(sb));
+	       btrfs_super_chunk_root(sb));
+	printf("chunk_root_level\t%u\n",
+	       btrfs_super_chunk_root_level(sb));
 	printf("log_root\t\t%llu\n",
-	       (unsigned long long)btrfs_super_log_root(sb));
+	       btrfs_super_log_root(sb));
 	printf("log_root_transid (deprecated)\t%llu\n",
 	       le64_to_cpu(sb->__unused_log_root_transid));
-	printf("log_root_level\t\t%llu\n",
-	       (unsigned long long)btrfs_super_log_root_level(sb));
+	printf("log_root_level\t\t%u\n",
+	       btrfs_super_log_root_level(sb));
 	printf("total_bytes\t\t%llu\n",
-	       (unsigned long long)btrfs_super_total_bytes(sb));
+	       btrfs_super_total_bytes(sb));
 	printf("bytes_used\t\t%llu\n",
-	       (unsigned long long)btrfs_super_bytes_used(sb));
-	printf("sectorsize\t\t%llu\n",
-	       (unsigned long long)btrfs_super_sectorsize(sb));
-	printf("nodesize\t\t%llu\n",
-	       (unsigned long long)btrfs_super_nodesize(sb));
+	       btrfs_super_bytes_used(sb));
+	printf("sectorsize\t\t%u\n",
+	       btrfs_super_sectorsize(sb));
+	printf("nodesize\t\t%u\n",
+	       btrfs_super_nodesize(sb));
 	printf("leafsize (deprecated)\t%u\n",
 	       le32_to_cpu(sb->__unused_leafsize));
-	printf("stripesize\t\t%llu\n",
-	       (unsigned long long)btrfs_super_stripesize(sb));
+	printf("stripesize\t\t%u\n",
+	       btrfs_super_stripesize(sb));
 	printf("root_dir\t\t%llu\n",
-	       (unsigned long long)btrfs_super_root_dir(sb));
+	       btrfs_super_root_dir(sb));
 	printf("num_devices\t\t%llu\n",
-	       (unsigned long long)btrfs_super_num_devices(sb));
+	       btrfs_super_num_devices(sb));
 	printf("compat_flags\t\t0x%llx\n",
-	       (unsigned long long)btrfs_super_compat_flags(sb));
+	       btrfs_super_compat_flags(sb));
 	printf("compat_ro_flags\t\t0x%llx\n",
-	       (unsigned long long)btrfs_super_compat_ro_flags(sb));
+	       btrfs_super_compat_ro_flags(sb));
 	print_readable_compat_ro_flag(btrfs_super_compat_ro_flags(sb));
 	printf("incompat_flags\t\t0x%llx\n",
-	       (unsigned long long)btrfs_super_incompat_flags(sb));
+	       btrfs_super_incompat_flags(sb));
 	print_readable_incompat_flag(btrfs_super_incompat_flags(sb));
 	printf("cache_generation\t%llu\n",
-	       (unsigned long long)btrfs_super_cache_generation(sb));
+	       btrfs_super_cache_generation(sb));
 	printf("uuid_tree_generation\t%llu\n",
-	       (unsigned long long)btrfs_super_uuid_tree_generation(sb));
+	       btrfs_super_uuid_tree_generation(sb));
 
 	uuid_unparse(sb->dev_item.uuid, buf);
 	printf("dev_item.uuid\t\t%s\n", buf);
@@ -2339,11 +2339,11 @@ void btrfs_print_superblock(struct btrfs_super_block *sb, int full)
 	printf("dev_item.fsid\t\t%s %s\n", buf,
 	       cmp_res ? "[match]" : "[DON'T MATCH]");
 
-	printf("dev_item.type\t\t%llu\n", (unsigned long long)
+	printf("dev_item.type\t\t%llu\n",
 	       btrfs_stack_device_type(&sb->dev_item));
-	printf("dev_item.total_bytes\t%llu\n", (unsigned long long)
+	printf("dev_item.total_bytes\t%llu\n",
 	       btrfs_stack_device_total_bytes(&sb->dev_item));
-	printf("dev_item.bytes_used\t%llu\n", (unsigned long long)
+	printf("dev_item.bytes_used\t%llu\n",
 	       btrfs_stack_device_bytes_used(&sb->dev_item));
 	printf("dev_item.io_align\t%u\n", (unsigned int)
 	       btrfs_stack_device_io_align(&sb->dev_item));
@@ -2359,7 +2359,7 @@ void btrfs_print_superblock(struct btrfs_super_block *sb, int full)
 	       btrfs_stack_device_seek_speed(&sb->dev_item));
 	printf("dev_item.bandwidth\t%u\n", (unsigned int)
 	       btrfs_stack_device_bandwidth(&sb->dev_item));
-	printf("dev_item.generation\t%llu\n", (unsigned long long)
+	printf("dev_item.generation\t%llu\n",
 	       btrfs_stack_device_generation(&sb->dev_item));
 	if (full) {
 		printf("sys_chunk_array[%d]:\n", BTRFS_SYSTEM_CHUNK_ARRAY_SIZE);
-- 
2.54.0

