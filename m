Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from old.lon-b.elastichosts.com ([84.45.121.3]:55043 "EHLO
	lon-b.elastichosts.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752589AbaEANtp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 May 2014 09:49:45 -0400
Received: from [79.135.116.105] (helo=[192.168.0.76])
	by lon-b.elastichosts.com with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.72)
	(envelope-from <alin.dobre@elastichosts.com>)
	id 1Wfr6R-0003qL-JH
	for linux-btrfs@vger.kernel.org; Thu, 01 May 2014 14:32:43 +0100
Message-ID: <53624D07.2000602@elastichosts.com>
Date: Thu, 01 May 2014 14:32:55 +0100
From: Alin Dobre <alin.dobre@elastichosts.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Negative qgroup sizes
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I am having trouble with one of the btrfs subvolumes, as it shows
negative quota accounting values, like in the following output:

  # btrfs qgroup show -f /tmp/test
  qgroupid rfer                 excl
  -------- ----                 ----
  0/299    -1576960             -1511424

Running a "btrfs quota rescan -w /tmp/test" seems to fix it, but it
seems to come back pretty often (happened twice in the last couple of
days). I can't think of a possible reproduction of the problem, so I'm
just stuck. Here's the output of subvolume after the rescan, maybe it
also gives you some insight:

  # btrfs qgroup show -f /tmp/test
  qgroupid rfer       excl
  -------- ----       ----
  0/299    1065955328 1056542720

The kernel we are using is 3.14.1 (stable) and the btrfs-progs version
is 3.12.

Any idea on why this happens or if there's an obvious fix I missed?

Cheers,
Alin.
