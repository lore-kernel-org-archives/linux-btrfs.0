Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 254.102.124.202.static.netspeed.net.nz ([202.124.102.254]:45715
	"EHLO mx.anathoth.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751402AbbDPBlk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Apr 2015 21:41:40 -0400
Received: from localhost (localhost [127.0.0.1])
	by mx.anathoth.net (Postfix) with ESMTP id 6FB5841C60
	for <linux-btrfs@vger.kernel.org>; Thu, 16 Apr 2015 13:41:35 +1200 (NZST)
Received: from [49.224.132.98] (98.132.224.49.dyn.cust.vf.net.nz [49.224.132.98])
	(Authenticated sender: matt@mattgrant.net.nz)
	by mx.anathoth.net (Postfix) with ESMTPSA
	for <linux-btrfs@vger.kernel.org>; Thu, 16 Apr 2015 13:41:29 +1200 (NZST)
Date: Thu, 16 Apr 2015 13:41:21 +1200
Subject: Btrfs-cleaner FS DoS issues
From: Matt Grant <matt@mattgrant.net.nz>
To: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <20150416014135.6FB5841C60@mx.anathoth.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

When ever I delete a large snapshot this stalls all the processes on my system for 30 minutes plus, kernel v19.2. Btrfs-cleaner is taking 100% CPU when completely stalled. Every few minutes its say 99.8% and satall abates andÂ  processes/io happen.

About to lodge a kernel bug about this as it is serious issue.

Could some one look at making the clean up process more sensitive to when the system is idle? MD Raid is very good at this, and it should be possible to set this up.

Best Regards,

Matt Grantÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
