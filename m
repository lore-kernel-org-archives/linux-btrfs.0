Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78B203D75C1
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Jun 2026 12:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781266444; cv=none; b=h6vWxcxTA2n44hIZpkGN5GaTd6HfKrrvrwAO4vrNuaMBvo6oebyB5rcwrT8g21ZnzbMKpEtcVSMMxqSr74Q5JOXcpC7nAnINmnlLzpive5itGyM5mdrhN2ncBGYW9rpOeLw2292HteWFlPKmyOPC0PAm/XDOY9TA3uQHlFszDPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781266444; c=relaxed/simple;
	bh=f5n3SEumxtvv/li02yC9+ZqoIHS6JBUakq9EJQYUjmQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uHnE90/BlBZFy2XqeGqc7S762aqVXsDivvKHir+R7442OSIj2081uNBZncavnM7mreFU7kK8XZx4AGSLLKcfS2ibJJ5rwpcvoee+gqthQ2ziBsdP/pUxDztGRhuVjZ3FssHvgQWU8YTnow4o2t0R2qxOBK2DoHonDGOzEO1w4GE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Px7diUTB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Px7diUTB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC7BA1F000E9
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Jun 2026 12:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781266443;
	bh=IvYl3aOt6AnyNh7u+aLjKW5W+3BVsmSoZ1czbqArBko=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=Px7diUTB+nnMN5zV8jMba/it7Ht7nBqZV8oOotxg5IrpLlIDK7WL20wACbzbotUGW
	 RGbef6+alz1FXTGLXxtPlOr0+X/+TfOvMpw1GzRD71T91MDUCCEEFH2ASbbYFkmA/c
	 YoDim/ghoPyvszsAk1KqST2LW40tehhOf/n4qTCU1fSYMH0VDbOxyJ4W23fz2X/Hc+
	 3Ugc38g9cojSa5YKNEG5VFPVtLYrB/Tt1yIIoOyQNpYxFoZ8ySYmHWydYYA5Esyld+
	 qRmsheti+P5gas8aCWHWAqDXQBEdOTMhGKQRnQ5tXBVqQSbWbGkJEmadF4uuItvxwm
	 ayh8ewDWe3Q7Q==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs: fix memory barrier order in reloc_root_is_dead()
Date: Fri, 12 Jun 2026 13:13:57 +0100
Message-ID: <62602395bf1488aa81645ea59e22405d6c06d3f7.1781263239.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1781263239.git.fdmanana@suse.com>
References: <cover.1781263239.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

When we set a root's reloc_root to NULL, we do it like this:

   static void clear_reloc_root(struct btrfs_root *root)
   {
       root->reloc_root = NULL;
       /*
        * Need barrier to ensure clear_bit() only happens after
        * root->reloc_root = NULL. Pairs with have_reloc_root().
        */
        smp_wmb();
        clear_bit(BTRFS_ROOT_DEAD_RELOC_TREE, &root->state);
   }

So that a NULL reloc_root is always seen before seeing that the bit
BTRFS_ROOT_DEAD_RELOC_TREE was cleared.

But on the read side we have:

   static bool reloc_root_is_dead(const struct btrfs_root *root)
   {
        smp_rmb();
        if (test_bit(BTRFS_ROOT_DEAD_RELOC_TREE, &root->state))
            return true;
        return false;
   }

And then callers of reloc_root_is_dead() access root->reloc_root.

Because the read memory barrier is placed before testing the bit, the CPU
is completely free to speculatively reorder those two loads. It can read
root->reloc_root before it actually checks the dead tree bit.

Sashiko reported this as an existing problem in another patch review, see
the link in the Link tag below.

Fix this by moving the read memory barrier to happen after testing the bit
and update the comment to reflect current reality.

Link: https://sashiko.dev/#/patchset/cf84f1a217c719e25b6b69e4298dd7afd36c9427.1781194426.git.fdmanana%40suse.com
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/relocation.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 6b5a59cb21bb..00993505c9c3 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -339,14 +339,15 @@ static struct btrfs_backref_node *walk_down_backref(
 
 static bool reloc_root_is_dead(const struct btrfs_root *root)
 {
+	if (test_bit(BTRFS_ROOT_DEAD_RELOC_TREE, &root->state))
+		return true;
 	/*
-	 * Pair with set_bit/clear_bit in clean_dirty_subvols and
-	 * btrfs_update_reloc_root. We need to see the updated bit before
-	 * trying to access reloc_root
+	 * Pairs with set_bit/clear_bit in clear_reloc_root() and
+	 * btrfs_update_reloc_root(). We need to see the updated bit before
+	 * trying to access root->reloc_root in our callers.
 	 */
 	smp_rmb();
-	if (test_bit(BTRFS_ROOT_DEAD_RELOC_TREE, &root->state))
-		return true;
+
 	return false;
 }
 
-- 
2.47.2

