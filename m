Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:55572 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751239AbeANQcy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 14 Jan 2018 11:32:54 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1ealBE-0000TV-H8
        for linux-btrfs@vger.kernel.org; Sun, 14 Jan 2018 17:30:44 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Hanging after frequent use of systemd-nspawn --ephemeral
Date: Sun, 14 Jan 2018 16:30:38 +0000 (UTC)
Message-ID: <pan$46776$62a5e0fc$bbee4809$9a4f8e9d@cox.net>
References: <6B7B9360-41EA-4190-8C7D-9E001D186B23@gmail.com>
        <8c9933e1-f694-a513-83ca-33fcb503b7e8@gmx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Qu Wenruo posted on Sun, 14 Jan 2018 10:27:40 +0800 as excerpted:

> Despite of that, did that really hangs?
> Qgroup dramatically increase overhead to delete a subvolume or balance
> the fs.
> Maybe it's just a little slow?

Same question about the "hang" here.

Note that btrfs is optimized to make snapshot creation fast, while 
snapshot deletion has to do more work to clean things up.  So even 
without qgroup enabled, deletion can take a bit of time (much longer than 
creation, which should be nearly instantaneous in human terms) if there's 
a lot of relinks and the like to clean up.

And qgroups makes btrfs do much more work to track that as well, so as Qu 
says, that'll make snapshot deletion take even longer, and you probably 
want it disabled unless you actually need the feature for something 
you're doing.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

