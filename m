Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:46826 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1752993AbdGHTh7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 8 Jul 2017 15:37:59 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dTvY7-0008VY-E6
        for linux-btrfs@vger.kernel.org; Sat, 08 Jul 2017 21:37:51 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: raid10 array lost with single disk failure?
Date: Sat, 8 Jul 2017 19:37:42 +0000 (UTC)
Message-ID: <pan$6b094$f0581f40$6591029b$d3b08010@cox.net>
References: <CACzgC9j026GHxX9m8=1iaYyV9ejFrzaC3nqwgn+j_awXA7D_Lw@mail.gmail.com>
        <CACzgC9i4Eb2=xKpF02Czr432r1WQkhTx+8tZswsgw5EUfofJsg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Adam Bahe posted on Fri, 07 Jul 2017 23:40:20 -0500 as excerpted:

> Some additional information. I am running Rockstor just like Daniel
> Brady noted in his post just before mine titled "Chunk root problem".
> Sorry I am somewhat unfamiliar with newsgroups so I am not sure how to
> reply to his thread before I was subscribed. But I am noticing something
> in my logs very similar to his, I get:
> 
> [  716.902506] BTRFS error (device sdb): failed to read the system
> array: -5
> [  716.918284] BTRFS error (device sdb): open_ctree failed
> [  717.004162] BTRFS warning (device sdb): 'recovery' is deprecated,
> use 'usebackuproot' instead
> [  717.004165] BTRFS info (device sdb): trying to use backup root at
> mount time
> [  717.004167] BTRFS info (device sdb): disk space caching is enabled
> [  717.004168] BTRFS info (device sdb): has skinny extents
> [  717.005673] BTRFS error (device sdb): failed to read the system
> array: -5
> [  717.020248] BTRFS error (device sdb): open_ctree failed
> 
> He also received a similar open_ctree failed message after he upgraded
> his kernel on Rockstor to 4.10.6-1.el7.elrepo.x86_64 and
> btrfs-progs-4.10.1-0.rockstor.x86_64.

FWIW that's not significant.  Open ctree failed is simply the generic 
btrfs failure to mount message.  It tells you nothing of the real 
problem, so other clues must be used to discern that.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

