Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:50938 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932472AbaHZKUe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Aug 2014 06:20:34 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Chris Mason <clm@fb.com>
Cc: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v3] Btrfs: fix task hang under heavy compressed write
Date: Tue, 26 Aug 2014 12:20:28 +0200
Message-ID: <5413015.p5ELBzGdTR@merkaba>
In-Reply-To: <53FB4F05.6050801@fb.com>
References: <1407829499-21902-1-git-send-email-bo.li.liu@oracle.com> <1408117013-305-1-git-send-email-bo.li.liu@oracle.com> <53FB4F05.6050801@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Montag, 25. August 2014, 10:58:13 schrieb Chris Mason:
> On 08/15/2014 11:36 AM, Liu Bo wrote:
> > This has been reported and discussed for a long time, and this hang occurs
> > in both 3.15 and 3.16.
> 
> [ great description ]
> 
> I ran this through tests last week, and an overnight test over the
> weekend.  It's in my for-linus branch now, along with everything else I
> plan on sending for rc3.
> 
> Please double check my merge, I had to undo your rebase onto Miao's patches.

I would like to test this on 3.17-rc2, what do I need to do to make it apply 
cleanly? That function in disk-io.c looks quite different from what the patch 
assumes at the beginning, so I am not sure how to merge this.

martin@merkaba:~/Computer/Merkaba/Kernel/linux> patch -p1 < "../[PATCH v3] 
Btrfs_fix task hang under heavy compressed write.mbox"   
patching file fs/btrfs/async-thread.c
patching file fs/btrfs/async-thread.h
patching file fs/btrfs/delayed-inode.c
patching file fs/btrfs/disk-io.c
Hunk #2 FAILED at 713.
Hunk #3 succeeded at 827 (offset -29 lines).
1 out of 3 hunks FAILED -- saving rejects to file fs/btrfs/disk-io.c.rej
patching file fs/btrfs/extent-tree.c
patching file fs/btrfs/inode.c
Hunk #1 succeeded at 1096 (offset -15 lines).
Hunk #2 succeeded at 1883 (offset -43 lines).
Hunk #3 succeeded at 2825 (offset -47 lines).
Hunk #4 succeeded at 2835 (offset -47 lines).
Hunk #5 succeeded at 7166 (offset -345 lines).
Hunk #6 succeeded at 8504 (offset -371 lines).
patching file fs/btrfs/ordered-data.c
patching file fs/btrfs/qgroup.c
Hunk #1 succeeded at 2720 (offset -2 lines).
patching file fs/btrfs/raid56.c
patching file fs/btrfs/reada.c
patching file fs/btrfs/scrub.c
Hunk #1 succeeded at 428 (offset 1 line).
Hunk #2 succeeded at 999 (offset 2 lines).
Hunk #3 succeeded at 1616 (offset -8 lines).
Hunk #4 succeeded at 3204 (offset -29 lines).
patching file fs/btrfs/volumes.c
Hunk #1 succeeded at 5800 (offset -87 lines).

Otherwise, I´d wait till rc3, as my current 3.16.2 with v1 of this patch seems 
to behave stable with trees occupying all space:

merkaba:~> btrfs fi sh /home
Label: 'home'  uuid: […]
        Total devices 2 FS bytes used 127.69GiB
        devid    1 size 160.00GiB used 160.00GiB path /dev/dm-0
        devid    2 size 160.00GiB used 160.00GiB path /dev/mapper/sata-home

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
