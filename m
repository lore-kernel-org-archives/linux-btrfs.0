Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57915 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950Ab3HaVug (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 31 Aug 2013 17:50:36 -0400
Received: by mail-pb0-f46.google.com with SMTP id rq2so3264212pbb.33
        for <linux-btrfs@vger.kernel.org>; Sat, 31 Aug 2013 14:50:36 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 31 Aug 2013 14:50:36 -0700
Message-ID: <CAN05THSnkRsRytfPZcn8eBqD_Y4BgjQTmJ9CsZC6h03xHzXJLA@mail.gmail.com>
Subject: Unmountable BTRFS with parent transid verify failed
From: ronnie sahlberg <ronniesahlberg@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have a 9 disk raid1 filesystem that is no longer mountable.
I am using ubuntu 13.04 with kernel 3.8.0-26-generic


What happened was that I was removing a device using
btrfs device delete
and this was running for quite a while (I was removing a 3T device)
but eventually this failed with the btrfs command segfaulting.

Now when I have rebooted but the filesystem does not mount.
When I run "btrfsck /dev/sde" I get a lot of

parent transid verify failed on 35344449986560 wanted 301481 found 301495
parent transid verify failed on 35344449986560 wanted 301481 found 301495
parent transid verify failed on 35344449986560 wanted 301481 found 301495
parent transid verify failed on 35344449986560 wanted 301481 found 301495
Ignoring transid failure
leaf parent key incorrect 35344449986560
leaf parent key incorrect 35344446398464
bad block 35344446398464

And while btrfsck eventually does complete  the filesystem remains unmountable.

Any advice ?


regards
ronnie sahlberg
