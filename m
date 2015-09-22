Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:38648 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933181AbbIVQ3b (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Sep 2015 12:29:31 -0400
From: Luis de Bethencourt <luisbg@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        Luis de Bethencourt <luis@debethencourt.com>
Subject: [PATCH 0/2] btrfs: Fix returned errno codes
Date: Tue, 22 Sep 2015 17:29:37 +0100
Message-Id: <cover.1442939007.git.luis@debethencourt.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Luis de Bethencourt <luis@debethencourt.com>

Hi,

These two patches fix instances where -1 is used to specify a buffer
allocation fail, instead of using -ENOMEM.

I could merge the two patches into one if that's more appropriate.

Thanks,
Luis

Luis de Bethencourt (2):
  btrfs: check-integrity: Fix returned errno codes
  btrfs: reada: Fix returned errno code

 fs/btrfs/check-integrity.c | 4 ++--
 fs/btrfs/reada.c           | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

-- 
2.5.3

