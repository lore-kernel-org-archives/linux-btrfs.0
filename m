Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793135391;
	b=cKwBrl3mbuXt8kPtXXF6U5vSP0ve6odj+pZtq7KcrXZEjD6g+jUsfvQ/hdmexjiZnuG2
	 0oJqclKdB+UYKl2s41VYYz9OZI1cd+6yglSJffcv04O6EJPWF8FyN9ady4CH2Iklic0hN
	 +P4z8EsjLhFSs7PKAz3EhRl7w/7c9CGOjXflYScHXg0HT8N6cBwc13Yl5z8OoJ2PEB3V9
	 SIhMxoMoU6PZhnXBQrAhiXqWSZvyTPPhUxe+LWu4nxhpQX51iCYnz3bLIZquDKqvWi7rB
	 vvGtwPS+3SKya8huyifIvmzp6i8KmhhUXU1m0olYO5WksoN3J2gYrDBEuomXdo1O9xg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793135391;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=IpMKT1cwbF2BM7+4MFg5CQwWFq73xTe9BXIlwTOQUCI=;
	b=Wpv/h/bCoX1VmhXzmyREUvm21NqGEDh1IprKeG47RsmrLQf1dH4FGMWVAqJKf4XzGriw
	 c8grKA11YOkNR0uVNdZxFrtFwEWMir5mMWJs5zgx1T50zo5YlwVr57ZNn+Wj+POIzhoQR
	 UVN9ktDxXGHm1kbqLmZ8jq66YDK8XcMfiR51S3ouMgUkiA5tOwEGuGpUfkCNbsDr6JlVa
	 0/v5Z3f8Q2GUmTA0Y+TgUCpraKTG2xoeY0QMtTspIRYUNu8Xs5yqwTKfy0x3qGj4pG05t
	 wIHEnJI7E44hjM2xMbQXmYU1plHTUczGiRWrdQ8XpPAhSwtEHKQvABhJMdkgHU3K7XQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=WnvvvdTc;
	arc=none smtp.remote-ip=209.85.160.181
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC31160A260D
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 21:09:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EC31160A260D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=WnvvvdTc
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-5364042eecfso5162871cf.2
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 14:09:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793135390; x=1793740190; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IpMKT1cwbF2BM7+4MFg5CQwWFq73xTe9BXIlwTOQUCI=;
        b=WnvvvdTc7G1nfaWX/xZKKnrICsgfAqeL0R9qFWLgI1Lu6RxgO3Y0j6JpA78kzWjYYF
         KyHoApYnqdtPpwWqfZAw1ZHZJU+FOrbBiHwQmZ71f/p1rv0nSKVSrveRfhtfsUqhDK77
         whvi1LUz+/OAAEmIQmJJBuXgJAoalPNrMrCHO8ICLrteLjaaazmRhnuZZB8693EsvC0P
         aFtcYWZhs+cUyb6MfKJ7TpwPzncqeXWQlaRPzHPMlLHVg9VuV/+ATMzV6LYkGnffpwU0
         nteEG1kjc7zbUoS7e89EOLrDTDoYhaVC660ZHf2WhRhQ+FzhUdOwf98TItMqyoculpUQ
         Q7lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793135390; x=1793740190;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IpMKT1cwbF2BM7+4MFg5CQwWFq73xTe9BXIlwTOQUCI=;
        b=L1OiLgFUk+PFBP5e2ggRGVhz7Fl8Sy0621Ys0iZ1/6iXwr/Yum6wPjtnpSf+1bTvWQ
         O8VIRolMIFFMmC9PWziv6+BkIqyvjk9C+xB8xqzTrThSijzrpAVla/POtRHpu0v6y5OB
         1ezzwjimBYjS4KsGn+8h1HXoFmyp1RgtptB/rLdVVVGDG4Rr8vLjhH4lFOCYis4TToet
         2hvWnRx2bNddQ5wRHK2V7kxmRQTAebYN9xcCTYNWKjbztijoA0apFNTPJR14XSsTzFPE
         FKeWjgg5FH6KxaDNvTgboUSnxQQzSd1jTx+2GGmWSHrRYKZh31hPaSmldnuHURU74V7/
         wOOw==
X-Forwarded-Encrypted: i=1; AKwUvByUCxbQJfUKpRaq46Sa5IVYUXtKghjybt9S44Jcf1tzzK1wf+dsCgXsQaonagSNvrEwj1hbddtWwLUnIg==@vger.kernel.org
X-Gm-Message-State: AFq9FYLRvtDKd/iQlovm4Om5uLSnG42oruBV5iTeQTNUgHO/ThCcSIvm
	c7GO30aFp2sGsosLjdxM6cX82LwQt+fZwtS6ueMyni2mJHMyjrpKgshOxO795A/iw+E=
X-Gm-Gg: AYBFou2GhSX39xAVn9JmE1/0b3qy2+Jneubj+WE+UtjpOBir3IyrlEcp+l6tvYPyu/P
	D4iufGyWLmHUoqgCck6lhIYS810mCz3X4ejuDtQ4wA9jQYPe/tK20RY/X4q2/iYQ2VVc4JaQ8iH
	mvtvIi3S+c7MXi03r6dBtleQMfNSRh0zxQ0tbUZ2xRXDSeQ2O105VSfPzIHgAGhRPGDqpogPFmr
	3QCZCnCjicqoaqCjZdL9bTJc2mMdq3bsu332NUmCRYAVoyoVipqJ9rUBgJEoySO2Mm5OfFiSto6
	hZGwnZu2MFTO8x8FTlE5O8yh+yMs/EOGjluS/xS/QzWnRWMWo97wbbg67aXXgJPEu5v4IazUUrQ
	17/PEWOzpi7WSlx/mSpfy9HsY+8Dq1QAMOsSANzBQTHttWo8Rq3x0cqrY/dTsI/LdD1nXJn64wD
	PNnjWYrcLcPCh1vy4W0A51HEAyK4lajh3Yeiph+6RvVaDgvgxeeb7qO0S22nAYv0MclDQXlw27o
	1jSzIf1D+9cH4BT1HO0Z0UtmdLoIfx6Jmpv9Lv8preC3BwUyfelMnq3OrwfdL1Z4HxQDBzhm8qr
	sZVGVD3oDFNF/dX55g==
X-Received: by 2002:a05:622a:8b08:b0:535:d7e:dbe with SMTP id d75a77b69052e-53fcbee4226mr9184971cf.12.1793135390022;
        Tue, 27 Oct 2026 14:09:50 -0700 (PDT)
Received: from toxicpanda.com ([153.61.196.255])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-53838cf2dbfsm88162341cf.2.2026.10.27.14.09.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 14:09:49 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
Date: Tue, 27 Oct 2026 21:09:29 +0000
Subject: [PATCH 03/10] xfs: set SB_I_OVL_USE_SYNC_FS
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-b4-ovl-containerized-sync-v1-3-802e512379a6@toxicpanda.com>
References: <20261027-b4-ovl-containerized-sync-v1-0-802e512379a6@toxicpanda.com>
In-Reply-To: <20261027-b4-ovl-containerized-sync-v1-0-802e512379a6@toxicpanda.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 Christian Brauner <brauner@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Theodore Ts'o <tytso@mit.edu>, Carlos Maiolino <cem@kernel.org>, 
 David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
 Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, 
 linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1793135381; l=709;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=1Z5502S4N9+PxpDJ24MamzJyZyNagTbtfNLwpblShXA=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QDJutvjNlSBU/eOcQ9wQNaWwYhbQ0y1uFYtQSeQkyDonWymvy92FRNAyiqlerkJRJJxNhvaXRz7
 8R+gU7AP+DQw=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

All metadata is logged, xfs_fs_sync_fs() forces the log, and there is no
->write_inode().

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/xfs/xfs_super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 5a06132aa384..2f09d48b7e6f 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1924,7 +1924,7 @@ xfs_fs_fill_super(
 		sb->s_time_max = XFS_LEGACY_TIME_MAX;
 	}
 	trace_xfs_inode_timestamp_range(mp, sb->s_time_min, sb->s_time_max);
-	sb->s_iflags |= SB_I_CGROUPWB | SB_I_ALLOW_HSM;
+	sb->s_iflags |= SB_I_CGROUPWB | SB_I_ALLOW_HSM | SB_I_OVL_USE_SYNC_FS;
 
 	set_posix_acl_flag(sb);
 

-- 
2.55.0

