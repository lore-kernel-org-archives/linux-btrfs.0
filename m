Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f170.google.com ([209.85.128.170]:34248 "EHLO
        mail-wr0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751099AbdGGQmT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Jul 2017 12:42:19 -0400
Received: by mail-wr0-f170.google.com with SMTP id 77so54286961wrb.1
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Jul 2017 09:42:18 -0700 (PDT)
MIME-Version: 1.0
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 7 Jul 2017 10:42:16 -0600
Message-ID: <CAJCQCtR+dJr8H2co41LB0hEUZCFSnkixeyv46ccdureMiBVTWg@mail.gmail.com>
Subject: btrfs device ready purpose
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm digging through piles of list emails and not really finding an
answer to this. Maybe it's Friday and I'm just confused...


[root@f26s ~]# btrfs device ready /dev/sda1
[root@f26s ~]# echo $?
0
[root@f26s ~]# btrfs device ready /dev/mapper/vg-1
[root@f26s ~]# echo $?
0


/dev/sda1 is a single device btrfs and it is present, 'btrfs fi show' finds it.
/dev/mapper/vg-1 is one member of a two device Btrfs volume, the
missing device is /dev/mapper/vg-2 and 'btrfs fi show' sees 1 but not
2 and says a device is missing.

And yet the ready command completes and the exit code is the same, and
I just don't understand the purpose of this command. The man page says
"wait" but I don't see any waiting, so at the very least we probably
need to come up with a more descriptive man page description.

Thanks.


-- 
Chris Murphy
