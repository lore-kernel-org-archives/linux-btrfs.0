Return-Path: <SRS0=6tJf=MR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 689EAC00449
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 10:20:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 338062084D
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 10:20:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 338062084D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cox.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728025AbeJERS6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Oct 2018 13:18:58 -0400
Received: from [195.159.176.226] ([195.159.176.226]:48076 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1727535AbeJERS6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Oct 2018 13:18:58 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1g8NBp-0008WB-O0
        for linux-btrfs@vger.kernel.org; Fri, 05 Oct 2018 12:18:33 +0200
X-Injected-Via-Gmane: http://gmane.org/
To:     linux-btrfs@vger.kernel.org
From:   Duncan <1i5t5.duncan@cox.net>
Subject: Re: Transaction aborted error -28 clone_finish_inode_update
Date:   Fri, 5 Oct 2018 10:18:27 +0000 (UTC)
Message-ID: <pan$ecd8c$bd7ed29d$90a3d00a$d10e0947@cox.net>
References: <a4a4cf31-9cf4-e52c-1f86-c62d336c9cd1@codepoets.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@blaine.gmane.org
User-Agent: Pan/0.146 (Hic habitat felicitas; 22c743dad)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

David Goodwin posted on Thu, 04 Oct 2018 17:44:46 +0100 as excerpted:

> While trying to run/use bedup ( https://github.com/g2p/bedup ) .... I
> hit this :
> 
> 
> [Thu Oct  4 15:34:51 2018] ------------[ cut here ]------------
> [Thu Oct  4 15:34:51 2018] BTRFS: Transaction aborted (error -28)
> [Thu Oct  4 15:34:51 2018] WARNING: CPU: 0 PID: 28832 at
> fs/btrfs/ioctl.c:3671 clone_finish_inode_update+0xf3/0x140 

> [Thu Oct  4 15:34:51 2018] CPU: 0 PID: 28832 Comm: bedup Not tainted
> 4.18.10-psi-dg1 #1

[snipping a bunch of stuff that I as a non-dev list regular can't do much 
with anyway]

> [Thu Oct  4 15:34:51 2018] BTRFS: error (device xvdg) in
> clone_finish_inode_update:3671: errno=-28 No space left
> [Thu Oct  4 15:34:51 2018] BTRFS info (device xvdg): forced readonly 

> % btrfs fi us /filesystem/
> Overall:
>      Device size:           7.12TiB
>      Device allocated:      6.80TiB
>      Device unallocated:    330.93GiB
>      Device missing:        0.00B
>      Used:                  6.51TiB
>      Free (estimated):      629.87GiB    (min: 629.87GiB)
>      Data ratio:            1.00
>      Metadata ratio:        1.00
>      Global reserve:        512.00MiB    (used: 0.00B)
> 
> Data+Metadata,single: Size:6.80TiB, Used:6.51TiB
>     /dev/xvdf       1.69TiB
>     /dev/xvdg       3.12TiB
>     /dev/xvdi       1.99TiB
> 
> System,single: Size:32.00MiB, Used:780.00KiB
>     /dev/xvdf      32.00MiB
> 
> Unallocated:
>     /dev/xvdf     320.97GiB
>     /dev/xvdg     949.00MiB
>     /dev/xvdi       9.03GiB
> 
> 
> I kind of think there is sufficient free space..... at least globally
> within the filesystem.
> 
> Does it require balancing to redistribute the unallocated space better?
> Or is something misbehaving?

The latter, but unfortunately there's not much you can do about it at 
this point but wait for fixes, unless you want to spit up that huge 
filesystem into several smaller ones.

In general, btrfs has at least four kinds of "space" that it can run out 
of, tho in your case it appears you're running mixed-mode so data and 
metadata space are combined into one.

* Unallocated space:  This is space that remains entirely unallocated in 
the filesystem.  It matters most when the balance between data and 
metadata space gets off.

This isn't a problem for you as in single mode space can be allocated 
from any device and you have one with hundreds of gigs unallocated.  It 
also tends to be less of a problem on mixed-bg mode, which you're 
running, as there's no distinction in mixed-mode between data and 
metadata.

* Data chunk space:
* Metadata chunk space:

Because you're running mixed-bg mode, there's no distinction between 
these two, but for normal mode, running out of one or the other while all 
the free space is allocated to chunks of the other type, can be a problem.

* Global reserve:  Taken from metadata, the global reserve is space the 
system won't normally use, that it tries to keep clear in ordered to be 
able to finish transactions once they're started, as btrfs' copy-on-write 
semantics means even deleting stuff requires a bit of additional space 
temporarily.

This seems to actually be where the problem is, because currently, 
certain btrfs operations such as reflinking/cloning/snapshotting (that 
is, just what you were doing) don't really calculate the needed space 
correctly and use arbitrary figures, which can be *wildly* off, while 
conversely a bare half-gig of global-reserve for a huge 7+ TiB filesystem 
seems rather proportionally small.  (Consider that my small pair-device 
btrfs raid1 root filesystem, 8-GiB/device, 16 GiB total, has a 16 MiB 
reserve, proportionally, your 7+ TB filesystem would have 7+ GiB reserve, 
but it only has a half GiB.)

So relatively small btrfs' don't tend to run into the problem, because 
they have proportionally larger reserves to begin with.  Plus they 
probably don't have proportionally as many snapshots/reflinks/etc, 
either, so the problem simply doesn't trigger for them.

Now I'm not a dev and my own use-case doesn't include either snapshotting 
or deduping, so I haven't paid that much attention to the specifics, but 
I have seen some recent patches on-list that based on the explanations 
should go some way toward fixing this problem by using more realistic 
figures for global-reserve calculations.  At this point those patches 
would be for 4.20 (which might be 5.0), or possibly 4.21, but the devs 
are indeed working on the problem and it should get better within a 
couple kernel cycles.

Alternatively perhaps the global reserve size could be bumped up on such 
large filesystems, but let's see if the more realistic operations-reserve 
calculations can fix things, first, as arguably that shouldn't be 
necessary once the calculations aren't so arbitrarily wild.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

