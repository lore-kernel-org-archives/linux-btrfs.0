Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:54616 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751774AbdGILSD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Jul 2017 07:18:03 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dUADp-0000NY-Dg
        for linux-btrfs@vger.kernel.org; Sun, 09 Jul 2017 13:17:53 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: 4.11.6 / more corruption / root 15455 has a root item with a more
 recent gen (33682) compared to the found root node (0)
Date: Sun, 9 Jul 2017 11:17:47 +0000 (UTC)
Message-ID: <pan$2b9aa$a4dca8a2$fc1e4ebe$a8fffbe3@cox.net>
References: <20170501170641.GG3516@merlins.org>
        <20170707163834.GA6083@merlins.org> <20170709043417.GE6704@merlins.org>
        <21425367.VGcO8ck7Vu@merkaba>
        <MEXPR01MB216863F67F4553F8564CC3CD9EA80@MEXPR01MB2168.ausprd01.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Paul Jones posted on Sun, 09 Jul 2017 09:16:36 +0000 as excerpted:

>> Marc MERLIN - 08.07.17, 21:34:
>> >
>> > This is now the 3rd filesystem I have (on 3 different machines) that
>> > is getting corruption of some kind (on 4.11.6).
>> 
>> Anyone else getting corruptions with 4.11?
>> 
>> I happily switch back to 4.10.17 or even 4.9 if that is the case. I may
>> even do so just from your reports. Well, yes, I will do exactly that. I
>> just switch back for 4.10 for now. Better be safe, than sorry.
> 
> No corruption for me - I've been on 4.11 since about .2 and everything
> seems fine. Currently on 4.11.8

No corruptions here either. 4.12.0 now, previously 4.12-rc5(ish, git), 
before that 4.11.0.

I have however just upgraded to new ssds then wiped and setup the old 
ones as another backup set, so everything is on brand new filesystems on 
fast ssds, no possibility of old undetected corruption suddenly 
triggering problems.

Also, all my btrfs are raid1 or dup for checksummed redundancy, and 
relatively small, the largest now 80 GiB per device, after the upgrade.  
And my use-case doesn't involve snapshots or subvolumes.  

So any bug that is most likely on older filesystems, say those without 
the no-holes feature, for instance, or that doesn't tend to hit raid1 or 
dup mode, or that is less likely on small filesystems on fast ssds, or 
that triggers most often with reflinks and thus on filesystems with 
snapshots, is unlikely to hit me.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

