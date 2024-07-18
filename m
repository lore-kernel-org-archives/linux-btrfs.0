Received: from smtp.gentoo.org (woodpecker.gentoo.org [140.211.166.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C67548F7
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Jul 2024 21:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=140.211.166.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721339686; cv=none; b=uKjDbq4hz/wVfHIL4mWg2cDxb7sWWJb7BMBJLsEFEdkm49N6Fk9k0Pv5ZD0qejpRqIEXphMSzSTRJFguQc2lT/s7BfE6bvvBA/+RkeSpLNzuZuRpEFHHh0lnnVeQ7d0pl9G5a9cIMUup9rVN2knBtgYUIsbKft8s8spk9j/CD88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721339686; c=relaxed/simple;
	bh=ICzQj1vPo0nnP1zJXurkm9+urF3LtR00tfBKeo6BM/c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Nu9SWLQDYJ+qU/5pBBDuywrquyiHROb/l6FaMg0AeUCoQFMtvTtDY+ovXcu9i7FCNzp+0wR8BnliAZhvJmsUBEfGxmbYlK98jqr3hIOhlCXCCck85VSPbWp5cQph68cC9x0oLuuu+lfmYKx2CgEO9ftZpC5XtBMQr+APPvqjj4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org; spf=pass smtp.mailfrom=gentoo.org; arc=none smtp.client-ip=140.211.166.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentoo.org
From: Sam James <sam@gentoo.org>
To: linux-btrfs@vger.kernel.org
Cc: Alejandro Colomar <alx@kernel.org>
Subject: Build failure with trunk GCC 15 in fs/btrfs/print-tree.c
 (-Wunterminated-string-initialization)
Organization: Gentoo
Date: Thu, 18 Jul 2024 22:54:40 +0100
Message-ID: <87ttgmz7q7.fsf@gentoo.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

GCC 15 introduces a new warning -Wunterminated-string-initialization
which causes, with the kernel's -Werror=3D..., the following:
```
/var/tmp/portage/sys-kernel/gentoo-kernel-6.6.41/work/linux-6.6/fs/btrfs/pr=
int-tree.c:29:49: error: initializer-string for array of =E2=80=98char=E2=
=80=99 is too long [-Werror=3Dunterminated-string-initialization]
   29 |         { BTRFS_BLOCK_GROUP_TREE_OBJECTID,      "BLOCK_GROUP_TREE" =
     },
      |
      ^~~~~~~~~~~~~~~~~~
```

It was introduced in https://gcc.gnu.org/PR115185. I don't have time
today to check the case to see what the best fix is, but CCing Alex who
wrote the warning implementation in case he has a chance.

thanks,
sam
