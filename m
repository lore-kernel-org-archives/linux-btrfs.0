Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.sws.net.au ([203.15.120.15]:57892 "EHLO smtp.sws.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757957AbcHCMN3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Aug 2016 08:13:29 -0400
Received: from www.coker.com.au (ppp118-209-253-193.bras2.mel11.internode.on.net [118.209.253.193])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: russell@coker.com.au)
	by smtp.sws.net.au (Postfix) with ESMTPSA id CCEACF290
	for <linux-btrfs@vger.kernel.org>; Wed,  3 Aug 2016 20:58:06 +1000 (AEST)
From: Russell Coker <russell@coker.com.au>
To: linux-btrfs@vger.kernel.org
Subject: BTRFS admin access control
Date: Wed, 3 Aug 2016 20:58:05 +1000
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201608032058.05342.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've just written a script for "mon" to monitor BTRFS filesystems.  I had to 
use sudo because "btrfs device stats" needs to be run as root.

Would it be possible to do some of these things as non-root?  I think it would 
be ideal if there was a "btrfs tunefs" operation somewhat comparable to 
"tune2fs" that allowed us to specify which UID or GID could perform operations 
like "btrfs device stats".

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
