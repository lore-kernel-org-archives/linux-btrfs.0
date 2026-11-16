Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794830986;
	b=vS1VaxsShHMGIrRsi9Pi5TC4aOO9yQLeK4t67jEo4c3ICdwsA8oH33Hck+riQTqCeh5K
	 /xVwFBnqelo/0cuz39dK8GlAHMZxU1N2w0hTN0br8EzyZ35sXjpHLZkddt5vOXb2Hj/Cj
	 /8zuNnVZiSk0rwQewj7w0UWFdH4+kOVsdiWRC1FQFJJHhVbuRLENSNaA+9y0kVyMwz/rq
	 o4lu5/iLJ2mw0+bgpLZTzceTLVgBgAtDufXYS3FRHvCw8Fc8P753Ou9noXoi4wtd7Wn4q
	 mLjUTbBb62P1RevM+EbJmkckc7m8q+J6IOZK1o9oKOIeWGENIgachz2TmfHKoI0Q7pA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794830986;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M4BcsKDTpZ7hnrOT5LVXVW0b/vIkxzElt1QlfDPvdjE=;
	b=vMc1pNZhNZyIBfrvgaWfB/XcIyuWQpU5tigWCq/DZqmwf/u4mnlGRq4Px85393R9TlCv
	 ivXJOOJ8d/+zMyjNxXM05ahGZFak7/BMVgIPuyHttn/k6p0tqinWnof6+WC2feZywezVe
	 wabOkyUtTLVk0IQoKoHJA2j69SJKH5gLHf/ABMwSaWi2i47d+j5zji5hTNMEObCI9IRDO
	 1h2Cs/LsR8JfLPpqtVfMdRDa5MEBT4tKrZwnuyWBCbtxu/pkwa35GpERcE4KjQiDTVaa/
	 DEphNzphlnb74wWVhyCMB43RZZpK8XcuqvgWU8QoOVNIbGoIqTz+8Atv2Gmrf7JWMOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="OIJLX2/X";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE51A606A329
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2026 12:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OIJLX2/X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4989B1F000C5
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2026 12:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794830986;
	bh=M4BcsKDTpZ7hnrOT5LVXVW0b/vIkxzElt1QlfDPvdjE=;
	h=From:To:Subject:Date;
	b=OIJLX2/XdAwYMnzm519zJasoE9jD2AkXuVBTEPfXUIm8ZCkVYNbKO5uYVR27UcJbC
	 fanlorA0gdhk5XMkRcv/I4bAuVsJekU0XgcoSB4qsVIfks4yIM6p7S1aMGLrGSJy+c
	 X7eRrcH08YPF4jRanyXZXw6EsBX2qKmFH7NmiQI8Eimakz5KaJxhLuk3RWXR5UH6Rj
	 +X2LWDJX7fMkxceg+KibQbmdMmwOkjiyNAhaZlnxdhvdOr+dHzKHBhBj5q/CsZfYLW
	 oJTL0vG2WTKa8D4eU8irFBOj2sw6lax3N38YazkhaiVDwlq1niclY14M4hXSU0/Iis
	 q3rEMw5btvdyA==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: fix delayed inode count leak after failure to delete inode ref
Date: Mon, 16 Nov 2026 12:09:43 +0000
Message-ID: <44026acd9104694d8d08a19dc33a8b06aefc392f.1794829388.git.fdmanana@suse.com>
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

From: Filipe Manana <fdmanana@suse.com>

When updating a delayed inode, if we have an inode ref to delete (the flag
BTRFS_DELAYED_NODE_DEL_IREF is set) and we fail the deletion of the inode
ref item (if it's in another leaf), we abort the transaction and then
never release the delayed count for the inode ref deletion (by calling
btrfs_release_delayed_iref()), resulting in a permanent leak of the
delayed inode.

Fix this by jumping to the 'out' label instead and removing the now no
longer necessary 'err_out' label.

Fixes: 67de11769bd5 ("Btrfs: introduce the delayed inode ref deletion for the single link inode")
Link: https://sashiko.dev/#/bug/linux-3520c6eb-7928-477d-b369-9caff2b98d10
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/delayed-inode.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 333ce8b52489..295329d67b21 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1053,7 +1053,7 @@ static int __btrfs_update_delayed_inode(struct btrfs_trans_handle *trans,
 		ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
 		if (unlikely(ret < 0)) {
 			btrfs_abort_transaction(trans, ret);
-			goto err_out;
+			goto out;
 		}
 		ASSERT(ret > 0);
 		ASSERT(path->slots[0] > 0);
@@ -1081,7 +1081,6 @@ static int __btrfs_update_delayed_inode(struct btrfs_trans_handle *trans,
 out:
 	btrfs_release_delayed_iref(node);
 	btrfs_release_path(path);
-err_out:
 	btrfs_delayed_inode_release_metadata(fs_info, node, (ret < 0));
 	btrfs_release_delayed_inode(node);
 	return ret;
-- 
2.53.0

