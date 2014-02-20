Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zebra708.server4you.de ([188.138.112.148]:59028 "EHLO
	niklasfi.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752214AbaBTMfs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Feb 2014 07:35:48 -0500
Received: from localhost.localdomain (p54B448FD.dip0.t-ipconnect.de [84.180.72.253])
	by niklasfi.de (Postfix) with ESMTPSA id DE16019404A6
	for <linux-btrfs@vger.kernel.org>; Thu, 20 Feb 2014 13:27:00 +0100 (CET)
Message-ID: <5305F494.6030900@niklasfi.de>
Date: Thu, 20 Feb 2014 13:27:00 +0100
From: Niklas Fischer <niklas@niklasfi.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: btrfs device add hangs
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I am noticing some weird behavior with btrfs device add. The command
does not return/finish although there is no disk activity in iotop. I
have compiled a gist [1] with the details, which I would gladly update,
if anyone knows what additional information I can provide.

kind regards,
Niklas Fischer


[1] https://gist.github.com/niklasfi/9111967
