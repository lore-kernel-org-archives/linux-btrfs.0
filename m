Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:58588 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751449AbdHKAjX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 Aug 2017 20:39:23 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dfxys-0004z3-AC
        for linux-btrfs@vger.kernel.org; Fri, 11 Aug 2017 02:39:14 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Replace missing disc => strange result!?
Date: Fri, 11 Aug 2017 00:39:04 +0000 (UTC)
Message-ID: <pan$efeee$bd714cab$37822ac5$dd8b65e2@cox.net>
References: <1502395208.3361.1.camel@cloud.haefemeier.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Cloud Admin posted on Thu, 10 Aug 2017 22:00:08 +0200 as excerpted:

> Hi,
> I had a disc failure and must replace it. I followed the description on
>  https://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devi
> ces and started the replacement.
> Setup is a two disc RAID1!
> After it was done, I called 'btrfs fi us /mn/btrfsroot' and I got the
> output below. What is wrong?
> Is it a rebalancing issue? I thought the replace command started it
> automatically...

...
 
> Data,single: Size:1.00GiB, Used:0.00B
>    /dev/mapper/luks-3ff6c412-4d3a-4d33-85a3-cc70e95c26f8	   1.00
> GiB

...

It's not entirely clear what you're referring to with the "what's wrong" 
question, but I'll assume it's all those single and dup chunks that 
aren't raid1.

Unlike device delete, which does an implicit rebalance, replace simply 
replaces one device with another in terms of content, and doesn't 
rebalance anything on remaining devices.  This tends to make it much 
faster, with less danger of something else bad (like another device going 
bad) happening in the process, but it pretty much copies verbatim as much 
as possible so unlike device delete with its implicit balance or an 
explicit balance, existing chunks remain as they were.

Which means any existing single and dup chunks didn't get removed, as I'm 
guessing you expected.

But most or all of them are 0 used, so an explicit rebalance to eliminate 
them should be quite short as it'll just delete the references to them.  
Try this (path from your post above):

btrfs balance start -dusage=0 -musage=0 /mn/btrfsroot

That should eliminate the 0-usage chunks, making the usage output easier 
to follow even if you do need to post updates because my guess as to what 
you were referring to with the "what's wrong" was incorrect.  And as I 
said it should be much faster (almost instantaneous on ssd, probably not 
/quite/ that on spinning rust) than rebalancing chunks that weren't 
empty, too.  =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

