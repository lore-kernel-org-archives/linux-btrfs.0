Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:48569 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750977AbcABLDD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 2 Jan 2016 06:03:03 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
	by mailout.nyi.internal (Postfix) with ESMTP id 2953F20248
	for <linux-btrfs@vger.kernel.org>; Sat,  2 Jan 2016 06:03:03 -0500 (EST)
Received: from [10.0.0.5] (x1-6-20-0c-c8-26-c9-2d.cpe.webspeed.dk [176.23.125.70])
	by mail.messagingengine.com (Postfix) with ESMTPA id 764E1C013FE
	for <linux-btrfs@vger.kernel.org>; Sat,  2 Jan 2016 06:03:02 -0500 (EST)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 9.2 \(3112\))
Subject: Re: Add big device, remove small device, read-only
From: Rasmus Abrahamsen <btrfs@rasmusa.net>
In-Reply-To: <1451729336.2917121.480913242.132825EE@webmail.messagingengine.com>
Date: Sat, 2 Jan 2016 12:03:02 +0100
Message-Id: <E84088C8-6D44-488A-AE02-842132DB4596@rasmusa.net>
References: <9E462AAE-481A-4A0D-9918-FF56A73D6F6D@rasmusa.net> <CAJCQCtSCJ91FaJ20g-+TKMwGkXeQdEkn1yDf6w+H3=V_8_xshA@mail.gmail.com> <1451679613.2761176.480641362.3ADA17DB@webmail.messagingengine.com> <1451729336.2917121.480913242.132825EE@webmail.messagingengine.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Oops, sent this message from the wrong email, then tried attaching a file. I am really bad at this.

This morning I wanted to check on progress of removing the device but
when trying to get the screen to wake, I was met with nothing. I tried
SSH, nothing. The machine had crashed or something of the like. After a
reboot, the device is still part of the filesystem.
I have now tried booting from an Arch Linux flash drive and try to
remove the device when booted from that.

Let's see how it goes.

UPDATE: Seems like the kernel crashed. I have attached a picture link.
https://dl.dropboxusercontent.com/u/323865/2016-01-02%20IMG_8478.jpg

Can anyone give me any advice on what to do?

I think I will reboot and try a btrfs scrub before trying again.

Rasmus