Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:58420 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751968AbaAFAtz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 5 Jan 2014 19:49:55 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfs-transaction blocked for more than 120 seconds
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <52C9F80F.4080500@gmx.at>
Date: Sun, 5 Jan 2014 17:49:53 -0700
Cc: linux-btrfs@vger.kernel.org
Message-Id: <677399F4-2208-412F-B54F-3527B19369F3@colorremedies.com>
References: <52C2AE7C.5020601@gmx.at> <64E70864-9830-4145-9EDF-F53A79977999@colorremedies.com> <52C9CBEF.2000309@gmx.at> <846FC885-56B5-422B-9366-D690D4258139@colorremedies.com> <06E20869-27B1-4868-8F0E-F78A154E76F0@colorremedies.com> <52C9F80F.4080500@gmx.at>
To: Sulla <Sulla@gmx.at>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 5, 2014, at 5:25 PM, Sulla <Sulla@gmx.at> wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Thanks Chris!
> 
> Thanks for your support.
> 
>>> echo 120 >/sys/block/sdX/device/timeout
> timeout is 30 for my HDDs.

I don't think those drives support a configurable time out; the Green hasn't support it in years. Where are you getting this information? What do you get for 'smartctl -l scterc /dev/sdX'?



> I don't really wish to install or compile cumstom kernels, to be honest.

If the problem is reproducible, then that's the fastest way to find out if it's been fixed or not. In this case 3.11 is EOL already, no more updates.


Chris Murphy