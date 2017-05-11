Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:40071 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S932444AbdEKODk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 May 2017 10:03:40 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1d8ogl-0000t3-0J
        for linux-btrfs@vger.kernel.org; Thu, 11 May 2017 16:03:31 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: runtime btrfsck
Date: Thu, 11 May 2017 14:03:24 +0000 (UTC)
Message-ID: <pan$4d4b8$c6068466$2883d412$cf40ce2b@cox.net>
References: <9267c96a-72a7-0726-d058-4b2589d7e73e@profihost.ag>
        <f5c610b2-7400-2507-9db2-021b22c0b6d9@profihost.ag>
        <5d86903f-96f8-b61c-16b0-15ba9ac48986@profihost.ag>
        <1801706.Ls22q1bWhG@merkaba> <20170510135255.790fbe39@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Roman Mamedov posted on Wed, 10 May 2017 13:52:55 +0500 as excerpted:

> So even with a minor corruption (something wonky in just ONE block of a
> multi-terabyte FS) the answer is way too often "nuke the entire thing
> and restore from backups".

Just another case where my "keep it small enough to be maintainable" 
policy triggers.  If that double-digit-TB fs is instead broken along 
functional/logical lines into say a dozen 1 TB each fs and that single 
block is corrupted, it can only be corrupted in one of them, so 11 of the 
dozen will be fine, and nuking to restore from backups just the single 1 
TB filesystem of a dozen, instead of the single 12-TB fs, isn't such a 
big deal -- it remains realistically maintainable.

Of course if at your scale 12 TB... or 12000 TB... is considered 
maintainable, great, but then we'd be unlikely to be having this 
discussion...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

