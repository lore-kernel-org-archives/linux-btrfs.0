Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:44258 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbbHAKFx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Aug 2015 06:05:53 -0400
From: Russell Coker <russell@coker.com.au>
To: John Ettedgui <john.ettedgui@gmail.com>,
        btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: mount btrfs takes 30 minutes, btrfs check runs out of memory
Date: Sat, 1 Aug 2015 20:05:48 +1000
References: <CAJ3TwYQXqUZiKhYc5rciTmvGX1RLkHnkQb5SSYAJ7AD+kbudag@mail.gmail.com> <CAJ3TwYS+yL8Tk8d3uigpXrfD+dcn2G4tWwbF7jcB=BCDZqs6+g@mail.gmail.com> <CAJ3TwYQc3d5R6r+tjY9mxUzptWA_MktUbZeaQebmNRBuqB7zYA@mail.gmail.com>
In-Reply-To: <CAJ3TwYQc3d5R6r+tjY9mxUzptWA_MktUbZeaQebmNRBuqB7zYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201508012005.48675.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 1 Aug 2015 02:35:39 PM John Ettedgui wrote:
> >> It seems that you're using Chromium while doing the dump. :)
> >> If no CD drive, I'll recommend to use Archlinux installation iso to make
> >> a bootable USB stick and do the dump.
> >> (just download and dd would do the trick)
> >> As its kernel and tools is much newer than most distribution.
> 
> So I did not have any usb sticks large enough for this task (only 4Gb)
> so I restarted into emergency runlevel with only / mounted and as ro,
> I hope that'll do.

The Debian/Jessie Netinst image is about 120M and allows you to launch a 
shell.  If you want a newer kernel you could rebuild the Debian Netinst 
yourself.

Also a basic text-only Linux installation takes a lot less than 4G of storage.  
I have a couple of 1G USB sticks with Debian installed that I use to fix 
things.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
