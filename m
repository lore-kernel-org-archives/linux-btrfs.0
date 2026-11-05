Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793880473;
	b=TWPxKhaQJ/Pi7PU29iayLHom6hiZJf7911D2gJQe3HsU/yD1K5JBruOkqRul5UnX/19F
	 Yk1r/gfNGobz70UTaFzAncA2KFG9NRkud+oBb3SkrGWub45cRzkHahPnvaYnbgW+EO/2M
	 H44rYqMS/iSGZJ//2H7J0SIfmmXl8x3xgKDfnlfgZd1fzq09CRiAUz7tvEv0xywi61lMX
	 liCSJE1ERyzuMQOQolPQPhmu1MbvHaoGjDzCPfs+g/xQLX4EH/l1A8/lpTHWxHqhlvm3n
	 VYeHqxH7JWVbMceHdgACusY4whN2SU3W0faiJPNZRWEeitvTYsyXjlmXdazftGxxIiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793880473;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:Date:From:To:Cc:Subject:Message-ID:
	 MIME-Version:Content-Type:Content-Disposition;
	bh=P/GlmUjHdK49hN7w1Asyw8OwEiiwg391G3XQYJFs6CI=;
	b=RPD68eM69o3sBB2yJoNKeC9Wu8XQUwDTgxp36x9bQghuosoYzMh0u4UYqSPbgKUw3ZSW
	 lGTTX5a1tNagCAREr+kp+iR2BYW6Mf21bHWmn6Qt61Ro0DNii8ciEf9WHm9wjgU8+Y9RD
	 jWO3yjSkWafh0YX6aDnzwYQO8NLZpsqiG5kxlstGzdK7/AZaqUxaW303fTAMctDb+Bl8s
	 tKOxAorqI0QAFXmUFSDyGra7A6BizPdLg5VZ9BwsR9tV4FIbywNF2jL9h3FM9/Pt0zRJS
	 5iQ+7/cnd5+rxfN4tlVqlsVBZf9UQf6aqGIqwqGzd0QGbcNAUVaIz8c9U4uAicJHs4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=debian.org;
	spf=pass smtp.mailfrom=gmail.com;
	arc=none smtp.remote-ip=209.85.128.178
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 898FD606A31B
	for <linux-btrfs@vger.kernel.org>; Thu,  5 Nov 2026 12:07:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 898FD606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-8b312be5de8so19997297b3.2
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Nov 2026 04:07:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793880471; x=1794485271;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=P/GlmUjHdK49hN7w1Asyw8OwEiiwg391G3XQYJFs6CI=;
        b=yL1ZGxPSBxT4kjKj7suaWHuoQ+qbzNlMDtZ8gRsrlowqXLiP0KvbYAtRXZsWmvw+7v
         XafL9o/wwaZfhZzK0bDJ/+Pr6oe9O6RwkyOS16vlikb5MzFFzYQ9Qw2xEBtfyzUxUg0V
         IAsppU81VyctEZ6OTZwutkqUUD70ivKO98EDdXx7IKEUGkB6lj5fmroXm467shC68OLO
         JZAG9sCX6GTZbujdNjkYC7kAzEJ9dXWsXidx0PmCnD/C4FPip0TWp37oUPc367x0MRCa
         aqm36f3MEZWyqch9j2iEFLsXDUikzOSphGRmjTRjQGtnkGzd7XT6EQlyiNO8sL9CQwbJ
         ACUg==
X-Gm-Message-State: APuU4Z82GpQNu806xuBkzpBVaPnjMG3nIv3btZjxexiQFF5D2+DGeE79
	lduB2F1hPXrQE47SSkVWG8PVMIRQ5GLhoXtQzdkK07heAwsqxEhE3mf2U6ExJA==
X-Gm-Gg: AYBFou31L9ceSO5U75Ad2gK7ha9qTmgPT/IcPy30Ku2cIU8NGEvbUU7+nPEBapw+H/U
	zaOwAFMumeRznLGa/vckQxY5IY+X1MxlILhWD3kFrh7JjzfEkjrMGMwZRz47G1D8hSRAKQLvxsB
	hLZ3FaVmRghRegqlTw47ke0EbfaQ4KJlyADpV9ZhGUqkVOuKXV065dgLh6RiPqG5InvvkV8pHzk
	Ys/Nga/Thj+J817zboVRdN9kVjS1YztwFAThNrCVRLQV27/tSotdb114X9UkDSTJcqM+6VWj+Fj
	J7ZO9m0Mksjcc6Rg8MB5GVLEu3Mvs/6+7pUjtASEkH44bDbr88z7XDyF8WXHsJMv72prXiryK7P
	yQKseJAA0iEgnyqA0cQsDqpwswnHv1/P6XGziplQ9E+2V2l6hcZkeitLcTEIaDaVjN84AIkpa3F
	V8w14oB3PR8i3cEO5FFlJ+JxN+9w5IwELEWghB5yKqP0Eo42fkwnQBUjpUeMXSt1VmN65wuZD9B
	hEuZ0Eg3wAp7Iuk1rSLOZXJDJASzPN9O2BdgJWECfijuOSNbH3jgZU0d81qs+wlU0Bqk/TtBJ3e
	VCTnsXstc9w0/41gw8w=
X-Received: by 2002:a05:690e:1385:b0:67b:f101:ff2c with SMTP id 956f58d0204a3-67bf102166amr2388495d50.96.1793880471605;
        Thu, 05 Nov 2026 04:07:51 -0800 (PST)
Received: from gmail.com ([2a03:2880:24ff:8::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67bedf232ccsm3306902d50.3.2026.11.05.04.07.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 04:07:51 -0800 (PST)
Date: Thu, 5 Nov 2026 04:07:49 -0800
From: Breno Leitao <leitao@debian.org>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
	Qu Wenruo <wqu@suse.com>, Filipe Manana <fdmanana@kernel.org>, Boris Burkov <boris@bur.io>, 
	Atish Patra <atish.patra@linux.dev>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, leitao@debian.org
Subject: bug: btrfs: direct IO fallback racing with in-flight direct IO fails
 fsync
Message-ID: <auxv7Tg0xSq5yHmb@gmail.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

Atish reported that arm64 production hosts (64K pages, 4K blocks) that
keep VM disk images as NOCOW files on btrfs, opened with O_DIRECT, on
7.x based kernels, and it still reproduces in linux-next as of
next-20261104:

  Page cache invalidation failure on direct I/O.  Possible data corruption due to collision with buffered I/O!

Besides the message, dio_warn_stale_pagecache() records -EIO in the
mapping, so the next fsync() on the image fails. The message blames the
application for mixing buffered and direct IO, but every write here is
O_DIRECT: the buffered writes come from btrfs itself, when it falls back
for writes that are not 4K aligned.

It does not look like a regression, since the fallback never waited for
in-flight direct IO. 64K pages make it easy to hit, as a folio then holds
16 blocks. Since e9b7b9d9e78e5b ("btrfs: use IOMAP_DIO_BOUNCE flag
instead of falling back to buffered IO"), COW files are exposed too.

I was able to come up with a reproducer that hits the issue within
seconds with 64K pages. With XFS on a loop device backed by such a file,
standing in for the VM, XFS shuts down on "log I/O error -5":

        https://github.com/leitao/btrfs-dio-fallback

My robot identified this as the root cause:

1. Task A has an async O_DIRECT write in flight to one 4K block of a 64K
   folio. iomap invalidated the page cache before submitting it, and the
   inode lock was dropped.
2. Task B issues an O_DIRECT write whose offset, length or buffer is not
   4K aligned. btrfs_direct_write() falls back to btrfs_buffered_write(),
   which does not wait for in-flight direct IO, and dirties another block
   of the same folio.
3. Task A's write completes. kiocb_invalidate_post_direct_write() finds
   the folio dirty, so invalidate_inode_pages2_range() fails with -EBUSY
   and dio_warn_stale_pagecache() records -EIO. The next fsync() fails.

ext4 fixed the same race in 15cdefd0c052 ("ext4: drain in-flight DIO
before buffered write fallback"), and ext2, ntfs and exfat are getting
the same fix. Doing the same in btrfs_buffered_write() for the fallback
case makes the reproducer clean, and I can send that patch if it looks
like the right direction.

This patch is a copy of the fixes above (from other FS) and make the
reproducer happy.

commit 16cd17d1e8205f9f86b8da0a9b1ccefdb2665764
Author: Breno Leitao <leitao@debian.org>
Date:   Thu Nov 5 02:59:39 2026 -0800

    btrfs: drain in-flight direct IO before buffered write fallback
    
    When btrfs_direct_write() cannot do a write as direct IO, because the
    offset, the length or the user buffer is not aligned to the sectorsize,
    or the range has compressed extents or page cache, it falls back to
    btrfs_buffered_write(). That dirties the page cache without waiting for
    direct IO still in flight from other tasks:
    
    1) Task A submits an async direct write to block 1 of a folio. iomap
       invalidates the page cache in the range and submits the bio, and the
       inode lock is dropped.
    2) Task B issues a 512 byte O_DIRECT write to block 0 of the same folio.
       btrfs_direct_write() falls back to btrfs_buffered_write(), which
       dirties the folio.
    3) Task A's write completes. kiocb_invalidate_post_direct_write() finds
       the folio dirty, invalidate_inode_pages2_range() fails with -EBUSY,
       and dio_warn_stale_pagecache() logs:
    
       [    2.048568] Page cache invalidation failure on direct I/O.  Possible data corruption due to collision with buffered I/O!
       [    2.048574] File: /tmp/diorepro.JTCKpJ/block.img PID: 260 Comm: kworker/11:1
    
       It also records -EIO in the mapping, so the next fsync() fails.
    
    The two writes do not touch the same bytes, they only share a folio.
    With 4K blocks on 64K pages a folio holds 16 blocks, so this is easy to
    hit there. Meta's arm64 hosts with 64K pages hit it with VM disk images
    that are NOCOW files on btrfs, opened with O_DIRECT. In a test, XFS on a
    loop device with direct IO on such a file gets EIO on a log write and
    shuts down within seconds.
    
    Wait for in-flight direct IO before the fallback dirties the page cache,
    as ext4 does since commit 15cdefd0c052 ("ext4: drain in-flight DIO
    before buffered write fallback"). btrfs_buffered_write() holds the inode
    lock exclusively there, so no new direct IO can start until the write is
    done. NOWAIT writes never get there, as btrfs_direct_write() returns
    -EAGAIN for them before falling back.
    
    A reproducer that keeps 4K libaio O_DIRECT writes in flight while other
    threads issue 512 byte O_DIRECT writes to the same folios of a NOCOW
    file got 1123 fdatasync() EIOs in 10 seconds on a 64K page VM, and none
    with this patch.
    
    Fixes: f85781fb505e ("btrfs: switch to iomap for direct IO")
    Reported-by: Atish Patra <atish.patra@linux.dev>
    Signed-off-by: Breno Leitao <leitao@debian.org>

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index f978c6524aa03f..2017a96814d857 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1334,6 +1334,14 @@ ssize_t btrfs_buffered_write(struct kiocb *iocb, struct iov_iter *iter)
 	if (ret < 0)
 		return ret;
 
+	/*
+	 * A direct write that fell back to buffered IO must not dirty folios
+	 * while direct IO is in flight: its completion fails to invalidate
+	 * them and records -EIO in the mapping.
+	 */
+	if (iocb->ki_flags & IOCB_DIRECT)
+		inode_dio_wait(inode);
+
 	/*
 	 * We can only trust the isize with inode lock held, or it can race with
 	 * other buffered writes and cause incorrect call of
