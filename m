Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.profihost.ag ([85.158.179.208]:48980 "EHLO
	mail.profihost.ag" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757158Ab2FYOIe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jun 2012 10:08:34 -0400
Message-ID: <4FE870DF.90308@profihost.ag>
Date: Mon, 25 Jun 2012 16:08:31 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs deadlock in 3.5-rc3
References: <4FE58366.8000302@profihost.ag> <4FE862D7.3060005@fusionio.com>
In-Reply-To: <4FE862D7.3060005@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 25.06.2012 15:08, schrieb Josef Bacik:>
 > This isn't showing the guy who's actually trying to commit the
 > transaction.  Next time this happens can you do a sysrq+w and capture
 > the output and post it here so we can see what everybody is doing? 
Thanks,
 >
 > Josef

No problem.

Kernel trace:
http://pastebin.com/raw.php?i=puZkCRCn

# sys rq w trigger:
# echo w > /proc/sysrq-trigger
http://pastebin.com/raw.php?i=AQA8xxCX

Hope that helps. I'm able to trigger this pretty easily with ceph. So i 
can produce as much info as you want.

Thanks!

Greets,
Stefan

