Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f42.google.com ([209.85.213.42]:35405 "EHLO
	mail-vk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbbH0R1e (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Aug 2015 13:27:34 -0400
Received: by vkfi73 with SMTP id i73so12613078vkf.2
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Aug 2015 10:27:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGAq4WF1-aeLHzz25WjqnrP9wrfjERFy+MqdTK5nbqfg6c5xcA@mail.gmail.com>
References: <CAGAq4WGf475k4oN6+MHrOfnKNdeLsHQE1WfKQAkwPxOH3=9-cw@mail.gmail.com>
	<CAJCQCtTxrBXxi3UQVXqPbXeRQobsvdZq9rsnyVioKQ0nNCZNsw@mail.gmail.com>
	<CAGAq4WFEown9JQxj0qi46zuBun2eUQFKtRSOsgLC03Uv6r1UPw@mail.gmail.com>
	<CAJCQCtQQmz3+Cs0KXL+-18UTP1tUG3_4BEpU0qAevi=Os4bYSw@mail.gmail.com>
	<CAGAq4WF1-aeLHzz25WjqnrP9wrfjERFy+MqdTK5nbqfg6c5xcA@mail.gmail.com>
Date: Thu, 27 Aug 2015 11:27:33 -0600
Message-ID: <CAJCQCtR_83dzDtALR=joqdBqWAB4mG8vK0p_t3wgiwKgKz22ew@mail.gmail.com>
Subject: Re: Meta data full on a Readynas
From: Chris Murphy <lists@colorremedies.com>
To: Mike Aubury <mike@aubit.com>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 27, 2015 at 11:18 AM, Mike Aubury <mike@aubit.com> wrote:
> Offlist - thanks for the help so far..

No, I'm changing it back to onlist. It's not appropriate to take this offlist.

This whole conversation is relevant to others who end up in this same
situation. And the ReadyNAS folks should have better support for this,
you paid them money for this product, and it was their choice to use
Btrfs. They should support you. But in the meantime the Btrfs list is
the right place for the discussion.


>
>
> The loop device is still there
>
> # losetup  -a
> /dev/loop0: [0861]:198 (/media/USB_HDD_1/t1/tmpbtrfs)
>
> But doesnt seem to be being picked up :
>
> # btrfs fi show
> warning devid 4 not found already
> Label: '0e36d290:data'  uuid: e75a9856-d9e5-4d02-92e6-a217056c69b7
>         Total devices 4 FS bytes used 6.09TiB
>         devid    1 size 2.71TiB used 2.71TiB path /dev/md127
>         devid    2 size 1.82TiB used 1.82TiB path /dev/md126
>         devid    3 size 1.82TiB used 1.82TiB path /dev/md125
>         *** Some devices missing


Try

# btrfs dev scan


> Trying a mount in that state gives :
>
> # mount /data
> mount: wrong fs type, bad option, bad superblock on /dev/md126,
>        missing codepage or helper program, or other error
>        In some cases useful info is found in syslog - try
>        dmesg | tail  or so
>
> dmesg gives :
> btrfs: failed to read chunk tree on md125
> btrfs: open_ctree failed

If dev scan doesn't work you could try to mount with -o ro,degraded
but I do not recommend it until you fist explore all options to make
btrfs aware of this loop back device.

In the future I think it's better to use the USB stick directly rather
than loopback files which just adds more complexity to an already
fragile situation.


> FWIW - When I used the usb file - it never had any "usage" reported in
> the "fi show" - used was always 0GB, I think the thing is just totally
> messed up, and all i've done is mess it up more!

There is at least some metadata on it, or it wouldn't be get fussy
that the device is missing. So you need to get the loop back device
visible to Btrfs and then it will almost certainly mount at least ro
at which point you can get data off of it first; and then you can deal
with the btrfs dev delete part.





-- 
Chris Murphy
