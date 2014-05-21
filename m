Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:57543 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750735AbaEUAv2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 May 2014 20:51:28 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: problem with degraded boot and systemd
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <pan$6f6ec$5ba926ea$9860d25c$5d86cd20@cox.net>
Date: Tue, 20 May 2014 18:51:26 -0600
Cc: linux-btrfs@vger.kernel.org
Message-Id: <9289871B-275D-4994-8617-BD83EECCFB2B@colorremedies.com>
References: <45D5C607-ED9D-49BB-BA60-CA2B0E94223D@colorremedies.com> <537BD078.7070504@libero.it> <20140520222609.GD1756@carfax.org.uk> <pan$6f6ec$5ba926ea$9860d25c$5d86cd20@cox.net>
To: Duncan <1i5t5.duncan@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On May 20, 2014, at 6:03 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> 
> 
> I'd actually argue that's functioning as it should, since I see forced 
> manual intervention in ordered to mount degraded as a FEATURE, NOT A BUG.

Manual intervention is OK for now, when it takes the form of dropping to a dracut shell, and only requires the user to pass mount -o degraded. To mount degraded automatically is worse because within a notification API for user space, it will lead users to make bad choices resulting in data loss.

But the needed sequence is fairly burdensome: force shutdown, boot again, use rd.break=premount, then use mount -o degraded, and then exit a couple of times.


> [1] dracut: I use it here on gentoo as well, because my rootfs is a multi-
> device btrfs and a kernel rootflags=device= line won't parse correctly, 
> apparently due to splitting at the wrong =, so I must use an initr* 
> despite my preference for a direct initr*-less boot, and I use dracut to 
> generate it.

rootflags doesn't take a device argument, it only applies to the volume to be mounted at /sysroot, so only one = is needed.


Chris Murphy