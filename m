Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:60173 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751969AbdG2Xic (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 29 Jul 2017 19:38:32 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dbbJQ-0008Pe-8a
        for linux-btrfs@vger.kernel.org; Sun, 30 Jul 2017 01:38:24 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: 4.11.6 / more corruption / root 15455 has a root item with a more
 recent gen (33682) compared to the found root node (0)
Date: Sat, 29 Jul 2017 23:38:10 +0000 (UTC)
Message-ID: <pan$12269$5fb80e78$f5b26ca4$74a3427f@cox.net>
References: <20170501170641.GG3516@merlins.org>
        <20170707163834.GA6083@merlins.org> <20170709043417.GE6704@merlins.org>
        <21425367.VGcO8ck7Vu@merkaba>
        <MEXPR01MB216863F67F4553F8564CC3CD9EA80@MEXPR01MB2168.ausprd01.prod.outlook.com>
        <pan$2b9aa$a4dca8a2$fc1e4ebe$a8fffbe3@cox.net>
        <CAK5rZE7sj+T8-x0q=wPXeHKN4zBZGc2Jhj9NYA7ZQcV+yk2XSA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Imran Geriskovan posted on Sat, 29 Jul 2017 21:29:46 +0200 as excerpted:

> On 7/9/17, Duncan <1i5t5.duncan@cox.net> wrote:
>> I have however just upgraded to new ssds then wiped and setup the old
>> ones as another backup set, so everything is on brand new filesystems 
on
>> fast ssds, no possibility of old undetected corruption suddenly
>> triggering problems.
>>
>> Also, all my btrfs are raid1 or dup for checksummed redundancy
> 
> Do you have any experience/advice/comment regarding
> dup data on ssds?

Very good question. =:^)

Limited.  Most of my btrfs are raid1, with dup only used on the device-
respective /boot btrfs (of which there are four, one on each of the two 
ssds that otherwise form the btrfs raid1 pairs, for each of the working 
and backup copy pairs -- I can use BIOS to select any of the four to 
boot), and those are all sub-GiB mixed-bg mode.

So all my dup experience is sub-GiB mixed-blockgroup mode.

Within that limitation, my only btrfs problem has been that at my 
initially chosen size of 256 MiB, mkfs.btrfs at least used to create an 
initial data/metadata chunk of 64 MiB.  Remember, this is dup mode, so 
there's two of them = 128 MiB.  Because there's also a system chunk, that 
means the initial chunk cannot be balanced even with an entirely empty 
filesystem, because there's not enough space to write a second 64 MiB 
chunk duped to 128 MiB.

Between that and the 256 MiB in dup mode size meaning under 128 MiB 
usable, and the fact that I routinely run and sometimes need to bisect 
pre-release kernels, I was routinely running out of space, then cleaning 
up, but not being able to do a full cleanup without a blow-away and new 
mkfs.btrfs, because I couldn't balance.

When I recently purchased the second pair of (now larger) ssds in ordered 
to put everything, including the media and backups that were previously 
still on spinning rust, on ssd, I redid the layout and made the /boots 
512 MiB, still mixed-bg dup mode.  That seems to have solved the problem, 
and I can now rebalance the first mkfs.btrfs-created mixed-bg chunk, as 
it's now small enough that it's less than half the filesystem even when 
duped.

Because it's now 512 MiB, however, I can't say for sure whether the 
previous problem with mkfs.btrfs creating an initial mixed-bg chunk of a 
quarter the 256 MiB filesystem size, so in dup mode it can't be balanced 
because it's half the total filesystem size and with the system chunk as 
well, the other half is partially used so there's no space to write the 
balance destination chunks, is fixed, or not.  What I can say is that the 
problem doesn't affect the new 512 MiB size, at least with btrfs-progs 
4.11.x, which is what I used to mkfs.btrfs the new layout.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

