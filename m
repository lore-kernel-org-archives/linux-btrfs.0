Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail2.unitix.de ([176.9.2.175]:54748 "EHLO mail2.unitix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754393Ab2GJIwO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Jul 2012 04:52:14 -0400
Message-ID: <4FFBED3C.3000302@arndnet.de>
Date: Tue, 10 Jul 2012 10:52:12 +0200
From: Arnd Hannemann <arnd@arndnet.de>
MIME-Version: 1.0
To: Christian Robert <christian.robert@polymtl.ca>
CC: linux-btrfs@vger.kernel.org
Subject: Re: 3.5.0-rc6: btrfs and LVM snapshots -> wrong devicename in /proc/mounts
References: <4FFB59BF.1050104@arndnet.de> <4FFBA1C8.9020502@polymtl.ca>
In-Reply-To: <4FFBA1C8.9020502@polymtl.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Am 10.07.2012 05:30, schrieb Christian Robert:
> I agree with you, but you should never mount a snapshot of a btrfs filesystem at the same time the original is,
> because both the original and the snapshot had same "device fsid 5c3e8ca2-da56-4ade-9fef-103a6a8a70c2"
> 
> the kernel will tkink twice and fold back to the same device.

If that is correct the bug is that the kernel lets me mount the same device fsid on different devices twice.

> 
> btrsf does not behave like other filesystems, you can't snapshot a btrfs filesystem
> and hope to mount the snapshot somewhere else.

> snapsoot also duplicate lots of things internally that have no sence in a snapshot (like raid level, single or multiple devies ...)

I see. However, I expect a "simple" btrfs to just work or fail gracefully.

Best regards,
Arnd

