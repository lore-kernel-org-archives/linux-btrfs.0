Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:55085 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750764AbdAaE6j (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Jan 2017 23:58:39 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cYQWV-00043I-Nj
        for linux-btrfs@vger.kernel.org; Tue, 31 Jan 2017 05:58:31 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs recovery
Date: Tue, 31 Jan 2017 04:58:26 +0000 (UTC)
Message-ID: <pan$dc869$86af3c32$d85f3e93$f334f454@cox.net>
References: <961e2f81-40e6-cced-f14a-7af7effe1e5e@googlemail.com>
        <20170126092559.GD24076@carfax.org.uk>
        <24f6cfb2-d008-af12-ad94-4a4da1be1ee2@googlemail.com>
        <9c38e493-e4aa-a718-c6a8-d400bcff0df8@googlemail.com>
        <2c02d0b6-859d-f66f-e259-748db131d38d@googlemail.com>
        <304177d4-cc35-9bfc-816c-85ff3501dc50@gmail.com>
        <pan$cc953$ec4078b0$696ed46d$9618e10e@cox.net>
        <ad929c7d-8781-6c9f-382c-b2fbdfad5f2c@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Oliver Freyermuth posted on Sat, 28 Jan 2017 17:46:24 +0100 as excerpted:

>> Just don't count on restore to save your *** and always treat what it
>> can often bring to current as a pleasant surprise, and having it fail
>> won't be a down side, while having it work, if it does, will always be
>> up side.
>> =:^)
>> 
> I'll keep that in mind, and I think that in the future, before trying
> any "btrfs check" (or even repair)
> I will always try restore first if my backup was not fresh enough :-).

That's a wise idea, as long as you have the resources to actually be able 
to write the files somewhere (as people running btrfs really should, 
because it's /not/ fully stable yet).

One of the great things about restore is that all the writing it does is 
to the destination filesystem -- it doesn't attempt to actually write or 
repair anything on the filesystem it's trying to restore /from/, so it's 
far lower risk than anything that /does/ actually attempt to write to or 
repair the potentially damaged filesystem.

That makes it /extremely/ useful as a "first, to the extent possibke, 
make sure the backups are safely freshened" tool. =:^)


Meanwhile, FWIW, restore can also be used as a sort of undelete tool.  
Remember, btrfs is COW and writes any changes to a new location.  The old 
location tends to stick around, not any more referenced by anything 
"live", but still there until some other change happens to overwrite it.
 
Just like undelete on a more conventional filesystem, therefore, as long 
as you notice the problem before the old location has been overwritten 
again, it's often possible to recover it, altho the mechanisms involved 
are rather different on btrfs.  Basically, you use btrfs-find-root to get 
a list of old roots, then point restore at them using the -t option.  
There's a page on the wiki that goes into some detail in a more desperate 
"restore anything" context, but here, once you found a root that looked 
promising, you'd use restore's regex option to restore /just/ the file 
you're interested in, as it existed at the time that root was written.

There's actually a btrfs-undelete script on github that turns the 
otherwise multiple manual steps into a nice, smooth, undelete operation.  
Or at least it's supposed to.  I've never actually used it, tho I have 
examined the script out of curiosity to see what it did and how, and it /
looks/ like it should work.  I've kept that trick (and knowledge of where 
to look for the script) filed away in the back of my head in case I need 
it someday. =:^)


-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

