From: Sander <sander@humilis.net>
Subject: Re: btrfs kernel oops and hot storage removing
Date: Fri, 29 Jan 2010 17:41:55 +0100
Message-ID: <20100129164155.GA3786@attic.humilis.net>
References: <792ba59f1001281533w5e238744k134ebbdb6a166647@mail.gmail.com>
Reply-To: sander@humilis.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Maksim 'max_posedon' Melnikau <maxposedon@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <792ba59f1001281533w5e238744k134ebbdb6a166647@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hello Maksim,

Maksim 'max_posedon' Melnikau wrote (ao):
> I'm running btrfs on my sheevaplug on storage attached via usb. I use
> multi-device configuration for testing (use different partitions for
> emulate this). I catched kernel oops on hot removing storage (without
> umount/etc). First one was one device decide reboot themselves, second
> when I manually turned it off and on.
> 
> Basically I don't expect correct btrfs working in such situation, but
> as I know it designed to work correctly in raid configuration, so, may
> be somebody expect better behavior even in such situation.

You pull the entire raid array when removing the USB storage, as the
Sheevaplug has only one USB port. That will not work and it is not the
fault of btrfs :-)

	With kind regards, Sander

-- 
Humilis IT Services and Solutions
http://www.humilis.net
