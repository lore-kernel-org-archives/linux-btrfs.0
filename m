Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.162]:58628 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756074AbaCZVLY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Mar 2014 17:11:24 -0400
Received: from linux-z0zw.site (p508DFA95.dip0.t-ipconnect.de [80.141.250.149])
	by smtp.strato.de (RZmta 32.31 DYNA|AUTH)
	with ESMTPSA id t05620q2QL5GIHQ
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	for <linux-btrfs@vger.kernel.org>;
	Wed, 26 Mar 2014 22:05:16 +0100 (CET)
Message-ID: <5333410F.3010000@hat-hill.de>
Date: Wed, 26 Mar 2014 22:05:19 +0100
From: Johannes Stemmler <jobus@hat-hill.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Inappropriate ioctl
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sorry for reporting this issue to you, but I have not found any helpful
information elsewhere.

I have installed a new opensuse-system 12.3 from scratch and selected an
ext4-fs for /
and btrfs for /home
The installation works and the access to the /home btrfs works also.

But the btrfs-progs doesn't.

show works
# btrfs filesystem show /dev/sda8
Label: lx_home  uuid: 5a6857e3-b421-4a68-92f4-0c7e5f9fcb4c
        Total devices 1 FS bytes used 74.40GiB
        devid    1 size 262.63GiB used 77.04GiB path /dev/sda8

df does not work
# btrfs filesystem df /dev/sda8
ERROR: couldn't get space info - Inappropriate ioctl for device
ERROR: get_df failed Inappropriate ioctl for device

#mount
/dev/sda6 on / type ext4 (rw,relatime,data=ordered)
/dev/sda8 on /home type btrfs (rw,relatime,ssd,space_cache)

A reinstallation of the btrfs-progs did not help.
Is the system bad packaged by opensuse or is my constellation forbidden?

Best regards,
Johannes Stemmler

p.s. the btrfs is on a ssd-partition
