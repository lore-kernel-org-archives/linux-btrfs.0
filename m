Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:47809 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751015AbdEBLyo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 May 2017 07:54:44 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1d5WO4-0002Rr-TE
        for linux-btrfs@vger.kernel.org; Tue, 02 May 2017 13:54:36 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS warning (device sda7): block group 181491728384 has wrong
 amount of free space
Date: Tue, 2 May 2017 11:54:30 +0000 (UTC)
Message-ID: <pan$28804$b4e53a6$f8693243$cefcb283@cox.net>
References: <c73f374d-5d53-c2cf-d09c-5d91f0919b12@rqc.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marat Khalili posted on Tue, 02 May 2017 09:14:12 +0300 as excerpted:

> I cannot understand two messages in syslog, could someone please shed
> some light? Here they are:
> 
>> Apr 29 08:54:03 container-name kernel: [792742.662375] BTRFS warning
>> (device sda7): block group 181491728384 has wrong amount of free space

>> Apr 29 08:54:03 container-name kernel: [792742.662381] BTRFS warning
>> (device sda7): failed to load free space cache for block group
>> 181491728384, rebuilding it now

> Especially strange is the fact that messages appear in LXC container's
> syslog, but not in syslog of a host system. I only saw network and
> apparmor-related messages in container syslogs before.
> 
> I didn't run any usermode btrfs tools at the time (especially in
> container, since they are not even installed there), but there's a quota
> set for this subvolume, and it was coming close to exhausting by large
> mysql database. There're no snapshots this time. smartmon finds no
> problems.

These aren't anything to be alarmed about in themselves; they're just low 
priority warnings from the free-space *cache*, saying it somehow got out 
of sync with what's actually there.  As that's just a cache, designed to 
help speed up looking for free space without having to actually go and 
check every time, and problems will be caught and that block-group's 
cache invalidated and recreated (with those messages indicating that's 
exactly what's happening) if btrfs finds there's actually data written in 
a block that the cache said was free, no harm done.

Inconsistencies are typically generated in an unclean unmount situation, 
but may not be caught until sometime later, when btrfs goes to actually 
use some space the cache says should be available, that actually isn't.

AFAIK (I'm a btrfs user and list regular, not a dev), it shouldn't have 
anything to do with quota.

I wouldn't worry about it myself, particularly if I hadn't been able to 
do a clean unmount at some point, tho if I saw the warning, I'd probably 
do a btrfs scrub just to be sure that warning wasn't hinting at some more 
real problem somewhere.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

