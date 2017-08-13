Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:37992 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750816AbdHMPFN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 13 Aug 2017 11:05:13 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dguRr-0003dT-Gt
        for linux-btrfs@vger.kernel.org; Sun, 13 Aug 2017 17:05:03 +0200
To: linux-btrfs@vger.kernel.org
From: Adam Hunt <voxadam@gmail.com>
Subject: lazytime mount =?CP1251?Q?option=97no?= support in Btrfs
Date: Sun, 13 Aug 2017 11:50:59 +0000 (UTC)
Message-ID: <ompef3$sim$1@blaine.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Back in 2014 Ted Tso introduced the lazytime mount option for ext4 and 
shortly thereafter a more generic VFS implementation which was then 
merged into mainline. His early patches included support for Btrfs but 
those changes were removed prior to the feature being merged. His 
changelog includes the following note about the removal:

  - Per Christoph's suggestion, drop support for btrfs and xfs for now, 
    issues with how btrfs and xfs handle dirty inode tracking.  We can add
    btrfs and xfs support back later or at the end of this series if we
    want to revisit this decision. 

My reading of the current mainline shows that Btrfs still lacks any 
support for lazytime. Has any thought been given to adding support for 
lazytime to Btrfs?

Thanks,

Adam

