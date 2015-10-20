Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:38299 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159AbbJTN41 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Oct 2015 09:56:27 -0400
From: Luis de Bethencourt <luisbg@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.com, jbacik@fb.com, clm@fb.com,
        Luis de Bethencourt <luisbg@osg.samsung.com>
Subject: [RESEND PATCH 0/2] btrfs: Fix returned errno codes
Date: Tue, 20 Oct 2015 14:56:21 +0100
Message-Id: <1445349383-21722-1-git-send-email-luisbg@osg.samsung.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

This is a resend of this patch series. It was posted on September 24 [0]

These two patches fix instances where -1 is used to specify a buffer
allocation fail, instead of using -ENOMEM.

Patch 1/2 is already reviewed by David Sterba.

Best regards,
Luis

[0]: https://lkml.org/lkml/2015/9/24/553

Luis de Bethencourt (2):
  btrfs: check-integrity: Fix returned errno codes
  btrfs: reada: Fix returned errno code

 fs/btrfs/check-integrity.c | 4 ++--
 fs/btrfs/reada.c           | 8 +++++---
 2 files changed, 7 insertions(+), 5 deletions(-)

-- 
2.5.3

