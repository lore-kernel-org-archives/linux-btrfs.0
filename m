Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:47521 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751951AbdDKNSk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Apr 2017 09:18:40 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cxvgk-0007H5-Du
        for linux-btrfs@vger.kernel.org; Tue, 11 Apr 2017 15:18:30 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: About free space fragmentation, metadata write amplification
 and (no)ssd
Date: Tue, 11 Apr 2017 15:13:24 +0200
Message-ID: <20170411151324.4f1bac32@jupiter.sol.kaishome.de>
References: <5e11b988-05ea-c468-21ef-589c71058436@mendix.com>
        <17965132-ca31-461a-7838-6a3500ffaeb6@gmail.com>
        <2bdc4a03-3a8e-52b6-5ede-ee4d40baac6c@mendix.com>
        <d07ae84b-72f7-bf67-147e-c3aa0940e69b@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Tue, 11 Apr 2017 07:33:41 -0400
schrieb "Austin S. Hemmelgarn" <ahferroin7@gmail.com>:

> >> FWIW, it is possible to use a udev rule to change the rotational
> >> flag from userspace.  The kernel's selection algorithm for
> >> determining is is somewhat sub-optimal (essentially, if it's not a
> >> local disk that can be proven to be rotational, it assumes it's
> >> non-rotational), so re-selecting this ends up being somewhat
> >> important in certain cases (virtual machines for example).  
> >
> > Just putting nossd in fstab seems convenient enough.  
> While that does work, there are other pieces of software that change 
> behavior based on the value of the rotational flag, and likewise make 
> misguided assumptions about what it means.

Something similar happens when you put btrfs on bcache. It now assumes
it is on SSD but in reality it isn't. Thus, I also deployed udev rules
to force back nossd behavior.

But maybe, in the bcache case using "nossd" instead would make more
sense. Any ideas on this?


-- 
Regards,
Kai

Replies to list-only preferred.

