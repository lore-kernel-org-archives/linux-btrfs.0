Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f173.google.com ([209.85.220.173]:37158 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758531AbaGOJm0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Jul 2014 05:42:26 -0400
Received: by mail-vc0-f173.google.com with SMTP id hy10so5701895vcb.4
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Jul 2014 02:42:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3431118.WpiWX9X6ip@xev>
References: <CANcfdL3ZUwOGPf2YQpyXYSd8ZoNntyaX8rdQXdciSADGCsb-Sg@mail.gmail.com>
 <5907875.Oun3LlLFiV@xev> <CANcfdL1Ldf0-Bbe16bRyUtA+cpupTzqYLdzmHrsOJacE5c92Lw@mail.gmail.com>
 <3431118.WpiWX9X6ip@xev>
From: constantine <costas.magnuse@gmail.com>
Date: Tue, 15 Jul 2014 11:42:05 +0200
Message-ID: <CANcfdL0E+gFkVQWkzy+MJ5PZhB2y51_k3OQF+Ygekhbw=_ZrKg@mail.gmail.com>
Subject: Re: Btrfs and LBA errors
To: russell@coker.com.au
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thank you very much for your advice. It worked!

I verified that the superblocks 1 and 2 had similar information with
btrfs-show-super -i 1 /dev/sdc1 (and -i 2) and then with crossed
fingers:
btrfs-select-super  -s 2 /dev/sdc1
which restored my btrfs filesystem.

Then I runned scrub. For future reference, scrub was "stuck":
"
# btrfs scrub status partition/
scrub status for c1eb1aaf-665a-4337-9d04-3c3921aa67e0
scrub started at Thu Jul 10 21:30:41 2014, running for 2743 seconds
   total bytes scrubbed: 193.47GiB with 0 errors
"
and could not cancel it:
"
btrfs scrub cancel partition/
ERROR: scrub cancel failed on Downloads/: not running
"
After deleting /var/lib/btrfs/scrub.status.c1eb1aaf-665a-4337-9d04-3c3921aa67e0
it was completed successfully.

Many thanks!
