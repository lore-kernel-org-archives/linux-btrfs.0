Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:43681 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750960AbeDMFtM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Apr 2018 01:49:12 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1f6rY1-0000EM-AF
        for linux-btrfs@vger.kernel.org; Fri, 13 Apr 2018 07:46:57 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs fails to mount after power outage
Date: Fri, 13 Apr 2018 05:46:51 +0000 (UTC)
Message-ID: <pan$23865$85130c9$51fc5bf6$31d44e36@cox.net>
References: <CAG4vCreOmBdsPT84ajozGb4XV83+Fc-joyUqXgizutPah0VrrA@mail.gmail.com>
        <db34f571-2a31-5a0a-9f8d-e55a9b579753@gmx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Qu Wenruo posted on Thu, 12 Apr 2018 07:25:15 +0800 as excerpted:


> On 2018年04月11日 23:33, Tom Vincent wrote:
>> My btrfs laptop had a power outage and failed to boot with "parent
>> transid verify failed..." errors. (I have backups).
> 
> Metadata corruption, again.
> 
> I'm curious about what's the underlying disk?
> Is it plain physical device? Or have other layers like bcache/lvm?
> 
> And what's the physical device? SSD or HDD?

The last line of his message said progs 4.15, kernel 4.15.15, NVMe, so 
it's SSD.

Another important question, tho, if not for this instance, than for 
easiest repair the next time something goes wrong:

What mount options?  In particular, is the discard option used (and of 
course I'm assuming nothing as insane as nobarrier)?

Because as came up on a recent thread here...

Btrfs normally keeps a few generations of root blocks around and one 
method of recovery is using the usebackuproot (or the deprecated 
recovery) option to try to use them if the current root is bad.  But 
apparently nobody considered how discard and the backup roots would 
interact, and there's (currently) nothing keeping them from being marked 
for discard just as soon as the next new root becomes current.  Now some 
device firmware batches up discards as garbage-collection that can be 
done periodically, when the number of unwritten erase-blocks gets low, 
but others do discards basically immediately, meaning those backup roots 
are lost effectively immediately, making the usebackuproots recovery 
feature worthless. =:^(

Not a tradeoff that would occur to most people, obviously including the 
btrfs devs that setup btrfs discard behavior, considering whether to 
enable discard or not. =:^(

But it's definitely a tradeoff to consider once you /do/ know it!

Presumably that'll be fixed at some point, but not being a dev nor 
knowing how complex the fix might be, I won't venture a guess as to when, 
or whether it'd be considered stable-kernel backport material or not, 
when it happens.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

