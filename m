Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:32851 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754926Ab3FGBBL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Jun 2013 21:01:11 -0400
Received: by mail-we0-f181.google.com with SMTP id p58so2571964wes.40
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Jun 2013 18:01:10 -0700 (PDT)
MIME-Version: 1.0
From: Andrea Gelmini <andrea.gelmini@gmail.com>
Date: Fri, 7 Jun 2013 03:00:50 +0200
Message-ID: <CAK-xaQabh32xjmytaJXZqYicAaZivrPYx-LOSt+kZYc6q18WBQ@mail.gmail.com>
Subject: btrfsck: free-space-cache.c:813: btrfs_add_free_space: Assertion
 `!(ret == -17)' failed
To: Linux BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi everybody,
   and thanks a lot for your support and work.

   I've an external hard drive formatted with BTRFS that sometimes
goes readonly (no complains in logs or dmesg output).

   It happens with kernel v9.4 and latest vanilla kernel in dev, too.

   If I check it I got (git BTRFS progs):

./btrfsck /dev/mapper/toshi
Checking filesystem on /dev/mapper/toshi
UUID: 35eb15cd-d7e3-4be8-92f1-7b210353e241
checking extents
checking free space cache
btrfs: unable to add free space :-17
btrfsck: free-space-cache.c:813: btrfs_add_free_space: Assertion
`!(ret == -17)' failed.

Thanks a lot for your time,
Andrea
