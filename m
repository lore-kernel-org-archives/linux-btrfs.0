Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:35087 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbbJLSha (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Oct 2015 14:37:30 -0400
Received: by igbkq10 with SMTP id kq10so78558547igb.0
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2015 11:37:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+wwUFCw8EiAuLKx+5y1sY5km_o5AdN7-k=dLXkUc5PvD9POUA@mail.gmail.com>
References: <CA+wwUFBKOxHSXOn9rcG+k5CTaKMPWGnx2a5dNo=CCfzawRLKGg@mail.gmail.com>
	<20151012132136.GE27761@twin.jikos.cz>
	<BLU436-SMTP165112E5F4D118F381D47A4A9310@phx.gbl>
	<CA+wwUFCw8EiAuLKx+5y1sY5km_o5AdN7-k=dLXkUc5PvD9POUA@mail.gmail.com>
Date: Mon, 12 Oct 2015 12:37:30 -0600
Message-ID: <CAJCQCtQAqHxqvSk9vVmMfgytJBN6SLdamwWy0Ads=rtLckigxA@mail.gmail.com>
Subject: Re: BTRFS with 8TB SMR drives
From: Chris Murphy <lists@colorremedies.com>
To: Warren Hughes <wsh@warrenhughes.net>
Cc: Henk Slager <hslager@hotmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I get a lot of these from both sdb and sdc

Oct 11 23:00:03 cloud.warrenhughes.net kernel: sd 0:0:1:0: [sdb]
UNKNOWN(0x2003) Result: hostbyte=0x00 driverbyte=0x08
Oct 11 23:00:03 cloud.warrenhughes.net kernel: sd 0:0:1:0: [sdb] Sense
Key : 0x3 [current]
Oct 11 23:00:03 cloud.warrenhughes.net kernel: sd 0:0:1:0: [sdb]
ASC=0x11 ASCQ=0x0
Oct 11 23:00:03 cloud.warrenhughes.net kernel: sd 0:0:1:0: [sdb] CDB:
opcode=0x88 88 00 00 00 00 00 11 b3 e1 98 00 00 00 08 00 00
Oct 11 23:00:03 cloud.warrenhughes.net kernel: blk_update_request:
critical medium error, dev sdb, sector 297001368



Oct 11 23:47:32 cloud.warrenhughes.net kernel: sd 0:0:2:0: [sdc]
UNKNOWN(0x2003) Result: hostbyte=0x00 driverbyte=0x08
Oct 11 23:47:32 cloud.warrenhughes.net kernel: sd 0:0:2:0: [sdc] Sense
Key : 0x3 [current] [descriptor]
Oct 11 23:47:32 cloud.warrenhughes.net kernel: sd 0:0:2:0: [sdc]
ASC=0x11 ASCQ=0x0
Oct 11 23:47:32 cloud.warrenhughes.net kernel: sd 0:0:2:0: [sdc] CDB:
opcode=0x88 88 00 00 00 00 01 3e 0a 7d 80 00 00 01 00 00 00
Oct 11 23:47:32 cloud.warrenhughes.net kernel: blk_update_request:
critical medium error, dev sdc, sector 5335842176

There are a lot of these kinds of errors and they aren't all for the
same LBA +/- 8 so they're are different physical sectors affected on
both drives, but I don't know what the error is.


Oct 10 07:42:36 cloud.warrenhughes.net kernel: sd 0:0:1:0: [sdb]
15628053168 512-byte logical blocks: (8.00 TB/7.27 TiB)
Oct 10 07:42:36 cloud.warrenhughes.net kernel: sd 0:0:1:0: [sdb]
4096-byte physical blocks

sd 0:0:1:0 starts out as sdb, but then goes a bit crazy somehow and
eventually gets offlined
Oct 11 23:55:24 cloud.warrenhughes.net kernel: sd 0:0:1:0: rejecting
I/O to offline device

And then reappears as sdo

Oct 11 23:57:56 cloud.warrenhughes.net kernel: sd 0:0:1:0: [sdo]
15628053168 512-byte logical blocks: (8.00 TB/7.27 TiB)

But no further scsi messages for this drive while Btrfs now complains
about sdo instead of sdb. Seems to me that this device is confused
even about its own error reporting. Anyway both sdb and sdc were
having problems at the same time.


Chris Murphy
