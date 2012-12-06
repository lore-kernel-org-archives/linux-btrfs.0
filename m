Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37706 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755005Ab2LFMww (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Dec 2012 07:52:52 -0500
Received: by mail-ob0-f174.google.com with SMTP id ta14so6084368obb.19
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Dec 2012 04:52:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20121206063151.GC20550@merlins.org>
References: <CACR_K2s2NXFJfNknzJLLnQGK6=Sz+6Abs8y7kJfxxynUUaF+cA@mail.gmail.com>
	<20121206063151.GC20550@merlins.org>
Date: Thu, 6 Dec 2012 07:52:51 -0500
Message-ID: <CACR_K2sPZMoqr6hO-xzWFiQ95dsi_0=3kWyi+zmY3qKHP0x1NA@mail.gmail.com>
Subject: Re: Question about btrfs snapshot delay and rm -rf delay
From: Sylvain Alain <d2racing911@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, right now I own this SSD :

Intel SSD 520 Series MLC 120 Gigs

I'm using the latest firmware from Intel.

Also, this is my /etc/fstab

/dev/sda3      /boot            ext2       noauto,noatime,defaults
          1 2
/dev/sda1      /boot/efi        vfat        noauto,defaults
                 0 0
/dev/sda4      /                  btrfs
defaults,noatime,ssd,discard,compress=lzo,subvol=@racine 0 1
tmpfs          /var/tmp/portage tmpfs      size=12G
                0 0
none           /dev/shm         tmpfs      nodev,nosuid,noexec
                0 0

I discovered that when it hangs, it can be small or big files.

My latest hang was when I removed the vanilla-sources-3.6.8 last night.

I don't see any errors inside dmesg or /var/log/messages.

Sylvain



2012/12/6 Marc MERLIN <marc@merlins.org>:
> On Wed, Dec 05, 2012 at 11:56:27PM -0500, Sylvain Alain wrote:
>> Hi everyone, I'm running btrfs since octobre 2012 and I would like to
>> understand 2 behavior that I noticed.
>>
>> 1. When I delete a big directory, sometimes it can hang my box for 1
>> minutes or so, it seems that's the btrfs lock my SSD.
>
> Doesn't directly answer your question, but if you don't have discard as a
> mount option, you should try that.
>
> Which SSD do you have? Do normal big file writes succeed or hang too?
>
> My guess right now is that you don't have discard, and your drive is doing
> very slow garbage collection. I had a Crucial C300 that did just that before
> it ate itself and my data a month later.
> Also check that your drive does not have a firmware update to remove those
> hangs.
>
> Marc
> --
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> Microsoft is to operating systems ....
>                                       .... what McDonalds is to gourmet cooking
> Home page: http://marc.merlins.org/



--
Salut
alp
Sylvain
