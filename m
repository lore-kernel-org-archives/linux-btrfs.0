Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:53556 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750763AbdHSFVc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 19 Aug 2017 01:21:32 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1diwCH-0004IV-Fr
        for linux-btrfs@vger.kernel.org; Sat, 19 Aug 2017 07:21:21 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Moving btrfs fs disk between computers
Date: Sat, 19 Aug 2017 05:21:13 +0000 (UTC)
Message-ID: <pan$3f6ee$469dad4a$bd79d02d$56f8cf2@cox.net>
References: <CAD6NJSwG7tJSnbpyGAT41r3Y7RqPe99YQAg2yGGbMRt=EO+o-Q@mail.gmail.com>
        <20170819023526.wbhl2wydq4bw6u75@angband.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Adam Borowski posted on Sat, 19 Aug 2017 04:35:26 +0200 as excerpted:

> On Fri, Aug 18, 2017 at 11:09:22PM -0300, Hérikz Nawarro wrote:
>> Hello everyone,
>> 
>> Can i create a btrfs fs in a machine and move the disk to another
>> machine like a ext4 or ntfs?
> 
> Yeah, no problem whatsoever, even for multi-device filesystems.
> Btrfs doesn't care about what devices it is on.
> 
> There has been no new incompat features in quite a while, so old kernels
> shouldn't be an issue either.
> 
> I think the only way for valid btrfs to be unmountable on another
> machine with a modern kernel is to mess with page size, which is AFAIK
> not even possible on x86.

IOW, as long as the two machines are the same arch, or more precisely, 
have the same page size if different archs, it should be fine as long as 
you're not running a really old kernel on one of them.

But don't try mounting a filesystem created on x86_64 on something exotic 
like sparc or ppc or something.  If the two archs' page sizes are the 
same it should work, but I'd still be sure I had an extra set of backups 
before I tried something like that.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

