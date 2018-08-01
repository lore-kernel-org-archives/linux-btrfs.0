Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:41508 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1729769AbeHAJjl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Aug 2018 05:39:41 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1fklwO-0000AM-6q
        for linux-btrfs@vger.kernel.org; Wed, 01 Aug 2018 09:53:04 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: csum failed on raid1 even after clean scrub?
Date: Wed, 1 Aug 2018 07:52:58 +0000 (UTC)
Message-ID: <pan$52810$75612769$2a695738$2cb031b6@cox.net>
References: <CAMOu_z0HuviCqK9fFFjFA52GMbbWCVmd4GgORzwx754j+JAfDg@mail.gmail.com>
        <09e9001a-b624-cc78-eee5-3dd139eb02bc@gmx.com>
        <CAMOu_z0d+CB3JXBgwXtj2gZGTdtCjKOZNHEuB43DxXprubKW=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sterling Windmill posted on Mon, 30 Jul 2018 21:06:54 -0400 as excerpted:

> Both drives are identical, Seagate 8TB external drives

Are those the "shingled" SMR drives, normally sold as archive drives and 
first commonly available in the 8TB size, and often bought for their 
generally better price-per-TB without fully realizing the implications.

There have been bugs regarding those drives in the past, and while I 
believe those bugs were fixed and AFAIK current status is no known SMR-
specific bugs, they really are /not/ particularly suited to btrfs usage 
even for archiving, and definitely not to general usage (that is, pretty 
much anything but the straight-up archiving use-case they are sold for) 
use-cases.

Of course USB connections are notorious for being unreliable in terms of 
btrfs usage as well, and I'd really hate to think what a combination of 
SMR on USB might wreak.

If they're not SMR then carry-on! =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

