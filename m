Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 182981F4611;
	Sun, 12 Jul 2026 14:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783866324; cv=none; b=kNtzvTdvEO6+hUY8EnJJg7tZTi7S1/9lHemYjA+m70umA5b94CI+HfwMzYUdifozqsi1vZx4yhflhFZsWvOvPTqkppvlAyz19OF752/vGsF8KFhSvmvLAeY4qojm/+NQcTVBe5aRXmB8gu/an4a/HXYGdbfGsCbDmnA9M94wbI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783866324; c=relaxed/simple;
	bh=qaXEC32MfQGt8UOFvwvDkdREPyI2tYc6ieR1JjlanBY=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=b6z2f0DK1Cql6rC7L8J3Lk9N8IrllwqauyJrsOA6RlJtLjwt99cexkd8TraLWCIvmAxL2SBOQHR9iID7fcBxPP/bgVKsdU/aKizkvn84+veZOv4o/5mh0yUntHsvRglAoM0UWB5+sEExb/P7JhBaGJY0VW2VIWIdhAGkrysnuiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cv+1Z5rC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cv+1Z5rC"
Received: by smtp.kernel.org (Postfix) with ESMTPS id AC0C6C2BCB7;
	Sun, 12 Jul 2026 14:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1783866323;
	bh=qaXEC32MfQGt8UOFvwvDkdREPyI2tYc6ieR1JjlanBY=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=Cv+1Z5rCH3aig77YeegRGn/McOg9Lv1G8eUwb4/A+yFKuM10V2iQj0aAYQwbraq38
	 H5v0sqLOUsshlnhBll93rUWfUTLDE7hiAS9NOoQAqNa7R/2BBzxtfD5sEonyK2DkdH
	 caBrBpM3gJxs6cvSi/f6URYM2p7dWfiSub9agrVMXb3xAiaacXLyXli8gp2UL94v3+
	 Zr+JLA/5iPOlbW59MRk0kioxxc95uC/TAjQpgzDl8d65sN1mfdIJhyxQ8TDa6Xe47E
	 FCmD7NGLfOOozLztLRRLcXPaLqUUiZ8FWj8qm3PWud+UQ4KbZzIc/WDeiXlhY6jkMM
	 A9NaTaHf3BYMQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88BA6C43458;
	Sun, 12 Jul 2026 14:25:23 +0000 (UTC)
From: Daan De Meyer via B4 Relay <devnull+daan.amutable.com@kernel.org>
Subject: [PATCH 0/2] btrfs: allow reflinks into NODATASUM files
Date: Sun, 12 Jul 2026 16:25:12 +0200
Message-Id: <20260712-reflink-into-nodatasum-v1-0-9f27ef836073@amutable.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yWMQQ6CMBBFr0JmbROoBoJXMS6mZSqjMjWdYkwId
 7fV5ft5/22glJgUzs0Gid6sHKVAd2jAzyg3MjwVBtvavh06axKFJ8vDsORoJE6YUdfFYAhjb8N
 xGE8E5fwqHn9+4cv1z7q6O/lca9VwqGRcQvFznRbUTAn2/QvP6psfkwAAAA==
X-Change-ID: 20260712-reflink-into-nodatasum-aff962f3794e
To: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Daan De Meyer <daan@amutable.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783866322; l=1580;
 i=daan@amutable.com; s=20260712; h=from:subject:message-id;
 bh=qaXEC32MfQGt8UOFvwvDkdREPyI2tYc6ieR1JjlanBY=;
 b=vNqE8SGJ6710yEKKP1HPWKT1TlfVE9R+k90beYLrBA2RExdy4fn/nIlYELTYqZaTyOBgESCOc
 IzHU400w4eXB8ifm3bSZ4kHuhWe8FcPtxX+w6JG5/4IOQX9GYI5m2OV
X-Developer-Key: i=daan@amutable.com; a=ed25519;
 pk=I1l+WwrtmzRgofA5SQ1wTuJi18fjh91w+f5uRkFeZEA=
X-Endpoint-Received: by B4 Relay for daan@amutable.com/20260712 with
 auth_id=868
X-Original-From: Daan De Meyer <daan@amutable.com>
Reply-To: daan@amutable.com

The primary use case for this series is building a NOCOW VM image from
individual partition images that are COW and checksummed. Today those
partitions cannot be cloned into the NODATACOW and NODATASUM destination,
so tools fall back to a full copy. This makes provisioning slower and
duplicates all of the image data up front.

Allow cloning and deduplication from a checksummed file into a NODATASUM
file. The VM image can then share extents with the partition images.
Existing checksummed extents are COWed once when modified, protecting the
source checksums, while newly allocated extents use the destination's
normal NOCOW behavior.

The reverse direction remains rejected because the destination would
expect checksums that do not exist.

Patch 1 prevents swap activation from bypassing the COW protection when a
NODATASUM file references checksummed extents. Patch 2 relaxes the reflink
restriction in the safe direction.

The xfstests branch is available at:
https://github.com/kdave/xfstests/pull/6

Signed-off-by: Daan De Meyer <daan@amutable.com>
---
Daan De Meyer (2):
      btrfs: reject swapfile activation if any extent has checksums
      btrfs: allow reflinking from checksummed files into nodatasum files

 fs/btrfs/inode.c   | 29 +++++++++++++++++++++++++++++
 fs/btrfs/reflink.c | 18 ++++++++++++++----
 2 files changed, 43 insertions(+), 4 deletions(-)
---
base-commit: cab9e339cfbc1a4e075e53e281dfb00391e1a6bb
change-id: 20260712-reflink-into-nodatasum-aff962f3794e

Best regards,
--  
Daan De Meyer <daan@amutable.com>


