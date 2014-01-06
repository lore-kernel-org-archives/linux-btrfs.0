Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:32918 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751460AbaAFBz7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 5 Jan 2014 20:55:59 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfs-transaction blocked for more than 120 seconds
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <52CA06FE.2030802@gmx.at>
Date: Sun, 5 Jan 2014 18:55:57 -0700
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <C5D750A3-4A0B-47AD-B822-D817E8A2B41A@colorremedies.com>
References: <52C2AE7C.5020601@gmx.at> <64E70864-9830-4145-9EDF-F53A79977999@colorremedies.com> <52C9CBEF.2000309@gmx.at> <846FC885-56B5-422B-9366-D690D4258139@colorremedies.com> <06E20869-27B1-4868-8F0E-F78A154E76F0@colorremedies.com> <52C9F80F.4080500@gmx.at> <677399F4-2208-412F-B54F-3527B19369F3@colorremedies.com> <52CA06FE.2030802@gmx.at>
To: Sulla <Sulla@gmx.at>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 5, 2014, at 6:29 PM, Sulla <Sulla@gmx.at> wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Hi Chris!
> 
> # sudo smartctl -l scterc /dev/sda
> tells me
> SCT Error Recovery Control command not supported
> 
> you're right. the /sys/block/sdX/device/timeout file probably is useless then.

OK there's some confusion. /sys/block/sdX/device/timeout is the SCSI block layer timeout - linux itself has a timeout for each command issued to a block device, and will reset the link upon timeout being reached. So writing 120 to this will cause linux to wait for up to 120 seconds for the drive to respond. This is necessary because if there's a bad sector, the drive must report a read error in order for the md driver to reconstruct that data from parity. This is needed  bothfor effective scrubs, and recovery on read error in normal operation. It is not a persistent setting so you'll want to create a start up script for it.


Chris Murphy

