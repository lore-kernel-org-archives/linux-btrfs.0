Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtprelay05.ispgateway.de ([80.67.31.100]:50692 "EHLO
	smtprelay05.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584AbcHPTcD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Aug 2016 15:32:03 -0400
Received: from p4fce2bf8.dip0.t-ipconnect.de ([79.206.43.248] helo=[127.0.0.1])
	by smtprelay05.ispgateway.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
	(Exim 4.84)
	(envelope-from <hendrik@friedels.name>)
	id 1bZk5f-00025j-Eb
	for linux-btrfs@vger.kernel.org; Tue, 16 Aug 2016 21:31:59 +0200
From: "Hendrik Friedel" <hendrik@friedels.name>
To: "Btrfs BTRFS" <linux-btrfs@vger.kernel.org>
Subject: Debian Jessie: How to set rootflags=degraded
Date: Tue, 16 Aug 2016 19:31:57 +0000
Message-Id: <em5669168d-5565-4286-9e94-0d18f614ee57@laptophendrik>
Reply-To: "Hendrik Friedel" <hendrik@friedels.name>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I am using a raid1 under debian Jessie, because I need to decrease the 
likelyhood of unavailability of the system.
Unfortunately I found, that when removing one of the drives, the system 
will not boot up. Instead initramfs will show up and tell me that the 
root volume could not be mounted.

I read here:
https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg31265.html
that adding rootflags=degraded.

Furthermore I see that this is not yet default -at least in Ubuntu-
https://bugs.launchpad.net/ubuntu/+source/grub2/+bug/1229456?comments=all

But that it should work by modifying /etc/grub.d/10_linux:
https://bugs.launchpad.net/ubuntu/+source/grub2/+bug/1229456/comments/3
GRUB_CMDLINE_LINUX="rootflags=subvol=${rootsubvol},degraded 
${GRUB_CMDLINE_LINUX}"

when doing that and running grub-mkconfig and update-grub, I still get 
no entry with with "degraded" in /etc/grub.cfg.

Can someone tell me, how to achieve this? I've been seaching for very 
long now and I am surprised, that I don't find any answer.

Greetings,
Hendrik


---
Diese E-Mail wurde von Avast Antivirus-Software auf Viren geprüft.
https://www.avast.com/antivirus

