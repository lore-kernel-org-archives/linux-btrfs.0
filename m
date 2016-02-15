Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bitfolk.com ([85.119.80.223]:46245 "EHLO mail.bitfolk.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751597AbcBOAN7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 14 Feb 2016 19:13:59 -0500
Date: Mon, 15 Feb 2016 00:13:56 +0000
From: Andy Smith <andy@strugglers.net>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Problems with "btrfs dev remove" of dead disk
Message-ID: <20160215001356.GR4290@bitfolk.com>
References: <20160214215531.GQ4290@bitfolk.com>
 <CAJCQCtSTWLXWCwNVmcWc6zt+fGAv-pJy73VtL0xTnyaw10MTrw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJCQCtSTWLXWCwNVmcWc6zt+fGAv-pJy73VtL0xTnyaw10MTrw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

On Sun, Feb 14, 2016 at 04:49:29PM -0700, Chris Murphy wrote:
> On Sun, Feb 14, 2016 at 2:55 PM, Andy Smith <andy@strugglers.net> wrote:
> > $ sudo btrfs dev remove /dev/sdh /srv/tank
> > ERROR: not a block device: /dev/sdh
> 
> 
> Since now it's a missing device, it should be
> 
> sudo btrfs device remove missing /srv/tank

$ sudo btrfs device remove missing /srv/tank
ERROR: error removing device 'missing': no missing devices found to remove

> But I'm not sure if this works when the volume is not already mounted
> degraded.

I have now done:

# mount -oremount,degraded /srv/tank 

and tried again, but it produces the same response ("mount" now does
show "degraded" as one of the mount flags, however).

I have not yet tried completely unmounting it and mounting it again.

> it really doesn't make sense to me you'd want to increase risk of
> more Btrfs problems when such known things are now fixed. Consider
> 4.1.15 if you want a stable long term yet currently supportable
> kernel.

It is inconvenient to reboot just now, so if I'm able to fix things
without doing so (e.g. by balance or replace) then I would like to.

If that won't be possible then I will of course boot into a newer
kernel at the same time.

If I end up booting into 4.1.15 then it should be possible to mount
degraded and remove missing?

Cheers,
Andy
