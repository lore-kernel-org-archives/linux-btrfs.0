Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:55943 "EHLO
        mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750912AbcIKPct (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Sep 2016 11:32:49 -0400
From: Martin Steigerwald <martin@lichtvoll.de>
To: Imran Geriskovan <imran.geriskovan@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Small fs
Date: Sun, 11 Sep 2016 17:32:44 +0200
Message-ID: <5440522.9CHaGU5Wjs@merkaba>
In-Reply-To: <CAK5rZE49j5QYZJSriG70LVo-9JnRJRfwFA0qRZSEotXpCxJC6A@mail.gmail.com>
References: <CAK5rZE49j5QYZJSriG70LVo-9JnRJRfwFA0qRZSEotXpCxJC6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sonntag, 11. September 2016, 18:27:30 CEST schrieben Sie:
> What is the smallest recommended fs size for btrfs?
> 
> - There are mentions of 256MB around the net.
> - Gparted reserves minimum of 256MB for btrfs.
> 
> With an ordinary partition on a single disk,
> fs created with just "mkfs.btrfs /dev/sdxx":
> - 128MB works fine.
> - 127MB works but as if it is 64MB.
> 
> Can we say size should be in multiples of 64MB?

Do you want to know the smalled *recommended* or the smallest *possible* size?

I personally wouldn´t go below one or two GiB or or so with BTRFS. On small 
filesystems, I don´t know the treshold right now it uses a mixed metadata/data 
format. And I think using smaller BTRFS filesystem invited any left over 
"filesystem is full while it isn´t" issues.

Well there we go. Excerpt from mkfs.btrfs(8) manpage:

       -M|--mixed
           Normally the data and metadata block groups are isolated.
           The mixed mode will remove the isolation and store both
           types in the same block group type. This helps to utilize
           the free space regardless of the purpose and is suitable
           for small devices. The separate allocation of block groups
           leads to a situation where the space is reserved for the
           other block group type, is not available for allocation and
           can lead to ENOSPC state.

           The recommended size for the mixed mode is for filesystems
           less than 1GiB. The soft recommendation is to use it for
           filesystems smaller than 5GiB. The mixed mode may lead to
           degraded performance on larger filesystems, but is
           otherwise usable, even on multiple devices.

           The nodesize and sectorsize must be equal, and the block
           group types must match.

               Note
               versions up to 4.2.x forced the mixed mode for devices
               smaller than 1GiB. This has been removed in 4.3+ as it
               caused some usability issues.

Thanks
-- 
Martin
