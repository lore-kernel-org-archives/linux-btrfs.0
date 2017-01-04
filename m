Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aquinas.techsquare.com ([75.125.237.226]:38048 "EHLO
        techsquare.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S967247AbdADPyL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Jan 2017 10:54:11 -0500
Received: from dhcp-18-189-120-26.dyn.mit.edu ([18.189.120.26])
        by techsquare.com with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
        (Exim 4.71)
        (envelope-from <matt@techsquare.com>)
        id 1cOnRI-0007p0-9F
        for linux-btrfs@vger.kernel.org; Wed, 04 Jan 2017 10:25:22 -0500
To: linux-btrfs@vger.kernel.org
From: Matt McKinnon <matt@techsquare.com>
Message-ID: <c0d145b6-6c81-ef52-4876-85eab927bae7@techsquare.com>
Date: Wed, 4 Jan 2017 10:25:17 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Subject: kernel crash after upgrading to 4.9
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi All,

I seem to have a similar issue to a subject in December:

Subject: page allocation stall in kernel 4.9 when copying files from one 
btrfs hdd to another

In my case, this is caused when rsync'ing large amounts of data over NFS 
to the server with the BTRFS file system.  This was not apparent in the 
previous kernel (4.7).

The poster mentioned some suggestions from Ducan here:

https://mail-archive.com/linux-btrfs@vger.kernel.org/msg60083.html

But those are not visible in the thread.  What suggestions were given to 
help alleviate this pain?

-Matt
