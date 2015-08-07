Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from static.68.134.40.188.clients.your-server.de ([188.40.134.68]:57328
	"EHLO mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbbHGIUs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Aug 2015 04:20:48 -0400
To: linux-btrfs@vger.kernel.org
Cc: Mark Fasheh <mfasheh@suse.de>, Chris Mason <clm@fb.com>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Missing dedupe/locking patch in integration-4.2 tree?
Message-ID: <55C46842.2000301@googlemail.com>
Date: Fri, 7 Aug 2015 10:11:46 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Mark's patch titled

  "[PATCH 3/5] btrfs: fix clone / extent-same deadlocks" [1]

from his "btrfs: dedupe fixes, features" series is missing from the integration-4.2 tree and 4.2-rc5, where it still applies cleanly (as of 5 mins ago).

Any particular reason why this was silently dropped?

-h

[1] http://www.spinics.net/lists/linux-btrfs/msg45149.html
