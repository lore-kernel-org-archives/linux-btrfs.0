Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.30.189.100
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794869015;
	b=izag45uEhA6No3CKihHSD1EASdTEdF5MAZ9ZKXwuHInb9IESeTt8o8oPV8jHpM7+FiRu
	 7VL7gEknlyA0e1L7uf/KZrrOd/ee7Cwv5vNB6SobiurPv1nYqspb5bkqtG+EcR/5/ZfQn
	 P/pq22xZ3nd6FTDAGvoT41mEZ66lvqZv1Hic3i0TC/3L4rDY1O4j+SVXCwnXX4YOQV7TK
	 B3r2wGenNVjmkctR3kcCPrg2vTxr5EqlLygiPL3W22M7Er1GMR2Qwhejbqmuof2XOCumh
	 gzrQEoSYkovesfXGqLOJSe/2fck4r0/q01xDnUHBJkIFLGREO8kFd6XmjFWPpAeGhYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794869015;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=N4dtWhUNiSukhf8R9NIb08lmkSRTINrzxb9Pf8lumPY=;
	b=MpuxmbKMaInZktVXcDKbXAv4EbWYQyi1l5wLpT2dSpYGa4ld24oAB6a8AojcF7R8eLqS
	 xBPm5JVo28cIpz2QVbThF120A8fYWK3Y5KNeA0XEGLpQKBqR8/ILo0Mk5c8dYD7GLg2iF
	 pTS8pSgE0wegBzp5Fn0X9chRWyngt5CqS2Vowp7L09A6OykiUNcs2kZoS1jYwf3dh4Dif
	 mU7MoV5zfw37hPSreIkPXiIhQJFnaJtrkLdRCGv2aHIvlLe8NPR42U+IqqQsadKJVL5u8
	 yWfr3z57cjq5L1kOcBrF0Z3/MQGoZ+4q/9csuUff/P7hss1r9NUjCY4mUpZLbNkVJDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=iodev.co.uk;
	spf=pass smtp.mailfrom=iodev.co.uk;
	arc=none smtp.remote-ip=46.30.189.100
Received: from iodev.co.uk (iodev.co.uk [46.30.189.100])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 413F5606A31C;
	Mon, 16 Nov 2026 22:43:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 413F5606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=iodev.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iodev.co.uk
Received: from localhost (unknown [79.116.217.174])
	by iodev.co.uk (Postfix) with ESMTPSA id EBE015E22CE;
	Mon, 16 Nov 2026 23:43:26 +0100 (CET)
From: Ismael Luceno <ismael@iodev.co.uk>
To: linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org
Cc: Ismael Luceno <ismael@iodev.co.uk>,
	David Sterba <dsterba@suse.com>,
	Chris Mason <mason@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: [PATCH 0/8] btrfs: assemble a multi-device root filesystem without an initrd
Date: Mon, 16 Nov 2026 23:43:16 +0100
Message-ID: <20261116224316.11237-10-ismael@iodev.co.uk>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

A multi-device btrfs root filesystem is normally assembled by the device
scanner that an initrd runs before mounting the root.  Without an initrd
nothing runs that scanner, so the root mount names a single device and
the rest of the array is left out.

This series lets btrfs assemble such a root filesystem in the kernel:

  * mount devtmpfs on the initial root before the root filesystem, so
    device nodes exist to open the other devices by name (init);
  * let a filesystem tell whether it is mounting the root device and read
    rootwait, and resolve root=UUID=/root=LABEL= values that name the
    filesystem rather than a partition (init/VFS);
  * scan all block devices for the remaining members of a btrfs root
    filesystem, and wait for all of them to appear before mounting.

The scan and wait are gated on CONFIG_BTRFS_ROOT_SCAN (default y) and
only act on the root mount when the user asked for it with rootwait, so
non-root mounts and systems without the option are unchanged.


Ismael Luceno (8):
  btrfs: add config options for the root device scan
  init: mount devtmpfs before the root filesystem
  init: let filesystems ask whether they are mounting the root device
  btrfs: add a helper to scan all block devices
  btrfs: wait for the root filesystem to have all its devices
  Documentation: btrfs: document waiting for the root filesystem devices
  init: let a filesystem resolve a root device by UUID or label
  btrfs: resolve root=UUID= and root=LABEL=

 Documentation/filesystems/btrfs.rst |  31 +++++
 fs/btrfs/Kconfig                    |  25 ++++
 fs/btrfs/super.c                    | 165 +++++++++++++++++++++++
 fs/btrfs/volumes.c                  | 196 ++++++++++++++++++++++++++++
 fs/btrfs/volumes.h                  |  25 ++++
 fs/filesystems.c                    |  37 ++++++
 include/linux/fs.h                  |  10 ++
 include/linux/root_dev.h            |  14 ++
 init/do_mounts.c                    |  51 +++++++-
 9 files changed, 553 insertions(+), 1 deletion(-)

