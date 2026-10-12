Received: from m16.mail.126.com (m16.mail.126.com [117.135.210.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BAB6341660;
	Mon, 12 Oct 2026 13:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791811829; cv=none; b=OWl1CiHaNV8RY9kLUhJv3w+SWRRNis2tUsHQZe4owtXEW/o61X1ZwjOzMSqnWZTURXjIf353xIOsx5rZhvh0bVO4rgHEzaPoOhCRIDoEXZwG3uv3VdAs4/K734Ko5517xuIqTbP1LTXH6Cgoz1voKoEIGDficvO2EU+NGCo2l8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791811829; c=relaxed/simple;
	bh=aQ78LASre3qEtPEbfr/6lC0V7PapA/7OxhZILTzCjh4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=m/GkGJJ/t66NKHeY5GoNBehvf9JYgUqWMWokOqgwFjq9oRgsYYLIe7nPtQUOA+sbbjrmwyoK3cFkMYQQbeMwoRL5OUD49MjNtps35JHzYcbKmn1jQOaw/MDf7lSZNC258Yae0S6Xy23wQMwB2u2SjOFWnmO7bVKtUSAbuc1USOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com; spf=pass smtp.mailfrom=126.com; dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b=iqJzfP7F; arc=none smtp.client-ip=117.135.210.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=126.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b="iqJzfP7F"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=Ml
	jY9Xj+ICsCrZJc82UVVbDGowGvkttY2gUdd6dYbmU=; b=iqJzfP7FnIN5ZPqi9T
	yZ+x2vvXbkX+48uEvOY1IWM4wiH+uMguanF5U0c6zUohmxhkOw9n49vUmlgvEMYC
	o9aBGlk5RBp2TIzC5TdkDzDAG4O4pY0TJhuJJISlZHKdaclm059mpH23WjAxXonp
	DmhxEgF7eb9lPo9aSGdaC/vJw=
Received: from song-MS-7E28.. (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wD3n7am4MxqMdzZBA--.33230S2;
	Mon, 12 Oct 2026 21:29:12 +0800 (CST)
From: Song Chen <chensong_2000@126.com>
To: dsterba@suse.com,
	mason@kernel.org,
	akinobu.mita@gmail.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	arnd@arndb.de,
	akpm@linux-foundation.org,
	ees@kernel.org
Cc: linux-doc@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Song Chen <chensong_2000@126.com>
Subject: [PATCH v3 0/2] btrfs: add error injection support for checksum verification
Date: Tue, 13 Oct 2026 05:29:08 +0800
Message-ID: <20261012212910.54623-1-chensong_2000@126.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3n7am4MxqMdzZBA--.33230S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7CF1xWr1UWw47tryUKF4Durg_yoW8Xr4rpF
	40k3sxuryFvFy8JrWxCayxC34Fvws8Xa15GF1DGw18u3yjvFyv9Fsak34rZ3W5KrWkAa48
	X3ZagF4vyr15AFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07bbxhJUUUUU=
X-CM-SenderInfo: xfkh02prqjsjqqqqqiyswou0bp/xtbBpAgwr2rM4KitKQAA3Z

This patchset adds fault injection support for btrfs_data_csum_ok,
enabling controlled simulation of checksum mismatches to test btrfs
silent data corruption detection and reporting paths.

The first patch extends the error injection framework with a new type,
EI_ETYPE_FALSE, which allows bool-returning functions to be overridden
with a false return value directly.

The second patch marks btrfs_data_csum_ok with ALLOW_ERROR_INJECTION
using this new type.


Song Chen (2):
  error-injection: Introduce EI_ETYPE_FALSE for fail_function
  btrfs: Allow error injection on btrfs_data_csum_ok

 Documentation/fault-injection/fault-injection.rst | 3 +++
 fs/btrfs/inode.c                                  | 1 +
 include/asm-generic/error-injection.h             | 1 +
 kernel/fail_function.c                            | 2 ++
 lib/error-inject.c                                | 2 ++
 5 files changed, 9 insertions(+)

---
changelog:
v1 --- v2:
Add a parent field to struct fei_attr.

v2 --- v3
1, Withdraw adding parent field in fet_attr in v2.
2, Update commit message of second patch regarding sashiko-bot's
   suggestion in [1].
3, Add EI_ETYPE_FALSE in error_type_string regarding sashiko-bot's
   suggestion in [2].
4, Add EI_ETYPE_FALSE in Documentation/fault-injection/fault-injection.rst
   regarding sashiko-bot's suggestion in [2].

[1] https://lore.kernel.org/all/20260724022150.D2D811F000E9@smtp.kernel.org/
[2] https://lore.kernel.org/all/20260724022044.F31F11F000E9@smtp.kernel.org/
-- 
2.43.0

