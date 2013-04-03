Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f176.google.com ([209.85.215.176]:43826 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760476Ab3DCQza (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Apr 2013 12:55:30 -0400
Received: by mail-ea0-f176.google.com with SMTP id h10so756328eaj.21
        for <linux-btrfs@vger.kernel.org>; Wed, 03 Apr 2013 09:55:29 -0700 (PDT)
Message-ID: <515C5F0D.40909@gmail.com>
Date: Wed, 03 Apr 2013 18:55:41 +0200
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: =?UTF-8?B?U3fDom1pIFBldGFyYW1lc2g=?= <swami@petaramesh.org>
CC: Roman Mamedov <rm@romanrm.ru>,
        "BTRFS, Linux" <linux-btrfs@vger.kernel.org>,
        zfs-discuss@zfsonlinux.org
Subject: Re: Moving...
References: <515A95C7.5090607@petaramesh.org> <20130402230421.016afe58@natsu> <515B120F.6000004@petaramesh.org>
In-Reply-To: <515B120F.6000004@petaramesh.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/02/2013 07:14 PM, Swâmi Petaramesh wrote:
> Le 02/04/2013 19:04, Roman Mamedov a écrit :
>> but at this point I trust my data to BTRFS more, than I would trust ZFS.
> 
> My experience with ZFS on Linux is still somewhat limited, the only
> thing that I can say is that I've used it for about 2 years and a half
> on my (quite loaded) home server without ever encoutering a single issue
> (besides some tricky Ubuntu version upgrades, only due to the fact that
> ZFS is "not in the standard kernel" by opposition to BTRFS).
> 
> On the BTRFS side, I've used it on 5 machine for about a year on a daily
> basis ; I've completely lost a filesystem, beyond repair, twice ; I
> found myself with a machine that wouldn't boot anymore and would
> necessitate serious and tricky FS maintenance, 3 times, I had to
> completely reinstall the FS because of extremely degraded performance, 4
> times.
> 
> Add to this that the FS management tools and properly working FS
> features are an order of magnitude better in ZFS than in BTRFS...
> 
> That's enough for me...

With these experiences, I am not surprise that you changed the filesystem.

However I would like to report my experience which is quite positive
regarding btrfs. I used BTRFS as root filesystem for about two-three
years. And I encountered two filesystem corruption.

The first one was due to a bug in BTRFS. I don't remember the details,
it was due to a problem with the linking a file between two subvolumes.
However the filesystem worked well, the only problem which I had was the
in-ability to remove a file (the link).

The second problem was due a hardware fault: the power supply was
insufficient, so sometime the hard disk returned errors. With scrub I
was able to find the files corrupted and to recreate the metadata (which
in BTRFS is DUP-ed).
This problem happened several time before I replaced the power supply;
and the filesystem worked well (with the exception of the corrupted file
of course).

May be that I was very lucky or you was very un-lukcy.
I hope that with ZFS you will be able to solve all your problems.

> 
> I've already converted 2 machines from BTRFS to ZFS since yesterday.
> 
> My netbook (now ZFS) boots to GDM in less than 30 seconds. My son's same
> machine (except for the FS) takes 75 MORE seconds.

The BTRFS performance are not the best, but good enough. May be that
BTRFS require more memory than other filesystem, so it is not good for
old computer. For my old laptop I had to revert to ext4.

However I have to point out that am not a fan of the test "time to
login": I prefer the responsiveness of the system, and with the latest
kernel (IIRC from 3.6/3.7 onwards) this was a lot improved.

> 
> You get it.
> 
> Kind regards.
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
