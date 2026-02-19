Received: from mx1.orionsoft.ru (ip-210-182.nltel.ru [185.110.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56634347BC1;
	Thu, 19 Feb 2026 17:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.110.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771523744; cv=none; b=PKeduzdaY0VjYlQ75RPBkWm0/elwVIzbKJPH10QBnICHVEMluIlzg1gXW0MJCuslru+DLTWWXw1qwy0pbD6yfH68bRPxhRwLYj9sQvpl290yroKVNUZumL+ouAmv/kktAXLVzvTBIr46lfTkPrfrrV9D7Wj6uJFg5zyfv7ZfJrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771523744; c=relaxed/simple;
	bh=4CYpMHT7HToX4hDi4Xpf7Z9vRZ3HJm59yEiFSRpGcqU=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=NLGnf5V1O14R/YNeoRk7lFiea9/knR5yj+CmibGt0kIs/d8G6no97hoUxZyPRkFvVcjSKxdsoGyvpiSiCv3HLihVKmz06OLV7fCEnQqbi0jzNGdqbEUz06YYjMWb2W8kLPebyf53JMI/oAUYg9xFJudEgddgbtRuCg1IT+8Ocec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=orionsoft.ru; spf=pass smtp.mailfrom=orionsoft.ru; dkim=pass (2048-bit key) header.d=orionsoft.ru header.i=@orionsoft.ru header.b=nl6tLCoN; arc=none smtp.client-ip=185.110.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=orionsoft.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=orionsoft.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=orionsoft.ru header.i=@orionsoft.ru header.b="nl6tLCoN"
Received: by orionsoftpostfix.orionsoft.ru (Postfix, from userid 1001)
	id D9444A1A71; Thu, 19 Feb 2026 20:54:41 +0300 (MSK)
X-Spam-Level: 
X-Envelope-From: eburenchev@orionsoft.ru
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=orionsoft.ru; s=dkim;
	t=1771523681; bh=4CYpMHT7HToX4hDi4Xpf7Z9vRZ3HJm59yEiFSRpGcqU=;
	h=From:To:CC:Subject:Date:From;
	b=nl6tLCoNV/QmCbEHXlIrG28yOHtnKLkD1LAuB4okvye+kHHNLMxGvWjZ015md0Ale
	 hgl+xgDW19pL1PQIt5KDiEI6OInH/r8Fo7FvB9HVhjDMbs5g8fPldQgEkOlinK0fXF
	 wNLUZF1SY6dL6OAclkcqTMZHRUzWy9t/DQTlrsHcrTgr6EOPLNWPY3fGfjhoWjnTlc
	 Pjr3akSq0u2s/AgqU9Qfnf6SiXHJT602UFz2csLTUjc3qySXlE8dP6fbudIeDmta3C
	 Zvy+Z7zgepXzT5HODH26i/dbIFMgS6zDlv+7au8fqOQGerlZ7sNv3/jaF80AEWx9nD
	 P+kxcg+2mN/UA==
X-Envelope-From: eburenchev@orionsoft.ru
X-Envelope-From: eburenchev@orionsoft.ru
X-Envelope-From: eburenchev@orionsoft.ru
X-Envelope-From: eburenchev@orionsoft.ru
X-Envelope-From: eburenchev@orionsoft.ru
X-Envelope-From: eburenchev@orionsoft.ru
From: Burenchev Evgenii <EBurenchev@orionsoft.ru>
To: "clm@fb.com" <clm@fb.com>, "dsterba@suse.com" <dsterba@suse.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>,
	"mssola@mssola.com" <mssola@mssola.com>, "fdmanana@kernel.org"
	<fdmanana@kernel.org>
Subject: [PATCH] btrfs: perform a minor cleanup in btrfs_search_path_in_tree()
Thread-Topic: [PATCH] btrfs: perform a minor cleanup in
 btrfs_search_path_in_tree()
Thread-Index: AQHcocg4bkgjOW3Ar0KhpFkKCifPug==
Date: Thu, 19 Feb 2026 17:55:32 +0000
Message-ID: <5a31d815257543b689373583411428b0@orionsoft.ru>
Accept-Language: ru-RU, en-US
Content-Language: ru-RU
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="koi8-r"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-SEG-SpamProfiler-Score: -1

After the introduction of btrfs_search_backwards(), the directory
traversal state in btrfs_search_path_in_tree() is fully maintained via
struct btrfs_key. The local variable 'dirid' is no longer used to control
the search and the assignment

    dirid =3D key.objectid;

has no observable effect and is dead code.

Also initialize ret at declaration and remove a redundant
"ret =3D 0;" before out:.

Remove the unused assignment to avoid confusion and silence static
analysis warnings.

No functional change.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Evgenii Burenchev <eburenchev@orionsoft.ru>
---
 fs/btrfs/ioctl.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a6cc2d3b414c..d85e6a92538e 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1648,7 +1648,7 @@ static noinline int btrfs_search_path_in_tree(struct =
btrfs_fs_info *info,
 	struct btrfs_root *root;
 	struct btrfs_key key;
 	char *ptr;
-	int ret =3D -1;
+	int ret =3D 0;
 	int slot;
 	int len;
 	int total_len =3D 0;
@@ -1708,11 +1708,9 @@ static noinline int btrfs_search_path_in_tree(struct=
 btrfs_fs_info *info,
 		btrfs_release_path(path);
 		key.objectid =3D key.offset;
 		key.offset =3D (u64)-1;
-		dirid =3D key.objectid;
 	}
 	memmove(name, ptr, total_len);
 	name[total_len] =3D '\0';
-	ret =3D 0;
 out:
 	btrfs_put_root(root);
 	return ret;
--=20
2.43.0

