Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:40382 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754718AbaHZMEB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Aug 2014 08:04:01 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: bo.li.liu@oracle.com
Cc: Chris Mason <clm@fb.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v3] Btrfs: fix task hang under heavy compressed write
Date: Tue, 26 Aug 2014 14:04 +0200
Message-ID: <13694505.X5eM3fMWWZ@merkaba>
In-Reply-To: <20140826103802.GG16865@localhost.localdomain>
References: <1407829499-21902-1-git-send-email-bo.li.liu@oracle.com> <5413015.p5ELBzGdTR@merkaba> <20140826103802.GG16865@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Dienstag, 26. August 2014, 18:38:03 schrieb Liu Bo:
> On Tue, Aug 26, 2014 at 12:20:28PM +0200, Martin Steigerwald wrote:
> > Am Montag, 25. August 2014, 10:58:13 schrieb Chris Mason:
> > > On 08/15/2014 11:36 AM, Liu Bo wrote:
> > > > This has been reported and discussed for a long time, and this hang
> > > > occurs
> > > > in both 3.15 and 3.16.
> > > 
> > > [ great description ]
> > > 
> > > I ran this through tests last week, and an overnight test over the
> > > weekend.  It's in my for-linus branch now, along with everything else I
> > > plan on sending for rc3.
> > > 
> > > Please double check my merge, I had to undo your rebase onto Miao's
> > > patches.> 
> > I would like to test this on 3.17-rc2, what do I need to do to make it
> > apply cleanly? That function in disk-io.c looks quite different from what
> > the patch assumes at the beginning, so I am not sure how to merge this.
> > 
> > martin@merkaba:~/Computer/Merkaba/Kernel/linux> patch -p1 < "../[PATCH v3]
> > Btrfs_fix task hang under heavy compressed write.mbox"
> > patching file fs/btrfs/async-thread.c
> > patching file fs/btrfs/async-thread.h
> > patching file fs/btrfs/delayed-inode.c
> > patching file fs/btrfs/disk-io.c
> > Hunk #2 FAILED at 713.
> > Hunk #3 succeeded at 827 (offset -29 lines).
> > 1 out of 3 hunks FAILED -- saving rejects to file fs/btrfs/disk-io.c.rej
> > patching file fs/btrfs/extent-tree.c
> > patching file fs/btrfs/inode.c
> > Hunk #1 succeeded at 1096 (offset -15 lines).
> > Hunk #2 succeeded at 1883 (offset -43 lines).
> > Hunk #3 succeeded at 2825 (offset -47 lines).
> > Hunk #4 succeeded at 2835 (offset -47 lines).
> > Hunk #5 succeeded at 7166 (offset -345 lines).
> > Hunk #6 succeeded at 8504 (offset -371 lines).
> > patching file fs/btrfs/ordered-data.c
> > patching file fs/btrfs/qgroup.c
> > Hunk #1 succeeded at 2720 (offset -2 lines).
> > patching file fs/btrfs/raid56.c
> > patching file fs/btrfs/reada.c
> > patching file fs/btrfs/scrub.c
> > Hunk #1 succeeded at 428 (offset 1 line).
> > Hunk #2 succeeded at 999 (offset 2 lines).
> > Hunk #3 succeeded at 1616 (offset -8 lines).
> > Hunk #4 succeeded at 3204 (offset -29 lines).
> > patching file fs/btrfs/volumes.c
> > Hunk #1 succeeded at 5800 (offset -87 lines).
> > 
> > Otherwise, I´d wait till rc3, as my current 3.16.2 with v1 of this patch
> > seems to behave stable with trees occupying all space:
> > 
> > merkaba:~> btrfs fi sh /home
> > Label: 'home'  uuid: […]
> > 
> >         Total devices 2 FS bytes used 127.69GiB
> >         devid    1 size 160.00GiB used 160.00GiB path /dev/dm-0
> >         devid    2 size 160.00GiB used 160.00GiB path
> >         /dev/mapper/sata-home
> 
> Hmm, the v3 patch is based on Chris's integration branch, so it's expected
> not to apply it cleanly.  But if you're urgent, I can provide a patch based
> on 3.17-rc2.
> 
> (rc3 is coming soon though ;-) )

I see.

Well I can stick with 3.16.1 for the time being. But if you want some 
additional testing soonish, feel free to provide a patch.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
