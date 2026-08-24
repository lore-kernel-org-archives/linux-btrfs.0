Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6685411FAD;
	Mon, 24 Aug 2026 11:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787572512; cv=none; b=K7ouBR3vj3o7JU277QWLLFdjxi5AJM7LmP/2XqhX47VPzB6UrJFbMor45BtISwSTWFe3lE9N6yLJniQgqre9NrCHIlT5w2CwnA4xzE0vPIL7XAgrLrxkafqSdXVOaWxVW7fNbfgilL5p/tORyy4bc8gdphKyZLyG8qEsoxkYyxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787572512; c=relaxed/simple;
	bh=h6Rs3GAdmEO+2K8AlUCoCja+QDytr+hATsV6MLe8NfU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=qL0pGPQKe193c/7EpsdqR9sj6hn3GpF8Cf9D+VpKAmRS5XW5boTl1s8odHdh4DC+Vf0p15vEWuoSxyzMdMfGheMhqY0SpopC/LCF3Q8S+D6unZy6EHicI1gv8OZJLTT0jpMLfxZQ9FTCmc/1BZKAKGvnu9+rUabXJ0Ccg7xqi94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=OZxoAakY; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="OZxoAakY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:
	Reply-To:Content-ID:Content-Description:In-Reply-To:References;
	bh=mLD3c8hZnQhdE+utd512nbtRwqzHUud/pp5VcxhSBV4=; b=OZxoAakYGdGPcBrsBKPogyjA/t
	/dScFPPI/CurKDX3a4FH7TbKQgfJIfsrCnDa+HZwHQ4p63lsn1o+LUrs2r/GcBE1qd/eqF5MU/nN7
	tiYGG7ceyy+5DEbvE3KO3XHyqoooeWuVvuSadBgcP3vO3wjabsV9BqMJVR9yTv9QLd1rRYTbdxipc
	SB5TSwQDPIPHyXpn0BNcD5eIlt3em4DBt5KH8G7/atY1JoLza174z1IF+LVniEa1jU2yc2hxxc3cw
	T8KHWOEVryBsHqNSXtjdMnkeDKDeoPZn2GvK5L9P0drhVIali65eQAORQZ7Zu0gNGwemuv7L0vjgp
	CbJ84vbA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wyTGU-00De3f-0c;
	Mon, 24 Aug 2026 11:54:58 +0000
From: Breno Leitao <leitao@debian.org>
Date: Mon, 24 Aug 2026 04:54:45 -0700
Subject: [PATCH v2] btrfs: skip the extent map tree lock for inodes without
 extent maps
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260824-b4-btrfs-em-shrinker-v2-1-a6fc80447e70@debian.org>
X-B4-Tracking: v=1; b=H4sIAAQxjGoC/22NQQ6CMBBFr2Jm7Zi2CDSuvIdhQekURmMxUyQaw
 t0FjDuXL/n/vQkSCVOC024CoZET93EBs99B09WxJWS/MBhlCmWNQndEN0hISHdMnXC8kWCZWeP
 LoLxXOSzXh1Dg16a9VF9OT3elZlhd66LjNPTy3rqjXne/hP6fGDVqNLYIWXA6t2V29uS4jodeW
 qjmef4A2BMQT8sAAAA=
X-Change-ID: 20260820-b4-btrfs-em-shrinker-7382d7f0dd05
To: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
 fdmanana@suse.com
Cc: boris@bur.io, wqu@suse.com, layton@kernel.org, 
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 kernel-team@meta.com, Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.15-dev-47773
X-Developer-Signature: v=1; a=openpgp-sha256; l=3310; i=leitao@debian.org;
 h=from:subject:message-id; bh=h6Rs3GAdmEO+2K8AlUCoCja+QDytr+hATsV6MLe8NfU=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqjDEPKOlB/Xkch099rg/KrScB+85kkcSszMlNu
 705tmFnf3WJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaowxDwAKCRA1o5Of/Hh3
 bWA+D/9Fpj+rO7+oCGgsYTK1J8RVqIg9008UY7sstljAftPmLUAvnxHoaFUb5nR20Tga08OnvBE
 tKAjtIFkfwbkg5JMLsyNGLdywPCqwDm1BVIHsgy5z7tcz3KWDYzuRBinNv2LrnL5yR7JaS8NanS
 iOhdbQBgJ887y6S/b7ZSuV9+OwrkiKEI8c3PZoTE18T9w+SC/DWcCgsQIghD5k1fWeBOqZeZMi1
 kHJyMExyMW+uzszDPUlK4YQ+/RpXt9EOdBd8AOxKwofYPNBH+Y9RooCHtTSRI3+XtdsqIpYvQwF
 0lq+OBAUN2Zvqntlz2Ll/7XuJNuw1dW/ZW5FXYs5nW7QiKUdNOvphXjU3LI5L+3rnlqhRmSg/gd
 6MNxphM33vkuQ82f6XIjgGwyuSkCc8p9THRlOQjU3oz+Vv/I8xAe3voxYyH1tIFX1wLPG8lMraJ
 nDFKmPIZBIPVVg1LU2fX0JePK7dXM76v+12CZc8yGEIlvmUdxXRcMhBfroa/Vt/HAliYJOp44ei
 T4uQNoqqfe4MwDdaaZkdDNYXqK9kwIuGyvNW60npCeeWgi77lqeNCIr26iV1/5l8sHe6gLgSfPS
 wlOkz6xFJhyLuEtImY7G8sVjfdEnX7ZORn9PeGeiVlQRMsVrX4ZizlvQaU6dHNAyug4LDw/aS0H
 Y8WTbvRcc+EoQ9w==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao

find_first_inode_to_shrink() takes inode->extent_tree.lock in write mode
on every inode it walks, only to find out whether that inode has any
extent maps. Most inodes have none, so the lock is taken and dropped
again without any work being done.

Check whether the tree is empty before taking the lock. tree->root is
only modified with the tree lock held for write, so the unlocked read is
a harmless race: a false empty just defers the inode to a later scan,
which already happens whenever the write_trylock() below fails, and a
false non-empty falls through to the existing check under the lock.

Across the Meta production fleet the extent map shrinker is ~0.35% of
non-idle kernel CPU. Attributing callees to their caller,
find_first_inode_to_shrink() is ~65% of that, and the write_trylock() it
does is ~30% of the whole shrinker.

Micro benchmark: a 6 GiB btrfs on a loop device, 100000 empty files kept
open, plus 200 1 MiB files created last so they get the highest inode
numbers and every scan has to walk all the empty ones first. Each round
drops the page cache, re-reads the data files to recreate the extent
maps, then triggers the shrinker with "echo 2 > /proc/sys/vm/drop_caches".
15 rounds per run on arm64 (Neoverse V2), 8 CPUs, no lock debugging.
Cost of find_first_inode_to_shrink() from the ftrace function profiler,
in ns per inode walked, median of runs:

                          base   patched    delta
    idle                  46.4      40.1   -13.6%
    4 concurrent readers  47.8      38.4   -19.7%

A separate build with CONFIG_LOCK_STAT, same test, for the extent map
tree rwlock. The shrinker is not the only user of that lock, every
extent map insert and lookup takes it too, which is why the acquisition
count drops by two thirds rather than to nothing:

                              base   patched    delta
    write acquisitions      628016    228000   -63.7%
    hold time total (us)     47512     22717   -52.2%
    acq cacheline bounces     1574      1288   -18.2%

Signed-off-by: Breno Leitao <leitao@debian.org>
---
Changes in v2:
- Better justification for the patch.
- Mark this unlocked read as racy
- use the proper RB_EMPTY_ROOT() primitive
- Link to v1: https://patch.msgid.link/20260821-b4-btrfs-em-shrinker-v1-1-286f3fb15873@debian.org
---
 fs/btrfs/extent_map.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 6ad7b39ae358b..86d9c6f5ff4bd 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -1219,6 +1219,14 @@ static struct btrfs_inode *find_first_inode_to_shrink(struct btrfs_root *root,
 
 		tree = &inode->extent_tree;
 
+		/*
+		 * Most inodes have no extent maps, so check without the lock.
+		 * The race is harmless: a false empty just defers the inode to
+		 * a later scan, and a false non-empty is caught under the lock.
+		 */
+		if (data_race(RB_EMPTY_ROOT(&tree->root)))
+			goto next;
+
 		/*
 		 * We want to be fast so if the lock is busy we don't want to
 		 * spend time waiting for it (some task is about to do IO for

---
base-commit: 6a746cd265aed59107ebdaa9ce039bb832922969
change-id: 20260820-b4-btrfs-em-shrinker-7382d7f0dd05

Best regards,
--  
Breno Leitao <leitao@debian.org>

