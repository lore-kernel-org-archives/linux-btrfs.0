Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 254.102.124.202.static.netspeed.net.nz ([202.124.102.254]:54439
	"EHLO mx.anathoth.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752944AbbDACFJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 Mar 2015 22:05:09 -0400
Received: from localhost (localhost [127.0.0.1])
	by mx.anathoth.net (Postfix) with ESMTP id B4BB6C3C3A
	for <linux-btrfs@vger.kernel.org>; Wed,  1 Apr 2015 14:59:47 +1300 (NZDT)
Received: from en-gedi (139.20.225.49.dyn.cust.vf.net.nz [49.225.20.139])
	(Authenticated sender: matt@mattgrant.net.nz)
	by mx.anathoth.net (Postfix) with ESMTPSA id E70ACC3C3D
	for <linux-btrfs@vger.kernel.org>; Wed,  1 Apr 2015 14:59:40 +1300 (NZDT)
Message-ID: <1427853689.3942.9.camel@mattgrant.net.nz>
Subject: Python pybtrfs df wrapper script to report btrfs metadata, block,
 space in df compatible output
From: Matt Grant <matt@mattgrant.net.nz>
To: linux-btrfs@vger.kernel.org
Date: Wed, 01 Apr 2015 15:01:29 +1300
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

Use this at work.  Releasing to list to prompt design of output that is
100% df format compatible for automated reporting and graphing.

This is so BTRFS space statistics acn bre reported back to existing
graphing tool chains that many of you would have in place.  Quite useful
for munin, hint, hint :-)

URL for github is:

https://github.com/grantma/pybtrfs.git

There is also a shell script there that can be called from cron.

Please get back to me if you have any questions.

Standard not warranted disclaimers apply to the code.  Its GPLv3
licensed.

Best Regards,

Matt Grant

