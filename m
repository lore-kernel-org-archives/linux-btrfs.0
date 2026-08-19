Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9498208D0;
	Wed, 19 Aug 2026 02:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787108119; cv=none; b=bZTZGoThinSPONTf67G9Y4kgPVOdxqjGfUbiuFCUi3igsL9hvQZdDGNGSob+plcfbPkL6lt39WnzQhZUTW4crVs2YGyBbiYo1NYI5AT3JaSTmSxn+aLCGDeFTedDOMPt/2ToTwd2hhRT8z2ObAm9MwdgxZi9krJNJzRHdw1Z8hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787108119; c=relaxed/simple;
	bh=znnZbSer3Gl6m1nbz1sbn1IPZHtdo7O1ofXJWYCSqZM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=RCdhswvmr0998ZIq4h+hLMgy1Bhe1BPD3SsO+bALBBVjN/ZGJa4zaMd8RO2Dq2i4jyerJx3pP0WbbbPkguESulc5jvig3peP6ylD2a/I6ShiV7DAFscESjEFAAlLlYqOqEik/uYswFKw/6R1kg/smAMtFVqBbx3TohfFoKOpZdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=CLFZeOaR; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="CLFZeOaR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=d0
	DkPMnng1za6OeXdqOUkqxnNlYbzmJYo2xv/SwQru4=; b=CLFZeOaRlOQwW1pMzl
	aeCHNEG2LSOclQf+SuibFt+Y39dFhClPk7xob9MwZavqr39JSW64HNZ5qbG4cU3O
	cIyyqYM6KNud81ZOfHcHa1cz4+j9WoI5KSTdNwcw92NXU9O555nELJgR72K+slca
	J5qyj0kzAe5KVnGqgKY67rsJg=
Received: from localhost.localdomain (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgAnxADwGoVqdX4FMA--.6093S2;
	Wed, 19 Aug 2026 10:54:44 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: clm@fb.com,
	dsterba@suse.com
Cc: quwenruo.btrfs@gmx.com,
	linux-btrfs@vger.kernel.org,
	io-uring@vger.kernel.org,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [PATCH v3 0/5] btrfs: fix io_uring encoded IO cleanup
Date: Wed, 19 Aug 2026 10:54:31 +0800
Message-Id: <20260819025436.1949152-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgAnxADwGoVqdX4FMA--.6093S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Kw4xKry5XFW7tr1UXF1xuFg_yoW5Jryxpr
	W3WF43JrWDA348tF4kKa15GryrXws7Ja17J39aqw4xAa45AF9ayr4IkasYgryDXFyrJay8
	XFyYqFWqk34DZaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UdcTLUUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbCwha-UGqFGvbN-wAA3K

Hi,

Fixes for the io_uring ENCODED_READ / ENCODED_WRITE cleanup paths.

1. Always return -EIOCBQUEUED after endio so the caller and
   btrfs_uring_read_finished() do not both clean up.

   Link: https://lore.kernel.org/linux-btrfs/20260630091609.3414-1-samsun1006219@gmail.com/

2. btrfs_uring_read_extent() failure skipped kfree(data->iov).

3. Unlock inode/extent in the caller on read-extent failure.

4. Do not stash encoded data in the cmd PDU across -EAGAIN.

5. Drop the unused REISSUE restore.

v2 also exported __import_iovec() and passed IO_URING_F_COMPAT.
That is not a bug with the current io_uring thread setup:
create_io_thread() copies TS_COMPAT, so import_iovec() already
sees compat iovecs. Passing the flag explicitly would still be a
cleanup, but this series does not take it.

Testing:
- xfstests btrfs/333 passed.
- kmemleak after dropping the ring on NONBLOCK encoded write/read:

  unreferenced object (size 512):
    comm "btrfs_uring_eag"
    __kmalloc_cache_noprof+0x38f/0x4a0
    btrfs_uring_encoded_write+0x78d/0x1790 [btrfs]
    btrfs_uring_cmd+0x142/0x1d0 [btrfs]
    io_uring_cmd+0x296/0x5e0

  unreferenced object (size 512):
    comm "btrfs_uring_eag"
    __kmalloc_cache_noprof+0x38f/0x4a0
    btrfs_uring_encoded_read+0x89a/0x12b0 [btrfs]
    btrfs_uring_cmd+0x173/0x1d0 [btrfs]
    io_uring_cmd+0x296/0x5e0

  After 4/5 the same repro is clean.

Changes in v3:
- Drop the __import_iovec / IO_URING_F_COMPAT patches. 
- 3/5: drop a leftover goto out_fail from v2.

Changes in v2:
- unlock in the caller (Qu Wenruo)
- address further error-path issues raised on the v1 review
- export __import_iovec(); use IO_URING_F_COMPAT
- no PDU stash across -EAGAIN; drop REISSUE helpers

v2: https://lore.kernel.org/linux-btrfs/20260806085041.1410576-1-yangxiuwei@kylinos.cn/
v1: https://lore.kernel.org/linux-btrfs/20260805021135.1896609-1-yangxiuwei@kylinos.cn/

Yang Xiuwei (5):
  btrfs: always return -EIOCBQUEUED after btrfs_uring_read_extent_endio
  btrfs: free iov when btrfs_uring_read_extent fails
  btrfs: unlock inode and extent in caller when uring read extent fails
  btrfs: don't stash uring encoded data across -EAGAIN
  btrfs: drop unused uring encoded IO REISSUE stash helpers

 fs/btrfs/inode.c |  7 +++----
 fs/btrfs/ioctl.c | 39 ++++++++++++++-------------------------
 2 files changed, 17 insertions(+), 29 deletions(-)

-- 
2.25.1

