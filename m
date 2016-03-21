Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:36660 "EHLO
	mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbcCUAC0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Mar 2016 20:02:26 -0400
Received: by mail-io0-f177.google.com with SMTP id 124so41840018iov.3
        for <linux-btrfs@vger.kernel.org>; Sun, 20 Mar 2016 17:02:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <000c01d18300$93b757c0$bb260740$@codenest.com>
References: <000c01d18300$93b757c0$bb260740$@codenest.com>
Date: Sun, 20 Mar 2016 18:02:25 -0600
Message-ID: <CAJCQCtQWC8g5v61aAKeH4Zwer6xF=etiEfu5SAfnO-v0zcK+Jg@mail.gmail.com>
Subject: Re: kernel BUG at fs/btrfs/volumes.c:5519 when hot-removing device in RAID-1
From: Chris Murphy <lists@colorremedies.com>
To: James Johnston <johnstonj.public@codenest.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There are a number of things missing from multiple device support,
including any concept of a device becoming faulty (i.e. persistent
failures rather than transient which Btrfs seems to handle OK for the
most part), and then also getting it to go degraded automatically, and
finally hot spare support. There are patches that could use testing.

https://www.spinics.net/lists/linux-btrfs/msg52084.html
http://www.spinics.net/lists/linux-btrfs/msg53048.html

I think when testing, it's simpler to not use any additional device
mapper layers. Yes those should work, but it has to work with Btrfs on
the raw partition or device first. Then add additional layers one at a
time as the use case requires, testing in between the additions.
Otherwise it makes it harder to isolate.


Chris Murphy
