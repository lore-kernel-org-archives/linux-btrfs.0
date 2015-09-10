Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail15.tpgi.com.au ([203.12.160.61]:39711 "EHLO
	mail15.tpgi.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbbIJElo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Sep 2015 00:41:44 -0400
Received: from office.waterlogic.com.au (27-33-194-165.tpgi.com.au [27.33.194.165])
	by mail15.tpgi.com.au (envelope-from paul@pauljones.id.au) (8.14.3/8.14.3) with ESMTP id t8A4fd0U015112
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Sep 2015 14:41:41 +1000
From: Paul Jones <paul@pauljones.id.au>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Cancel device remove?
Date: Thu, 10 Sep 2015 04:41:37 +0000
Message-ID: <B7F2379062E32745A8651FBDB20F64596913D2BD@Server.waterlogic.com.au>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Is there some way to cancel a device remove operation? I have discovered that if I reboot that will cancel it, but that's not always possible. What I'm after is something the same as cancelling scrub.
I keep running into situations where I want to pause a remove operation for speed reasons.

Thanks!
Paul.
