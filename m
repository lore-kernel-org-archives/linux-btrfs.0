Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([91.121.75.85]:56416 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933012AbdJRFKy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Oct 2017 01:10:54 -0400
Date: Wed, 18 Oct 2017 10:10:52 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Cameron Kelley <cameronkelley28@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: Mount failing - unable to find logical
Message-ID: <20171018101052.3e5221af@natsu>
In-Reply-To: <93bfd00c-1ade-176d-0c0f-675fe904ab88@gmx.com>
References: <8aa155ab-4722-9448-0f9e-b383f37d7973@gmail.com>
        <93bfd00c-1ade-176d-0c0f-675fe904ab88@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 18 Oct 2017 09:24:01 +0800
Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:

> 
> 
> On 2017年10月18日 04:43, Cameron Kelley wrote:
> > Hey btrfs gurus,
> > 
> > I have a 4 disk btrfs filesystem that has suddenly stopped mounting
> > after a recent reboot. The data is in an odd configuration due to
> > originally being in a 3 disk RAID1 before adding a 4th disk and running
> > a balance to convert to RAID10. There wasn't enough free space to
> > completely convert, so about half the data is still in RAID1 while the
> > other half is in RAID10. Both metadata and system are RAID10. It has
> > been in this configuration for 6 months or so now since adding the 4th
> > disk. It just holds archived media and hasn't had any data added or
> > modified in quite some time. I feel pretty stupid now for not correcting
> > that sooner though.
> > 
> > I have tried mounting with different mount options for recovery, ro,
> > degraded, etc. Log shows errors about "unable to find logical
> > 3746892939264 length 4096"
> > 
> > When I do a btrfs check, it doesn't find any issues. Running
> > btrfs-find-root comes up with a message about a block that the
> > generation doesn't match. If I specify that block on the btrfs check, I
> > get transid verify failures.
> > 
> > I ran a dry run of a recovery of the entire filesystem which runs
> > through every file with no errors. I would just restore the data and
> > start fresh, but unfortunately I don't have the free space at the moment
> > for the ~4.5TB of data.
> > 
> > I also ran full smart self tests on all 4 disks with no errors.
> > 
> > root@nas2:~# uname -a
> > Linux nas2 4.13.7-041307-generic #201710141430 SMP Sat Oct 14 14:39:06
> > UTC 2017 i686 i686 i686 GNU/Linux
> 
> I don't think i686 kernel will cause any difference, but considering
> most of us are using x86_64 to develop/test, maybe it will be a good
> idea to upgrade to x86_64 kernel?

Indeed a problem with mounting on 32-bit in 4.13 has been reported recently:
https://www.spinics.net/lists/linux-btrfs/msg69734.html
with the same error message.

I believe it's this patchset that is supposed to fix that.
https://www.spinics.net/lists/linux-btrfs/msg70001.html

@Cameron maybe you didn't just reboot, but also upgraded your kernel at the
same time? In any case, try a 4.9 series kernel, or a 64-bit machine if you
want to stay with 4.13.

-- 
With respect,
Roman
