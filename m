Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:57685 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1755352AbdDPPKF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 16 Apr 2017 11:10:05 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1czloL-0003x7-SK
        for linux-btrfs@vger.kernel.org; Sun, 16 Apr 2017 17:09:57 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Encountered kernel bug#72811. Advice on recovery?
Date: Sun, 16 Apr 2017 15:09:51 +0000 (UTC)
Message-ID: <pan$2f4cc$c770dd52$f6a80ea0$7430a310@cox.net>
References: <CAFKQ2Bs9-=serb7F-PHDVNQ-X2AXcWPG5jBs9xKXTKkTQ59O7Q@mail.gmail.com>
        <pan$29c2d$faf1fff7$a4518780$dbb0b61@cox.net>
        <CAN05THTcoQ6zLrDaVmoZ=pUQ3oMxU8EvYrz8TcUGOAo6a=5qHw@mail.gmail.com>
        <pan$5f10d$2c1e5c86$a2062192$8e2ab6b@cox.net>
        <4868ddee9604c8b5aa208580fa01b7e7@rqc.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marat Khalili posted on Sun, 16 Apr 2017 11:01:00 +0300 as excerpted:

>> Even making such a warning conditional on kernel version is
>> problematic, because many distros backport major blocks of code,
>> including perhaps btrfs fixes, and the nominally 3.14 or whatever
>> kernel may actually be running btrfs and other fixes from 4.14 or
>> later, by the time they actually drop support for whatever LTS distro
>> version and quit backporting fixes.
> 
> This information could be stored in kernel and made available for
> usermode tools via some proc file. This would be very useful
> _especially_ considering backporting. Raid56 could be fixed already (or
> not) by the time it is implemented, but no doubt there will still be
> other highly experimental capabilities judging by how things go. And
> this feature itself could easily be backported.

What they /could/ do would be something very similar to what they already 
did for the free-space-tree (as opposed to the free-space-cache, the 
original and still default implementation).

There was a critical bug in the early implementations of free-space-
tree.  But btrfs has incompatibility/feature flags for a reason, and they 
set it up in such a way that the flaw could be detected and fixed.

In theory they could grab another bit from it and make that raid56v2, or 
something similar, and if the raid56 flag is there but not raid56v2, 
warn, etc.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

