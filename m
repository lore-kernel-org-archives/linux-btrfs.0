Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:45506 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1753905AbcJYPRn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Oct 2016 11:17:43 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1bz3Tp-0002oE-OX
        for linux-btrfs@vger.kernel.org; Tue, 25 Oct 2016 17:17:33 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Replace missing drive in RAID56 BTRFS without mounting.
Date: Tue, 25 Oct 2016 15:16:54 +0000 (UTC)
Message-ID: <pan$e0640$e75abc22$daca6577$7759c483@cox.net>
References: <CABaAYfRcZ5L_hU+J7DLyuLrGtHB0u+5YKSm7CQS4N08B0K3X_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

George Chlipala posted on Tue, 25 Oct 2016 09:30:34 -0500 as excerpted:

> We had a major failure in one drive in a RAID56 BTRFS volume and that
> drive is no longer accessible.   How can I replace the drive without
> mounting the filesystem?  I have tried using a degraded mount but I
> receive the following error messages

Someone should be along with specific help, but FYI, btrfs raid56 mode is 
bugged at this time and may require a major rewrite to fix properly.  As 
a result it's not recommended for anything but testing, and due to 
immaturity of the raid56 code, deployment with backups ready or otherwise 
with data that can be lost has always been the very strong recommendation 
even before these specific bugs were known.

That being the case and since switching to other than raid56 mode is 
strongly recommended anyway, blowing away the existing filesystem and 
recreating in raid1 or raid10 mode, then restoring from backups if the 
data was worth the trouble of having them, is the shortest and most 
efficient way back to operation.

Saving the data on the raid56 may be possible, but it's likely to require 
serious effort and still may not succeed.  As I said, Chris Murphy or 
someone else with experience at trying to recover raid56 should be along 
with more detail, if you'd still prefer to go to that extra effort 
regardless of the real chance it won't help, in case it can.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

