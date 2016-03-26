Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:36212 "EHLO
	mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbcCZAtE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Mar 2016 20:49:04 -0400
Received: by mail-io0-f173.google.com with SMTP id 124so126583847iov.3
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Mar 2016 17:49:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAafysEuE0CXZ2fyY2ybnff3=XLEdGirCU9BJf9mhLE0xFTTrQ@mail.gmail.com>
References: <CAAafysGTQucscr-8sTuT2c4BpdAovq0w9UbehRYDrSH71CLF-A@mail.gmail.com>
	<CAPmG0jbXcqfB1jG7WFriMhicdsoZ+pbD_uUBu7v9YiD-ey=jDw@mail.gmail.com>
	<CAAafysEhGJi5jYxHooV4h1tD3pqnc-brbB9k4prS9yK0P5PGdg@mail.gmail.com>
	<CAAafysEuE0CXZ2fyY2ybnff3=XLEdGirCU9BJf9mhLE0xFTTrQ@mail.gmail.com>
Date: Fri, 25 Mar 2016 18:49:02 -0600
Message-ID: <CAJCQCtQcX+U1cWz1j3Re5E-=ruPBY+zj0SFqB1jDibgeQniSVw@mail.gmail.com>
Subject: Re: RAID Assembly with Missing Empty Drive
From: Chris Murphy <lists@colorremedies.com>
To: John Marrett <johnf@zioncluster.ca>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 25, 2016 at 4:31 PM, John Marrett <johnf@zioncluster.ca> wrote:
> Continuing with my recovery efforts I've built overlay mounts of each
> of the block devices supporting my btrfs filesystem as well as the new
> disk I'm trying to introduce. I have patched the kernel to disable the
> check for multiple missing devices. I then exported the overlayed
> devices using iSCSI to a second system to attempt the recovery.
>
> I am able to mount the device rw, then I can remove missing devices
> which removes the missing empty disk. I can add in a new device to the
> filesystem and then attempt to remove the second missing disk (which
> has 2.7 TB of content on it).
>
> Unfortunately this removal fails as follows:
>
> ubuntu@btrfs-recovery:~$ sudo btrfs device delete missing /mnt
> ERROR: error removing the device 'missing' - Input/output error


Quite honestly I don't understand how Btrfs raid1 volume with two
missing devices even permits you to mount it degraded,rw in the first
place. That's rather mystifying considering the other thread where
there's a 4 disk raid10 with one missing device, and rw,degraded mount
is allowed only once, after that it disallows further attempts to
rw,degraded mount it.

Anyway, maybe it's possible there's no dual missing metadata chunks,
although I find it hard to believe. But OK, maybe it works for a while
and you can copy some stuff off the drives where there's at least one
data copy. If there's dual  missing data copies but there's still at
least 1 metadata copy, then file system will just spit out noisy error
messages. But if there ends up being dual missing metadata, I expect a
crash, or the file system goes read only, or maybe even unmounts. I'm
not sure. But once there's 0 copies of metadata I don't see how the
file system can correct for that.

Because there are two devices missing, I doubt this matters, but I
think you're better off using 'btrfs replace' for this rather than
'device add' followed by 'device remove'. The two catches with
replace: the replacement device must be as big or bigger than the one
being replaced; you have to do a resize on the replacement device,
using 'fi resize devid:max' to use all the space if the new one is
bigger than the old device. But I suspect either the first or second
replacement will fail also, it's too many missing devices.

So what can happen, if there's 0 copies of metadata, is that you might
not get everything off the drives before you hit the 0 copies problem
and the ensuing face plant. In that case you might have to depend on
btrfs restore. It could be really tedious to find out what can be
scraped. But I still think you're better off than any other file
system in this case, because they wouldn't even mount if there were
two mirrors lost.


-- 
Chris Murphy
