Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo203.cox.net ([68.230.241.218]:35469 "EHLO
	eastrmfepo203.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974Ab3BDP6I (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Feb 2013 10:58:08 -0500
Received: from eastrmimpo109 ([68.230.241.222]) by eastrmfepo203.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20130204155807.UXQH21186.eastrmfepo203.cox.net@eastrmimpo109>
          for <linux-btrfs@vger.kernel.org>; Mon, 4 Feb 2013 10:58:07 -0500
From: Gene Czarcinski <gene@czarc.net>
To: linux-btrfs@vger.kernel.org
Cc: Gene Czarcinski <gene@czarc.net>
Subject: [PATCH] Btrfs-progs print more informative error when we fail to open a device
Date: Mon,  4 Feb 2013 10:57:56 -0500
Message-Id: <1359993477-18281-1-git-send-email-gene@czarc.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I believe that this patch may have been lost in the noise and I felt
it made a very small but meaningful change so I shuffled some
test around and made sure it applied to integration-20120201

This patch simply prints more informative message when
we fail to open a device.

Eric Sandeen (1):
  Btrfs-progs print more informative error when we fail to open a device
 utils.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

-- 
1.8.1

