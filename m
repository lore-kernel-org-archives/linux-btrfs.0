Received: from mail.burntcomma.com (mail2.burntcomma.com [217.169.27.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F4217244687
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Apr 2026 14:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.169.27.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776867080; cv=none; b=RzpPFHYzAKdVrQrrfJP5GI7xiZ4ATB0+SF7YC+oRhfnX2rLoF8QK4YbSkwJPa1aO5t/c9gKuo+R5g4E9nkvwcnzIXrpnIga1/T71uADZO+hqChN9R191YkEWYx3alv/jxVxMRq3QgeN4dieNTmQNXd9Eu4PC9+zdDfplg9wZHGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776867080; c=relaxed/simple;
	bh=rEnkjjl3zIr2s8ICDm42RaVDMqVpfu1Ji1McIduqxc8=;
	h=From:To:Cc:Subject:Date:Message-ID:Mime-Version; b=V49msfwVz9t49KeL3sJPM8hlE8+rna3LW+wWcINbR06pH20IhC/kYIMIVgbuVFmfwMGnQ370bNjToUbxMFJ3a5npKHtaZPduBcs73HyVmecobNQF785pj5sN5uWt98Pgn7/E7nanXXL7ZbJIXDXreJtCrCWYfWX3YGW48y9KpxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com; spf=pass smtp.mailfrom=harmstone.com; dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b=CerqtKD5; arc=none smtp.client-ip=217.169.27.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=harmstone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b="CerqtKD5"
Received: from beren (beren.burntcomma.com [IPv6:2a02:8012:8cf0:0:ce28:aaff:fe0d:6db2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.burntcomma.com (Postfix) with ESMTPSA id 7CD65320ADC;
	Wed, 22 Apr 2026 15:03:40 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=harmstone.com;
	s=mail; t=1776866620;
	bh=bvCixvJijhm88KqYGAyNrK9x/9T9tlR+yS1Dm481l2M=;
	h=From:To:Cc:Subject:Date;
	b=CerqtKD5frLSYxEpq7qmxs48VYw6Dv1wS331V1uqpakB8Yrecw6897k2cYYQVX4UG
	 tS9qdp+1FJ/EIHFdmPqtpkWEhk1DeTU1uSi1CgRqcmZdpEtGkoY7XK+jhFcGN1CQYK
	 zTOYxCdZak9+Ee5NikEjV3MiWrTgmaUxp0YKLRDQ=
From: Mark Harmstone <mark@harmstone.com>
To: linux-btrfs@vger.kernel.org
Cc: josef@toxicpanda.com,
	boris@bur.io,
	Mark Harmstone <mark@harmstone.com>
Subject: [PATCH] btrfs: don't force DIO writes to be serialized
Date: Wed, 22 Apr 2026 15:03:35 +0100
Message-ID: <20260422140339.417238-1-mark@harmstone.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit

Before btrfs switched to the new mount API in 2023, we were setting
SB_NOSEC in btrfs_mount_root(). This flag tells the VFS that the
filesystem may have files which don't have security xattrs, enabling it
to do some optimizations.

Unfortunately this was missed in the transition, meaning that IS_NOSEC
will always return false for a btrfs inode. This means that
btrfs_direct_write() calls will always get the inode lock exclusively,
meaning that DIO writes to the same file will be serialized.

On my machine, this one-line change results in a ~59% improvement in DIO
throughput:

Before patch:

  test: (g=0): rw=randwrite, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=io_uring, iodepth=64
  ...
  fio-3.39
  Starting 32 processes
  test: Laying out IO file (1 file / 1024MiB)
  Jobs: 32 (f=32): [w(32)][100.0%][w=764MiB/s][w=195k IOPS][eta 00m:00s]
  test: (groupid=0, jobs=32): err= 0: pid=586: Wed Apr 22 13:03:04 2026
    write: IOPS=202k, BW=787MiB/s (826MB/s)(46.1GiB/60012msec); 0 zone resets
     bw (  KiB/s): min=498714, max=1199892, per=100.00%, avg=806659.03, stdev=4229.94, samples=3808
     iops        : min=124677, max=299971, avg=201661.82, stdev=1057.49, samples=3808
    cpu          : usr=0.32%, sys=1.27%, ctx=8329204, majf=0, minf=1163
    IO depths    : 1=0.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=100.0%
       submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
       complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
       issued rwts: total=0,12094328,0,0 short=0,0,0,0 dropped=0,0,0,0
       latency   : target=0, window=0, percentile=100.00%, depth=64

  Run status group 0 (all jobs):
    WRITE: bw=787MiB/s (826MB/s), 787MiB/s-787MiB/s (826MB/s-826MB/s), io=46.1GiB (49.5GB), run=60012-60012msec

After patch:

  test: (g=0): rw=randwrite, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=io_uring, iodepth=64
  ...
  fio-3.39
  Starting 32 processes
  test: Laying out IO file (1 file / 1024MiB)
  Jobs: 32 (f=32): [w(32)][100.0%][w=1255MiB/s][w=321k IOPS][eta 00m:00s]
  test: (groupid=0, jobs=32): err= 0: pid=572: Wed Apr 22 13:13:46 2026
    write: IOPS=320k, BW=1250MiB/s (1311MB/s)(73.3GiB/60003msec); 0 zone resets
     bw (  MiB/s): min=  619, max= 2289, per=100.00%, avg=1251.28, stdev= 9.64, samples=3808
     iops        : min=158538, max=586025, avg=320320.80, stdev=2468.97, samples=3808
    cpu          : usr=0.35%, sys=11.50%, ctx=1584847, majf=0, minf=1160
    IO depths    : 1=0.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=100.0%
       submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
       complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
       issued rwts: total=0,19203309,0,0 short=0,0,0,0 dropped=0,0,0,0
       latency   : target=0, window=0, percentile=100.00%, depth=64

  Run status group 0 (all jobs):
    WRITE: bw=1250MiB/s (1311MB/s), 1250MiB/s-1250MiB/s (1311MB/s-1311MB/s), io=73.3GiB (78.7GB), run=60003-60003msec

Fixes: ad21f15b0f79 ("btrfs: switch to the new mount API")
Signed-off-by: Mark Harmstone <mark@harmstone.com>
---
 fs/btrfs/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index a60bce413d33b5..fb15decb086189 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1872,6 +1872,7 @@ static int btrfs_get_tree_super(struct fs_context *fc)
 	fs_info->fs_devices = fs_devices;
 	mutex_unlock(&uuid_mutex);
 
+	fc->sb_flags |= SB_NOSEC;
 
 	sb = sget_fc(fc, btrfs_fc_test_super, set_anon_super_fc);
 	if (IS_ERR(sb)) {
-- 
2.52.0

