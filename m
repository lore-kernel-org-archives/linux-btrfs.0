Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:40717 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S932993AbdDJQyS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Apr 2017 12:54:18 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cxcZo-0008Ua-Sc
        for linux-btrfs@vger.kernel.org; Mon, 10 Apr 2017 18:54:04 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: btrfs filesystem keeps allocating new chunks for no apparent
 reason
Date: Mon, 10 Apr 2017 18:53:58 +0200
Message-ID: <20170410185358.389c61e0@jupiter.sol.kaishome.de>
References: <572D0C8B.8010404@mendix.com>
 <89a684c7-364e-f409-5348-bc0077fd438c@cn.fujitsu.com>
 <5b642448-951e-5b5e-1343-0299a950089c@mendix.com>
 <51778c0f-2720-1c2d-aba2-e22e5f4d3a3a@mendix.com>
 <4532f6ee-2a6e-412a-7230-edb76735d55f@mendix.com>
 <07a7f59e-64e0-4d09-5d32-01bc933fe38d@gmail.com>
 <20170410144533.664fc304@jupiter.sol.kaishome.de>
 <5488ea5a-b41c-5987-e664-ec17cf2d5e01@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Mon, 10 Apr 2017 08:51:38 -0400
schrieb "Austin S. Hemmelgarn" <ahferroin7@gmail.com>:

> On 2017-04-10 08:45, Kai Krakow wrote:
> > Am Mon, 10 Apr 2017 08:39:23 -0400
> > schrieb "Austin S. Hemmelgarn" <ahferroin7@gmail.com>:
> >  
> >> They've been running BTRFS
> >> with LZO compression, the SSD allocator, atime disabled, and mtime
> >> updates deferred (lazytime mount option) the whole time, so it may
> >> be a slightly different use case than the OP from this thread.  
> >
> > Does btrfs really support lazytime now?
> >  
> It appears to, I do see fewer writes with it than without it.  At the 
> very least, if it doesn't, then nothing complains about it.

Did you put it in /etc/fstab only for the rootfs? If yes, it probably
has no effect. You would need to give it as rootflags on the kernel
cmdline.


-- 
Regards,
Kai

Replies to list-only preferred.

