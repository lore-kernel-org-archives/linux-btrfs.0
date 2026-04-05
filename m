Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F7F737B010
	for <linux-btrfs@vger.kernel.org>; Sun,  5 Apr 2026 19:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775418626; cv=none; b=T4TIPsaVPG5H3gFbicPcKwQ6uDwY/0zluXitlHmHbsm/vwPDg4971PjGPEjeHRFj7BipDNcd3Sf+s668A2Db5abGd3Tm8yorWSphur/pVYpirrENdNeziBliLUh+5sQ2wtHRl2UQexQfApcdUdXTlxX/cE3jaEQgd8cqiqjjV8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775418626; c=relaxed/simple;
	bh=2HpA9a7YpMsG6RzQeS6NPv0xbOy+YIj0lAohp10XXe8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uXdw16arbHDffWNols9+FPXCbJL0e+GFdxrZWZyRgiTxk5wg1rRS+rSRo0DBYbihlwStB1cO5ml2nreHM7ReGVmpIdvAcscYQJY1+MoFTx5pcwCyTQCiHPAG3xd4i60F0NeEKiQEZ3ROQ0FVAW9g3zrehMg64tPgaS8Uh5ks8Kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y2CnWMUz; arc=none smtp.client-ip=209.85.167.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y2CnWMUz"
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-46eca92a297so1675669b6e.0
        for <linux-btrfs@vger.kernel.org>; Sun, 05 Apr 2026 12:50:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775418623; x=1776023423; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=y/Z3NqYghOFgX7NQJkYe62ulZHnLEHQdOk5LkLv1xhc=;
        b=Y2CnWMUz4w4zMlm9x6ciVxO8joSA7xE31SJz8acNidGeY5dZFXKH12Wf6MNFq4ODL9
         TPnIsixU7uNY8QSLUX904sjn6uJowghtBSkzy4mxsn/IFElFKxC1WwDYxiWWOMPIRhQW
         lMctjeEH5Y+N67Ix9lN4sBqtIwH82Pr/Qwa133fm7pm5i/o+RFvuxHDG7cYJyVpID3aC
         IJksWAX8rvgcMUVPhhrSSAQqz6QAJ7wJrcgl6XsEdjGq40DUx7pOol1AlAFHxklc2PAw
         r4RNyCbxwT2M8DlA9WYFHo6BjHQBbsX0+zmEGtcUPBLI8UDnx0wASdI7kyHcevJc1EMy
         dK3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775418623; x=1776023423;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y/Z3NqYghOFgX7NQJkYe62ulZHnLEHQdOk5LkLv1xhc=;
        b=KDNISaaHbliKpX67NtX5t1G0Q/mR/DaW8ApTc/ejh+ynXMpBq1X/Ugn7gEG++5kV1h
         v929v9OOebsKbAz1eWZMyCN5KKoZepzNllGpj0/8HEyalHSBphU0KEgTk7fCRPQiZHqU
         nAoi45WdQDL8eEqrymsl44Env9TGVysQ47olJztqsa/GebJON/6r110sOi8+5EgJryoG
         nblT9FhYyaO/80mf/B6ETe+cHGEaXj86D+lS6MnycjG++WUp52nqUacCjabWkeDEe8ku
         gR6Ve76MzIextPsR/5U5JDnuD4bwhbJNfouGT6VZ4dxOh/m0ubAH2EhCvS5Qgap4jEac
         Dj+A==
X-Forwarded-Encrypted: i=1; AJvYcCWI5ihaxht7OManurjYTBHFfmbXRqurxxRSy+NrxaL0LOCZxSRWF05sJ5CdXXpL+bL3aXqxwMqKi3SuLw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwTahBXdAo19gg5xNTuwqbrkOYVeI2878kyBiM3GWj7R+bIS+Ef
	khcdlcw9QRqQbeO1mHWXDXrBG0Asxly7ds7RXfL4ahBfW2OiIvD8CpRQ
X-Gm-Gg: AeBDietD13RGt3lCmmQg2OpqhzIqZt2uHs2ljcxJ9jQE5bkLXPMWOu1NPWFqm0PgjLi
	CfdKu6bAsJWVoKYXK4s9i+yYbi1mvgWGpAB4RUJZm5yg7Saiy6PTC4Z8nVmcSv18c5cRYT+awKq
	4h/iMEaO1KlaL41ALUufetkFZtXo1sMbYbmQjK3dYd6thnfrKRvOYqjvldqdesbPvu0goO1WW9d
	Zr2gijTNtFiOH4J9j1ets+L8OjikmvD4uvjpnlQLg12JWA9raxCjKuOnAp8U4NqCxTGm5Ty6hM1
	GVlo8DIfa/izTI3E+MTKpUiUwDVqQ5nT/wM1BF08X0Ctq7ts9kzUZfqzBf63pldvunIyEmSVDCL
	YwKjKpDV37OW0GrGpoh1a0UGphXv65ePJajfmpjmynd1bHc72ZmX33gRNXzFNkOSMRMNcfcyXiI
	DlryTwQQvoGpy1WUB+RwhHO12TLE2HxKZusyinV9QzFDK6PGPKN+GftLxmacoDQeqGieZWIWoHE
	dtzPvlCFXIvh5uLVghF3sMayA==
X-Received: by 2002:a05:6808:c298:b0:46a:c98c:bfe9 with SMTP id 5614622812f47-46efbbe9a45mr5481201b6e.40.1775418623283;
        Sun, 05 Apr 2026 12:50:23 -0700 (PDT)
Received: from localhost.localdomain (c-73-5-99-191.hsd1.la.comcast.net. [73.5.99.191])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-46f46160155sm4547428b6e.17.2026.04.05.12.50.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2026 12:50:21 -0700 (PDT)
From: Sean Smith <defendthedisabled@gmail.com>
X-Google-Original-From: Sean Smith <DefendTheDisabled@gmail.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	tytso@mit.edu,
	dsterba@suse.com,
	david@fromorbit.com,
	brauner@kernel.org,
	osandov@osandov.com,
	almaz@kernel.org,
	hirofumi@mail.parknet.co.jp,
	linkinjeon@kernel.org,
	Sean Smith <DefendTheDisabled@gmail.com>
Subject: [RFC PATCH v1 0/6] provenance_time (ptime): a new settable timestamp for cross-filesystem provenance
Date: Sun,  5 Apr 2026 14:49:56 -0500
Message-ID: <20260405195007.1306-1-DefendTheDisabled@gmail.com>
X-Mailer: git-send-email 2.51.0.windows.1
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series adds provenance_time (ptime) -- a new settable inode
timestamp that records when a file's content was first created,
preserving this date across copies, moves, and application saves.

This is a working implementation of the concept I proposed in my
RFC in March:
  https://lore.kernel.org/linux-fsdevel/CAOx6djP4hb-Cd1Zk07SNfFfLc8irjNmbVqq+58h1Whz+h1wSFA@mail.gmail.com/T/#u

MOTIVATION

Linux has no mechanism to preserve original creation dates when
files move between filesystems. Every copy resets btime to "now."
For workflows involving document migration (NTFS to Btrfs, between
ext4 volumes, to USB drives), creation date provenance is lost.

Since the March RFC, I attempted an xattr-based workaround
(user.provenance_time) and found it structurally unworkable:

  1. Application atomic saves destroy xattrs. Programs that save
     via write-to-temp + rename() replace the inode, permanently
     destroying all extended attributes. Only the VFS sees both
     inodes during rename -- no userspace mechanism can intercept
     this and copy metadata across.

  2. Every tool in the copy chain must explicitly opt in to xattr
     preservation. cp requires --preserve=xattr, rsync requires -X,
     tar requires --xattrs. Each missing flag causes silent data
     loss. Transparent preservation through arbitrary tool flows
     is not achievable in userspace.

Atomic saves are the default behavior of mainstream applications
(LibreOffice, Vim, Kate, etc.).

DESIGN

ptime is a separate timestamp from btime. btime remains immutable
and forensic ("when was this inode born on this disk"). ptime is
settable and portable ("when was this content first created").

This resolves the 2019 impasse: Dave Chinner's forensic argument
for immutable btime is fully respected -- btime is untouched on
native Linux filesystems. Ted Ts'o's March 2025 concept of a
settable "crtime" alongside immutable btime is implemented in ext4
with dedicated i_ptime fields.

Two implementation categories:

  Native (Btrfs, ext4): Dedicated on-disk ptime field. btime
  remains immutable. Full nanosecond precision.

  Mapped (ntfs3, FAT32/vfat, exFAT): ptime reads/writes the
  existing creation time field. This matches Windows and macOS
  behavior, where creation time is already settable via standard
  APIs. No new on-disk structures needed.

Key VFS capability -- rename-over preservation: when rename()
overwrites an existing file, the kernel copies ptime from the
old file to the new file. This fixes the atomic-save xattr
destruction problem at its root, for every application on
every supported filesystem.

API

ptime is exposed through existing interfaces with minimal
additions:

  - statx: STATX_PTIME (0x00040000U) returns ptime in stx_ptime
  - utimensat: AT_UTIME_PTIME (0x20000) flag with times[2]
    extension for setting ptime
  - setattr_prepare: ATTR_PTIME (bit 19) / ATTR_PTIME_SET (bit 20)

The utimensat extension reuses Sandoval's 2019 pattern. For
upstream, an extensible-struct syscall (utimensat2, following
the clone3/openat2 convention) may be preferred -- I am open
to guidance on the API design.

Permissions follow the existing utimensat model: file owner
or CAP_FOWNER required.

TESTING

This has been running on EndeavourOS (kernel 6.19.11) for daily
use. Test coverage:

  - 10 xfstests (7 generic VFS + 3 Btrfs-specific): basic
    set/read, persistence, rename-over, permissions, utime-omit,
    chmod/truncate survival, snapshots, nlink guards, compat_ro

  - Runtime tests across all 5 filesystems: set/read, rename-over,
    cp -a preservation, cross-FS copies (Btrfs, ext4, ntfs3,
    FAT32, exFAT)

KNOWN LIMITATIONS

  - XFS: deferred (separate inode structure analysis needed)
  - Btrfs send/receive: not yet patched for ptime
  - glibc utimensat() wrapper: cannot pass ptime; tools use raw
    syscall()
  - Btrfs compat_ro: writing ptime sets a compat_ro flag;
    unpatched kernels refuse RW mount (correct Btrfs behavior)

The userspace ecosystem (patched cp, rsync, tar, KDE Dolphin)
and xfstests are available at:
  https://github.com/DefendTheDisabled/linux-ptime

This implementation was developed using AI-assisted tooling for
code generation, iterative review, and test infrastructure. I am
responsible for review, testing, and sign-off.

Sean Smith (6):
  vfs: add provenance_time (ptime) infrastructure
  btrfs: add provenance time (ptime) support
  ntfs3: map ptime to NTFS creation time with rename-over
  ext4: add dedicated ptime field alongside i_crtime
  fat: map ptime to FAT creation time with rename-over
  exfat: map ptime to exFAT creation time with rename-over

 fs/attr.c                       |  6 +++-
 fs/btrfs/btrfs_inode.h          |  4 +++
 fs/btrfs/delayed-inode.c        |  4 +++
 fs/btrfs/fs.h                   |  3 +-
 fs/btrfs/inode.c                | 43 +++++++++++++++++++++++++
 fs/btrfs/tree-log.c             |  2 ++
 fs/btrfs/volumes.c              |  2 +-
 fs/exfat/file.c                 |  9 ++++++
 fs/exfat/namei.c                | 21 +++++++++++--
 fs/ext4/ext4.h                  |  3 ++
 fs/ext4/inode.c                 | 14 +++++++++
 fs/ext4/namei.c                 | 13 ++++++++
 fs/fat/file.c                   |  6 ++++
 fs/fat/namei_vfat.c             | 20 ++++++++++--
 fs/init.c                       |  2 +-
 fs/ntfs3/file.c                 | 13 ++++++++
 fs/ntfs3/frecord.c              |  8 +++++
 fs/ntfs3/namei.c                | 14 +++++++++
 fs/stat.c                       |  2 ++
 fs/utimes.c                     | 56 +++++++++++++++++++++++++--------
 include/linux/fs.h              |  5 ++-
 include/linux/stat.h            |  1 +
 include/uapi/linux/btrfs.h      |  1 +
 include/uapi/linux/btrfs_tree.h |  4 ++-
 include/uapi/linux/fcntl.h      |  3 ++
 include/uapi/linux/stat.h       |  4 ++-
 init/initramfs.c                |  2 +-
 27 files changed, 239 insertions(+), 26 deletions(-)

-- 
2.53.0
