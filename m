Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 513A4331222
	for <linux-btrfs@vger.kernel.org>; Wed,  1 Apr 2026 15:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775059104; cv=none; b=obM90f/DizfpW3umFHhfVjmSzJk+lkXJznrfJUvIwxOdoefxWI6ZOIktxqNdhQIqW6jnW1ckCzcTSQCS7gx7mqC5jte9MhZMXuYTZJHFEsyX5RBO4MZo2JnDjk0Px2E27UnD0ent3BItx/8WFSSVi9hCx3KLGDARRhd7hXEm+7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775059104; c=relaxed/simple;
	bh=46MleQHvJEp8Ljg50hF8/hDaSLt1dzlCwwc0BDZbB00=;
	h=Message-ID:Subject:From:To:Date:Content-Type:MIME-Version; b=OaFjJMXfr2UdqeqNc4jHXPbug1DW6y0iK8o3p4fLy6upN3yVNwONzhVZqMY7H1MTUlgQo0pzpy7fqzG1vA13SJSjvvgZc9yuCfbI5aJOra9e/WmdDKX8loxzHujzMkeyQFLTvuzwOYu5EXQ5/nHinWtSC9exqZgQZkz3KYfPoag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jtHDhacl; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jtHDhacl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=MIME-Version:Content-Transfer-Encoding
	:Content-Type:Date:To:From:Subject:Message-ID:Sender:Reply-To:Cc:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=hCrsH3xF697H4inxuvIQRYLopYH90xVZrPAY9SMgeN4=; b=jtHDhacl784QZyIKbelU9zIHCz
	zaO4wGUs7LXMRW84iixnLO4deMIUPjYLPQaI/nz1EQnBPwiSpApOMRY4b/o3s3xK8n2siBCu2hGFa
	tH86aJsw1BfS3FK8bLeefttPY5Y5BJoDC4LfIdGe/UVD0Y8V7QCVNKWT4dcHWF59R2LHA2BXDOaAL
	w3mFXCK+Hq9p1mYbAjMzBrPqQ+sukRJxD16BJ85uKYw8iMj/wIp3At+DMgGZY3uhltcYlp3fVDEFW
	lQIo9Q2qEWQHFc23ptMGNvw56RyW4VvrR+l/slVzqn0qlRBGcH1NpFLvK4TAR2xV5LMnSCY+gTxtT
	D8sTmKYA==;
Received: from [84.233.216.247] (helo=[172.31.28.190])
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w7xxS-00000000po3-0xju
	for linux-btrfs@vger.kernel.org;
	Wed, 01 Apr 2026 15:58:18 +0000
Message-ID: <8c8e2466574b29ba1da29c325a108824c8373a85.camel@infradead.org>
Subject: Fixing a corrupted file system
From: Amit Shah <amit@infradead.org>
To: linux-btrfs@vger.kernel.org
Date: Wed, 01 Apr 2026 17:58:17 +0200
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hello folks,

I had a msata drive that started showing signs of failure - error
reading sectors.  I had a single LUKS partition on it (for encryption)
with btrfs as the file system taking up the entire space (1 TB).

I got all the raw data from the drive via ddrescue, and have dumped it
into a second drive.  However, it looks like before I noticed the disk
errors, btrfs tried correcting them based on the erroneous reads on the
first disk, causing those errors to propagate on the recovered copy:

# mount /dev/mapper/luks-ad4cc8e3-17c1-41f8-8d9d-bb831bfcef23
/mnt/msatassd/
mount: /mnt/msatassd: can't read superblock on /dev/mapper/luks-
ad4cc8e3-17c1-41f8-8d9d-bb831bfcef23.
       dmesg(1) may have more information after failed mount system
call.

# dmesg|tail
[960464.502742] BTRFS: device label msatafs devid 1 transid 772442
/dev/mapper/luks-ad4cc8e3-17c1-41f8-8d9d-bb831bfcef23 scanned by mount
(10021)
[960464.516714] BTRFS info (device dm-0): first mount of filesystem
28fa4955-eadf-4f12-a34d-fb7405bbd0a5
[960464.526014] BTRFS info (device dm-0): using crc32c (crc32c-generic)
checksum algorithm
[960464.534065] BTRFS info (device dm-0): disk space caching is enabled
[960464.559255] BTRFS info (device dm-0): bdev /dev/mapper/luks-
ad4cc8e3-17c1-41f8-8d9d-bb831bfcef23 errs: wr 0, rd 0, flush 0, corrupt
100, gen 0
[960464.607016] BTRFS error (device dm-0): bad tree block start, mirror
1 want 1116258304 have 5031253079992706228
[960464.617170] BTRFS error (device dm-0): failed to read block groups:
-5
[960464.626009] BTRFS error (device dm-0): open_ctree failed: -5


(I also have the raw file that I can loop-mount instead of using this
other drive, but for this experiment, working on the drive is simpler
to iterate.)

So questions:

1. Can I do anything to fix the metadata for this filesystem, and have
it mount, recognize and recover the data on there?

2. Does it make sense to drop down the filesystem to read-only when the
underlying drive starts exhibiting errors?

Thanks,
		Amit
