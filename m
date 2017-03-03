Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:57939 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751250AbdCCIGm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Mar 2017 03:06:42 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cjgCY-0005Cj-2D
        for linux-btrfs@vger.kernel.org; Fri, 03 Mar 2017 06:56:26 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: raid1 degraded mount still produce single chunks, writeable
 mount not allowed
Date: Fri, 3 Mar 2017 06:56:22 +0100
Message-ID: <20170303065622.2a9a244e@jupiter.sol.kaishome.de>
References: <CAJCQCtQByC_pTnZhFFfHmxktN-Ga4W0TZ8wVRPxe_b18G+Kajw@mail.gmail.com>
        <20170302103753.x35jhe7xgnwl6ee6@angband.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Thu, 2 Mar 2017 11:37:53 +0100
schrieb Adam Borowski <kilobyte@angband.pl>:

> On Wed, Mar 01, 2017 at 05:30:37PM -0700, Chris Murphy wrote:
> > [1717713.408675] BTRFS warning (device dm-8): missing devices (1)
> > exceeds the limit (0), writeable mount is not allowed
> > [1717713.446453] BTRFS error (device dm-8): open_ctree failed
> > 
> > [chris@f25s ~]$ uname -r
> > 4.9.8-200.fc25.x86_64
> > 
> > I thought this was fixed. I'm still getting a one time degraded rw
> > mount, after that it's no longer allowed, which really doesn't make
> > any sense because those single chunks are on the drive I'm trying to
> > mount.  
> 
> Well, there's Qu's patch at:
> https://www.spinics.net/lists/linux-btrfs/msg47283.html
> but it doesn't apply cleanly nor is easy to rebase to current kernels.
> 
> > I don't understand what problem this proscription is trying to
> > avoid. If it's OK to mount rw,degraded once, then it's OK to allow
> > it twice. If it's not OK twice, it's not OK once.  
> 
> Well, yeah.  The current check is naive and wrong.  It does have a
> purpose, just fails in this, very common, case.

I guess the reasoning behind this is: Creating any more chunks on this
drive will make raid1 chunks with only one copy. Adding another drive
later will not replay the copies without user interaction. Is that true?

If yes, this may leave you with a mixed case of having a raid1 drive
with some chunks not mirrored and some mirrored. When the other drives
goes missing later, you are loosing data or even the whole filesystem
although you were left with the (wrong) imagination of having a
mirrored drive setup...

Is this how it works?

If yes, a real patch would also need to replay the missing copies after
adding a new drive.

-- 
Regards,
Kai

Replies to list-only preferred.

