Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:35151 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457AbbH0Pib (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Aug 2015 11:38:31 -0400
Received: by pacdd16 with SMTP id dd16so29303051pac.2
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Aug 2015 08:38:30 -0700 (PDT)
Received: from arch-nb.localdomain ([175.118.89.137])
        by smtp.gmail.com with ESMTPSA id vw6sm2844831pab.14.2015.08.27.08.38.28
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 27 Aug 2015 08:38:29 -0700 (PDT)
From: Byongho Lee <bhlee.kernel@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/3] btrfs-progs: Small fixes for code using strdup()
Date: Fri, 28 Aug 2015 00:38:15 +0900
Message-Id: <1440689898-35178-1-git-send-email-bhlee.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

1. fix memory leak in btrfs-convert main()
2. fix memory leak in btrfs-map-logical main()
3. add memory allocation fail check in btrfs_add_to_fsid()

Byongho Lee (3):
  btrfs-progs: fix memory leak in btrfs-convert main()
  btrfs-progs: fix memory leak in btrfs-map-logical main()
  btrfs-progs: add memory allocation fail check in btrfs_add_to_fsid()

 btrfs-convert.c     |  9 +++++----
 btrfs-map-logical.c |  2 ++
 utils.c             | 20 ++++++++++++--------
 3 files changed, 19 insertions(+), 12 deletions(-)

-- 
2.5.0

