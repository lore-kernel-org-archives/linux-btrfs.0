Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:56777 "EHLO
        mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751817AbdGINAa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Jul 2017 09:00:30 -0400
Received: from merkaba.localnet (ppp-93-104-47-0.dynamic.mnet-online.de [93.104.47.0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.lichtvoll.de (Postfix) with ESMTPSA id F1B52D9005
        for <linux-btrfs@vger.kernel.org>; Sun,  9 Jul 2017 15:00:27 +0200 (CEST)
From: Martin Steigerwald <martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: 4.11.6 / more corruption / root 15455 has a root item with a more recent gen (33682) compared to the found root node (0)
Date: Sun, 09 Jul 2017 15:00:27 +0200
Message-ID: <8928893.KSgCgv7lUQ@merkaba>
In-Reply-To: <pan$2b9aa$a4dca8a2$fc1e4ebe$a8fffbe3@cox.net>
References: <20170501170641.GG3516@merlins.org> <MEXPR01MB216863F67F4553F8564CC3CD9EA80@MEXPR01MB2168.ausprd01.prod.outlook.com> <pan$2b9aa$a4dca8a2$fc1e4ebe$a8fffbe3@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Duncan.

Duncan - 09.07.17, 11:17:
> Paul Jones posted on Sun, 09 Jul 2017 09:16:36 +0000 as excerpted:
> >> Marc MERLIN - 08.07.17, 21:34:
> >> > This is now the 3rd filesystem I have (on 3 different machines) that
> >> > is getting corruption of some kind (on 4.11.6).
> >> 
> >> Anyone else getting corruptions with 4.11?
> >> 
> >> I happily switch back to 4.10.17 or even 4.9 if that is the case. I may
> >> even do so just from your reports. Well, yes, I will do exactly that. I
> >> just switch back for 4.10 for now. Better be safe, than sorry.
> > 
> > No corruption for me - I've been on 4.11 since about .2 and everything
> > seems fine. Currently on 4.11.8
> 
> No corruptions here either. 4.12.0 now, previously 4.12-rc5(ish, git),
> before that 4.11.0.
> 
> I have however just upgraded to new ssds then wiped and setup the old
[…]
> Also, all my btrfs are raid1 or dup for checksummed redundancy, and
> relatively small, the largest now 80 GiB per device, after the upgrade.
> And my use-case doesn't involve snapshots or subvolumes.
> 
> So any bug that is most likely on older filesystems, say those without
> the no-holes feature, for instance, or that doesn't tend to hit raid1 or
> dup mode, or that is less likely on small filesystems on fast ssds, or
> that triggers most often with reflinks and thus on filesystems with
> snapshots, is unlikely to hit me.

Hmmm, the BTRFS filesystems on my laptop 3 to 5 or even more years old. I stick 
with 4.10 for now, I think.

The older ones are RAID 1 across two SSDs, the newer one is single device, on 
one SSD.

These filesystems didn´t fail me in years and since 4.5 or 4.6 even the "I 
search for free space" kernel hang (hung tasks and all that) is gone as well.

Thanks,
-- 
Martin
