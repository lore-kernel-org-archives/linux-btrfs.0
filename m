Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=111.22.67.151
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793780920;
	b=IlQCZosAuH7DWgI/ps9qAUZvNxYuCYrNuXC2QXx86Yj8D/Ckus4TxQYoPObm56VgEAxT
	 TMA19Ggj8OtufxS8ycYwK5yWuNTBeLOZxZkNgsBi5O9Zy8RIPoXAMNkmoyVoSX0AEhk4n
	 IuNaYcqkRBXrn7ZxRfJXdooOu5c3aMs+sNwqCEVqa29QGb2iL8kCC1ioqMuo/uJfyA2ot
	 M3WH/pAft4Ns92u2meTOEuhvcqt9ktRE7D2ywo6uvAA19OmXVZGjyoslT38W48BMjj/2B
	 44s5C3CqFKjd8gDbf3ned+69hu/Cgxo50Hjd9r0OeufpVUlT3MLd5bYMPKaqLjZKXHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793780920;
	h=DMARC-Filter:DKIM-Signature:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:
	 X-RM-TRANSID:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:X-RM-TRANSID:From:
	 To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=90tu+K8j6r16cqCpreLay2De8tvqM0wRXCWOZZEYqpg=;
	b=W7rlJ+P9kJSTTU8QzotrvHGfrPajPwAWHNuvj5o5i/UR0RG25eQxOimKg3V88p9gIcE0
	 OTgRoaaj8+BDbm9ciVYwDSVCsr9i/ROju7unzWCUbE9QRBr6s+zSOokezZerWZKHj3/DW
	 sZXcrJMZoyPVttcP7dIoQfhsRlVmtTBhz5TvPWtHAfh/nJqRq+iE4usOkMGEYStjreh8y
	 a0Fo3vCfjikKT7+AkZc5U/NmvqvCA1X5rOMJExzAjwb5dflHPWlxHXfI6PQHCXAHP34Vi
	 g5UIVQdfU1CriFGMMWi7KSU75SAhNK0cpQLznCf8Sq+z7C7jAAF3x2mBTXjt35vLe4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cmss.chinamobile.com;
	spf=pass smtp.mailfrom=cmss.chinamobile.com;
	dkim=pass header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=rPOrwuSQ;
	arc=none smtp.remote-ip=111.22.67.151
Received: from cmccmta8.chinamobile.com (cmccmta8.chinamobile.com [111.22.67.151])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84936606A32C;
	Wed,  4 Nov 2026 08:28:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 84936606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=rPOrwuSQ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=rPOrwuSQxi1rQb3+Y5Sd/UrROmlOx+QKopvSf0u70EiaamC8i/DyvMKO3sM9O47S9grtBza1UdVXa
	 H5dA99tHfyBcMfZG1RRvbW++vjEb/9QUj8T2xeDLIQbWVIjk5udQ291iORd+qqDuTbPdGMIVSpjpJL
	 TA9Oo6VxWymxwkqE=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app02-12002 (RichMail) with SMTP id 2ee26aeaecb32c7-d7c68;
	Wed, 04 Nov 2026 16:28:36 +0800 (CST)
X-RM-TRANSID:2ee26aeaecb32c7-d7c68
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from utest (unknown[223.108.79.103])
	by rmsmtp-syy-appsvr01-12001 (RichMail) with SMTP id 2ee16aeaecb2cc1-1b3fd;
	Wed, 04 Nov 2026 16:28:36 +0800 (CST)
X-RM-TRANSID:2ee16aeaecb2cc1-1b3fd
From: Shunbo Shi <shishunbo@cmss.chinamobile.com>
To: dsterba@suse.com,
	mason@kernel.org
Cc: jbacik@fb.com,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+7ec60f4482abeecb0fd8@syzkaller.appspotmail.com
Subject: [PATCH] btrfs: fix delayed_refs_rsv leak when realloc shrinks an extent
Date: Wed,  4 Nov 2026 08:28:34 +0000
Message-ID: <20261104082834.25047-1-shishunbo@cmss.chinamobile.com>
X-Mailer: git-send-email 2.53.0
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

When a data extent is freed and reallocated (with a smaller size)
before its delayed refs are processed, update_existing_head_ref()
updates existing->num_bytes to the new size while the extent is
still in the " csum reservation\ state (total_ref_mod < 0).

The csum space for deleting the checksums was reserved for the
original size in add_delayed_ref_head():

 pending_csums += head_ref->num_bytes;
 trans->delayed_ref_csum_deletions += csum_leaves(num_bytes);

but when total_ref_mod later turns non-negative,
update_existing_head_ref() releases the reservation based on the
new, smaller num_bytes:

 pending_csums -= existing->num_bytes;
 btrfs_delayed_refs_rsv_release(fs_info, 0, csum_leaves);

The difference between the old and the new size is never released,
so delayed_refs_rsv.size (and .reserved) stay above zero forever.
At unmount this triggers

 WARNING: fs_info->delayed_refs_rsv.reserved > 0
 at btrfs_release_global_block_rsv

and at runtime the leaked reservation keeps inflating
space_info->bytes_may_use, which can lead to premature ENOSPC.

Fix this by adjusting the csum accounting to the new size at the
time existing->num_bytes is updated: if the head is still in the
reservation state, release the difference in csum leaves (or add
it, if the extent grew) and update pending_csums accordingly, so
that the release in the total_ref_mod transition stays symmetric
with the reservation.

Fixes: ba2c4d4e3bda ("btrfs: introduce delayed_refs_rsv")
Reported-by: syzbot+7ec60f4482abeecb0fd8@syzkaller.appspotmail.com
Link: https://lore.kernel.org/linux-btrfs/6ae88b9e.64e51036.15cf6a.0027.GAE@google.com/
Signed-off-by: Shunbo Shi <shishunbo@cmss.chinamobile.com>
---
 fs/btrfs/delayed-ref.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 8bc1929237f7..a3e32f08dacc 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -694,6 +694,34 @@ static noinline void update_existing_head_ref(struct btrfs_trans_handle *trans,
 		existing->must_insert_reserved = update->must_insert_reserved;
 		existing->owning_root = update->owning_root;
 
+		/*
+		 * The extent may have been reallocated with a different
+		 * size before its delayed refs were processed.  The csum
+		 * reservation was made for the old size (see
+		 * add_delayed_ref_head()), so adjust the accounting to the
+		 * new size here; otherwise the release done when
+		 * total_ref_mod turns non-negative below releases less than
+		 * what was reserved and delayed_refs_rsv leaks the
+		 * difference.
+		 */
+		if (existing->is_data && existing->total_ref_mod < 0 &&
+		    existing->num_bytes != update->num_bytes) {
+			u64 old_leaves = btrfs_csum_bytes_to_leaves(fs_info,
+							   existing->num_bytes);
+			u64 new_leaves = btrfs_csum_bytes_to_leaves(fs_info,
+							    update->num_bytes);
+
+			if (new_leaves < old_leaves)
+				btrfs_delayed_refs_rsv_release(fs_info, 0,
+						old_leaves - new_leaves);
+			else if (new_leaves > old_leaves)
+				trans->delayed_ref_csum_deletions +=
+					new_leaves - old_leaves;
+
+			delayed_refs->pending_csums += update->num_bytes;
+			delayed_refs->pending_csums -= existing->num_bytes;
+		}
+
 		/*
 		 * update the num_bytes so we make sure the accounting
 		 * is done correctly
-- 
2.53.0



