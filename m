Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33772 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751525AbdE3OFb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 May 2017 10:05:31 -0400
Received: by mail-wm0-f65.google.com with SMTP id b84so25534630wmh.0
        for <linux-btrfs@vger.kernel.org>; Tue, 30 May 2017 07:05:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170526002631.8546-1-bo.li.liu@oracle.com>
References: <20170526002631.8546-1-bo.li.liu@oracle.com>
From: Ivan Sizov <sivan606@gmail.com>
Date: Tue, 30 May 2017 17:05:09 +0300
Message-ID: <CAMG9ccwjBmP9HKkodwARxQK7AkC68HACMzuT43wX6+gmWVUjbg@mail.gmail.com>
Subject: Re: [PATCH 0/6] add sanity check for extent inline ref type
To: Liu Bo <bo.li.liu@oracle.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-05-26 3:26 GMT+03:00 Liu Bo <bo.li.liu@oracle.com>:
>Patch 6 adds scrub support to detect the corruption, so users can be
noticed when they do scrub on a regular basis.
>I'm not sure in the real world what may result in this corruption

I've caught this type of corruption in the wild. The big rsync backup
always ends with a kernel crash due to BUG() statement in
ctime.h:1779. After applying this patchset and running scrub I've got
following messages:

[sivan@fruestuck ~]$ dmesg | grep "invalid extent inline"
[ 8812.428673] eb 4631634034688(tree block) invalid extent inline ref type 0
[ 8812.429148] BTRFS error (device sdb1): scrub: extent
2994741510144(0x2b944810000) has an invalid extent inline ref type,
ignored.
[ 8812.430086] eb 4631634034688(tree block) invalid extent inline ref type 0
[ 8812.430569] BTRFS error (device sdb1): scrub: extent
2994741559296(0x2b94481c000) has an invalid extent inline ref type,
ignored.

How to find the cause of the corruption? Should I try to fix it, or it
is not dangerous for the filesystem? If I should, how to do that?
