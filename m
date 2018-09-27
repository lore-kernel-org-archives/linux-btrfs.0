Return-Path: <SRS0=Zypw=MJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BC6EC43382
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Sep 2018 18:18:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E06EB215F0
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Sep 2018 18:18:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="xLLgeznr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E06EB215F0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728195AbeI1Ahh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 27 Sep 2018 20:37:37 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:37387 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727335AbeI1Ahh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Sep 2018 20:37:37 -0400
Received: by mail-pg1-f194.google.com with SMTP id c10-v6so2548996pgq.4
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Sep 2018 11:18:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZEZkuNk/mYlbmJnqhIp7NLDYlKCO+sBS18MEuPWY8zQ=;
        b=xLLgeznr+fVffGdJ/vD4OKIObMISxkHr7ElERK08oinOHrvI6vnXD1EDjHCF9SZsnf
         mpTeW/NSIwsmzHYriikbIvRzycraEzviZJOrPDbYFqV6mMTX6UX4OUr1wU1HI1jO0NVL
         x9j98edJmPynYGeVzkGhN3gi0Wm7QzOEOTVD+hLOAB4SGAK/jls+40PTtaf6EusmjVi5
         yL2F0ZxUt3kHJF15Y1NyepcxE8kyTde+hpI3dZa60SnPjchkBzXq1xj8Myl+C0VZZFzm
         lzuymP7JjDaeFtNE9dI+sxhEjEWo66qL8NlAdp9DJHHNDIdkUkbfMj94wDLfxFCBYFF0
         k3ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZEZkuNk/mYlbmJnqhIp7NLDYlKCO+sBS18MEuPWY8zQ=;
        b=FTYBFbszWq35O6uFnXxoZ/DH0BBhZjlpOGPmJRp2z3X0aDDCWn3A71uBnmiB6ztXAT
         VymRS9CbrqLdagRML457tZEWDAyct004BkZH9vBEa2zgPb2qYxNfZz8lWXuWKzne+5pS
         nnV/Azb/4k1E/CZpvNNG9vWSgAw77H9XzzUY7s5d3gkj9LZUvhkDmFBs8Giyg59r7mkB
         wlMZriPkSRcQrbQ9mNJm1GNNF8C8POlMc88nWFGNsjTdZ9+fL7gegTbWGGrxRGHV+Zf+
         uECJE/bKEBmzw3N/ZpKdNIu6uTeB1ytR+V4VXFnbIQkfmjnHxNoJ7ipoNDr21/gZlB3K
         xhLw==
X-Gm-Message-State: ABuFfogYTPnGIgQVLcjqTOT495CSKkKl2ru05QwaNM9LtXq/Ybg3v6s0
        Bs05DilC2514IdsQdrkq8G4PLo6lfXc=
X-Google-Smtp-Source: ACcGV63q1H3a865Yhxmy+OczLNadL92mqU9O+e5w0jhHHm4FI7zud6Er70Skl17T6r0TTAhiIuo8gw==
X-Received: by 2002:a17:902:b092:: with SMTP id p18-v6mr12424534plr.90.1538072286063;
        Thu, 27 Sep 2018 11:18:06 -0700 (PDT)
Received: from vader.thefacebook.com ([2620:10d:c090:200::5:3e64])
        by smtp.gmail.com with ESMTPSA id p19-v6sm4086614pgh.60.2018.09.27.11.18.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Sep 2018 11:18:05 -0700 (PDT)
From:   Omar Sandoval <osandov@osandov.com>
To:     linux-btrfs@vger.kernel.org
Cc:     kernel-team@fb.com, David Sterba <dsterba@suse.com>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH v9 0/6] Btrfs: implement swap file support
Date:   Thu, 27 Sep 2018 11:17:32 -0700
Message-Id: <cover.1538072009.git.osandov@fb.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

Hi,

This series implements swap file support for Btrfs.

Changes from v8 [1]:

- Fixed a bug in btrfs_swap_activate() which would cause us to miss some
  file extents if they were merged into one extent map entry.
- Fixed build for !CONFIG_SWAP.
- Changed all error messages to KERN_WARN.
- Unindented long error messages.

I've Cc'd Jon and Al on patch 3 this time, so hopefully we can get an
ack for that one, too.

Thanks!

1: https://www.spinics.net/lists/linux-btrfs/msg82267.html

Omar Sandoval (6):
  mm: split SWP_FILE into SWP_ACTIVATED and SWP_FS
  mm: export add_swap_extent()
  vfs: update swap_{,de}activate documentation
  Btrfs: prevent ioctls from interfering with a swap file
  Btrfs: rename get_chunk_map() and make it non-static
  Btrfs: support swap files

 Documentation/filesystems/Locking |  17 +-
 Documentation/filesystems/vfs.txt |  12 +-
 fs/btrfs/ctree.h                  |  29 +++
 fs/btrfs/dev-replace.c            |   8 +
 fs/btrfs/disk-io.c                |   4 +
 fs/btrfs/inode.c                  | 338 ++++++++++++++++++++++++++++++
 fs/btrfs/ioctl.c                  |  31 ++-
 fs/btrfs/relocation.c             |  18 +-
 fs/btrfs/volumes.c                |  82 ++++++--
 fs/btrfs/volumes.h                |   2 +
 include/linux/swap.h              |  13 +-
 mm/page_io.c                      |   6 +-
 mm/swapfile.c                     |  14 +-
 13 files changed, 523 insertions(+), 51 deletions(-)

-- 
2.19.0

