Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A784570C2
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Aug 2026 11:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786706570; cv=none; b=l3WKdeNvBYiuMinp0o5Kw05D5bwi7LS3SIWE0xJdKjeScF2x8DAftoF/eml6omt0Dcr2OOK5RnjCrVstdR4FXlBNgx3lBryJh2p9n5sHFtmFJx2bJCmZlVGRUBLUZ78exWsPAI9lkCdyxxqV8yOvl1SQlsczW3OO4yGrxQKpOX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786706570; c=relaxed/simple;
	bh=kOdbizL2WbRrvUiqLkpBWdx/ZB5Hjf4LqdHDhv8Y8xI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Kdex1itXT8II/OKLslTnbNCIRP1/jyIfE5nC8RK/299ebGMp6zldupGzbMatQj9Uy+3Sxp0U/L/UsNlAbAdra1pGhUTxoTaa2clFHRt5TVIVQcn0q1KdmUHNpjqokCl+eGe1K+uMsQ12x8iipYempWTUCfhAL+65dZ8l3c8c8ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=icvBDZuM; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="icvBDZuM"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-38d489b6b71so959189a91.0
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Aug 2026 04:22:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786706566; x=1787311366; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=iaZDoExgTDNkepgAKTiMPW+JYa3Hj6tKGTWkAI87vXg=;
        b=icvBDZuMnsY7f0QL6eZHNGkpxoygcKMFjhTzUmuVRJXxkBWbjH3nEsEJy9UhpjDzLm
         oRB0XVrWk6if/TssoGFtW8iiDMCYrL9tXMBqSKzvYg648u6MTg/9/xwkmjxB3gfe9zYi
         kQlFocfw5Oa88B+NFFUAGO0Vsrosphn9APvd45tPNYbt5j8i102F9lWiwQt5lhsZu07F
         YesxCsc2N8dV3UoxMzX5IRSWWhtHGecZoNlCuAIlsfCtaXEAL799Hsd1RRz2HJEPlgh9
         oBzpcnhDOpWtTSoFZtZ/7TgYgVnP5tF1BXEDF36Q76QPCE2wX7Fr7Z6LfNnzGmNYrZVU
         ziDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786706566; x=1787311366;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iaZDoExgTDNkepgAKTiMPW+JYa3Hj6tKGTWkAI87vXg=;
        b=c1ftjAUGJ33ObojmEYjxhZ5Yob/ZlmBkuT437M46+NBIqswbNym9h+6RI5ukLNFiD+
         19AkCwsMBO0aIaLtI8LvW47r45/8XM3Sq6WpGan66vmRubmZf5TingzjqXXF7EvdiI84
         M0IouPteA6GU8AY4wjxAnhtUYvxA9RLxWomAevGAtqVfX0Ke5RO9OL20xqNoEpqNCoYl
         gd6IlhPqwqMJwqGeuVw9KlB28su0t0+NLA7P1UHjCEsR3nuXCck3rAu9NwbDvgqglNWL
         f2wtM+PwrPAPJGeb7DVLCrEWqDSg7DsL+Q5EYDwHOzbLhR82S9nT0E+zD0JjZ0eibwmT
         Zmwg==
X-Gm-Message-State: AOJu0YxDipWuW1fvzcIkj+wcw0W08cIfeGD5RB+YnYOCAb1HJdY6NvX8
	x3WQ8hIo6WgGPJmGkISGpkTOo0/a0w58PUQl5jVoSjPqhYVkQw6bgl/ceLz00Ukr
X-Gm-Gg: AR+sD12e/MIkBNV4ptsxeLFRCbWiPJZLRupT3iSd1jap5X/N5dWotyRaQvjeXcN0CPi
	lG5IkGhPQtX0N0CaDOQW2l4F0omDY373vohMJAFZO2YdkvRvxDWAL7DNs9secndDA5ltmxQmHv7
	PYzyXQRf5sRMV8T6LyX1RMw8b9eZgx9oIh58VsxKIEp/meXzd573WgT5zazbOqXLqQb3BlmXyRu
	pfFe2b9RE+UOdQiHIi9ZWHSwmxOswafFFfg3EMhMPy4Of+5vPxo0P+EUeBIPkmn9opFUiWTh8eU
	VQVNP15zX8yF0r/QHksfdvfM7rhtH/TdIynInBIiw6kZSC/MzlgYlzYTKTA9vCEpF8ug4h2N2e/
	lhCWqE3wv3ZTT1399OwQe89tDMcjgYwyG7KdT29mARL3cA/TVR+/B0OJbXMrydlUOGwfiDOzy5Q
	KYGergmpnIfiBa49sOdpbkkx4YtUG6qbLHAOc7FK0cfukE8qQ+PWHx1rhhD+XW+H04r2f2nGJIf
	G4=
X-Received: by 2002:a17:90b:1f88:b0:392:c868:35af with SMTP id 98e67ed59e1d1-3933bd46d96mr5759300a91.20.1786706566416;
        Fri, 14 Aug 2026 04:22:46 -0700 (PDT)
Received: from localhost.localdomain ([203.175.14.199])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-394ea996575sm2300533a91.8.2026.08.14.04.22.44
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 14 Aug 2026 04:22:46 -0700 (PDT)
From: Guanjie Chen <jk.chen1095@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com,
	dsterba@suse.com,
	fdmanana@suse.com,
	linux-kernel@vger.kernel.org,
	Guanjie Chen <jk.chen1095@gmail.com>
Subject: [PATCH] btrfs: free qgroup configuration when quota enable fails
Date: Fri, 14 Aug 2026 19:22:40 +0800
Message-ID: <20260814112240.93514-1-jk.chen1095@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Quota enable adds qgroups to fs_info->qgroup_tree before the operation is
guaranteed to succeed.  On failure, the current error path removes only the
sysfs entries, leaving the qgroups and their relations in memory.

Use btrfs_free_qgroup_config() instead.  It is the existing qgroup teardown
helper and removes the in-memory qgroups, their relations and the sysfs
entries.

This is safe because the failure cleanup runs with qgroup_ioctl_lock held
and before quota_root is published or quota accounting is enabled.  Qgroups
already added to the tree are freed by btrfs_free_qgroup_config(), while an
untransferred preallocation and quota_root are still released by the
existing cleanup code.  Transaction handling is unchanged.

Signed-off-by: Guanjie Chen <jk.chen1095@gmail.com>
---
 fs/btrfs/qgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1292,7 +1292,7 @@ out_free_root:
 		btrfs_put_root(quota_root);
 out:
 	if (ret)
-		btrfs_sysfs_del_qgroups(fs_info);
+		btrfs_free_qgroup_config(fs_info);
 	mutex_unlock(&fs_info->qgroup_ioctl_lock);
 	if (ret && trans)
 		btrfs_end_transaction(trans);
-- 
2.43.0

