Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve1eur01on0062.outbound.protection.outlook.com ([104.47.1.62]:13760
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752548AbdBNMTv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Feb 2017 07:19:51 -0500
To: <linux-btrfs@vger.kernel.org>
From: Luca Citi <lciti@essex.ac.uk>
Subject: "btrfs receive" throws "No space left on device" on empty and large
 enough fs
Message-ID: <2506b3c0-2ecd-d59a-5ed7-b870a2493776@essex.ac.uk>
Date: Tue, 14 Feb 2017 12:19:44 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all

I recently submitted a bug report to launchpad ( 
https://bugs.launchpad.net/ubuntu/+source/btrfs-tools/+bug/1664013 ) but 
I now found out about this mailing list, which may be a better place to 
post.

Basically, whenever many files are created at high throughput in my 
empty btrfs file system, it throws an ENOSPC error.I have had this 
happen with both "btrfs receive" and with "rsync" but not when creating 
a single large file. Both "rsync" and "btrfs receive" fail not when 
creating a new file but when renaming/moving it (see link).

I hope the description of the error in launchpad is helpful (please let 
me know if I need to re-post it here).
I am happy to provide additional information or run other tests if this 
can help.

Thanks!
Luca
