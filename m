Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:36884 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbaGJOlY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Jul 2014 10:41:24 -0400
Received: by mail-lb0-f177.google.com with SMTP id u10so6101069lbd.22
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Jul 2014 07:41:23 -0700 (PDT)
MIME-Version: 1.0
From: Andrew Flerchinger <lorax3@gmail.com>
Date: Thu, 10 Jul 2014 10:41:02 -0400
Message-ID: <CAGTBuzTWV2jVqy4uScevHbMi-kp4_TRdeR21ZoA3-yOtCXPA=g@mail.gmail.com>
Subject: File server structure suggestion
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I am going to be building a new file server in a couple weeks and am
deciding on how to structure it. Previously, I ran RAID5 through mdadm
and XFS on Debian, but I had a silently bad drive that corrupted data
without dropping from the array. I suspected this was happening, and
changed over to ZFS on FreeNAS and the monthly scrub told me exactly
what was going on. That sold me on the idea of data checksums, but I'd
rather stay in linux than BSD, and I previously made use of online
capacity expansion as needed, which ZFS doesn't support.

Enter btrfs. Unfortunately, it's newer than ZFS and isn't as robust,
but it does support online capacity expansion, and the on disk format
is expect to be stable. It has data checksums and COW, which are the
primary things I'm after. RAID10 seems pretty stable, but RAID56
isn't.

So I'm looking for a suggestion. My end goal is RAID6 and expand it a
drive at a time as needed. For right now, I can either:

1) Run RAID6, but be aware of its limitations. I can manually remove
and add drives in separate steps if needed. Keep the server on a UPS
to limit unexpected shutdowns and any corruption there. The whole
array can't be scrubbed, but if there is a chechsum problem when
reading individual data, will that still be corrected and/or logged?
This will be a temporary situation, as over time, more features will
be built out, and the existing file system will be better supported.

2) Run RAID10, and convert the file system to RAID6 later once it is
stable. Since RAID10 is far more stable and feature complete than
RAID56 right now, all features will work okay, I'm just buying more
drives/running at lower capacity for the moment. If I have to grow the
array, I'd have to buy two drives. In the future, once RAID6 is better
supported, I can convert in-place to RAID6.

What do you think?

Thanks,
Andrew
