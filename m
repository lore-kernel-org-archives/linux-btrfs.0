Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-co1nam03on0042.outbound.protection.outlook.com ([104.47.40.42]:56607
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753389AbeAFBeP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 Jan 2018 20:34:15 -0500
From: "Karsai, Gabor" <gabor.karsai@Vanderbilt.Edu>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: btrfs quota exceeded notifications through netlink sockets
Date: Sat, 6 Jan 2018 01:34:09 +0000
Message-ID: <660251B721353E428446B0F99FE510A2A508D507@ITS-HCWNEM102.ds.vanderbilt.edu>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I created a subvolume on a btrfs, set a limit and the quota is enforced - dumping too much data into the subvolume results in a 'quota exceeded' message (from dd, for example). But when I am trying to get netlink socket notifications, nothing arrives on the socket (I am using pyroute2 which is supposedly able to receive disk quota notifications)

$ uname -a
Linux riaps-dev 4.10.0-42-generic #46~16.04.1-Ubuntu SMP Mon Dec 4 15:57:59 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux

btrfs: whatever Ubuntu 16.04 has 

Kconfig:
CONFIG_QUOTA_NETLINK_INTERFACE=y

Any advice would be appreciated.
Thanks,
-- Gabor Karsai


