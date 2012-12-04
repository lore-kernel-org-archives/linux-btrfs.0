Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33131 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab2LDBWH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Dec 2012 20:22:07 -0500
Received: by mail-pa0-f46.google.com with SMTP id bh2so2342707pad.19
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Dec 2012 17:22:06 -0800 (PST)
Message-Id: <E53AAC14-57EF-43AD-809F-96F00945245A@gmail.com>
From: Travis LaDuke <travisladuke@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Can't mount luks partition after reboot
Date: Mon, 3 Dec 2012 17:22:04 -0800
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is kind of silly, but may be salvageable...
I made a btrfs on top of luks partition and tried it for a couple  
days. Then I made another luks partition on another drive then added  
and balanced that new drive as btrfs raid1.  A lot of time passed and  
the balance finished.

Then I rebooted. The original partition will luksOpen, but btrfs won't  
mount it. The 2nd one is in worse shape, it won't even luksOpen.
I haven't tried btrfsck yet. Is there something else I should try  
first? What debug info can I post?

halp
--travis
