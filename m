Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.sws.net.au ([203.15.121.86]:60462 "EHLO smtp.sws.net.au"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750703AbdIDFTe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 4 Sep 2017 01:19:34 -0400
Received: from athena.localnet (unknown [1.152.175.208])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: russell@coker.com.au)
        by smtp.sws.net.au (Postfix) with ESMTPSA id 6DE1BEDDD
        for <linux-btrfs@vger.kernel.org>; Mon,  4 Sep 2017 15:19:35 +1000 (AEST)
From: Russell Coker <russell+btrfs@coker.com.au>
To: linux-btrfs@vger.kernel.org
Reply-To: russell+btrfs@coker.com.au
Subject: read-only for no good reason on 4.9.30
Date: Mon, 04 Sep 2017 15:19:30 +1000
Message-ID: <1841512.lHhB7WV3Ld@russell.coker.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have a system with less than 50% disk space used.  It just started rejecting 
writes due to lack of disk space.  I ran "btrfs balance" and then it started 
working correctly again.  It seems that a btrfs filesystem if left alone will 
eventually get fragmented enough that it rejects writes (I've had similar 
issues with other systems running BTRFS with other kernel versions).

Is this a known issue?

Is there any good way of recognising when it's likely to happen?  Is there 
anything I can do other than rewriting a medium size file to determine when 
it's happened?

# uname -a 
Linux trex 4.9.0-3-amd64 #1 SMP Debian 4.9.30-2+deb9u2 (2017-06-26) x86_64 
GNU/Linux
# df -h / 
Filesystem      Size  Used Avail Use% Mounted on 
/dev/sdc        239G  113G  126G  48% /
# btrfs fi df / 
Data, RAID1: total=117.00GiB, used=111.81GiB 
System, RAID1: total=32.00MiB, used=48.00KiB 
Metadata, RAID1: total=1.00GiB, used=516.00MiB 
GlobalReserve, single: total=246.59MiB, used=0.00B
# btrfs dev usa / 
/dev/sdc, ID: 1 
  Device size:           238.47GiB 
  Device slack:              0.00B 
  Data,RAID1:            117.00GiB 
  Metadata,RAID1:          1.00GiB 
  System,RAID1:           32.00MiB 
  Unallocated:           120.44GiB 

/dev/sdd, ID: 2 
  Device size:           238.47GiB 
  Device slack:              0.00B 
  Data,RAID1:            117.00GiB 
  Metadata,RAID1:          1.00GiB 
  System,RAID1:           32.00MiB 
  Unallocated:           120.44GiB

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/

