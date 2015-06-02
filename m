Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:36007 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbbFBCiP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Jun 2015 22:38:15 -0400
Received: by igbpi8 with SMTP id pi8so76647302igb.1
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Jun 2015 19:38:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1433208291.7073.52.camel@scientia.net>
References: <1433208291.7073.52.camel@scientia.net>
Date: Mon, 1 Jun 2015 20:38:14 -0600
Message-ID: <CAJCQCtS1sQ26KTL3NUe0vq-8HKsv_g2f94Hrk_zbQEsTGovPNA@mail.gmail.com>
Subject: Re: possible raid6 corruption
From: Chris Murphy <lists@colorremedies.com>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm seeing three separate problems:

May 19 03:25:39 lcg-lrz-dc10 kernel: [903095.585150] megasas:
megasas_aen_polling waiting for controller reset to finish for scsi0
May 19 03:25:50 lcg-lrz-dc10 kernel: [903106.581205] sd 0:0:14:0:
Device offlined - not ready after error recovery

I don't know if that's controller related or drive related. In either
case it's hardware related. And then:

May 28 16:40:43 lcg-lrz-dc10 kernel: [1727608.170703] BTRFS: bdev
/dev/sdm errs: wr 12, rd 0, flush 0, corrupt 0, gen 0
May 28 16:40:50 lcg-lrz-dc10 kernel: [1727615.608552] BTRFS: bdev
/dev/sdm errs: wr 12, rd 1, flush 0, corrupt 0, gen 0
...
May 28 16:43:16 lcg-lrz-dc10 kernel: [1727761.077607] BTRFS: bdev
/dev/sdm errs: wr 28, rd 21596, flush 0, corrupt 0, gen 0

This is just the fs saying it can't write to one particular drive, and
then also many read failures. And then:


May 28 21:03:06 lcg-lrz-dc10 kernel: [1743336.369569] BTRFS: lost page
write due to I/O error on /dev/sdm
May 28 21:03:07 lcg-lrz-dc10 kernel: [1743337.093299] sd 0:0:14:0:
rejecting I/O to offline device
May 28 21:03:07 lcg-lrz-dc10 kernel: [1743337.094348] BTRFS (device
sdp): bad tree block start 3328214216270427953 3448651776

So another lost write to the same drive, sdm, and then new problem
which is bad tree block on a different drive sdp. And then:

May 28 21:03:07 lcg-lrz-dc10 kernel: [1743337.096927] BTRFS: error -5
while searching for dev_stats item for device /dev/sdm!
May 28 21:03:07 lcg-lrz-dc10 kernel: [1743337.097314] BTRFS warning
(device sdp): Skipping commit of aborted transaction.

It still hasn't given up on sdm (which seems kinda odd by now that
there are thousands of read errors and the kernel thinks it's offline
anyway), but then now has to deal with problems with sdp. The
resulting stack trace though suggests a umount was in progress?


May 28 22:55:56 lcg-lrz-dc10 kernel: [1750099.616565] CPU: 4 PID:
134844 Comm: umount Tainted: G        W       4.0.0-trunk-amd64 #1
Debian 4.0-1~exp1



https://bugs.launchpad.net/ubuntu/+source/linux/+bug/891115
That's an old bug, kernel 3.2 era. But ultimately it looks like it was
hardware related.


Chris Murphy
