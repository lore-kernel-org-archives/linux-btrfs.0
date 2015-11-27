Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:58289 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751050AbbK0HmW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Nov 2015 02:42:22 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
	by mailout.nyi.internal (Postfix) with ESMTP id 667C920960
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2015 02:42:21 -0500 (EST)
Message-Id: <1448610141.801244.451299857.5EBE7B93@webmail.messagingengine.com>
From: Ian Kelling <ian@iankelling.org>
To: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: How to detect / notify when a raid drive fails?
Date: Thu, 26 Nov 2015 23:42:21 -0800
In-Reply-To: <pan$2baa9$6d4c6e73$140f6177$488caa5a@cox.net>
References: <1448601297.4093478.451242913.1CEE0D6D@webmail.messagingengine.com>
 <pan$2baa9$6d4c6e73$140f6177$488caa5a@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 26, 2015, at 09:30 PM, Duncan wrote:
> What generally happens now, however, is that the btrfs will note failures 
> attempting to write the device and start queuing up writes.  If the 
> device reappears fast enough, btrfs will flush the queue and be back to 
> normal.  Otherwise, you pretty much need to reboot and mount degraded, 
> then add a device and rebalance. (btrfs device delete missing broke some 
> versions ago and just got fixed by the latest btrfs-progs-4.3.1, IIRC.)
> 
> As for alerts, you'd see the pile of accumulating write errors in the 
> kernel log.  Presumably you can write up a script that can alert on that 
> and mail you the log or whatever, but I don't believe there's anything 
> official or close to it, yet.

Great info, thanks. Just trying to write a file, sync and read it
sounds like the easiest test for now, especially since I don't
know what the write fail log entries will look like. And setting
up SMART notifications.

- Ian
