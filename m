Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:55429 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751898AbeABCFQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Jan 2018 21:05:16 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1eWBv3-0004qH-88
        for linux-btrfs@vger.kernel.org; Tue, 02 Jan 2018 03:03:09 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: A Big Thank You, and some Notes on Current Recovery Tools.
Date: Tue, 2 Jan 2018 02:03:01 +0000 (UTC)
Message-ID: <pan$e5649$323c2eeb$2471e3a9$d73fbcc8@cox.net>
References: <CAJt7KB9UuW5Zg35VJ+fNV8RVZk_kAukmcgyK8GH4d1M286DkXA@mail.gmail.com>
        <c3d54bf6-20a8-0b98-baef-d2353b97849e@gmx.com>
        <1clphe-a7q.ln1@hurikhan77.spdns.de>
        <CAJt7KB-sq0sxHe_3LSC5kzU0CG8ABk4baDnGP138vNaLK0KN-Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Stirling Westrup posted on Mon, 01 Jan 2018 14:44:43 -0500 as excerpted:

> In hind sight (which is always 20/20), I should have updated the backups
> before starting to make my changes, but as I'd just added a new 4T drive
> to the BTRFS RAID6 in my backup system a week before, and it went as
> smooth as butter, I guess I was feeling insufficiently paranoid.

Are you aware of btrfs raid56-mode history?

If you're running a current enough kernel (wiki says 4.12 for raid56 
mode, but you might want 4.14 for other fixes and/or the fact that it's 
LTS) the severest known raid56 issues that had it recommendation-
blacklisted are fixed, but raid56 mode still doesn't have fixes for the 
infamous parity-raid write hole, and parities are not checksummed, in 
hindsight an implementation mistake as it breaks btrfs' otherwise 
integrity and checksumming guarantees, that's going to require an on-disk 
format change and some major work to fix.

If you're running at least kernel 4.12 and are aware of and understand 
the remaining raid56 caveats, raid56 mode can be a valid choice, but if 
not, I strongly recommend doing more research to learn and understand 
those caveats, before relying too heavily on that backup.

The most reliable and well tested btrfs multi-device mode remains raid1, 
tho that's expensive in terms of space required since it duplicates 
everything.  For many devices, the recommendation seems to remain btrfs 
raid1, either straight, or on top of a pair of mdraid0s (or alike, 
dmraid0s, hardware raid0s, etc), since that performs better than btrfs 
raid10, and removes a confusing tho not harmful if properly understood 
layout ambiguity of btrfs raid10 as well.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

