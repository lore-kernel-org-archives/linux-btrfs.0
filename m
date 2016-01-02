Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:49506 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750977AbcABKI5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 2 Jan 2016 05:08:57 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
	by mailout.nyi.internal (Postfix) with ESMTP id 82B1E20114
	for <linux-btrfs@vger.kernel.org>; Sat,  2 Jan 2016 05:08:56 -0500 (EST)
Message-Id: <1451729336.2917121.480913242.132825EE@webmail.messagingengine.com>
From: Rasmus Abrahamsen <me@rasmusa.net>
To: Chris Murphy <lists@colorremedies.com>,
        Rasmus Abrahamsen <btrfs@rasmusa.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
In-Reply-To: <1451679613.2761176.480641362.3ADA17DB@webmail.messagingengine.com>
References: <9E462AAE-481A-4A0D-9918-FF56A73D6F6D@rasmusa.net>
 <CAJCQCtSCJ91FaJ20g-+TKMwGkXeQdEkn1yDf6w+H3=V_8_xshA@mail.gmail.com>
 <1451679613.2761176.480641362.3ADA17DB@webmail.messagingengine.com>
Subject: Re: Add big device, remove small device, read-only
Date: Sat, 02 Jan 2016 11:08:56 +0100
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This morning I wanted to check on progress of removing the device but
when trying to get the screen to wake, I was met with nothing. I tried
SSH, nothing. The machine had crashed or something of the like. After a
reboot, the device is still part of the filesystem.
I have now tried booting from an Arch Linux flash drive and try to
remove the device when booted from that.

Let's see how it goes.
