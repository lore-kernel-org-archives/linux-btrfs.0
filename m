Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:35221 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbcFCNbT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Jun 2016 09:31:19 -0400
Received: by mail-oi0-f45.google.com with SMTP id w184so126606126oiw.2
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Jun 2016 06:31:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <aeade1fe-825c-6fc2-7f6d-85f4c5400b38@gmail.com>
References: <CAGQ70Yc=HHxJspMCKFBpEURRu=53pZW3k3rVDVO3QPGP_b9Tkw@mail.gmail.com>
 <aeade1fe-825c-6fc2-7f6d-85f4c5400b38@gmail.com>
From: Martin <rc6encrypted@gmail.com>
Date: Fri, 3 Jun 2016 15:31:17 +0200
Message-ID: <CAGQ70YeZzDgiT_v1Z0eGcWsn8prnji30hCkyjrBg8vNziLUkiQ@mail.gmail.com>
Subject: Re: Recommended why to use btrfs for production?
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> In general, avoid Ubuntu LTS versions when dealing with BTRFS, as well as
> most enterprise distros, they all tend to back-port patches instead of using
> newer kernels, which means it's functionally impossible to provide good
> support for them here (because we can't know for sure what exactly they've
> back-ported).  I'd suggest building your own kernel if possible, with Arch
> Linux being a close second (they follow upstream very closely), followed by
> Fedora and non-LTS Ubuntu.

Then I would build my own, if that is the preferred option.

> Do not use BTRFS raid6 mode in production, it has at least 2 known serious
> bugs that may cause complete loss of the array due to a disk failure.  Both
> of these issues have as of yet unknown trigger conditions, although they do
> seem to occur more frequently with larger arrays.

Ok. No raid6.

> That said, there are other options.  If you have enough disks, you can run
> BTRFS raid1 on top of LVM or MD RAID5 or RAID6, which provides you with the
> benefits of both.
>
> Alternatively, you could use BTRFS raid1 on top of LVM or MD RAID1, which
> actually gets relatively decent performance and can provide even better
> guarantees than RAID6 would (depending on how you set it up, you can lose a
> lot more disks safely).  If you go this way, I'd suggest setting up disks in
> pairs at the lower level, and then just let BTRFS handle spanning the data
> across disks (BTRFS raid1 mode keeps exactly two copies of each block).
> While this is not quite as efficient as just doing LVM based RAID6 with a
> traditional FS on top, it's also a lot easier to handle reshaping the array
> on-line because of the device management in BTRFS itself.

Right now I only have 10TB of backup data, but this is grow when
urbackup is roled out. So maybe I could get a way with plain btrfs
raid10 for the first year, and then re-balance to raid6 when the two
bugs have been found...

is the failed disk handling in btrfs raid10 considered stable?
