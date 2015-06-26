Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54146 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752143AbbFZRAi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Jun 2015 13:00:38 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1Z8WzR-0005X1-0r
	for linux-btrfs@vger.kernel.org; Fri, 26 Jun 2015 19:00:33 +0200
Received: from barriere.frankfurter-softwarefabrik.de ([217.11.197.1])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jun 2015 19:00:32 +0200
Received: from lvml by barriere.frankfurter-softwarefabrik.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jun 2015 19:00:32 +0200
To: linux-btrfs@vger.kernel.org
From: Lutz Vieweg <lvml@5t9.de>
Subject: btrfs filesystem defrag fails with "Resource temporarily unavailable"
 when strace'd
Date: Fri, 26 Jun 2015 19:00:27 +0200
Message-ID: <mmk0fb$jpn$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I started...
   btrfs filesystem defragment -v /some/directory
and this took (unexpectedly, for just 150M of data) a long time (minutes).

So I wondered whether I could see via "strace -p PID" what was going on with the process.

Immediately when strace tries to attach, the btrfs process dies with this error message:

> ERROR: defrag failed on /some/directory - Resource temporarily unavailable

This is 100% reproducable.

The strace output looks like this:
> Process 1402 attached
> brk(0)                                  = 0x1468000
> brk(0)                                  = 0x1468000
> brk(0x1460000)                          = 0x1460000
> brk(0)                                  = 0x1460000
> close(3)                                = 0
> write(2, "ERROR: defrag failed on /some/d"..., 84) = 84
> write(1, "btrfs-progs v4.1\n", 17)      = 17
> write(2, "total 1 failures\n", 17)      = 17
> exit_group(1)                           = ?
> +++ exited with 1 +++

This is the first time I see a prozess crash upon strace being attached -
is this intended behaviour? If so... why?

(Tried again without strace, "the btrfs filesystem defragment" command later
finished ok, albeight after a loong time.)

Regards,

Lutz Vieweg

