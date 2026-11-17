Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794884638;
	b=bHS8vXEeH+BLU+ILxyk24GgehK+3M0teMqxeQwq/Wk7KIbrOfX3AaawWErrtIqEkF6P4
	 qoQEbPjTBXr0ta7lH85tBGmpSaa8nmtFLL+Z0DhF9Hze3EoHLRNC/mCzmry5Q/dZ+xJTL
	 d2RZxzaxaWORyXen8xfhyIvqC7smF9a8toerJF20gj332cM4F2u9L1z71JHj3tKB6Tub3
	 W6hK+7j6qPMWdev7MovJmHeBx1ZNAEFjIRXlkxLGnnshV1+LBRm0VlZgqiNUvZfP8meBt
	 fC2nWO0YqMb45cazo5Edj+pYWv8vGfra42bnPSsK6aksJHvf5Gg3aFuYxFIG3TOJQrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794884638;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=59i9qNCywloB8yPnm+LVlMAqghoUzCqvi5ucPAFlF4U=;
	b=W6pPl2k+1o2swSUXqkbNcAhjAPq5BErCVV00uUIfDHP/05jhDE9l1axlcS5fDHfJWrck
	 9IrgpPNB4EuWzdSrKRG1GzOL1HddT8H53ME3XrNTXL5Z/kXeuis7/gcPISLE4WGUXfGUe
	 9W6N/qPILflypL7ae2fiH5BWNTZzhinW705YsnjNB0T3C9pDHaXc/05C3c/zyBsq4bp40
	 UUiyqnuO88QYx7XlNSOKCQroli3+VuN7TnF/FG5ZoYtyaOBgLOBC4EA2mQ2NBzqbREr2K
	 yZJsEi32wZW40jUhzL2983DoXe8GWx9pX1b8P3l2OXwFbGCoPIFueKmvhlpXgOK1uOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cs.unc.edu;
	spf=pass smtp.mailfrom=cs.unc.edu;
	dkim=pass header.d=cs.unc.edu header.i=@cs.unc.edu header.a=rsa-sha256 header.s=google header.b=UPWM48sC;
	arc=none smtp.remote-ip=209.85.128.179
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D764606A329
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 03:03:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8D764606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cs.unc.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cs.unc.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cs.unc.edu header.i=@cs.unc.edu header.a=rsa-sha256 header.s=google header.b=UPWM48sC
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-8b4d26094beso16675267b3.1
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2026 19:03:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cs.unc.edu; s=google; t=1794884637; x=1795489437; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=59i9qNCywloB8yPnm+LVlMAqghoUzCqvi5ucPAFlF4U=;
        b=UPWM48sC5oymWjtmL5e4xI7owhXfoZezZn2RXAp8qjflD0A7ZVgU7zD8z/gcqRdyIk
         9W9D4HtslpZaadRDTQF9HMVEixl+DEE3B4spBL01R1Lz7K6STQqqwzBgxbu9LWKYcAt2
         GpU2IKgBbMC02NJGJDSngkfls5q1+6YGGkhAb/3/uPNWKa2xij4TT/3D0prYRM0Dd2c4
         xJ1l7wkP9ARxvbIgHnv2fsRcSL1IWhPrLcByhtSbdfamnY6J5K4+uvM8iPFk7jbA87gW
         R5QU0p6Nk5ZSKUiLVJayzcbAJgzS539HWZp+ubhCywupnOA/bLJ4yhyHlTmGBzcAC9q4
         Es4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794884637; x=1795489437;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=59i9qNCywloB8yPnm+LVlMAqghoUzCqvi5ucPAFlF4U=;
        b=ZGMqTPL0QhLB+zpT03cBbtloNMpOFciVQUOhhLxGphPdt1qE8QwyPb9WybsI1Tsw5K
         VV8LucaMp7OjgNmfovS1Isq1WkH0uVGmVx2uSsDuN22sjBI5q+Gckq8q2QtquXT4D31u
         s3ZtjzExjSV7TVbsVMARq13RUlPGehiFR8o9ck4rryWgPgVZT47YNIpcMAwL+uKKzgiY
         5FsVkiz8SLm4ybjTpGHbCPsSarbfimMaulOjmTCP3gYJVrXuDLnlyWnn1JXZj2SuiBmK
         FHuRPNWJ3zFk9NPNXGcPMUqz3ZogPaIWb5jDhLa1/Hw01sU/GNLWwaA3y1a1MRkHMSb9
         EKlQ==
X-Gm-Message-State: APuU4Z/Oik3XNoy1zF5n7q9Wj7AFbjQrwz9hmNJufiRG68j0MMKJCvVM
	r6BihzcCU3OUeaxOEAkfG7Hl0GLdm4SjUSk/H8BBX7XNIipUnodFymhq+sqeBz0XCyd3xwPwnOx
	5me8uZBJUjhwUgUarmSeRwaw+i7ff5J5Uk/7AuJA0FrydZfTeBslFZWtADjXh7gDDlfgva2obfz
	k9vn+GzX6tSkIUV2PVS9tTSYW7Am36lRBv5Qhs/KuUSB4YkFg=
X-Gm-Gg: AZFdTZcvH9yyYaBWJnSoQR2bBILayX5N5+6fk+QA+7ZdnVgzcTYAw4rBhqCHitgAVyr
	YdXPG9aU0Mxl9k3KV/AFWJ4rslmlasGvwNr+mqUWGafDQDnt+uBeZjaNjUO4O1EpTC8XH/fx7l5
	TzGyZkBLNl9ALathpXx1FJBFZTDeiELYnBwlsyS8xnXl1rucoOsFsbCh8ucBaoInegOhNhWmusI
	6Usp+x01oFf/dwGi1/BiWHduAmAuB0bXg5v5EXGD5zto/UCtrwHVW9w3n0HanqfdA4YOz4BfbYC
	8qkUFGm3TdFXduPWI/7hFmb/1IlrAyAYBKccd7W9Py8Ka+M9L2mtbnQFLDyID/B3nla/k+o15Jg
	4QqOhjPr7eGFoyggF76Qgw1dmt36nI72JFjbJt67dJFbwMZIdfdfWYmpCdH6XPy9E2fq9UtaNGI
	aI8DkO2uCTb4oonkLP+xcDaJUmj2mmXnx5NXWoRmqJRp515rNUIUeRhb1JRfIf5e4UJOmLxkKW3
	68nLUTq2r8EDh34NzfcLOYZvlSsOFr8Qjz/f0+xGxH5SmO+2UtZTlygsej5zfs3Hiabdev/Ks8I
	V7iCWg1xn2y4uanZOIIcdNax4MexcgWmDbgRfnYbDbOLN2wBNbc=
X-Received: by 2002:a05:690c:7488:b0:8b4:c615:62fa with SMTP id 00721157ae682-8b4c6156634mr56285737b3.61.1794884637083;
        Mon, 16 Nov 2026 19:03:57 -0800 (PST)
Received: from cobra01.cs.unc.edu (cobra01.cs.unc.edu. [152.2.130.143])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b4ec29d0b5sm14482677b3.35.2026.11.16.19.03.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 19:03:56 -0800 (PST)
From: Hengyu Liang <hengyul@cs.unc.edu>
To: linux-btrfs@vger.kernel.org
Cc: Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>,
	Chris Mason <mason@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs: remove "rescue=usebackuproot" from "rescue=all" shortcut
Date: Mon, 16 Nov 2026 22:03:53 -0500
Message-ID: <20261117030353.1738805-1-hengyul@cs.unc.edu>
X-Mailer: git-send-email 2.53.0
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

[BUG]
Since commit c73eb6f72741 ("btrfs: always use the second newest slot for
rescue=usebackuproot"), "mount -o ro,rescue=all" mounts the second
newest backup root even when the newest roots are fine. As of now, the
changes of the last transaction are not visible with "rescue=all".

The issue can be reproduced with a healthy filesystem:

    mkfs.btrfs -q -f /dev/vda
    mount /dev/vda /mnt
    echo old > /mnt/A
    echo old > /mnt/C
    sync
    echo new > /mnt/A
    echo new > /mnt/B
    rm /mnt/C
    umount /mnt
    mount -o ro,rescue=all /dev/vda /mnt
    ls /mnt
    cat /mnt/A

Before that commit, the result is "A B" and "new". After that commit,
the result is "A C" and "old".

[CAUSE]
Commit 2fd3f6a2711b ("btrfs: add "rescue=usebackuproot" into
"rescue=all" shortcut") added USEBACKUPROOT to "rescue=all". At that
time the option only fell back to a backup root when the newest roots
failed to load. Now btrfs_parse_param() sets USEBACKUPROOT and
use_backup_slot = 1 for "rescue=all", and init_tree_roots() calls
read_backup_root(fs_info, 1) before it loads the tree root.

[FIX]
"rescue=usebackuproot" now selects a root instead of tolerating an
error, so remove it from "rescue=all". With this change "rescue=all"
never uses a backup root by itself. When the newest roots are damaged,
"rescue=usebackuproot" has to be given in addition.

Fixes: c73eb6f72741 ("btrfs: always use the second newest slot for rescue=usebackuproot")
Signed-off-by: Hengyu Liang <hengyul@cs.unc.edu>
---
This is new in 7.4-rc (v7.3 mounts the newest roots with "rescue=all"),
so it can be judged before the release.

On a copy of a disk taken while the next transaction was running,
"rescue=all" on v7.4-rc2 showed 30 of 60 files with the data of other
files and no read error, as the space freed by the newest transaction
was reused and data checksums are ignored.

If "rescue=all" should keep every rescue option, as btrfs-progs
documents it, using slot 0 for it also shows the newest state, and I
can send that instead.

Tested on btrfs for-next (26eb4d70f96d) with clean mkfs.btrfs images:
healthy, a damaged data block, a damaged extent, csum, fs or tree root
block, and the disk copy above.

 fs/btrfs/super.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index b424cc836bd4..d67d678451f6 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -624,8 +624,6 @@ static int btrfs_parse_param(struct fs_context *fc, struct fs_parameter *param)
 			btrfs_set_opt(ctx->mount_opt, IGNORESUPERFLAGS);
 			btrfs_set_opt(ctx->mount_opt, IGNOREBADROOTS);
 			btrfs_set_opt(ctx->mount_opt, NOLOGREPLAY);
-			btrfs_set_opt(ctx->mount_opt, USEBACKUPROOT);
-			ctx->use_backup_slot = 1;
 			break;
 		default:
 			btrfs_info(NULL, "unrecognized rescue option '%s'",

base-commit: 26eb4d70f96d9bf99e87c2565d6234eb652f9c26
-- 
2.53.0

