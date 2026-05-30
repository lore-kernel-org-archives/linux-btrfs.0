Received: from mail-24429.protonmail.ch (mail-24429.protonmail.ch [109.224.244.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94BD72165EA
	for <linux-btrfs@vger.kernel.org>; Sat, 30 May 2026 20:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.224.244.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780172751; cv=none; b=qFM86ZT4V2zYUGhCL9mt3lL+Ez3incXJ02LH9eD0Hvh/t56sNKg9CDdsDmr0QP/WSbQjgKUp3ClIWACO+UzLkJBHr2reN97nHxPpxs8a5ie0paPqLURA1YC5L5OeBo7SS/RuW97atMQB9uFpYiLTX0+5MvAZDh9WFdMwEPzuip0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780172751; c=relaxed/simple;
	bh=LfrDEjuNme8kAWlIPiuZuby64t1eo2ql6WSa7FpGA3o=;
	h=Date:To:From:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rnr3zKV4QDNoJV+80ku9HfGNCGV0MHhh1V85RgBbIUTTAD6nEbvNPorlAh6g/XMT+E3jvThKO/XC7tzwzTDubySyDgXqYgkco/wUPjEQKxQUG00Gigv8C3Wn5QecKAwOKnd9H5GHScJif24+JMTUIYidTnQtVikeK2uo8zNcWig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=n3Bc9FWW; arc=none smtp.client-ip=109.224.244.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="n3Bc9FWW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1780172745; x=1780431945;
	bh=QyjE75C+iIsUOsCcKZPGiER+YOnSTW7n2H4RmU35nuo=;
	h=Date:To:From:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=n3Bc9FWW3MzEuHb3rw4Pw7HQVo0INCjFmMhuPdO6d2sFeAfrPYIihgKi9vRXnql7/
	 qWroduEfnvpspQG/r2o+0jiX+niZyYLU/XaGFLnZBxjMceiJtLiVcI0A58Q/cALxAH
	 Ss2YEkzYjzXbKlhUqqmMjbSE/Ne4a4wALy1eOjsfpvrG0nNic3F1zPiNWi+f9L5zLg
	 ThzfbrmckiAbfwscKM5dAF0O5nWQUAZBT+fAtT5Rtt67ufkRi8clP74SiSABOnTI9U
	 MU+WO8Qm9DWQXNmPvgyQQ4id+F26XejLGKM7KFbgnhYRgv0d9LP4xsZlpl0uxZUXUB
	 O6bIDu0NB+wow==
Date: Sat, 30 May 2026 20:25:42 +0000
To: linux-btrfs@vger.kernel.org
From: xerobrinhek <xerobrinhek@proton.me>
Subject: btrfs: multi-device pool corrupted after repeated removal/recreation of missing device
Message-ID: <ISRv0Ku3zGY139-n3o62hjAyUorcln7sKNLrUViaahtGK-bidGOIjXvj6OeK6_od0CwGnW0RuTP1Un8PXSUv6owZVbEfIJkRuiS8NLwIBqU=@proton.me>
In-Reply-To: <JJ5S5tQDVkTmHxqx0ncj423p-TgogJGM8fSviYuGeF1i-xc7NtTdlmd1VO0aopC3SEVqYZF_Z6opVqrTz4eJ8sbDOiceQNzgwnjerSXJWhM=@proton.me>
References: <JJ5S5tQDVkTmHxqx0ncj423p-TgogJGM8fSviYuGeF1i-xc7NtTdlmd1VO0aopC3SEVqYZF_Z6opVqrTz4eJ8sbDOiceQNzgwnjerSXJWhM=@proton.me>
Feedback-ID: 188343733:user:proton
X-Pm-Message-ID: 3894e24eb53f0ebae4d82637ff72a3712bce83e3
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hello btrfs developers,

I have a btrfs multi-device setup that got corrupted after a failed device =
removal. I need help recovering the filesystem structure (not just raw file=
 extraction).

Setup:

- Two devices: nvme0n1p9 (17.53GB) and nvme0n1p8 (31,30GB) originally

- The filesystem uses subvolumes: @, @home, @var, @snapshots

- Compression: enabled (zstd)

What happened:

1. I removed /dev/nvme0n1p8 (devid 2) from the pool without proper 'btrfs d=
evice remove'

2. I tried to recreate the missing device multiple times, creating and remo=
ving btrfs on it

3. Now the filesystem won't mount at all

Current symptoms:

Mount attempt:

# mount -t btrfs -o degraded,ro,rescue=3Dall /dev/nvme0n1p9 /mnt

mount: /mnt: can't read superblock on /dev/nvme0n1p9.

dmesg shows:

[  688.380328] BTRFS warning: 'usebackuproot' is deprecated, use 'rescue=3D=
usebackuproot' instead

[  688.385530] BTRFS info (device nvme0n1p9): first mount of filesystem 0d5=
54048-1a10-4fbe-9d7d-80de9d3f0700

[  688.385538] BTRFS info (device nvme0n1p9): using crc32c checksum algorit=
hm

[  688.386981] BTRFS warning (device nvme0n1p9): devid 2 uuid a8559fa6-e465=
-459f-ac73-86c842aa6fe0 is missing

[  688.388044] BTRFS warning (device nvme0n1p9): failed to read root (objec=
tid=3D4): -5

[  688.388060] BTRFS warning (device nvme0n1p9): try to load backup roots s=
lot 1

[  688.388425] BTRFS warning (device nvme0n1p9): global root 2 0 already ex=
ists

[  688.388433] BTRFS error (device nvme0n1p9): failed to load root extent

[  688.388440] BTRFS warning (device nvme0n1p9): try to load backup roots s=
lot 2

[  688.388498] BTRFS warning (device nvme0n1p9): couldn't read tree root

[  688.388505] BTRFS warning (device nvme0n1p9): try to load backup roots s=
lot 3

[  688.388773] BTRFS warning (device nvme0n1p9): global root 2 0 already ex=
ists

[  688.388776] BTRFS error (device nvme0n1p9): failed to load root extent

[  688.389043] BTRFS error (device nvme0n1p9): open_ctree failed: -17

What I tried (all from Fedora Live USB):

1. Superblock recovery:

# btrfs rescue super-recover -v /dev/nvme0n1p9

All supers are valid, no need to recover

2. Zero log:

# btrfs rescue zero-log /dev/nvme0n1p9

Couldn't setup device tree

ERROR: could not open ctree

3. Chunk recover on both devices:

# btrfs rescue chunk-recover -y -v /dev/nvme0n1p8

Result: Chunk tree recovered successfully (generation 9, chunk root gen =
=F0=9F=98=8E

# btrfs rescue chunk-recover -y -v /dev/nvme0n1p9

Result: Chunk tree recovery failed (the device is the main one with data)

4. Mount with various options all fail with either "can't read superblock" =
or "FS exist" error:

- degraded,ro,subvol=3D@

- degraded,ro,rescue=3Dall

- degraded,ro,usebackuproot

- degraded,ro,sb=3D1 (parameter unknown)

Key observation:

btrfs-find-root shows there are valid roots at various addresses, but mount=
ing fails with EEXIST (-17) and "global root 2 0 already exists" errors.

Questions:

1. Is there any way to force the filesystem to forget about missing devid 2=
 and mount using only nvme0n1p9?

2. Can I manually copy the chunk tree from p8 to p9 using dd at specific of=
fsets?

3. What would be the correct procedure to rebuild the extent tree and root =
tree without losing subvolume structure?

4. Is --init-extent-tree a viable option at this stage?

I understand the risk of data loss. My goal is to restore the filesystem st=
ructure (subvolumes, names, directory hierarchy), not just raw file extract=
ion.

Thank you for your time.
