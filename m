Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:33327 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S935989AbdKPQms (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Nov 2017 11:42:48 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1eFNFK-0001Hp-H5
        for linux-btrfs@vger.kernel.org; Thu, 16 Nov 2017 17:42:34 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: Tiered storage?
Date: Thu, 16 Nov 2017 17:42:34 +0100
Message-ID: <20171116174234.0b6c21cc@jupiter.sol.kaishome.de>
References: <2093578773.146320.1510707691482.JavaMail.zimbra@karlsbakk.net>
        <08cbefb3-43eb-8d76-1dd6-191e2709bdc7@dirtcellar.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Wed, 15 Nov 2017 08:11:04 +0100
schrieb waxhead <waxhead@dirtcellar.net>:

> As for dedupe there is (to my knowledge) nothing fully automatic yet. 
> You have to run a program to scan your filesystem but all the 
> deduplication is done in the kernel.
> duperemove works apparently quite well when I tested it, but there
> may be some performance implications.

There's bees as near-line deduplication tool, that is it watches for
generation changes in the filesystem and walks the inodes. It only
looks at extents, not at files. Deduplication itself is then delegated
to the kernel which ensures all changes are data-safe. The process is
running as a daemon and processes your changes in realtime (delayed by
a few seconds to minutes of course, due to transaction commit and
hashing phase).

You need to dedicate it part of your RAM to work, around 1 GB is
usually sufficient to work well enough. The RAM will be locked and
cannot be swapped out, so you should have a sufficiently equipped
system.

Works very well here (2TB of data, 1GB hash table, 16GB RAM).
New dDuplicated files are picked up within seconds, scanned (hitting
the cache most of the time thus not requiring physical IO), and then
submitted to the kernel for deduplication.

I'd call that fully automatic: Once set up, it just works, and works
well. Performance impact is very low once the initial scan is done.

https://github.com/Zygo/bees


-- 
Regards,
Kai

Replies to list-only preferred.

