Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:37768 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753826AbcBNXt3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 14 Feb 2016 18:49:29 -0500
Received: by mail-ig0-f180.google.com with SMTP id 5so45011348igt.0
        for <linux-btrfs@vger.kernel.org>; Sun, 14 Feb 2016 15:49:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160214215531.GQ4290@bitfolk.com>
References: <20160214215531.GQ4290@bitfolk.com>
Date: Sun, 14 Feb 2016 16:49:29 -0700
Message-ID: <CAJCQCtSTWLXWCwNVmcWc6zt+fGAv-pJy73VtL0xTnyaw10MTrw@mail.gmail.com>
Subject: Re: Problems with "btrfs dev remove" of dead disk
From: Chris Murphy <lists@colorremedies.com>
To: Andy Smith <andy@strugglers.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Feb 14, 2016 at 2:55 PM, Andy Smith <andy@strugglers.net> wrote:

>
> So, ideally I'd like to remove the missing device sdh (id 2) to have
> redundant copies of the data until I can insert a new drive. But
> "remove" doesn't seem to want to work:
>
> $ sudo btrfs dev remove /dev/sdh /srv/tank
> ERROR: not a block device: /dev/sdh


Since now it's a missing device, it should be

sudo btrfs device remove missing /srv/tank

But I'm not sure if this works when the volume is not already mounted
degraded. There is no automatic degraded mechanism yet. I think even
newer than 4.4 is needed plus a patch.

http://www.spinics.net/lists/linux-btrfs/msg51912.html



> With this btrfs-progs and kernel version, will a later "btrfs
> replace start -r /dev/sdh /dev/sdl" work without me rebooting into a
> newer kernel, even though /dev/sdh doesn't exist as a device to the
> kernel right now?
>
> Any information/advice appreciated.

On the one hand, the rebuild doesn't change any fs features and
therefore a device rebuilt with e.g. kernel 4.4, should then read fine
later if you go back to 3.16. On the other hand, there's hundreds of
bug fixes, many thousands of insertions and deletions in Btrfs since
then, so it really doesn't make sense to me you'd want to increase
risk of more Btrfs problems when such known things are now fixed.
Consider 4.1.15 if you want a stable long term yet currently
supportable kernel.


-- 
Chris Murphy
