Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:37944 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1043728AbdDVJRp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 22 Apr 2017 05:17:45 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1d1rAf-0004KL-4Q
        for linux-btrfs@vger.kernel.org; Sat, 22 Apr 2017 11:17:37 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Experiences with metadata balance/convert
Date: Sat, 22 Apr 2017 09:17:31 +0000 (UTC)
Message-ID: <pan$4a44a$5b70b88a$e087c574$18e5ec69@cox.net>
References: <78d61749-ec9c-1cc3-196f-5330489e2b3e@mendix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hans van Kranenburg posted on Fri, 21 Apr 2017 12:26:18 +0200 as
excerpted:

> So, I used the clone functionality of the underlying iSCSI target to get
> a writable throw-away version of the filesystem to experiment with
> (great!).

Please, I'm rather sure you know all this and have setup your system 
accordingly, but we need to try to make it explicit any time there's 
mention of any sort of device or filesystem cloning tool, that we tell 
others that may happen on the post either just reading the list or via a 
google or the like...

Don't let btrfs see both the original and clone at the same time, say 
with a btrfs device scan (which udev runs automatically when block 
devices with a btrfs on them show up, so don't insert any btrfs-hosting 
devices or otherwise let udev see a new one, until either the clone or 
original are removed from the system).

Because btrfs, being potentially multi-device unlike most filesystems, 
tracks the parts of a filesystem via UUID, universally unique identifier, 
which it therefore depends on being just that, unique.

The trouble is that the clone, /being/ a clone, has the same UUID as the 
original, and if btrfs sees both the clone and the original of a write-
mounted filesystem, "Bad Things"TM can happen!

If people take care not to insert new btrfs devices while making a clone, 
and detach the clone from the system hosting the original as soon as 
possible after the clone is completed, those "Bad Things" shouldn't 
happen and they should be OK in that regard.

Of course as I said I'm rather sure you know of this and used a system 
not hosting the filesystem you were cloning to access the iscsi, but 
things will be a bit more complicated for people doing, for instance, 
same-system LVM snapshots or DD clones, and every time I see references 
to cloning devices and filesystems, even if they know good and well about 
the problems and steer well clear, I get worried that somebody new to 
btrfs or who simply isn't yet aware of that problem, is going to see it 
being discussed and take that as an invitation to do a same-system btrfs 
clone and get themselves in a *HEAP* of trouble!

So any time you mention btrfs clone, just devote a one-liner to something 
like "Yes, I'm aware of the UUID problem and this clone wasn't exposed on 
the same system."... and hopefully it'll get connected in people's minds 
and if necessary they'll either research further or ask before they start 
going LVM-clone wild or something!

(Of course the above is an explanation in far more detail than that 
single-liner, because it's the full topic of the post and I might as 
well, compared to the simple parenthetical I'm asking for when clone 
discussions come up.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

