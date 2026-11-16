Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.30.189.100
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794869015;
	b=ONmiL8ddMdhcQm0ml3KC8WiV1Alcv0JqjvJUfk9VbgomATG3CmQYtxmFS0YGZixBUmR1
	 b4sjgTS6EXfDhKE8eLHTI8fvZkacDzdovAHYwG8PfcNf1eQVJarZhVgtxU/0mZn31SwVI
	 Whslq6dJrzT2O8QuRbd4Y2dN8EiN5uaJVjwQNVRIUS/BV1uB35VP9pegDWw7jO00nNkPS
	 ub4xRwBypvxxN1ZEz+VM3K09a/Ir5CoJscnyfqeoyitkzHCOR1f4p6nGbTdSHC52QYeIo
	 JS83fEsMF0IvaIV/eAZCLDN4HNCuJegdZJyiIni8sK+s6Ppi6KE+Yp6tXAfVa+BiwMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794869015;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=i0yAYEvuPiSMBvjuTW9H7cIjWMZDwnqjcTEXqfxJWYs=;
	b=OJAQsyBQQrJncSdNC/BJsuvh5yl8uO3Uzd6+DbT4TbfpanD8hOpKIC8l65Bb2qTnO8pz
	 qUUrS6n9HtJFj4XIjFJFBWgnR8xGNhPBf9ppYdN1ZLhzJk1VxnnNa+Pv/yDU/GuPBGr4W
	 BGmqvA8szGdSptWetaUpRMDKdycvAHp2OvlttpZeI8rVetBTa1WCDVXNqVBa+aMWT2h2k
	 1G5iDjyVZUlLM43qdP7yJk/jgxAfptk0IX69HfvOIiir0zMI4TiqgPcxypIXVfO9UL9nC
	 PZI1uMjBfFubxFd93v3BysRlHsFYOVZHWIyCRedwB1olRSG9Psrq6iLPiyVIPfPd8dA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=iodev.co.uk;
	spf=pass smtp.mailfrom=iodev.co.uk;
	arc=none smtp.remote-ip=46.30.189.100
Received: from iodev.co.uk (iodev.co.uk [46.30.189.100])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D4DA606A323;
	Mon, 16 Nov 2026 22:43:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7D4DA606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=iodev.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iodev.co.uk
Received: from localhost (unknown [79.116.217.174])
	by iodev.co.uk (Postfix) with ESMTPSA id 4A1A25E22D1;
	Mon, 16 Nov 2026 23:43:28 +0100 (CET)
From: Ismael Luceno <ismael@iodev.co.uk>
To: linux-kernel@vger.kernel.org
Cc: Ismael Luceno <ismael@iodev.co.uk>,
	Ismael Luceno <iluceno@suse.de>,
	David Sterba <dsterba@suse.com>,
	Chris Mason <mason@kernel.org>,
	linux-btrfs@vger.kernel.org (open list:BTRFS FILE SYSTEM)
Subject: [PATCH 1/8] btrfs: add config options for the root device scan
Date: Mon, 16 Nov 2026 23:43:17 +0100
Message-ID: <20261116224316.11237-11-ismael@iodev.co.uk>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261116224316.11237-10-ismael@iodev.co.uk>
References: <20261116224316.11237-10-ismael@iodev.co.uk>
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

Add Kconfig options to enable scanning all block devices for the remaining
members of a multi-device btrfs root filesystem when no initrd is available
to run the device scanner, plus a configurable polling interval for the scan.

The scan relies on devtmpfs device nodes and is used by the root-device wait
logic that follows in this series.

Signed-off-by: Ismael Luceno <ismael@iodev.co.uk>
Signed-off-by: Ismael Luceno <iluceno@suse.de>
---
 fs/btrfs/Kconfig | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/fs/btrfs/Kconfig b/fs/btrfs/Kconfig
index 4b10d78ed99b..c8ce06c9c3e7 100644
--- a/fs/btrfs/Kconfig
+++ b/fs/btrfs/Kconfig
@@ -82,6 +82,31 @@ config BTRFS_ASSERT
 
 	  If unsure, say N.
 
+config BTRFS_ROOT_SCAN
+	bool "Btrfs multi-device root scan support"
+	select DEVTMPFS
+	depends on BTRFS_FS
+	default y
+	help
+	  When btrfs is the root filesystem and rootwait is given, look in the
+	  kernel for the rest of a multi-device filesystem.  This is for systems
+	  without an initrd to run the device scanner.  It finds devices through
+	  the device nodes that devtmpfs provides.
+
+	  If unsure, say Y.
+
+config BTRFS_ROOT_SCAN_INTERVAL_MS
+	int "Interval between device scans while waiting for root devices (ms)"
+	depends on BTRFS_ROOT_SCAN
+	range 1 10000
+	default 100
+	help
+	  How often, in milliseconds, to re-scan the block devices while
+	  waiting for all of a multi-device root filesystem's devices to
+	  appear.  Only used together with CONFIG_BTRFS_ROOT_SCAN.
+
+	  If unsure, say 100.
+
 config BTRFS_EXPERIMENTAL
 	bool "Btrfs experimental features"
 	depends on BTRFS_FS
