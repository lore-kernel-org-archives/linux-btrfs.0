Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:47582 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751863AbdHKAr4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 Aug 2017 20:47:56 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dfy78-0007xD-S9
        for linux-btrfs@vger.kernel.org; Fri, 11 Aug 2017 02:47:46 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH v3] Btrfs: fix out of bounds array access while reading
 extent buffer
Date: Fri, 11 Aug 2017 00:47:40 +0000 (UTC)
Message-ID: <pan$89624$c704946f$fd2367ea$532a370e@cox.net>
References: <20170807193903.9093-1-bo.li.liu@oracle.com>
        <20170809171016.7501-1-bo.li.liu@oracle.com>
        <20170809181529.GE7140@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills posted on Wed, 09 Aug 2017 18:15:29 +0000 as excerpted:

> On Wed, Aug 09, 2017 at 11:10:16AM -0600, Liu Bo wrote:
>> There is a cornel case that slip through the checkers in functions
>              ^^^^^^ corner
> 
>    Sorry, that's been bugging me every time it goes past. A cornel is
> a kind of tree, apparently.

LOL!  Me too but likely more so because I actually live in Cornell 
Condominiums so seeing "cornel" in this context is a rather confusing 
context switch, to say the least!  I let it slip the first time as I 
never expected it to make it to a v3, but...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

