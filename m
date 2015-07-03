Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:51109 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754826AbbGCN3g (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Jul 2015 09:29:36 -0400
Received: from merkaba.localnet (host-188-174-209-182.customer.m-online.net [188.174.209.182])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 2749310F
	for <linux-btrfs@vger.kernel.org>; Fri,  3 Jul 2015 15:29:35 +0200 (CEST)
From: Martin Steigerwald <martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Any hope of pool recovery?
Date: Fri, 03 Jul 2015 15:29:34 +0200
Message-ID: <1477911.JnaWx19SzT@merkaba>
In-Reply-To: <pan$d53e4$45e2ddf7$2a88de7f$b02d251@cox.net>
References: <CAC=t97D=Dmq3cu-z2PNjREQn5690+R9NBQsjr5KZ4grYnYr4WA@mail.gmail.com> <CAC=t97A4JtSzXpn9Yr3vhe6Z5JCfKEFB1GfwSLsfYPOWhZ+Zrw@mail.gmail.com> <pan$d53e4$45e2ddf7$2a88de7f$b02d251@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Friday 03 July 2015 09:31:03 Duncan wrote:
> Donald Pearson posted on Thu, 02 Jul 2015 13:19:41 -0500 as excerpted:
> > btrfs restore complains that every device is missing except the one that
> > you specify on executing the command.  Multiple devices as a parameter
> > isn't an option.  Specifcy /dev/disk/by-uuid/<uuid> claims that all
> > devices are missing.
> 
> That sounds like the kernel lost track of what devices correspond with
> the filesystem.  Try issuing the btrfs device scan command before
> restore, and see if that changes things.  (If it doesn't, try btrfs
> device scan --all-devices, just in case.)

Also does blkid and/or file-sk onto each device show that the BTRFS 
signatures are still there?

-- 
Martin
