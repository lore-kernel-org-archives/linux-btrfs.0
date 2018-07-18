Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:43727 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1726708AbeGRJS5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Jul 2018 05:18:57 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1ffi03-0003DG-7O
        for linux-btrfs@vger.kernel.org; Wed, 18 Jul 2018 10:39:55 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH 0/4] 3- and 4- copy RAID1
Date: Wed, 18 Jul 2018 08:39:48 +0000 (UTC)
Message-ID: <pan$47c54$5df59e3d$ab971dce$aa203b1@cox.net>
References: <cover.1531503452.git.dsterba@suse.com>
        <9945d460-99b5-a927-a614-c797bbc7862d@dirtcellar.net>
        <d340ce28-6c93-22d4-0f56-73de8e55f1f6@libero.it>
        <pan$b5258$f3ecc84$8e06948b$54511335@cox.net>
        <793d8ec3-7934-ea60-521d-7a039c9f1ce9@libero.it>
        <pan$98af2$39851f53$ef9fd141$bfd51f5b@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan posted on Wed, 18 Jul 2018 07:20:09 +0000 as excerpted:

>> As implemented in BTRFS, raid1 doesn't have striping.
> 
> The argument is that because there's only two copies, on multi-device
> btrfs raid1 with 4+ devices of equal size so chunk allocations tend to
> alternate device pairs, it's effectively striped at the macro level,
> with the 1 GiB device-level chunks effectively being huge individual
> device strips of 1 GiB.
> 
> At 1 GiB strip size it doesn't have the typical performance advantage of
> striping, but conceptually, it's equivalent to raid10 with huge 1 GiB
> strips/chunks.

I forgot this bit...

Similarly, multi-device single is regarded by some to be conceptually 
equivalent to raid0 with really huge GiB strips/chunks.

(As you may note, "the argument is" and "regarded by some" are distancing 
phrases.  I've seen the argument made on-list, but while I understand the 
argument and agree with it to some extent, I'm still a bit uncomfortable 
with it and don't normally make it myself, this thread being a noted 
exception tho originally I simply repeated what someone else already said 
in-thread, because I too agree it's stretching things a bit.  But it does 
appear to be a useful conceptual equivalency for some, and I do see the 
similarity.

Perhaps it's a case of coder's view (no code doing it that way, it's just 
a coincidental oddity conditional on equal sizes), vs. sysadmin's view 
(code or not, accidental or not, it's a reasonably accurate high-level 
description of how it ends up working most of the time with equivalent 
sized devices).)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

