Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:56707 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750737AbdEUBiU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 20 May 2017 21:38:20 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dCFoy-0002JK-PQ
        for linux-btrfs@vger.kernel.org; Sun, 21 May 2017 03:38:12 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH v2 2/2] Btrfs: compression must free at least PAGE_SIZE
Date: Sun, 21 May 2017 01:38:06 +0000 (UTC)
Message-ID: <pan$42cee$29ae88fa$3ea3d443$c10a99e5@cox.net>
References: <20170520164953.7344-1-nefelim4ag@gmail.com>
        <20170520164953.7344-3-nefelim4ag@gmail.com>
        <20170520191400.25202d75@jupiter.sol.kaishome.de>
        <CAGqmi76cLmXOj=P7qeR58n1aHNB-6e1R0yo+PjuMVLLgnWaryg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Timofey Titovets posted on Sat, 20 May 2017 21:30:47 +0300 as excerpted:

> 2017-05-20 20:14 GMT+03:00 Kai Krakow <hurikhan77@gmail.com>:
> 
>> BTW: What's the smallest block size that btrfs stores? Is it always
>> PAGE_SIZE? I'm not familiar with btrfs internals...

Thanks for asking the question. =:^)  I hadn't made the below conflicting 
patch sets association until I saw it.

> https://btrfs.wiki.kernel.org/index.php/Manpage/mkfs.btrfs

> AFAIK btrfs works with storage and account data by PAGE_SIZEd block,
> so it's must be usefull to check if compressed size will give as at
> least one PAGE_SIZE space.

[Not a dev, just a btrfs list regular and btrfs user.  If the devs say 
different...]

While AFAIK, btrfs now saves data in page-size blocks (tho note that if 
the entire file is under a block it may be inlined into metadata 
depending on various limits, at least one of which is configurable)...

There is a sub-page-size patch set that has already been thru several 
revision cycles and AFAIK, remains on the roadmap for eventual merge.

You'd need to check the list or ask the devs about current status, but 
it's quite possible the current code checking for at least one byte of 
compression savings, instead of the at least PAGE_SIZE bytes of savings 
that at present would make more sense, is in anticipation of that patch 
set being merged.

If the sub-page-size block patch-set is no longer anticipated to be 
merged in the relatively near future, it may be worth changing the 
compression profit checks to PAGE_SIZE minimum, as this patch set does, 
but the two patch sets clearly do conflict in concept, so merging this 
one is unlikely to be wise if the other one is still on track for merging.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

