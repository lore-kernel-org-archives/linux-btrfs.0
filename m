Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wj0-f177.google.com ([209.85.210.177]:34844 "EHLO
        mail-wj0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1032033AbdAEMi7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Jan 2017 07:38:59 -0500
Received: by mail-wj0-f177.google.com with SMTP id i20so33619551wjn.2
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Jan 2017 04:38:46 -0800 (PST)
Subject: Re: [PATCH v3 0/6] Btrfs: incremental send, fix serval case failure
From: Giuseppe Della Bianca <g.dellabianca@gestiware.it>
To: robbieko@synology.com
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 Jan 2017 13:39:25 +0100
Message-ID: <1483619965.3503.11.camel@localhost>
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi.

This looks bit like at my issue with the differential sending/receiving
and snapshot deleting.

Thanks for the test cases and for the patches.


Regards. 

Gdb

>>robbieko Thu, 05 Jan 2017 00:47:54 -0800


>>From: Robbie Ko <robbi...@synology.com>

>>Patch for fix btrfs incremental send.
>>These patches base on v4.8.0-rc8
>>V3: Improve the change log
>>V2: Add a new patch "add generation check in existence demtermination for
    the parent directory"

>>Robbie Ko (6):
>>  Btrfs: incremental send, fix failure to rename with the name collision
>>  Btrfs: incremental send, fix invalid path for truncate operations
>>  Btrfs: incremental send, fix not necessary waiting for rmdir operation
>>  Btrfs: incremental send, fix invalid path for rmdir operations
>>  Btrfs: incremental send, fix invalid rename operations
>>  Btrfs: incremental send, fix invalid utime operations
]zac[


