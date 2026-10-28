Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793195262;
	b=YEMDGwLT9RupacFQXg4+KQWKB7ViamHuZDjZbOMF9Qd/wBXvF859Pmwr1C/SIVClxz4M
	 Nz6mo/OGzf4c7oC9JZ26DL6ggWWM/t3N5SJipLKUYVwVOGxmVn1shraF61O6VI87JWb7A
	 C2cucabkXSqeDX4muB3DnqJxql4G28W5+L+62V8oZtroMe9zJTk9+18yNlMgwolE7bEb3
	 7QEuIrG/Q5Oeimj77m4Rafn3BYRYEIFsFSiCmVIzT9OvzUgtiPosPd0FjI5LFUQZIN0Yy
	 aQQFSkOYVYe3NeJ6VGlbS3p6bt6AatkDnnfqR53Pml0H4VBTz6cKYf9A+7OuYY4C9MQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793195262;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=7g2SJ+wOfq9sRV8snpEm8KQlGKS1nPNyY3GC+DoZQY4=;
	b=GFobAgMEa5oHMJ7eeX542o2i/NLqziiB5uDQbnBYTeKArA9zSpcXibcA9ptlZq9yV/Yt
	 DJZ2nvzWe1GQJfmOqxyuQBnq3OC4BBf4aXuYS461Xj6sxd4UZTSv43wDpqfv6JcXe8c+y
	 pAabaubyJVZdr2V4qq6XCjz8De8w/23fEnY9aqLa39bxdyn8/Cyl5s9tb2IXzSD6i7WAb
	 NNvafiBiBCHfIoz1j6u4XYY+FqTEZg2zKYwWkxXq3alJ2PH6JsbKCKpBurSMkWVwv2KjT
	 9scsaAVMdPw9I54qBXJkumc4idSfFvF4EIitv8GbOMAE9xbp/wqR6l7BeezAGFNdwRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="MbVHe/tr";
	arc=none smtp.remote-ip=209.85.128.54
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AEAD606A31A
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 13:47:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9AEAD606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MbVHe/tr
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4a9a8d6cea8so8055395e9.1
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 06:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793195260; x=1793800060; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=7g2SJ+wOfq9sRV8snpEm8KQlGKS1nPNyY3GC+DoZQY4=;
        b=MbVHe/tro9g1wXs57VqA0jvP4MOx9hxzYUPS3zpcoXrvK3Mw8iig12z5c+XzqiEz1P
         QVzp5bn9Dup3gduPxZWVSfKuLpZnxyVPXQ3zQIWzYIKINE79/zvdTJ8J6NxrFO+CJcE0
         +CZOftBiPauH72KgCXkms4zKD9r3ZSxT2J8SfHcSSyN8JtPfYw9MReDEkY9qVQ7IItyO
         rYmaWSdA4BGtXWpOECMySSuay4lLF220gmkjRmBoUjnchQFsXCWsJ+NrWcknyUCEtHOe
         yd28p9AL8OETjciC8rL2bGVvd6c0KVotwCiJeE2MP4mUr76Vt0INTrB29oUWO8Lq7dBP
         NHNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793195260; x=1793800060;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7g2SJ+wOfq9sRV8snpEm8KQlGKS1nPNyY3GC+DoZQY4=;
        b=JlNGrWu8kzzRLdpxGNP/Q/h3ycaSAhfDa6XR0o5ROGb0nNbzkKkpEAtm8a7IhTHbpk
         9R5K0CGOsVzCqBiQHCA5y6O2OlzNVIKPcimNrakEInwH3dzg/KYa6R+FrtZ73atvtx76
         6lDpdZH+JFH8APb07dJGSzvx6FQC0ANtHJJu9SJx8KDofqx+dYXWJCRe/T67mAktwJ99
         eP0a2Pv5exTpG6etEzei+8Nurk7MRFtpCM7bDHqj5k7hKxnh3eqx49pZSX43oYqXzlJZ
         f72Qo9GcAHPrwA1HhkY6lpslEMpghEjtTZipg6Zro4Md/iqVUmupBATW3+Nwv99CypSo
         tXdg==
X-Forwarded-Encrypted: i=1; AKwUvBwj099E9cT2FZRC7ND8G2mB3TCIOr9ASNvBYlhkQDMciTzGQHwX1AjUd29Ly6PZGcoasPUOoqhUgaFI7A==@vger.kernel.org
X-Gm-Message-State: AFq9FYK2L40R9ZucqPKCpUpkIHR/8qBBJebWQdd5xvI78sOOk+U+LRYC
	cQj0aGgLRwgv3/8/fNepGLBMrPUm5lShij3IbAB0TsVZ7yO78gJ+hs8b
X-Gm-Gg: AYBFou1Q1gl9O52BlNwrmtqGfj52jVah366/zYVAKYlV+KpYDDRVJPqoT/cevxFz89p
	jrQM7XlFE6m4+PTFprqYnE7GWkKLoWZ4jgdEXeypPOBajegHjBHVgf0cqgfiASGrYd7PV+D6+AF
	tuQzLbUkws50TjS1ycuRtjFwNNDEt2LR5PwoksUISRA3LbYwKq8WRpCdhYKUaLE8XrSkOuXJlPQ
	EVEc7Bs4d3FoRYqAvrXBCuXRhujSZNWF4hoqMfIvOFxh+UWWRJDUvse0NCQUaUgdfK4qfJSI9Ki
	wgPI2VCwjS/xgl1aqKRZlrH+OXHk5zlh5sgmYklbJ51ZUwtJJVxyEyONabjBakxZmGzRBkR9oIH
	c/Hw2qjHqTtsdjJOJIUUiu0J5RoeZoFdKvxIXYyTK9WAp8jQl2RfstS6k7P/n13nPf17nRyC8F8
	qZHUwWlyTIhQj6WYWoBA7V3ndZ+jgEtwcjZ0XHXzubfG3moYTRq7OJBUo4e1r0nxg4XGCO+brb+
	mkJAMClN/SmfWsIap3LC4vxyO8TOjN10UEIuHxwNb0t4OOvmn+sBUGNlbL6XbtN5bQObl7UTj+d
	4od4+MNzdzFbMxBcfxdyN8GgUw==
X-Received: by 2002:a05:600c:621a:b0:49f:c5aa:9ef4 with SMTP id 5b1f17b1804b1-4a996b9812emr41947295e9.8.1793195259973;
        Wed, 28 Oct 2026 06:47:39 -0700 (PDT)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ebc4d76sm29077715f8f.12.2026.10.28.06.47.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 06:47:38 -0700 (PDT)
From: koraynilay <koray.fra@gmail.com>
To: David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>
Cc: Chris Mason <mason@kernel.org>,
	Jan Kara <jack@suse.cz>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Sean Smith <defendthedisabled@gmail.com>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [RFC PATCH v2 0/2] add provenance time (ptime)
Date: Wed, 28 Oct 2026 14:47:26 +0100
Message-ID: <20261028134728.294127-1-koray.fra@gmail.com>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an initial implementation of a new timestamp to indicate the
time when a file/directory was initially created.

This patch series takes inspiration from the one by Sean Smith
<defendthedisabled@gmail.com> [1], but using
file_setattr()/file_getattr() as suggested by Darrick J. Wong
<djwong@kernel.org> in [2].

The semantics of this new timestamp should be at least these:
- it should be the same as btime on a newly created file
- it's user-settable, so it can be preserved for backups, filesystem
  conversions, archives and any similar operation
- it should be preserved every time mtime gets preserved

and the correspondence with the other timestamps is as follows:

ctime <-> btime
mtime <-> ptime

Examples:
1) a .zsh_history file created in 2019, then after a few years the user
   decides to switch to another filesystem, copying the .zsh_history to
   the new home, in that case btime would have the timestamp of the copy
   and ptime would have the 2019 timestamp (just like mtime would have
   been preserved)
2) a symlink created in 2020 from the home directory to a /path going
   through the same process as the .zsh_history, in this case it would
   also make sense to sync the ptime to the 2020 timestamp instead of
   keeping only the btime (so the inode creation time).

The proof-of-concept code (for testing) for stat(1) and cp(1) is
available at https://github.com/koraynilay/coreutils (master branch)
(Note: these coreutils code changes are a prototype and won't be
submitted upstream as-is, but they work as expected in simple stat and
cp -a/--preserve=ptime tests)

Lastly, the name "provenance" and "ptime" are not final, I personally
don't have a strong opinion on any name, but while testing with stat(1)
I noticed that "Provenance" is definitely too long for the normal
output, so another option which would fit well is "Origin time",
abbreviated as "ntime" (OrigiN time) and not as "otime", as that would
conflict with btrfs' internal naming and create confusion.

v2 changes:
- fix permission bypass leading to ptime update on immutable and
  append-only files (found by sashiko[3])
- normalize ptime timestamp as done in fs/attr.c:notify_change() (found
  by sashiko[3])
- fix wording in vfs patch to be like the cover-letter

Thanks.

[1]: https://lore.kernel.org/20260405195007.1306-2-DefendTheDisabled@gmail.com
[2]: https://lore.kernel.org/20260407014129.GC6192@frogsfrogsfrogs
[3]: https://sashiko.dev/#/patchset/20261027220532.736352-1-koray.fra%40gmail.com

koraynilay (2):
  vfs: add provenance time (ptime)
  btrfs: add provenance time (ptime)

 fs/btrfs/btrfs_inode.h          |  4 ++++
 fs/btrfs/delayed-inode.c        |  6 ++++++
 fs/btrfs/inode.c                | 17 ++++++++++++++++-
 fs/btrfs/ioctl.c                | 12 +++++++++++-
 fs/btrfs/print-tree.c           |  1 +
 fs/btrfs/tree-log.c             |  3 +++
 fs/file_attr.c                  | 29 +++++++++++++++++++++++++++--
 fs/stat.c                       |  2 ++
 include/linux/fileattr.h        | 27 ++++++++++++++++++++++++---
 include/linux/stat.h            |  1 +
 include/uapi/linux/btrfs_tree.h |  3 ++-
 include/uapi/linux/fs.h         |  8 +++++++-
 include/uapi/linux/stat.h       |  7 ++++++-
 13 files changed, 110 insertions(+), 10 deletions(-)


base-commit: 65ba8f34ec886ec72b2c07ddc8cf3d815c32869d
-- 
2.56.0

