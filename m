Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:59321 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751846AbeAZOCl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 09:02:41 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id ABCB120F35
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jan 2018 09:02:40 -0500 (EST)
Message-Id: <1516975360.4083556.1249069832.1B287A04@webmail.messagingengine.com>
From: Christophe Yayon <cyayon-list@nbux.org>
To: "Majordomo vger.kernel.org" <linux-btrfs@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Date: Fri, 26 Jan 2018 15:02:40 +0100
Subject: degraded permanent mount option
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I don't know if it the right place to ask. Sorry it's not...

Just a little question about "degraded" mount option. Is it a good idea to add this option (permanent) in fstab and grub rootflags for raid1/10 array ? Just to allow the system to boot again if a single hdd fail.

Of course, i have some cron jobs to check my array health.

Thanks.

-- 
  Christophe Yayon
  cyayon-list@nbux.org
