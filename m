Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792951387;
	b=IJ6p9Ti5yasVg0z+idIKXPNuJ0lPcksk1FT9c5XCjlhMylxS2/N8hFtzp+UFFjG2Fj4j
	 yXp+nbYQIEzn4CVYthS2YlPSnSvk/Pfs+iqxC9tYZmwOctfdNutgJw3Tf9FQwtmhLI4+5
	 DXAwMctQW2sy/JLiHnmITy9nsje3vz2IYCynD586OgOKVuI5WKrrUUFtKQdFgtOR1g6Y2
	 WPMN1um2QzI/hT+ZebTVtJF9lsUPsWJ2XIj9UbUl7ZmXXBcThacYmxoSusvPsDp87qNaH
	 PGUcccDu73xfTZejAB5CAh77L2He/lSNk2mxUUOjF1M2yacG0JA5sfSmeRrBdaI/irQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792951387;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=P+SFE5KlwHSbzSppx2ca382HQJ58fWCk3G4Y1HJ+92o=;
	b=0CsoaFzCAO26/EMIo5GfCVHf5GIEd2BR4JN0NRfmfM/2sIImtDCmuk/s2wyMz1KqoaqB
	 RMX/7e5JDZx9gM2M85h5L5/lEA8qRWRmyJJ1eRC4oaN8eo42Rf+155+EJGZlR+WKlCvg8
	 zlLWYw5w6z1YW+BHXOGQ2wWpj1LnISeMC532DecGZMJSUqtLMbCYWlol5XyfHkpt/VE0c
	 4xogWTY0eNEWpz1U0c+N4ELOhBHMqYyfUqetAEER8j7l32PW+g1aXvJJpXwWFBXOjI/gU
	 yZsn2Ckao+9MUiOPlhEf9Qbp3h5vS4Q55eQ7s/mX5gP79uIU5+8jloOSxrbvE5j/AmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b="bb5/zCB8";
	arc=none smtp.remote-ip=74.125.82.54
Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1DF0606A32A
	for <linux-btrfs@vger.kernel.org>; Sun, 25 Oct 2026 18:03:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B1DF0606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=bb5/zCB8
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-1438d9363fbso1755044c88.0
        for <linux-btrfs@vger.kernel.org>; Sun, 25 Oct 2026 11:03:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792951386; x=1793556186; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=P+SFE5KlwHSbzSppx2ca382HQJ58fWCk3G4Y1HJ+92o=;
        b=bb5/zCB8TnaQ4XKin8MIPuG11BE/emDViw0RrV6iuF85xr9Cp80GFsSZTEEDjOEFWg
         gcacQzdf8QBsKLpRT6N9GsJ2iSdYFn7vifeaB5FdPMdZVtr1JObbxh5k8VDW8abc7W5g
         UnN2WpLiTQluGUNw1ZSGKi/iiD34W8YOKSUIa9fEXqdOKEr9kC6GQe2gf922bLD84tAw
         R9VulzqnLOyMXb1uF3tPbK8Ucki0MrJ2uHK6haauFnrrrzSF1n+9Ugx0D3ff4YnNO2oC
         Pr1u8LKZORkeq8k8c3moIanPsIHmVZjK34heVdDID+YOu/KH3kE1lONUi/W6i7YC4CP0
         GIbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792951386; x=1793556186;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=P+SFE5KlwHSbzSppx2ca382HQJ58fWCk3G4Y1HJ+92o=;
        b=xlc+ra+6Ntylcjp+bnHyd6wlt9LAjdGT48f1SeidTxNQTOM2CnpEPkoWNEzx5vxz8g
         skpNPbLXS13Yv9+jExn3anbqrgtUmbxgLK4Spc2GYLQyHmABdtvLghuGOdo7rRgUI2y5
         7N2FuVnzpPcFHCokUIpnIXdiTgl8yGmb6c+ldXi03CIeJzL5/OV3fAy/XwRzOYk+QoJN
         M/q5hb9b8hiq2yzY/5x29ZTW53WJ55y+ieuRMO+c9dPTuF9865GzdIH24wiy1HNw18KW
         D5Jskex7cwsAzMkVSS02Xz3d9oEh2vxJo9zYCeQCXGZagHRjoCipCkthbj/2Vb0oCvya
         IwIA==
X-Forwarded-Encrypted: i=1; AKwUvBw9MPlC5K9mjw/fZEnrHYP6LxjlCumiBq90vopDDa1/+/hTkEqkZYSc/x1oYjmS4+VJbgc3EQSJttHSNA==@vger.kernel.org
X-Gm-Message-State: AFq9FYKxMzA5JSAPZ4G/dmIpObyaeWciWfgiGh0tGmhYH3JGcaHbCFcu
	U1uMR64VwRD0I2A63i3AHJz+3+m8t/o1/fbQaRGZy9Y/kRlzr9j7tLgc
X-Gm-Gg: AYBFou0CdYFliw6YlKuhz1xeyx0gxNT9vClNYfvBUoWHcLW9lgyEvsZ2wc7UboMZo7o
	FFn835jvoMs3ng/PV7jsStUe/tNORB9MNdWN1SaeRGDJLWe4pGnlZVmqGhG+cTCtgRf68kIVNux
	dPz20wqwlpzm7TEau9z+ppo2DxVg91mjRLBwUYgGCJIAxDmpgHz0NdYd2An3TIe9zVIiCrpByln
	gnbIvGORerEAN4f7aBCP/YsLUV7FKlgh1nZ0ckHn9jz27pXSQczAZCyG8IGsICbUkdoURnCxrg8
	DL4bSU/YNNRqFUjFRDGs/3rCyfK8RHS5C6VF9Zo+LqbaAbKNvjyjZa83xTw9S/4RsHKsJPTpDv3
	COqAZsJUhOrcwwseLY2rbMkgRahGedrl88aTpzR8tSPNAv7XBHe9guuZOADE/URlB8x9JTEZw6w
	mqfW8E7CFppfirNyksV1uJwkhRolGrwDnsj2D9oEJimuifU+DUdNUl0OhyIo1c5vX+t3SIJ2Ah8
	iPcYozPdLaIpopuq2PQUi/l8YyaMGXE71G+3aCxJa53b3PERU4aC2VPORQeElgmJ97M+ENNTUu8
	g/aNKM9wmxFbz55XRIQ=
X-Received: by 2002:a05:7022:c99:b0:197:1233:e9f8 with SMTP id a92af1059eb24-1994f68a910mr6198140c88.18.1792951385683;
        Sun, 25 Oct 2026 11:03:05 -0700 (PDT)
Received: from youngkk-vm.localdomain (67.216.200.102.16clouds.com. [67.216.200.102])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1989ff2ee69sm24500775c88.4.2026.10.25.11.03.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 11:03:05 -0700 (PDT)
From: Cheng Yongkang <teel4res@gmail.com>
To: David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Cheng Yongkang <teel4res@gmail.com>
Subject: [PATCH] btrfs: reject refs=0 subvolume without DEAD in SUBVOL_SYNC_WAIT
Date: Sun, 25 Oct 2026 11:02:58 -0700
Message-Id: <20261025180258.349175-1-teel4res@gmail.com>
X-Mailer: git-send-email 2.34.1
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

A crafted image can leave a tree-root ROOT_ITEM with refs==0 and without
BTRFS_ROOT_SUBVOL_DEAD, plus a matching orphan item.  Mount accepts it,
and btrfs_ioctl_subvol_sync() then reaches

  ASSERT(root_flags & BTRFS_ROOT_SUBVOL_DEAD, ...)

which is BUG() on CONFIG_BTRFS_ASSERT=y.

Return -EUCLEAN instead of asserting, and log the inconsistent state.

The ioctl BUG was reproduced in 2/4 baseline boots (the other two lost
a race to the same image's unrelated cleaner WARN).  With this change
the ioctl returns -EUCLEAN and no BUG; a normal btrfs mount/write/
readback/check regression passes.

Assisted-by: LLM
Signed-off-by: Cheng Yongkang <teel4res@gmail.com>
---
 fs/btrfs/ioctl.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 576cd76..00eab0b 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -5149,8 +5149,12 @@ static int btrfs_ioctl_subvol_sync(struct btrfs_fs_info *fs_info, void __user *a
 			return -ENOENT;
 
 		wait_for_deletion = true;
-		ASSERT(root_flags & BTRFS_ROOT_SUBVOL_DEAD, "root_flags=0x%llx",
-		       root_flags);
+		if (!(root_flags & BTRFS_ROOT_SUBVOL_DEAD)) {
+			btrfs_err(fs_info,
+				  "subvol %llu has refs 0 without DEAD flag",
+				  args.subvolid);
+			return -EUCLEAN;
+		}
 		sched_ret = schedule_timeout_interruptible(HZ);
 		/* Early wake up or error. */
 		if (sched_ret != 0)
-- 
2.34.1

