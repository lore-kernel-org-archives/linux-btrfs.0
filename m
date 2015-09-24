Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:39108 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbbIXTNj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Sep 2015 15:13:39 -0400
From: Luis de Bethencourt <luisbg@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        Luis de Bethencourt <luisbg@osg.samsung.com>
Subject: [PATCH v2 0/2] btrfs: Fix returned errno codes
Date: Thu, 24 Sep 2015 20:13:31 +0100
Message-Id: <cover.1443121865.git.luisbg@osg.samsung.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

These two patches fix instances where -1 is used to specify a buffer
allocation fail, instead of using -ENOMEM.

Patch 1/2 is already reviewed by David Sterba.

Luis de Bethencourt (2):
  btrfs: check-integrity: Fix returned errno codes
  btrfs: reada: Fix returned errno code

 fs/btrfs/check-integrity.c | 4 ++--
 fs/btrfs/reada.c           | 8 +++++---
 2 files changed, 7 insertions(+), 5 deletions(-)

-- 
2.5.1

