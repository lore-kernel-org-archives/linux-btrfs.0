Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=82.195.75.108
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793978792;
	b=NyGvJtPtPr+SInof1CUYYixasWUdoFHLfC2wUwXr2ltKm9hDzK+6of3Ae3i3lsS2hiVS
	 8l7XE8BBQPNazam3VIuEoXygbnOpC1CgnVb8Ojk6FOlKxrBCYX3QYA+jiCvyX0bNl4ylD
	 9hU3wgcyTUBakeAnCiXEyUnfjOZ4NumbrhXugBixnTpFuRMc+7WIfCg42n3vP4yHKwdx4
	 v1Hyt8CrSZbZK77liIO7AOrXyr+NAizEUHwkoC6vBjbhrCaeRlnlTzxXIsHnaKu9LoteS
	 gJGVoHiE1LKCyY3pmewLP6R/hHIZy5VDtEwOQ+nPXgbE995TS0N2tKJXy2xQhHp91NA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793978792;
	h=DMARC-Filter:DKIM-Signature:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Debian-User;
	bh=rNsjOe/KrdZQe41KIXUEyhhURKL3GfhHxPSvPzNZxKQ=;
	b=OEQyX5Zk2t/ohPyQwfvJ7zdclAwywvfQgY5HsE4KIsNOc2/v+jB5dDGu4mmVcTJ/vUF8
	 sC6dhjHlXPgeIoP0nSfvXjsT03TE+/HfP7qTRTBHBOnOAEL+JoIOQs9//iOGI+JCpnP9g
	 v5dUjtVx68YMwtzEwMaW4ce14N1BXrrSoHH9nqSLwWDSYvknRUAfSVZ0MVAusPahHdJLF
	 yJAUAk73D8vroD5561xf+WL6lQ5zD2Qai4FNU3XxkWHt9u3WmyhFunIvKJ3EdH4feSYJS
	 njuyPMo9AA2m9lT+hQir/6aFg3MDON0J3Ouha7MdUPz5B7WoSddEei431nrb/zqhNTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=debian.org;
	spf=pass smtp.mailfrom=debian.org;
	dkim=pass header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=Gj7PAGTw;
	arc=none smtp.remote-ip=82.195.75.108
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA742606A329;
	Fri,  6 Nov 2026 15:26:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CA742606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=Gj7PAGTw
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-Id:Date:Subject:From:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=rNsjOe/KrdZQe41KIXUEyhhURKL3GfhHxPSvPzNZxKQ=; b=Gj7PAGTwWipMZIwpuADrjXicYp
	7SwBXt0rQdA3cTZhg7JT8rKOck3HwhpI2RLYPOi9VAXrgc1+xhR1OH/3a5OBUXkTzm8Ik8RFqMjNw
	RyhcA/SX4gF42plz6sisWDGcx0T+qM7dzrOU+YDJDNhzhWscMGxNGObYQ1aaDMCsUGi4VxvdCvS3G
	x/22epGGkS7xXAxw/6sxAF7Ccsi+dp82too3C4HdA21zXUMSgOY5rz8zZeioq0IOzQyj/Gh/SO1yO
	NYLG7SsZNLRi1VN4VrAS9hRJDMtsuXMFh1SnEntqZuldhL0GhAEEaDNbYvQhmZ0s73oia5UTpLwsQ
	9vhW27tw==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xPLph-009NUF-2U;
	Fri, 06 Nov 2026 15:26:26 +0000
From: Breno Leitao <leitao@debian.org>
Subject: [PATCH v2 0/2] btrfs: drain in-flight direct IO before direct
 writes dirty the page cache
Date: Fri, 06 Nov 2026 07:21:09 -0800
Message-Id: <20261106-btrfs_page_cache-v2-0-f57575d0071d@debian.org>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAGrw7WoC/x3NsQ6CMBRA0V9p3lxMWxVDJ0d33QwhbX20L7GAL
 RII4d+NrHc4d4WMiTCDZisknChT34FmijNwwXQeC3qBZqCEKqUUZWHH1OZmMB4bZ1zAQhkrpTh
 VrpJH4AyGhC3NO/msOYNAeezTsh8m+a9gvvN0eXgx3z/n5Rbt1UdD74PrI9Tbtv0AvS61lZUAA
 AA=
X-Change-ID: 20261106-btrfs_page_cache-2ab11049c913
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>
Cc: Qu Wenruo <wqu@suse.com>, Filipe Manana <fdmanana@kernel.org>, 
 Boris Burkov <boris@bur.io>, Atish Patra <atish.patra@linux.dev>, 
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, Breno Leitao <leitao@debian.org>, 
 kernel-team@meta.com, stable@vger.kernel.org, 
 Qu Wenruo <quwenruo.btrfs@gmx.com>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=2514; i=leitao@debian.org;
 h=from:subject:message-id; bh=G5bu8pZByj7CV8JE5MV2SiAOm5Ks6FKz3MWBRljfLPk=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBq7fGdi4cemJ1mys8+l1vMEGG0dq/FWrzN9X9Qz
 6q6a3i8ccqJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCau3xnQAKCRA1o5Of/Hh3
 bQDmD/4mZeWhaDDZg4t5RPL5nylUSfKRfiOMsY/cLFg3HeFWmOgLoPFLw5/t+vf5JQzZT5SsNmr
 JdUySBrzqABuxRA1UoHyVXqozN+IZS4P0g1Sd9m7CkhdgJg/jhfwfirWkHoTiSK4vWugTwzUZ+A
 55qUam9oUSWQU4Wd+0kezWcsfr7ljCUzQZZhcQ5A2J0zmFD+UwLYuOKjSHzLeFuayCfqTKlptXC
 YH+ri8iQ97W1mF3zVR3XVTekurQD6RYzn5WAIlLnj+6yXhySbVIU2Udh5a59JQMFPj8C60L64wz
 /MqEwFPDw+rihIRXDK4yHFa7Ur6pNczkUT3uXbX1cGUGWuWJ0CU5l1aD+hiSGwd2aNtMcOpjxIp
 g+HN+1s/tbX3w6FYhQ2+mdncLIb0FJ93nt+gVENgwowsES9rxE5UaKevNbFWlsuYjFVrnG71l61
 r081vOfe0yM5H8JE/jcb5+zAPCCwEPmNhBTgoGxhfii2Ap1VCoBAjQ+EnmUCkT1d7P9JlfDwjX2
 3XmeYBsuiQRFm49oC38zrqJroT2EwSryV5FklYuueOAajAD4bRIBEdF9d5lnIZza4gCDrtEw7z/
 pyo6opIEubTVz4IoFZ7Lt/hw9LNT0poDQ/HqOWvWjwyJYUnWHvoy/nDj4UTAykIU06UZ4QU5DRk
 uCyKWdG6aZqgHUQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao

Atish reported that arm64 hosts with 64K pages and 4K btrfs blocks,
which keep VM disk images as NOCOW files opened with O_DIRECT, log

  Page cache invalidation failure on direct I/O.  Possible data corruption due to collision with buffered I/O!

and the next fsync() on the image fails with -EIO. Every write the VM
issues is O_DIRECT, the buffered writes come from btrfs itself.

Both patches close the same race: a direct write dirties a folio while
another task's direct write to a different block of that folio is in
flight, and the completion of the latter fails to invalidate it.

Patch 1 waits before the buffered fallback for unaligned writes. Patch 2
waits before btrfs_write_check() zeroes the block at an unaligned EOF,
which btrfs_direct_write() does before it decides to fall back.

Tested on a 64K page arm64 kernel, on a NOCOW file of a 4K block btrfs.
Async 4K O_DIRECT writes race 512 byte O_DIRECT writes inside EOF
(fallback), and O_DIRECT writes past an unaligned EOF, of 4K (eof-dio)
and of 512 bytes, which fall back (eof-fb). fdatasync() EIOs in 20
seconds per test:

              base   patch 1   patch 1+2
  fallback       6         0           0
  eof-dio       24        20           0
  eof-fb        34        14           0

60 second runs got 56 and 38 EIOs in the eof tests with patch 1, and
none in any test with both patches, in two runs. The reproducer for
patch 1 is at [1].

[1] https://github.com/leitao/btrfs-dio-fallback

Signed-off-by: Breno Leitao <leitao@debian.org>
---
Changes in v2:
- New patch 2: drain in-flight direct IO before btrfs_write_check()
  zeroes the block at an unaligned EOF (Qu, from a Sashiko review).
- Patch 1: no code change. Picked up Boris' Reviewed-by, and added a
  stable Cc.
- Both patches: the Fixes: tags now name 95ea0486b20e, which first
  allowed writes with more than one block per folio, 4K blocks on 64K
  pages.
- Link to v1: https://lore.kernel.org/all/auxv7Tg0xSq5yHmb@gmail.com/

---
Breno Leitao (2):
      btrfs: drain in-flight direct IO before buffered write fallback
      btrfs: drain in-flight direct IO before zeroing an unaligned EOF block

 fs/btrfs/file.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)
---
base-commit: ddfe51b0a0f5dc9e415cc2c8ad8db17532dd426b
base-tree: git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
change-id: 20261106-btrfs_page_cache-2ab11049c913

Best regards,
--  
Breno Leitao <leitao@debian.org>

