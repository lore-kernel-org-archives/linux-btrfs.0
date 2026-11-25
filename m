Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.23
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621520;
	b=G5GOKfqiBczvMxZmGyR7RpE5L0kCAhptbcZH63HNOLtpzUDLn12TN/8eGPyBMyduVuBz
	 1Q7tsJjQ3WNdVY0TfUUw3CW8MmZDnFdUGiQSnGiFxzsO5UDU7DOH4Y2+Cq+7WW1L8JVUC
	 +Nq5l/siS5xanUlOx6BnqUNHvIlW0aAX1vy59NA8ukHitLZ1I+npqX6sgJapQaYv4Efwe
	 bLpjThJxZ3UiESajisiQO0u+sZlOvX7Z1IGirE48ilBKt50NRuyFab38UbUfX6YXSq3Ju
	 3o2UNDL0AVm5x5FnarWENlrtXz6m/GLHz/I/cRmOVbnD5G5HZnWnqhoZJ8sT4MaFWbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621520;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:CC:Subject:In-Reply-To:
	 References:Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=/wgFsQ8VZzfnUKt55TQ4jfOIehlKTbCtB33ysIu8c3k=;
	b=jfwg2KCozKhrqBdOIhYQysLqs9hXqXx8jOekvnvH1bTDWjjC/snQZvYyDenfmHAOxM6E
	 FaNUsbRNJDxDZ9NMzIQEXQfO6SHTsm9nrvlwdfRwfbv+eQ29YE/DtN6ULkGSbQ/6q//Zm
	 Bc1LH/N9+tjsB735n927RMfuE2JCHIWlADvzWuUDb7ON62xbDR6d7UNK0vIgj8gGwYYlx
	 0enSCF8gf+zEK2QBDXjl+rYEcoAqXkY++pcBCsj30SVt9GbW60xG98CxYD1FYkf/4Mm5S
	 F6RoYGOEzVupodG3FOmQ30VQq+jx8j3jKIkbanP3AbgvVkbOOteJ9BXqu0WAxvdsV/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=p801VQe6;
	arc=none smtp.remote-ip=91.218.175.23
Received: from mta0.migadu.com (out-23.mta0.migadu.com [91.218.175.23])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 434BE606A321
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 15:45:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 434BE606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=p801VQe6
X-Envelope-To: linux-btrfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Aimq25gfVfgFiA8dFOiaOK/Gd0rXqrMjK4/YGHcF11w=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795621517; v=1; x=1796226317;
 b=p801VQe6cBg5PDHaFrygUP2YqskwpjLqjQbPRQoW6DtpSNVXlWEKUbFcC8/zruq5KMeKcl9s
 i8ds1+1Jj1K1pTt+JvaWtzFsdfSGUk6OWBws4AaO3cPbeLt+4YUKCIQiTr1P8S8H1JFacxZaxPq
 SQmPNcfyD2Hz+BrS6IpJnMGo=
X-Envelope-To: linux-btrfs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 3d909e1a88b2d1e6;
	Wed, 25 Nov 2026 15:45:14 +0000
X-Mizu-Trace-ID: 3d909e1a88b2d1e6
X-Migadu-Flow: FLOW_OUT
Date: Wed, 25 Nov 2026 15:45:12 +0000
From: Bradley Morgan <bradley.morgan@linux.dev>
To: Josef Schlehofer <pepe.schlehofer@gmail.com>, u-boot@lists.u-boot-project.org
CC: Tom Rini <trini@konsulko.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 =?ISO-8859-1?Q?Marek_Beh=FAn?= <kabel@kernel.org>, Qu Wenruo <wqu@suse.com>,
 Joao Marcos Costa <joaomarcos.costa@bootlin.com>,
 Richard Genoud <richard.genoud@bootlin.com>,
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
 Miquel Raynal <miquel.raynal@bootlin.com>, Peng Fan <peng.fan@nxp.com>,
 Jaehoon Chung <jh80.chung@samsung.com>,
 Tanmay Kathpalia <tanmay.kathpalia@altera.com>, linux-btrfs@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_0/6=5D_Avoid_64-bit_division?=
 =?US-ASCII?Q?s_that_need_=5F=5Fudivdi3=28=29_or_=5F=5Fumoddi3=28=29?=
In-Reply-To: <20261125124259.95636-1-pepe.schlehofer@gmail.com>
References: <20261125124259.95636-1-pepe.schlehofer@gmail.com>
Message-ID: <5D58F095-45B7-4BA0-A25E-2D65AF893947@linux.dev>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit

On 25 November 2026 12:42:53 GMT, Josef Schlehofer
<pepe.schlehofer@gmail.com> wrote:
>U-Boot's private libgcc does not provide __udivdi3() and __umoddi3().
>v3 of the mpc85xx LTO series links mpc85xx LTO builds with it and added
>both routines [1]. Christophe Leroy asked why the callers do not avoid
>'/' and '%' on 64-bit operands instead, and Tom Rini asked to update
>the common code [2].
>
>Patches 1-4 avoid the divisions that make the mpc85xx LTO builds call
>__udivdi3() or __umoddi3(), in btrfs, squashfs, mmc_berase() and
>get_win_cnt() of the mpc8xxx PAMU code. They do not depend on each
>other. Patch 5 removes fs/btrfs/dev.c, which nothing uses and which
>holds another 64-bit modulo. Patch 6 converts the remaining divisions
>in btrfs. U-Boot never runs them, but builds without LTO still link the
>ones in the RAID5/6 code. My reply in that thread announced these
>conversions for v4 of the LTO series. They are sent on their own
>instead.
>
>Patch 2 and my big-endian fix for squashfs [3] conflict in
>sqfs_read_nest(). I will rebase whichever of them goes in second.
>
>Build tested with a buildman world build on a fork's CI, and sandbox
>test.py gives the same results as before. Run tested on qemu-ppce500
>(btrfs) and qemu_arm (btrfs, squashfs, mmc erase), and on a Turris 1.1
>with the mpc85xx LTO patches on top, which boots from an SD card and
>loads files from btrfs. The PAMU change is build tested only.
>
>[1]
>https://lore.kernel.org/u-boot/20261119133310.22732-5-pepe.schlehofer@gmail.com/
>[2] https://lore.kernel.org/u-boot/20261119200924.GB3176972@bill-the-cat/
>[3]
>https://lore.kernel.org/u-boot/20261125095537.37979-1-pepe.schlehofer@gmail.com/


Thanks,  after review, who will merge? Me? Or anyone else up to?

>
>Josef Schlehofer (6):
>  fs: btrfs: Avoid a 64-bit modulo in __btrfs_devread()
>  fs/squashfs: Avoid 64-bit divisions
>  mmc: Use div_u64() in mmc_berase()
>  powerpc: mpc8xxx: Avoid a 64-bit division in get_win_cnt()
>  fs: btrfs: Remove the unused dev.c
>  fs: btrfs: Avoid the remaining 64-bit divisions
>
> arch/powerpc/cpu/mpc8xxx/fsl_pamu.c |  2 +-
> drivers/mmc/mmc_write.c             |  2 +-
> fs/btrfs/Makefile                   |  2 +-
> fs/btrfs/compat.h                   |  8 ++------
> fs/btrfs/dev.c                      | 25 -------------------------
> fs/btrfs/volumes.c                  | 19 +++++++++++--------
> fs/btrfs/volumes.h                  |  9 +++++----
> fs/squashfs/sqfs.c                  | 21 +++++++++++----------
> fs/squashfs/sqfs_inode.c            |  5 +++--
> 9 files changed, 35 insertions(+), 58 deletions(-)
> delete mode 100644 fs/btrfs/dev.c
>
>
>base-commit: 79497816056122c49b3b135e14cbac59374e636c
>

--- Thanks!
