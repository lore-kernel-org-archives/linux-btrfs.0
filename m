Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:51187 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751918AbdDGD01 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Apr 2017 23:26:27 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cwKXR-0004nF-7z
        for linux-btrfs@vger.kernel.org; Fri, 07 Apr 2017 05:26:17 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Is btrfs-convert able to deal with sparse files in a ext4
 filesystem?
Date: Fri, 7 Apr 2017 03:26:11 +0000 (UTC)
Message-ID: <pan$deea1$4effb1a3$4a442693$49dc32ff@cox.net>
References: <CADN-S7MzE=6x25DK0XOPzfBGCEpTjdUSokBkuCPGhCvCURzLPg@mail.gmail.com>
        <20170401191357.GA25721@coach>
        <pan$df213$fa344dca$8529fcec$34b89ea9@cox.net>
        <c5472e71-908c-3d42-ee40-73d003bfc598@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Andrei Borzenkov posted on Sun, 02 Apr 2017 09:30:46 +0300 as excerpted:

> 02.04.2017 03:59, Duncan пишет:
>> 
>> 4) In fact, since an in-place convert is almost certainly going to take
>> more time than a blow-away and restore from backup,
> 
> This caught my eyes. Why? In-place convert just needs to recreate
> metadata. If you have multi-terabyte worth of data copying them twice
> hardly can be faster.

Why twice?  If you care about the data by definition you already have 
backups, so it's only copying back from those backups to the newly 
created filesystem, right?

And if you don't have backups, then by definition, you don't care about 
the data, at least not enough to be worth the hassle of a backup and thus 
arguably not enough to be worth the hassle of a convert, so just blow it 
away with a new mkfs and start from scratch since you self-evidently 
didn't care enough about the data for it to be worth a backup anyway, no 
problem.

And actually, it's not even a single extra copy that you won't have to do 
anyway, if you schedule your new filesystem creation as part of your 
normal backup regime in place of what would otherwise be a full backup 
that you now don't have to make, so copying the data from the old 
filesystem to the new one is simply replacing the full backup that you'd 
otherwise be doing at the same point in time.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

