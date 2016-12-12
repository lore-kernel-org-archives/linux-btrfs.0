Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-12v.sys.comcast.net ([96.114.154.171]:38933 "EHLO
        resqmta-po-12v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750999AbcLLM1q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Dec 2016 07:27:46 -0500
Received: from calvin.localdomain ([10.0.0.8])
        by beta.localdomain with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.84_2)
        (envelope-from <twalberg@comcast.net>)
        id 1cGPZv-0002ss-Jp
        for linux-btrfs@vger.kernel.org; Mon, 12 Dec 2016 06:19:35 -0600
Received: from tew by calvin.localdomain with local (Exim 4.84_2)
        (envelope-from <tew@calvin.localdomain>)
        id 1cGPZv-0001iW-Eg
        for linux-btrfs@vger.kernel.org; Mon, 12 Dec 2016 06:19:35 -0600
Date: Mon, 12 Dec 2016 06:19:35 -0600
From: Tim Walberg <twalberg@comcast.net>
To: linux-btrfs@vger.kernel.org
Subject: btrfs check --repair question
Message-ID: <20161212121935.GA4345@comcast.net>
Reply-To: Tim Walberg <twalberg@comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

All -

I have a file system I'm having some issues with. The initial symptoms were that mount
would run for several hours, either committing or rolling back transactions (primarily
due to a balance that was running when the system was rebooted for other reasons -
the skip_balance mount option was specified because of this), but would then be killed
due to an OOM condition (not much else running on the box at the time - a desktop system
where everything else was waiting for the mount to finish). That's the background. Kernel
4.8.1 - custom config, but otherwise stock kernel - and btrfs-tools 4.8.3.

Ran btrfs check, and the only thing it reports is a sequence of these:

ref mismatch on [5400814960640 16384] extent item 0, found 1
Backref 5400814960640 parent 5401010913280 root 5401010913280 not found in extent tree
backpointer mismatch on [5400814960640 16384]
owner ref check failed [5400814960640 16384]

Which, to my reading are simply some missing backrefs, and probably should be one of the
easier issues to correct, but I know --repair is still considered experimental/dangerous,
so I thought I'd ask before I run it... Is this a case that --repair can be reasonably
expected to handle, or would I be better off recreating the file system and restoring from
either my saved btrfs send archives or the more reliable backups?


		      tw



-- 
twalberg@gmail.com
