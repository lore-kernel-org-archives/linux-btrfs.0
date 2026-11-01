Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793498242;
	b=lgj7g6lu5U+K20Etouoyn30qZTqMinzXEOM3nmahbmCDW9MyEmDMZhAL+p6248+pdZ/L
	 burgU/8O8quEbJFubMQPJ4X/1nbWNo0zfo35Pl8K8FLvThA9OAIZ01uHDYiLOPmRPMu2I
	 hTF5GcB2GmWHfBR36yIN5F7eGTqdmgnu8O66JCuOf0ZTsy5uyz/u3iW/6orI0nm6ADM0K
	 8y46ZSY+yHNttyEPPCdgVkosvYQ/05zGIYfkNk3niBBl68VA0ODmvQb/8+LG5Fxpruidk
	 we4oq37iMw7alGKi/lyI15K5Ab8OWByV0fhtd2mq/s4a4XXoto5FliqQLCrc10mERxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793498242;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ldhDDTtZAE/3brSKAhksuwsG1IPpe3NESKnYVMmoFBE=;
	b=DmrJLzlOQHYXPRL/jJndZh9xq64ZANB15Hokm+8vknX3EEtQwo2Mh/m3Dti4tyr2klg0
	 G9yy/wELkPzGIMRzMUY78Tj06hUetx3THYZW3Rpkd1J8DKx4pvLK8nUVVoE2ClwRWpqSk
	 4khTggMS6j6EfgReuKDODu4Pj2veHUOqWNpL9SUrXHxNsV1laT3VmPYvace8s2IhkZdcl
	 FMSM20SOz+/Xj8NNClfQ32LWVE2kzTJkc5fe78wbUTGmHm0JTbgsGpxaTI7ag61Zi/Zsb
	 AL1Xk/aqmovVNmfbzj6hbNqiyoDTMplpzJ/WxXf7uOl5Df+qvwJPkNHzFP5i8nYwFyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uAYmsTxn;
	arc=none smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 413EB606A327
	for <linux-btrfs@vger.kernel.org>; Sun,  1 Nov 2026 01:57:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 413EB606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uAYmsTxn
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a35ac4475dso12774785e9.2
        for <linux-btrfs@vger.kernel.org>; Sat, 31 Oct 2026 18:57:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793498240; x=1794103040; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ldhDDTtZAE/3brSKAhksuwsG1IPpe3NESKnYVMmoFBE=;
        b=uAYmsTxnVYOAxhIuO6akQJRAlwulHZ1cjkwNFSKIuLwxuMITROqm04zH8bg2jtdAiN
         K/q2Xv7O6neta4eG6DSc9d85IPEWiv1++igy29ZUlsr8AKb4Pw8hHevGM6CKovQDGs8p
         8kNi9wTr+vjarzKpUQpHytF8G944CMgJbukUoNCEdSh+49YhYerb/mSJYVUgYy+HarE1
         oUBMUty+81j//ZUZmDfTLrKQD5lVb23rSanXMXMqWrKZpIDmf1IeYUqKsCaVdZrygZnK
         9I/I/b6mqytwi3p1nsWGT6rMtbXnjrwlZ26NoWVYuNgErdJHIx9pErffmAQNAUQcGLmG
         s8dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793498240; x=1794103040;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ldhDDTtZAE/3brSKAhksuwsG1IPpe3NESKnYVMmoFBE=;
        b=ClOpw/wnmnwVXk25h3UWApzBESYcWhB/42Aq+myonM4AGVqAsVMkqDHorRhbHBOXq0
         y1xzvy0x5FekI+2NyQP4tueRaEPkfr5EbPp9boRC4v3Q74Ii7CniDpKIi1NH0GRi/3NB
         xVPQY9w2/+cXYwciTACmsH59Iz32PgyolM/iPWHH3tvMmiQBy32ETdJanoPIZVruHcPx
         lwW/0dzDYw7Rc374z6mZI8KLvjL3cZp2XayNSYI7HuWv8yxjf741kHlCNbAU716xa8R9
         KMjKgr0pU/ANb7J3F49s4HJ6Ffqq3vlYJUkqCvmpoofV2w8aXVPdAWeLj/sJF6O4WTaU
         Qv7Q==
X-Forwarded-Encrypted: i=1; AKwUvBy8MOqm8S0d12x/6p2p+4IuwChB3Pck3Vy+KwO3t+G9Q+r8yrFWwbwRytW6mCttTGxkMkUjtw91oWc2cg==@vger.kernel.org
X-Gm-Message-State: AFq9FYLGWCPBniwJXyTcZZcP+Qw0TFp3yJ6AkRb/ulj9ApFnpP9IxQa2
	FtaGMtBfxxwEm24SZow5InYYMqeT7WGGf7kO1glt+u0rle0sYiouOgF8
X-Gm-Gg: AYBFou2pz6HDodAO2I5NwahvVfTBkdMMPubl0mRlCrp6kKnVyHX5U2k7TmE1GnizkVk
	m91bLjC4+v9KiTRw12XPJH/Ou0gD2ljuKJTG4gLNvdi3uHqGdQHKzKQ386oIR2j/miZ87SqJ34I
	chbMCWw8CRR7V8gOvA6gByzDCodtTAw+y0v+Bv5eL6BlwO8vA+IIU15r4Z/Zm4KqlsHDHOAf22s
	B1p6oON93MdtD/o5OlnhbsGNUs2li1oCFT92LnRfB/UdLkXG2BiB8sWS6QYwXK6KpE6GpGEBV/w
	NHiZUrZET2w6Q5LghwSsVl/PpAycHX6jCoqVcPC8soNyrwI64j3A8HBmPI2wguMkKsU6j6W7jYj
	UppeM0Gh58KFEn1ju3eAs2xdDm95pZLANszFS5fopIG/zKorzcdjNoMJ83vXdEhlPexq/rkkAaV
	Mgw3UjowEbiW+2/9rUqbVtNIz1RoJykShCMR1HQ2YXux5LzPPha3dguJVtvjxZxbL8bsro+plGi
	uAvdtMru3EDICSPWXlxo7OtLONsRR5VoZmC5q7wiPi/caErafDuVBCfGAbe2vORF48Or4E+tOc9
	fgqUvFFnhccKBG0Tj6+QEGGO
X-Received: by 2002:a05:600d:c:b0:4af:83ad:8f70 with SMTP id 5b1f17b1804b1-4af83ad8fa7mr31193005e9.35.1793498240391;
        Sat, 31 Oct 2026 18:57:20 -0700 (PDT)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa81b7fe80sm273532835e9.11.2026.10.31.18.57.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2026 18:57:19 -0700 (PDT)
From: koraynilay <koray.fra@gmail.com>
To: David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Cc: Chris Mason <mason@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
	Chuck Lever <cel@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Sean Smith <defendthedisabled@gmail.com>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Amir Goldstein <amir73il@gmail.com>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	exfat@lists.linux.dev,
	ntfs3@lists.linux.dev,
	linux-api@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [RFC PATCH v3 0/5] add provenance time (ptime)
Date: Sun,  1 Nov 2026 02:55:46 +0100
Message-ID: <20261101015551.786044-1-koray.fra@gmail.com>
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

v3 changes:
- vfs: reject setting ptime with -EOPNOTSUPP on filesystems that do not
  support it instead of silently ignoring it (found by sashiko[4])
- vfs: fix not being able to clear immutable and append-only on files
  with ptime, and allow updating immutable/append-only atomically along
  with ptime (found by sashiko[4])
- btrfs: validate on-disk ptime nanoseconds and reset to otime if
  invalid (found by sashiko[4])
- btrfs: avoid re-assigning ptime on unrelated chattr calls (found by
  sashiko[4])
- add ntfs3 and exfat support as suggested by Amir Goldstein[5], but no
  vfat, smb, or nfs4 yet as they are a bit more complex
- move the introduction of fileattr_has_fsx_mask() from the btrfs patch
  to a standalone patch in the series
- btrfs: add fileattr_[gs]et to symlink and special file operations

Thanks.

[1]: https://lore.kernel.org/20260405195007.1306-2-DefendTheDisabled@gmail.com
[2]: https://lore.kernel.org/20260407014129.GC6192@frogsfrogsfrogs
[3]: https://sashiko.dev/#/patchset/20261027220532.736352-1-koray.fra%40gmail.com
[4]: https://sashiko.dev/#/patchset/20261028134728.294127-1-koray.fra%40gmail.com
[5]: https://lore.kernel.org/linux-btrfs/CAOQ4uxiuy0VwZj+3M-zRqQ49WTpHZpiaQ+6MZ8z8WdLjyQM_zA@mail.gmail.com/

koraynilay (5):
  vfs: add provenance time (ptime)
  vfs: add fileattr_has_fsx_mask()
  ntfs3: make crtime user-settable using ptime
  exfat: make crtime user-settable using ptime
  btrfs: add provenance time (ptime)

 fs/btrfs/btrfs_inode.h          |  4 ++++
 fs/btrfs/delayed-inode.c        |  6 ++++++
 fs/btrfs/inode.c                | 29 +++++++++++++++++++++++++-
 fs/btrfs/ioctl.c                | 12 ++++++++++-
 fs/btrfs/print-tree.c           |  1 +
 fs/btrfs/tree-log.c             |  3 +++
 fs/exfat/exfat_fs.h             |  2 ++
 fs/exfat/file.c                 | 36 ++++++++++++++++++++++++++++++++-
 fs/exfat/namei.c                |  1 +
 fs/file_attr.c                  | 33 ++++++++++++++++++++++++++++--
 fs/ntfs3/file.c                 | 14 +++++++++++--
 fs/ntfs3/frecord.c              |  8 +++++++-
 fs/stat.c                       |  2 ++
 include/linux/fileattr.h        | 26 +++++++++++++++++++++---
 include/linux/stat.h            |  1 +
 include/uapi/linux/btrfs_tree.h |  3 ++-
 include/uapi/linux/fs.h         |  8 +++++++-
 include/uapi/linux/stat.h       |  7 ++++++-
 18 files changed, 182 insertions(+), 14 deletions(-)


base-commit: cbbddb6b08cc9900a87cccaa9b22bbe06aa4f50a
-- 
2.56.0

