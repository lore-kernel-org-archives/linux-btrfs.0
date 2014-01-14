Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:39547 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752807AbaANAkf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Jan 2014 19:40:35 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfsck does not fix
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <52D317CF.2070007@friedels.name>
Date: Mon, 13 Jan 2014 17:40:33 -0700
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <EDD506BE-1DAC-4C2C-9FF4-184180315557@colorremedies.com>
References: <52C7127F.3060902@friedels.name> <6E517D5F-B921-47E7-82E7-27865077C43D@colorremedies.com> <52C87B67.1040503@friedels.name> <F9C2788F-B057-4C3F-A490-8F8A19C37F97@colorremedies.com> <52CC65C9.3090605@friedels.name> <52D08812.3040707@friedels.name> <0FFB7595-0A34-424C-BFC5-CCF6098A7801@colorremedies.com> <52D317CF.2070007@friedels.name>
To: Hendrik Friedel <hendrik@friedels.name>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I see no obvious hardware source for the problem, SATA Phy Event Counters are zeros except a few COMRESET events which is pretty minor. No ICRC or UDMA-CRC errors recorded. No reallocated or pending bad sectors.

I'd look at your historical system logs, messages or journalctl, and do case insensitive search for: err, unc, reset and see if anything along those lines has been reported that might explain it.

If you decide to backup, reformat, restore, then first I suggest 

btrfs-image -c 9-t 4 /dev/sdX /mnt/<pathtoanothervolume+filename>

You can keep it handy in case a dev asks for it or you can attach it to a kernel.org bug report.

Chris Murphy