Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:43541 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686Ab3FGDLm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Jun 2013 23:11:42 -0400
Received: by mail-wg0-f42.google.com with SMTP id n12so927431wgh.1
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Jun 2013 20:11:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130607015500.GC29248@localhost.localdomain>
References: <CAK-xaQabh32xjmytaJXZqYicAaZivrPYx-LOSt+kZYc6q18WBQ@mail.gmail.com>
 <20130607015500.GC29248@localhost.localdomain>
From: Andrea Gelmini <andrea.gelmini@gmail.com>
Date: Fri, 7 Jun 2013 05:11:20 +0200
Message-ID: <CAK-xaQbWxqjxCfW9+C_cbSktiUR2DwX9aMX1V9j_qCmvhi14Qg@mail.gmail.com>
Subject: Re: btrfsck: free-space-cache.c:813: btrfs_add_free_space: Assertion
 `!(ret == -17)' failed
To: Josef Bacik <jbacik@fusionio.com>
Cc: Linux BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2013/6/7 Josef Bacik <jbacik@fusionio.com>:
> and see if that works better?  Thanks,

Perfect:
Checking filesystem on /dev/mapper/toshi
UUID: 35eb15cd-d7e3-4be8-92f1-7b210353e241
checking extents
checking free space cache
checking fs roots
checking csums
checking root refs
found 86358842550 bytes used err is 0
total csum bytes: 628677868
total tree bytes: 843415552
total fs tree bytes: 64225280
total extent tree bytes: 59244544
btree space waste bytes: 105300529
file data blocks allocated: 643975458816
 referenced 645510266880
Btrfs v0.20-rc1

Now I'm scrubbing.

Thanks a lot,
Andrea
