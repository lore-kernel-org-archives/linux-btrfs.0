Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.30.189.100
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794869021;
	b=iXNh4Z9dY047QrGP+VUJi5eTWMc1CC6h5fg+neW4T3HNqFkQdX/XPF2Td2deXTngiNjo
	 S+z1Vih4Xxk6ALbk6IlkIAXIQZgKZQr5GVyv10BJXcH1SiW/CtG52/W+gLJsurtV9oQtu
	 sNQYM0sMEe93o+MXuixv47hx1yT+flSD4/oX2bxOWZgaNMIIi/cMNatTa5TMEGQFAnfKn
	 4E8t0lkJt4zAWmmfau/FSTumMVt7wHT4Y7rv8P/BZo5Mp99dlPgo6D/+mMeYlbSbFZ/Pp
	 OStAgIQ0HNjim5k8Lh7q+9EfnnDieDmu0/yGGKbyj6MQGZudyDLh5d21xGqjRMc39EQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794869021;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=e0lXXEZC9dHIaVd2wKZITazVzsaitYm0GW6OeFVOYAU=;
	b=J7xykU1f76P2cwrBriOasaXwdHe1SM96mdvrjWZ3qlUqYl7KOGTVsXaFGR/rvdeLLLPa
	 sSznB7PPhAc+A+1HyQARzLEe9IwqR9+aW4CCU8fRdG9CMHTxIV6xG7KfJYSMgcaaGhLQc
	 5bJqyeCyOMGtzi43hQfOGhqtg9gcYI57HPRm8bAoE5NTIkZQ0goag1ANLbUEvsGk1rZLD
	 OPvmXuu6BOtvSuwl1fz1XXPEipboCw+lnKtwfDkjZt7ISzcxKTsIzw7CiCpRFHWpmNWzO
	 rG0HWftgL3qHBeK1LgLKRz4ORM/kHGVPUGLggvfISzI+hI0RxtI5nqPIALJ0/sKlznw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=iodev.co.uk;
	spf=pass smtp.mailfrom=iodev.co.uk;
	arc=none smtp.remote-ip=46.30.189.100
Received: from iodev.co.uk (iodev.co.uk [46.30.189.100])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A147B606A89D;
	Mon, 16 Nov 2026 22:43:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A147B606A89D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=iodev.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iodev.co.uk
Received: from localhost (unknown [79.116.217.174])
	by iodev.co.uk (Postfix) with ESMTPSA id E1EA35E22DC;
	Mon, 16 Nov 2026 23:43:39 +0100 (CET)
From: Ismael Luceno <ismael@iodev.co.uk>
To: linux-kernel@vger.kernel.org
Cc: Ismael Luceno <ismael@iodev.co.uk>,
	Ismael Luceno <iluceno@suse.de>,
	David Sterba <dsterba@suse.com>,
	Chris Mason <mason@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	linux-btrfs@vger.kernel.org (open list:BTRFS FILE SYSTEM),
	linux-doc@vger.kernel.org (open list:DOCUMENTATION)
Subject: [PATCH 6/8] Documentation: btrfs: document waiting for the root filesystem devices
Date: Mon, 16 Nov 2026 23:43:22 +0100
Message-ID: <20261116224316.11237-16-ismael@iodev.co.uk>
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

Document the whole feature, including the part btrfs opens devices by
their /dev name and so cannot run the search at all without devtmpfs
mounted.  Say that too, and what happens when it is not, rather than
leaving a boot that stops with nothing in the log.

Signed-off-by: Ismael Luceno <ismael@iodev.co.uk>
Signed-off-by: Ismael Luceno <iluceno@suse.de>
---
 Documentation/filesystems/btrfs.rst | 31 +++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/Documentation/filesystems/btrfs.rst b/Documentation/filesystems/btrfs.rst
index a81db8f54d68..9dcdb87a53c3 100644
--- a/Documentation/filesystems/btrfs.rst
+++ b/Documentation/filesystems/btrfs.rst
@@ -33,6 +33,37 @@ The main Btrfs features include:
     * Read/write metadata verification
     * Online resize (shrink, grow)
 
+Multi-device root filesystem without an initrd
+----------------------------------------------
+
+A multi-device btrfs filesystem is normally assembled by the device scanner in
+userspace, which the initrd runs before mounting the root filesystem.  Without
+an initrd there is nothing to run that scanner, so the root filesystem is
+mounted from the single device named by ``root=`` and the remaining devices are
+left out.
+
+Given ``rootwait``, btrfs finds the rest of them during the root mount.
+
+    root=/dev/sda1 rootwait
+
+The devices are then given the time ``rootwait=`` specifies, or indefinite for
+``rootwait`` with no value.  The search repeats at the interval set by
+CONFIG_BTRFS_ROOT_SCAN_INTERVAL_MS (100 ms by default) until they are
+all found, and is not made for any other mount: a filesystem mounted later has
+been given the devices it needs, or is being mounted degraded on purpose.
+
+When the wait runs out btrfs mounts whatever it has, which for a redundant
+profile usually means the mount fails and the kernel panics; a warning is
+printed before that happens.  Without ``rootwait`` there is no wait at all, and
+an incomplete filesystem is mounted as usual.
+
+The search needs the device nodes in ``/dev``, which come from devtmpfs.  Where
+that is not mounted the search cannot start, and btrfs says so and gives up
+rather than waiting for something it can never find.
+
+The search is built with ``CONFIG_BTRFS_ROOT_SCAN``, which depends on
+``CONFIG_DEVTMPFS`` and is on by default.
+
 For more information please refer to the documentation site or wiki
 
   https://btrfs.readthedocs.io
