Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C225B42316A
	for <linux-btrfs@vger.kernel.org>; Wed, 13 May 2026 12:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778675735; cv=none; b=cBEzMCYmlYo7mMEWoYZBREOP7X7EAmU5mXpQiERKIDE63ZDL76GKB1Z/GYSqyAnVwL6Aotfs38KkCmnTDWxnhiFims9rAngKik+O9Pz4BAu+NT0BjiMJeWf6Eg9rlMYNbOBWFDhbbXvEi4a9aOQ/jZtST0KorobXM4bRf7Zq7NE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778675735; c=relaxed/simple;
	bh=hA4tg1dakk6so3LcNWgFnzajUcqldDxG/1xNzPT6lrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EGl87srRmJW4uAUA5eE5hQp8/9dvJ/g68mYsawRIlh6qzPS4J7VRcqbpjPbpI0qLCUenAm1sjBUfL493/8M4dISDQ1grzcyatl25EYb8al/1w//acpCqD/dQyLd6zXx3lJaQWceESB5EvAlTvjXZy/RHZvrEOSRlqHblzepWXTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=T2S/HRK1; arc=none smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="T2S/HRK1"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1778675734; x=1810211734;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hA4tg1dakk6so3LcNWgFnzajUcqldDxG/1xNzPT6lrc=;
  b=T2S/HRK1p+ZIdS8xuyKFC8bXebP3+GteqSqHkLP7Xo+SSu3Bxb/otCaA
   Dz8hDc/qpsW/iqjycgIcxXyQTGRQsOE6u3bfqyOxh0aY91Yygl1EiXefj
   mw2pPXohoNGNc0Rx4fCv2sYb4zjDyEBwQW0w8P0+q+5wbi1RyW+ali57L
   X3xgK8Fw9JlV7olzMN4KiisSwKMzDJd+3w3w6yT/A/RM4VG1jUkP13MmB
   +RpTYYjZfu/DtRvPawZIbTiL2xRncDEOdxIhvu0jOpA0DWrdWgDD8Vu0Z
   ubpb/AnoVWrxpF7eD1eVgJgOXGKmW44rIC0+Wc8utiRF+Or7xC1VZ8v5W
   Q==;
X-CSE-ConnectionGUID: 5fzRv7qcQbGiYtuMilFWVQ==
X-CSE-MsgGUID: ezCWARvgR/OPALQWplc1xA==
X-IronPort-AV: E=Sophos;i="6.23,232,1770566400"; 
   d="scan'208";a="146869039"
Received: from unknown (HELO uls-op-esad2-o.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 13 May 2026 20:35:26 +0800
X-CSE-ConnectionGUID: gUDWV5kYQBCi573mljcajA==
X-CSE-MsgGUID: nDvspb8uRD6rpVrlVm2mDA==
IronPort-SDR: 6a047008_iGk0mY/eUxj03XPPnyl+Q5a4IIkKjk6nxf6fsaLXxjXSvg+
 4FlYBGGJoQl3C/vfCnwHTZRaE0eMRpDW3P8Z6Zg==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad2-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 May 2026 05:35:19 -0700
X-CSE-ConnectionGUID: cH8sCtBITFWxmbJKTU7RgQ==
X-CSE-MsgGUID: aylkbbOiTUyG5+3Rod3MUg==
WDCIronportException: Internal
Received: from wdap-6xonuiesoc.ad.shared (HELO neo.wdc.com) ([10.224.28.49])
  by uls-op-esai1-o.wdc.com with ESMTP; 13 May 2026 05:35:19 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Hans Holmberg <Hans.Holmberg@wdc.com>,
	Boris Burkov <boris@bur.io>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [RFC PATCH 7/7] btrfs: zoned: add RECLAIM_ZONES and RESET_ZONES to first async reclaim loop
Date: Wed, 13 May 2026 14:34:45 +0200
Message-ID: <20260513123445.43197-8-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260513123445.43197-1-johannes.thumshirn@wdc.com>
References: <20260513123445.43197-1-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On zoned filesystems, when waiting for space tickets during data
relocation, the async reclaim flush state machine may starve if
RECLAIM_ZONES and RESET_ZONES states are not executed early in the flush
sequence.

Currently do_async_reclaim_data_space() only executes RECLAIM_ZONES and
RESET_ZONES in later flush states (FLUSH_DELALLOC and beyond), but by
the time these states are reached, the ticket wait may have already
deadlocked waiting for space that can only be freed by zone reset.

Fix this by adding RECLAIM_ZONES and RESET_ZONES to the first async
reclaim loop (FLUSH_ALLOC) for zoned filesystems, ensuring zone reset
happens early enough to free space for pending allocation tickets.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---

This patch was AI assisted and I'm not sure this is the correct thing to
do (the flushing, not the use of AI), hence the RFC tag. 

 fs/btrfs/space-info.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index ec811a77ebb1..a1235f114f3e 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -1451,6 +1451,17 @@ static void do_async_reclaim_data_space(struct btrfs_space_info *space_info)
 
 	while (!space_info->full) {
 		flush_space(space_info, U64_MAX, ALLOC_CHUNK_FORCE, false);
+		/*
+		 * For zoned filesystems, also run RECLAIM_ZONES and RESET_ZONES
+		 * in the first loop to avoid starvation. Zoned filesystems have
+		 * sequential write requirements, so space cannot be reused until
+		 * zones are reset. Running these states early ensures zones are
+		 * reclaimed and reset before we get into a starvation situation.
+		 */
+		if (btrfs_is_zoned(fs_info)) {
+			flush_space(space_info, U64_MAX, RECLAIM_ZONES, false);
+			flush_space(space_info, U64_MAX, RESET_ZONES, false);
+		}
 		spin_lock(&space_info->lock);
 		if (list_empty(&space_info->tickets)) {
 			space_info->flush = false;
-- 
2.54.0

