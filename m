Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:49076 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbbAJMXQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 10 Jan 2015 07:23:16 -0500
Received: from merkaba.localnet (host-188-174-199-142.customer.m-online.net [188.174.199.142])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id B1E5ABA
	for <linux-btrfs@vger.kernel.org>; Sat, 10 Jan 2015 13:21:58 +0100 (CET)
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: price to pay for nocow file bit?
Date: Sat, 10 Jan 2015 13:23:14 +0100
Message-ID: <2224067.qJDVSVqWin@merkaba>
In-Reply-To: <10396011.VnMcUEBNIZ@merkaba>
References: <20150107174315.GA21865@gardel-login> <pan$2625$dcbfe450$9a65d855$d7e62f1e@cox.net> <10396011.VnMcUEBNIZ@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Samstag, 10. Januar 2015, 13:00:23 schrieben Sie:
> I have seen this setting before, but I thought, well, logs would be good to 
> keep. But for the SSD based laptop I will try volatile storage now. I will
> see whether I missed a longer history, but I reduced it before anyway to a
> 14 day maximum retention time already, cause systemd used 1,1 GiB of my
> root partition for logs while rsyslog + logrotate used much less[1]. And I
> have yet not seen the immediate benefit for me here on this laptop to
> justify using up that much resources just for logging. So for me its a
> useless waste of resources currently. (This may be different on a server or
> anywhere where logfiles matter more, but then, when I consider some of our
> server VMs with just 4 to 5 GiB VMDK file, journald on Debian in default
> settings could easily fill the remaining space on some of them. Which I
> would consider a regression.)

Okay, scratch that.

journald is adaptive to the remaining space on the disk AFAIK.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
