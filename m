Received: from mx1.orionsoft.ru (ip-210-182.nltel.ru [185.110.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC0C4396D16;
	Wed, 25 Feb 2026 12:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.110.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772023301; cv=none; b=uKB1eG3VuQBnsvdZJR0ldsZBd5Bd8R0RgeL45gnkoA4/l6bWb42Ta8nNpbZ7YnXdiWTnvy9dRFiUnToV7wq83eqo3bXMwMmpbFg5SO0aDZYzXNuvZtnYvuCiDvg1xu4/E60wVw/Ggu/oLNyqbd7/lKeSTSayQT4n+xoqXPhBixg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772023301; c=relaxed/simple;
	bh=cqiqzesL0RhSAQ05AnKle55wG/yFojuZHdxiu+PO32U=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Oj8oaPzxvETW15e8LJ8hwY1LX9ELEyDoI/CsnmZk2SjklbTQhuTE7MdghbDcCT7mLTn456FMMvfuRDC1DTVzkv/d2YgA4TxC3c0hK/ItjtLvYKacX6fVhoaHF/HwBARDwSG9PyYS9+H84vCw1LxEsfI08I4cMK6ukXAkGr3B3PQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=orionsoft.ru; spf=pass smtp.mailfrom=orionsoft.ru; dkim=pass (2048-bit key) header.d=orionsoft.ru header.i=@orionsoft.ru header.b=AjG5jWo8; arc=none smtp.client-ip=185.110.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=orionsoft.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=orionsoft.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=orionsoft.ru header.i=@orionsoft.ru header.b="AjG5jWo8"
Received: by orionsoftpostfix.orionsoft.ru (Postfix, from userid 1001)
	id B5371A1A43; Wed, 25 Feb 2026 15:40:41 +0300 (MSK)
X-Spam-Level: 
X-Envelope-From: eburenchev@orionsoft.ru
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=orionsoft.ru; s=dkim;
	t=1772023209; bh=cqiqzesL0RhSAQ05AnKle55wG/yFojuZHdxiu+PO32U=;
	h=From:To:CC:Subject:Date:From;
	b=AjG5jWo8TyEDYKRz/EtVsUDTsZSD3iuhVQVY+zhpaRiEO+tZIbJ+stdORL5XkvPkn
	 NEh5SMCN4Ph0DOamGTWsVwI9L6TktfohNB9Do05lQwr6TawALKXQpY9Pj2pgxAnv/s
	 h4+RvYHZB4QlDeFz2z/a4zZqy9JFIFYCH2pqO9nSABrpPuFSg+KgGhLdVP2CMdDccz
	 Gb0poKrJyZXGY9izYP17xAhQ23sdhX6+p1VBkUJ1w5potqoUUQn8hANG+b3N7eT3OU
	 Zhw0aCH1NxpLxZmSiCJHFvSVI3wBPn2Qge8lKXADuwrzpgbMlhGH/enBwNIAHbNEnD
	 Vb00fhO6i/zvg==
X-Envelope-From: eburenchev@orionsoft.ru
X-Envelope-From: eburenchev@orionsoft.ru
X-Envelope-From: eburenchev@orionsoft.ru
X-Envelope-From: eburenchev@orionsoft.ru
X-Envelope-From: eburenchev@orionsoft.ru
X-Envelope-From: eburenchev@orionsoft.ru
X-Envelope-From: eburenchev@orionsoft.ru
From: Burenchev Evgenii <EBurenchev@orionsoft.ru>
To: "dsterba@suse.cz" <dsterba@suse.cz>
CC: "clm@fb.com" <clm@fb.com>, "dsterba@suse.com" <dsterba@suse.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>,
	"mssola@mssola.com" <mssola@mssola.com>, "fdmanana@kernel.org"
	<fdmanana@kernel.org>
Subject: [PATCH v2 2/2] btrfs: initialize ret at declaration and remove
 redundant assignment
Thread-Topic: [PATCH v2 2/2] btrfs: initialize ret at declaration and remove
 redundant assignment
Thread-Index: AQHcplMJ0gWT8M3/x0i3iazTagDdoQ==
Date: Wed, 25 Feb 2026 12:41:05 +0000
Message-ID: <2ef0d6ce96e44f2ab92c5dacdff4f597@orionsoft.ru>
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


Related discussion: https://lore.kernel.org/linux-btrfs/20260224172835.GB26=
902@twin.jikos.cz

Initialize ret at declaration and remove a redundant
"ret =3D 0" before the out: label.

This matches the usual return value handling pattern used in
similar functions.

No functional change.

Changes since v1:
- split from original patch

Signed-off-by: Evgenii Burenchev <eburenchev@orionsoft.ru>
---
 fs/btrfs/ioctl.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 3a45ee1a7026..de59eacc33b4 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1647,7 +1647,7 @@ static noinline int btrfs_search_path_in_tree(struct =
btrfs_fs_info *info,
 	struct btrfs_root *root;
 	struct btrfs_key key;
 	char *ptr;
-	int ret =3D -1;
+	int ret =3D 0;
 	int slot;
 	int len;
 	int total_len =3D 0;
@@ -1710,7 +1710,6 @@ static noinline int btrfs_search_path_in_tree(struct =
btrfs_fs_info *info,
 	}
 	memmove(name, ptr, total_len);
 	name[total_len] =3D '\0';
-	ret =3D 0;
 out:
 	btrfs_put_root(root);
 	return ret;
--=20
2.43.0

