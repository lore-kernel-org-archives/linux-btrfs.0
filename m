Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aquinas.techsquare.com ([75.125.237.226]:38804 "EHLO
        techsquare.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752445AbeDLVsU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Apr 2018 17:48:20 -0400
Received: from [128.119.201.136]
        by techsquare.com with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
        (Exim 4.71)
        (envelope-from <matt@techsquare.com>)
        id 1f6jQr-0005MS-8b
        for linux-btrfs@vger.kernel.org; Thu, 12 Apr 2018 17:07:06 -0400
To: linux-btrfs@vger.kernel.org
From: Matt McKinnon <matt@techsquare.com>
Message-ID: <8a1d5f92-88f9-8793-f074-21a228f32472@techsquare.com>
Date: Thu, 12 Apr 2018 17:06:58 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Subject: BUG during send, cannot delete subvolume
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi All,

I had a ctree.c error during a send/receive backup:

kernel BUG at fs/btrfs/ctree.c:1862

Nothing seemed to go wrong otherwise on the file system.  After 
restarting the send, it completed, but I'm left with a subvolume I can't 
delete:

BTRFS warning (device sdb1): Attempt to delete subvolume 176188 during send

I don't see any zombie btrfs send processes lying around.  Is there 
anyway to delete this volume?  Do I just need a reboot?

-Matt
