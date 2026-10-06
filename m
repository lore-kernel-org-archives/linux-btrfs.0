Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E474820B80B;
	Tue,  6 Oct 2026 21:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791322725; cv=none; b=kw/DeE6nDu+0k9ZgA9sstIVGsGlGUnKNr+xoNCaBiksZqPF5QAvY0UGVuVEJCh4tkYubMwrzmtBGxoS08NjPRob9uag9TkWEbp8pOId826F10wcdl0fu43DWHYnYpwWSC+/M7d8GsRFHZv9BaNVCFR0qOzCxVgRtjyvH6cZ/5nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791322725; c=relaxed/simple;
	bh=upa8bFZnV4m61b6EY23aXf3xv6W3qUjzmof78HH9rLA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=q+Big3lpMvDjf0Q3IfEHeQThQAi4inmnuhNMuctzx0YI5gawNFS+esD0Y4asUbX3wjbQtXwaEYmHdqWARfTsoQhKWisYVr8fPx6yTVpSRnhdVKxooLaLdVwmchv0XSzOkdaXOO0IqBtfFmLpqhHrdLLJ/aQhGFqJB9hpanJzkBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LCXUZBm9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LCXUZBm9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB6AA1F0089B;
	Tue,  6 Oct 2026 21:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791322724;
	bh=KI8OBH+SllJQzQpPj3aeWTY0OtJBMPWUZlWOgbkKBFM=;
	h=From:To:Cc:Subject:Date;
	b=LCXUZBm9pmANP+yDjlkFBvALuQLW7TMBfpywLbDWJ1z1337cwmaco9TlKiR9T7vH8
	 nSzs4fBvWdEwx6mHepbU+Dt9bAbSQYkpWTlwty1LVPZSx0xMDIJ6OQ7vzw6YhEfHS4
	 9RWWTUPpwnsqTiGxOJmngWY9ti9l4UmN28x+Fz3QI53fD5UnTcrOBDOendn2dxawvY
	 ot3OCbWvj4V5hFNSJJ+ErbS947B1KQGf0aTeflYUU7BavU9hPTtbZHX/24QRR8QuxD
	 gdbFYXAFqzwB6WNXfWzKOYM+YPbxEpIHDTK6Vfkere7KHFhixVd+cPlxKIrX5jLYe/
	 pE+ri/yvrNDUw==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: fsverity@lists.linux.dev,
	linux-btrfs@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.6 0/2] Forbid truncate of fsverity files on btrfs
Date: Tue,  6 Oct 2026 23:38:13 +0200
Message-ID: <20261006213815.47194-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Backport the fix to forbid truncate(2) of fsverity files on btrfs (and
also the fix for that fix).

Andrey Albershteyn (1):
  fs,fsverity: remove check for fsverity being enabled in
    setattr_prepare()

Christoph Hellwig (1):
  fs,fsverity: reject size changes on fsverity files in setattr_prepare

 fs/attr.c                | 12 +++++++++++-
 fs/ext4/inode.c          |  4 ----
 fs/f2fs/file.c           |  4 ----
 fs/verity/open.c         |  8 --------
 include/linux/fsverity.h | 25 -------------------------
 5 files changed, 11 insertions(+), 42 deletions(-)


base-commit: a91a6aa9253c64936f0bd8273a2a3c11522ec9c3
-- 
2.56.0

