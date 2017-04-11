Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:48332 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750721AbdDKEB3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Apr 2017 00:01:29 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cxmzY-0005Mo-2w
        for linux-btrfs@vger.kernel.org; Tue, 11 Apr 2017 06:01:20 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: btrfs filesystem keeps allocating new chunks for no apparent
 reason
Date: Tue, 11 Apr 2017 06:01:19 +0200
Message-ID: <20170411060119.65b34774@jupiter.sol.kaishome.de>
References: <572D0C8B.8010404@mendix.com>
        <89a684c7-364e-f409-5348-bc0077fd438c@cn.fujitsu.com>
        <5b642448-951e-5b5e-1343-0299a950089c@mendix.com>
        <51778c0f-2720-1c2d-aba2-e22e5f4d3a3a@mendix.com>
        <4532f6ee-2a6e-412a-7230-edb76735d55f@mendix.com>
        <07a7f59e-64e0-4d09-5d32-01bc933fe38d@gmail.com>
        <20170410144533.664fc304@jupiter.sol.kaishome.de>
        <5488ea5a-b41c-5987-e664-ec17cf2d5e01@gmail.com>
        <20170410184444.08ced097@jupiter.sol.local>
        <20170410185437.235b3b86@jupiter.sol.kaishome.de>
        <7ea65b63-d399-c049-d466-681c1df2d025@gmail.com>
        <20170410201842.216893be@jupiter.sol.kaishome.de>
        <ce3ddbc7-da26-9fc7-e783-e9d566009ae8@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Mon, 10 Apr 2017 15:43:57 -0400
schrieb "Austin S. Hemmelgarn" <ahferroin7@gmail.com>:

> On 2017-04-10 14:18, Kai Krakow wrote:
> > Am Mon, 10 Apr 2017 13:13:39 -0400
> > schrieb "Austin S. Hemmelgarn" <ahferroin7@gmail.com>:
> >  
> >> On 2017-04-10 12:54, Kai Krakow wrote:  
>  [...]  
>  [...]  
> >>  [...]
> >>  [...]  
>  [...]  
> >>  [...]
> >>  [...]  
>  [...]  
>  [...]  
> >> The command-line also rejects a number of perfectly legitimate
> >> arguments that BTRFS does understand too though, so that's not much
> >> of a test.  
> >
> > Which are those? I didn't encounter any...  
> I'm not sure there are any anymore, but I know that a handful (mostly 
> really uncommon ones) used to (and BTRFS is not alone in this
> respect, some of the more esoteric ext4 options aren't accepted on
> the kernel command-line either).  I know at a minimum at some point
> in the past alloc-start, check_int, and inode_cache did not work from
> the kernel command-line.

The post from Janos explains why: The difference is with the mount
handler, depending on whether you use initrd or not.

> >> I've just finished some quick testing though, and it looks
> >> like you're right, BTRFS does not support this, which means I now
> >> need to figure out what the hell was causing the IOPS counters in
> >> collectd to change in rough correlation  with remounting
> >> (especially since it appears to happen mostly independent of the
> >> options being changed).  
> >
> > I think that noatime (which I remember you also used?), lazytime,
> > and relatime are mutually exclusive: they all handle the inode
> > updates. Maybe that is the effect you see?  
> They're not exactly exclusive.  The lazytime option will prevent
> changes to the mtime or atime fields in a file from forcing inode
> write-out for up to 24 hours (if the inode would be written out for
> some other reason (such as a file-size change or the inode being
> evicted from the cache), then the timestamps will be too), but it
> does not change the value of the timestamps.  So if you have lazytime
> enabled and use touch to update the mtime on anotherwise idle file,
> the mtime will still be correct as far as userspace is concerned, as
> long as you don't crash before the update hits the disk (but
> userspace will only see the discrepancy _after_ the crash).

Yes, I know all this. But I don't see why you still want noatime or
relatime if you use lazytime, except for super-optimizing. Lazytime
gives you POSIX conformity for a problem that the other options only
tried to solve.

> > Well, relatime is mostly the same thus not perfectly resembling the
> > POSIX standard. I think the only software that relies on atime is
> > mutt...  
> This very much depends on what you're doing.  If you have a WORM 
> workload, then yeah, it's pretty much the same.  If however you have 
> something like a database workload where a specific set of files get 
> internally rewritten regularly, then it actually has a measurable
> impact.

I think "impact" is a whole different story. I'm on your side here.


-- 
Regards,
Kai

Replies to list-only preferred.

