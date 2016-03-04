Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40865 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756011AbcCDNq0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 4 Mar 2016 08:46:26 -0500
Received: from int-mx13.intmail.prod.int.phx2.redhat.com (int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id 80EEEA70F
	for <linux-btrfs@vger.kernel.org>; Fri,  4 Mar 2016 13:46:25 +0000 (UTC)
From: Ondrej Kozina <okozina@redhat.com>
To: linux-btrfs@vger.kernel.org
Cc: Ondrej Kozina <okozina@redhat.com>
Subject: [PATCH] remove max/min macros from libbtrfs API
Date: Fri,  4 Mar 2016 14:46:10 +0100
Message-Id: <1457099171-24095-1-git-send-email-okozina@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello btrfs-progs,

can we move the min/max macros away from libbtrfs public API? This may cause conflict
while compiling i.e. snapper with gcc 6.0 (aka with -std=gnu++14). The thing
is I don't see a point why those macros should be kept in kerncompat.h at all. Such macros
are used solely in btrfs-progs internals and there's no need to expose them in API.

Kind regards
Ondrej

Ondrej Kozina (1):
  btrfs-progs: libbtrfs: remove max/min macros from API

 backref.c          |  1 +
 ctree.c            |  1 +
 extent_io.c        |  1 +
 file-item.c        |  1 +
 free-space-cache.c |  1 +
 inode-map.c        |  1 +
 internal.h         | 42 ++++++++++++++++++++++++++++++++++++++++++
 kerncompat.h       | 20 --------------------
 utils.h            |  1 +
 9 files changed, 49 insertions(+), 20 deletions(-)
 create mode 100644 internal.h

-- 
2.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
