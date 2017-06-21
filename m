Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:53081 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751976AbdFUMFH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Jun 2017 08:05:07 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dNeNY-0004Wb-8E
        for linux-btrfs@vger.kernel.org; Wed, 21 Jun 2017 14:05:00 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: 4.11.3: BTRFS critical (device dm-1): unable to add free space
 :-17 => btrfs check --repair runs clean
Date: Wed, 21 Jun 2017 12:04:52 +0000 (UTC)
Message-ID: <pan$ecf47$b349364f$68454a0e$ff129d57@cox.net>
References: <20170620143916.GA22987@merlins.org>
        <20170620152354.GD7140@carfax.org.uk> <20170620152648.GB22987@merlins.org>
        <20170620153601.GE7140@carfax.org.uk> <20170620154429.GC22987@merlins.org>
        <20170620231202.GB5303@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN posted on Tue, 20 Jun 2017 16:12:03 -0700 as excerpted:

> On Tue, Jun 20, 2017 at 08:44:29AM -0700, Marc MERLIN wrote:
>> On Tue, Jun 20, 2017 at 03:36:01PM +0000, Hugo Mills wrote:
>> 
>>>> "space cache will be invalidated " => doesn't that mean that my
>>>> cache was already cleared by check --repair, or are you saying I
>>>> need to clear it again?
>>> 
>>>    I'm never quite sure about that one. :)
>>> 
>>>    It can't hurt to clear it manually as well.
>> 
>> Sounds good, done.
>  
> Except it didn't help :(
> It worked for a while, and failed again.
> 
> It looks like I'm hitting a persistent bug :(

[Omitted free space cache dmesg errors]

> Given that check --repair ran clean when I ran it yesterday after this
> first happened, and I then ran  mount -o clear_cache , the cache got
> rebuilt, and I got the problem again, this is not looking good, seems
> like a persistent bug :-/

Keep in mind this quote from a recent (I'm quoting -progs 4.11) btrfs-
check manpage (reformatted for posting):

>>>>> 

--clear-space-cache v1|v2

completely wipe all free space cache of given type

For free space cache v1, the clear_cache kernel mount option only 
rebuilds the free space cache for block groups that are modified while the
filesystem is mounted with that option. Thus, using this option with v1 
makes it possible to actually clear the entire free space cache.

For free space cache v2, the clear_cache kernel mount option does destroy 
the entire free space cache. This option with v2 provides an alternative
method of clearing the free space cache that doesn’t require mounting the 
filesystem.

<<<<<

Given the dmesg, seems you're still running the space cache, not the v2/
tree (which is fine, I'm conservative enough not to have switched yet 
either).  So try the check option instead of the mount option.  The mount 
option might simply have not caught all the badness while it was active.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

