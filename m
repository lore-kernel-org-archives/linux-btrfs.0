Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f193.google.com ([209.85.220.193]:35384 "EHLO
	mail-vc0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708Ab3JVC1k (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Oct 2013 22:27:40 -0400
Received: by mail-vc0-f193.google.com with SMTP id id10so275573vcb.0
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Oct 2013 19:27:39 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 22 Oct 2013 10:27:39 +0800
Message-ID: <CAC+R54B=O46o4q6OMRzC-=ZeKD3Mjjn-6i-UGLFKQCP1StOQ8w@mail.gmail.com>
Subject: btrfs flush data cache
From: shuo lv <lilofile82@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

transaction_kthread can periodically commit data and metedata to
disk,similarly btrfs_writepages can write data page to disk, in which
situation btrfs_writepages function is called? and i cannot find
btrfs_writepages is called in btrfs code? who can tell me?
