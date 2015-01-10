Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:50996 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbbAJMAZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 10 Jan 2015 07:00:25 -0500
Received: from merkaba.localnet (host-188-174-199-142.customer.m-online.net [188.174.199.142])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 661769A
	for <linux-btrfs@vger.kernel.org>; Sat, 10 Jan 2015 12:59:08 +0100 (CET)
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: price to pay for nocow file bit?
Date: Sat, 10 Jan 2015 13:00:23 +0100
Message-ID: <10396011.VnMcUEBNIZ@merkaba>
In-Reply-To: <pan$2625$dcbfe450$9a65d855$d7e62f1e@cox.net>
References: <20150107174315.GA21865@gardel-login> <54AD929E.608@fb.com> <pan$2625$dcbfe450$9a65d855$d7e62f1e@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Donnerstag, 8. Januar 2015, 06:30:59 schrieb Duncan:
> FWIW, I'm systemd on btrfs here, but I use syslog-ng for my non-volatile 
> logs and have Storage=volatile in journald.conf, using journald only for 
> current-session, where unit status including last-10-messages makes 
> troubleshooting /so/ much easier. =:^)  Once past current-session, text 
> logs are more useful to me, which is where syslog-ng comes in.  Each to 
> its strength, and keeping the journals from wearing the SSDs[1] is a very 
> nice bonus. =:^)

Nice, I try this as well.

Cause while journalctl provides some nice stuff to query the logs, even by field 
or time and what not, frankly on my laptop, I don´t care.

I have seen this setting before, but I thought, well, logs would be good to 
keep. But for the SSD based laptop I will try volatile storage now. I will see 
whether I missed a longer history, but I reduced it before anyway to a 14 day 
maximum retention time already, cause systemd used 1,1 GiB of my root 
partition for logs while rsyslog + logrotate used much less[1]. And I have yet 
not seen the immediate benefit for me here on this laptop to justify using up 
that much resources just for logging. So for me its a useless waste of 
resources currently. (This may be different on a server or anywhere where 
logfiles matter more, but then, when I consider some of our server VMs with 
just 4 to 5 GiB VMDK file, journald on Debian in default settings could easily 
fill the remaining space on some of them. Which I would consider a regression.)

[1] systemd: journal is quite big compared to rsyslog output
https://bugs.debian.org/773538

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
