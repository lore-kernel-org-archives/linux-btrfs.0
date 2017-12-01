Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aquinas.techsquare.com ([75.125.237.226]:58629 "EHLO
        techsquare.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751677AbdLAOqb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Dec 2017 09:46:31 -0500
Received: from dhcp-18-189-126-59.dyn.mit.edu ([18.189.126.59])
        by techsquare.com with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
        (Exim 4.71)
        (envelope-from <matt@techsquare.com>)
        id 1eKmFg-0004uc-VM
        for linux-btrfs@vger.kernel.org; Fri, 01 Dec 2017 09:25:28 -0500
To: linux-btrfs@vger.kernel.org
From: Matt McKinnon <matt@techsquare.com>
Message-ID: <bb2cfbcb-31dd-715c-114f-59d574a2012b@techsquare.com>
Date: Fri, 1 Dec 2017 09:25:14 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Subject: btrfs-transacti hammering the system
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi All,

Is there any way to figure out what exactly btrfs-transacti is chugging 
on?  I have a few file systems that seem to get wedged for days on end 
with this process pegged around 100%.  I've stopped all snapshots, made 
sure no quotas were enabled, turned on autodefrag in the mount options, 
tried manual defragging, kernel upgrades, yet still this brings my 
system to a crawl.

Network I/O to the system seems very tiny.  The only I/O I see to the 
disk is btrfs-transacti writing a couple M/s.

# time touch foo

real    2m54.303s
user    0m0.000s
sys     0m0.002s

# uname -r
4.12.8-custom

# btrfs --version
btrfs-progs v4.13.3

Yes, I know I'm a bit behind there...

-Matt



