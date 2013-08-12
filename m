Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f170.google.com ([209.85.220.170]:39872 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756780Ab3HLQ5T (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Aug 2013 12:57:19 -0400
Received: by mail-vc0-f170.google.com with SMTP id kw10so3017531vcb.29
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Aug 2013 09:57:18 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 12 Aug 2013 19:57:18 +0300
Message-ID: <CAOv4OrWkKGL37r+gnMtB8KbQip61NjhPpX1YA-rLCZQu4vDzHA@mail.gmail.com>
Subject: BTRFS corruptions counter
From: Todor Ivanov <t.i.ivanov@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

We decided to give BTRFS a try. We find it very flexible and generally
fast. However last week we had a problem with a Marvell controller in
AHCI and one BTRFS formatted hard drive. We isolated the problem by
relocating the disk to an Intel contoller (SATA controller: Marvell
Technology Group Ltd. 88SE9172 SATA 6Gb/s Controller (rev 11) had a
lot of problems and I managed to overcome them by passing
libata.force=noncq for a couple of weeks, until it failed generally).
Now that the disk is on the intel contoller it works fine and data is
intact, but whenever I do mount or unmount I see:

Aug 10 18:34:47 MyServerHere kernel: btrfs: bdev /dev/sde1 errs: wr 0,
rd 0, flush 0, corrupt 166, gen 0

The problem is "corrupt 166"
Sofar I did:

1. btrfsck and it reported everything is OK
2. btrfs scrub start /dev/sde1 and it again reported all is OK

Am I missing something in my filesystem checks or there is another way
to zero the corrupt counter?

Regards,
Todor
