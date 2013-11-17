Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fnsib-smtp02.srv.cat ([46.16.60.194]:48526 "EHLO
	fnsib-smtp02.srv.cat" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520Ab3KQM2C (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 Nov 2013 07:28:02 -0500
Received: from [192.168.1.54] (104.Red-81-36-195.dynamicIP.rima-tde.net [81.36.195.104])
	by fnsib-smtp02.srv.cat (Postfix) with ESMTPSA id 801ABC983E
	for <linux-btrfs@vger.kernel.org>; Sun, 17 Nov 2013 13:21:35 +0100 (CET)
Message-ID: <5288B4CF.90703@zignux.com>
Date: Sun, 17 Nov 2013 13:21:35 +0100
From: Antonio Rodulfo <arodulfo@zignux.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Ubunutu scanning for a btrfs fs it will never find
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear fellows,

After upgrading one of my laptops from XUbuntu 12.04 to 12.10, I started to
see a "Scanning for Btrfs filesystems" message after the initial grub menu
and before the system issues its startup sequence of messages.

The first time I saw the message, my laptop completely stopped after
issuing some error message, claiming it wasn't able to start any system. I
restarted the system and opted for a former startup option, which worked
fine; restarted the system and opted for a WXP startup (I happen to need
this monster installed too), which worked fine; to my surprise, the next
restart with the newest kernel & version of XUbuntu worked fine as well.

The system hangs now there for several seconds (15, maybe?) and keeps going
with no further reference to btrfs.

I don't have any btrfs in my laptop nor plan to have it. Since it has
already showed fatal errors, I'd like to get rid of it.

I have read I could remove btrfs-tools module from my kernel and / or
blacklist it in /etc/modprobe.d

What do you recommend?

--
Kind regards,

Antonio Rodulfo
Industrial Engineer, Development Engineer and Project Consultant

