Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:34350 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1754585AbdBGUUI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Feb 2017 15:20:08 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cbCEo-0001g6-B3
        for linux-btrfs@vger.kernel.org; Tue, 07 Feb 2017 21:19:42 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: BTRFS for OLTP Databases
Date: Tue, 7 Feb 2017 21:19:41 +0100
Message-ID: <20170207211941.3310d7a8@jupiter.sol.kaishome.de>
References: <CA+RUij3aW1ZYyJPNRLzckwOCCmoWa15Eu4h142jB_-qKc49hBw@mail.gmail.com>
        <20170207140058.GA4249@carfax.org.uk>
        <CA+RUij3LJeFR1pz9QDOkMEVbh1cws5Rv2KPep3ghVAimJy7aLA@mail.gmail.com>
        <91c8a758-23b6-edf1-74b0-2d87acbb2560@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Tue, 7 Feb 2017 14:50:04 -0500
schrieb "Austin S. Hemmelgarn" <ahferroin7@gmail.com>:

> > Also does autodefrag works with nodatacow (ie with snapshot)  or
> > are these exclusive ?  
> I'm not sure about this one.  I would assume based on the fact that
> many other things don't work with nodatacow and that regular defrag
> doesn't work on files which are currently mapped as executable code
> that it does not, but I could be completely wrong about this too.

Technically, there's nothing that prevents autodefrag to work for
nodatacow files. The question is: is it really necessary? Standard file
systems also have no autodefrag, it's not an issue there because they
are essentially nodatacow. Simply defrag the database file once and
you're done. Transactional MySQL uses huge data files, probably
preallocated. It should simply work with nodatacow.

On the other hand: Using snapshots clearly introduces fragmentation over
time. If autodefrag kicks in (given, it is supported for nodatacow), it
will slowly unshare all data over time. This somehow defeats the
purpose of having snapshots in the first place for this scenario.

In conclusion, I'd recommend to run some maintenance scripts from time
to time, one to re-share identical blocks, and one to defragment the
current workspace.

The bees daemon comes into mind here... I haven't tried it but it
sounds like it could fill a gap here:

https://github.com/Zygo/bees

Another option comes into mind: XFS now supports shared-extents
copies. You could simply do a cold copy of the database with this
feature resulting in the same effect as a snapshot, without seeing the
other performance problems of btrfs. Tho, the fragmentation issue would
remain, and I think there's no dedupe application for XFS yet.

-- 
Regards,
Kai

Replies to list-only preferred.

