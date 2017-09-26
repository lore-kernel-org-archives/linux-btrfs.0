Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:52797 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1031377AbdIZWxk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Sep 2017 18:53:40 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dwyjG-000241-Jd
        for linux-btrfs@vger.kernel.org; Wed, 27 Sep 2017 00:53:26 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: 4.13.3 still has the out of space kernel oops
Date: Wed, 27 Sep 2017 00:53:10 +0200
Message-ID: <20170927005310.105688bf@jupiter.sol.kaishome.de>
References: <CAA85sZuBVU+Z5L2gwUst1-MdkK8VGM=tHv1cqKho5JGZt5DEjg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Wed, 27 Sep 2017 00:45:04 +0200
schrieb Ian Kumlien <ian.kumlien@gmail.com>:

> I just had my laptop hit the out of space kernel oops which it kinda
> hard to recover from
> 
> Everything states "out of disk" even with 20 gigs free (both according
> to df and btrfs fi df)

You should run balance from time to time. I can suggest the auto
balance script from here:

https://www.spinics.net/lists/linux-btrfs/msg52076.html

It can be run unattended on a regular basis.


> So I'm suspecting that i need to run btrfs check on it to recover the
> lost space (i have mounted it with clear_cache and nothing)

I don't think that "btrfs check" would recover free space, that's not a
file system corruption, it's an allocation issue due to unbalanced
chunks.


> The problem is, finally getting a shell with rd.shell rd.break=cmdline
> - systemd is still a pain and since it's "udev" it's not allowing me
> to do cryptsetup luksopen due to "dependencies"

Does "emergency" as a cmdline work? It should boot to emergency mode of
systemd. Also, "recovery" as a cmdline could work, boots to a different
mode. Both work for me using dracut on Gentoo with systemd.


> Basically, btrfs check should be able to run on a ro mounted
> fileystem, this is too hard to get working without having to bring a
> live usb stick atm

I think this is possible in the latest version but only running in
non-repair mode.


-- 
Regards,
Kai

Replies to list-only preferred.

