Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:53221 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750784AbdBAEgU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Jan 2017 23:36:20 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cYmeO-0006je-Ps
        for linux-btrfs@vger.kernel.org; Wed, 01 Feb 2017 05:36:08 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs recovery
Date: Wed, 1 Feb 2017 04:36:02 +0000 (UTC)
Message-ID: <pan$c41f7$32662c2a$a3163b7$95c8e3e8@cox.net>
References: <961e2f81-40e6-cced-f14a-7af7effe1e5e@googlemail.com>
        <20170126092559.GD24076@carfax.org.uk>
        <24f6cfb2-d008-af12-ad94-4a4da1be1ee2@googlemail.com>
        <9c38e493-e4aa-a718-c6a8-d400bcff0df8@googlemail.com>
        <2c02d0b6-859d-f66f-e259-748db131d38d@googlemail.com>
        <304177d4-cc35-9bfc-816c-85ff3501dc50@gmail.com>
        <pan$cc953$ec4078b0$696ed46d$9618e10e@cox.net>
        <ad929c7d-8781-6c9f-382c-b2fbdfad5f2c@googlemail.com>
        <pan$dc869$86af3c32$d85f3e93$f334f454@cox.net>
        <fbe803ef-4b7e-ec39-5f32-a9cc03ab6689@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S. Hemmelgarn posted on Tue, 31 Jan 2017 07:45:42 -0500 as
excerpted:

>> There's actually a btrfs-undelete script on github that turns the
>> otherwise multiple manual steps into a nice, smooth, undelete
>> operation. Or at least it's supposed to.  I've never actually used it,
>> tho I have examined the script out of curiosity to see what it did and
>> how, and it /looks/ like it should work.  I've kept that trick (and
>> knowledge of where to look for the script) filed away in the back of
>> my head in case I need it someday. =:^)

> I've not used the script itself before, but I've used the method before
> on a couple of occasions to pull out old versions of files that I should
> have had under some kind of VCS but didn't, and the method does work
> reliably as long as you do it soon.

>From reading the script, the two potentially difficult steps the script 
helpfully automates for you are...

1) going thru the roots find-root has found to find a good one to use

... and...

2) the fiddly regex escaping, so you don't have to pay too much attention 
to that, just feed it a normal path.

IOW, it should be a great help to users that don't know btrfs command or 
filesystem internals very well, and/or who don't find regex use 
particularly easy.

IOW, it'd be an excellent tool to either include in btrfs-tools as-is or 
C-codify and add as a btrfs subcommand, at some point as btrfs nears true 
stability and readiness for for ordinary less technical users.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

