Received: from out203-205-221-210.mail.qq.com (out203-205-221-210.mail.qq.com [203.205.221.210])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA10E7478;
	Sun, 12 Jul 2026 03:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.210
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783826275; cv=none; b=ApimkiicrnUgp1rYm+fByZP+by1QmWa6xdL4k9Ngr15Kg2NDDWeeUhFzc2g/AkDklQtvhjkSpp/GJrijEcKO5PvgZ3t0Q9AmFaixNYMcJz6I70iV52o4v7COyPeQeoIDbLN9W+ebFHz66LVL9Jhjxj28Zobay1QkQDYWG9uM7bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783826275; c=relaxed/simple;
	bh=tW3LrhxpvkYaxfBk7LB1LK1YgLjEyNDzr6CXNckSnmE=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=BQo8lBBfpvLC40b40E9peemuHTelPKiyoxsGZTlsomZGkTcS+H2IQXebTePV4//5gfi9KbS9Zokd7/YXDIrmCht6ny8sW+yeOKcx4AhwB/mSQrBgY1r4eBhOqs0zUFUmmIcKj6TCwT1DvEfmHH0nSP5BARFNtD8qGCYhZ8wcLXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=jxvYxpNr; arc=none smtp.client-ip=203.205.221.210
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="jxvYxpNr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1783826264; bh=keaGbqQUWrQv6yJ4G371G5+fnEtJrhavL5LB5rAKcPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jxvYxpNr9dW02GjJDbjHVAdDp3ElncpDbN+wrYPjQlKLOuwP7OWFaH/JdBMpz9JCj
	 kTmYB43XmNyq5fyxqI6XvymkStD3JAGginHDSNVBB/1GUjJJnbW+NBaj4y4pF0rKha
	 L9ux44/S+na+NEuoedO0EGq4G/Nz+YvsKGReHQWQ=
Received: from ubuntu.. ([218.196.207.7])
	by newxmesmtplogicsvrszc56-0.qq.com (NewEsmtp) with SMTP
	id 46A13441; Sun, 12 Jul 2026 11:17:42 +0800
X-QQ-mid: xmsmtpt1783826262t5p6z940u
Message-ID: <tencent_9F36B70488B79803AA2A9E02C52C4FC41007@qq.com>
X-QQ-XMAILINFO: MxdSvGmuhzbKh5OFHbV26xXRTr06j6uUic3n5pukRDQNYrks8J27yHtb0me08N
	 LuumBA3O60+HqrieouHGo0SnozNnE58U30ssZeS9oTgam9yvHwnkr5sfgTc53s3Yj+QWNkJvIN9s
	 TwiqatI3UhorE26BXqdnQAGE3tVDsw82BMOsD5M3ITTyHBZjtY5ZhpzjBY+3Giu19EukqYiV+w9u
	 cKmjkwDN/V5WwI8Dg3dPldSftf+o9ImUe/5LfZQ4ZshX/dmnyuKXCfuDoI08Et6GkIbs/nc72VcK
	 8Bkh5el358JRWhvx+FO0zGzXQYzRu4KWtEe9M1QmdKjSQz4pQjFsVUHW2tKVKlhU0eRxrZRgzlYt
	 SzAtVh0QuVOzxQZKxr8ghwqrk2OtGAItshiqShNfDtix8sG614cXqYgAQBXmwIT/Dw3l8saEhgEZ
	 Gntjfq4821r/8bx8sUIsg3aR65TsEE8sqBuGAY+9RltudddhM+C80ueumOKNwdOeblw6YOE/LHTh
	 N+72K2RlQQ10yXwv97TOAC6PDDr3+oeozJBkYZ0fkHVJzfzZDnqiBLfxPfnDr6CxMCgyLvcgRN3k
	 MrT/xgGLhE5kJebghLneDqhskNyDNL3duEcNqJesIchSGQkZO0Qq+63P0UP0Cq8jqJ+wGsIlgW44
	 1KpWhmQk7esPtVBiY7dHRbyeoDJ5SMazTT+UXC8SGCTb//bstHshU48U3K5CTdli+gh3I+qpFKOY
	 0ZWiGKmsG6JYhn7sZk+ay/okza2J5HRr9k3YLRCGoTz7OvNNaKrWhpsy+PPCTUj/NJedcrSzAns3
	 gzPIRtvEm11CppJKiyfsygKMXa6gniy4Cl8hKUuqmxUPf+uRcHmDGc4Jg0vLSfNkxhAAwupidZZf
	 +1fGYiOw2jFS2R9pS6JiR1VfF2iK/lhuYzCt4vL2ksX+9f8xhTSfEf2HuQYqcWLDEzGKbeTAD/0W
	 7RkapUop49cFuRxlUCPwzbDhLwnC2+9U4vKgP4JgfdrEOe7+VT2SQEaF3ce6VIS4pWHHSIsPIggh
	 /3TFJN5zbJM5fj7lz9HQW7tQqiT7IVZ9e9FhmXEKY9aomTu7Gq/ntxnVrBLRZBY67gAclNBel0XN
	 +ws6ITs/yEG96nvC0=
X-QQ-XMRINFO: MPJ6Tf5t3I/ylTmHUqvI8+Wpn+Gzalws3A==
From: Guanghui Yang <3497809730@qq.com>
To: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>
Cc: Qu Wenruo <wqu@suse.com>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Guanghui Yang <3497809730@qq.com>
Subject: [PATCH v2] btrfs: free mapping node on duplicate reloc root insert
Date: Sun, 12 Jul 2026 03:17:28 +0000
X-OQ-MSGID: <20260712031728.1699856-1-3497809730@qq.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <tencent_39D68A519E8921206E77105E313354703C08@qq.com>
References: <tencent_39D68A519E8921206E77105E313354703C08@qq.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__add_reloc_root() allocates a mapping_node before inserting it into
rc->reloc_root_tree.  If rb_simple_insert() finds an existing entry, it
returns the existing rb_node and leaves the newly allocated node unlinked.

The error path then returns -EEXIST without freeing the new node.  Since
the node was never inserted into reloc_root_tree, the later cleanup in
put_reloc_control() cannot find it either.

Free the newly allocated node before returning -EEXIST.

The callers currently assert that -EEXIST should not happen, so this is a
defensive cleanup for an unexpected duplicate insert path.  If the path is
ever reached, the local allocation should still be released.

Fixes: 57a304cfd43b ("btrfs: do not panic in __add_reloc_root")
Signed-off-by: Guanghui Yang <3497809730@qq.com>
---
Changes in v2:
- Add Fixes tag as requested by Qu Wenruo.

 fs/btrfs/relocation.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index fb85bc8b345c..7e451e587726 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -588,6 +588,7 @@ static int __add_reloc_root(struct btrfs_root *root, struct reloc_control *rc)
 		btrfs_err(fs_info,
 			    "Duplicate root found for start=%llu while inserting into relocation tree",
 			    node->bytenr);
+		kfree(node);
 		return -EEXIST;
 	}
 
-- 
2.34.1

