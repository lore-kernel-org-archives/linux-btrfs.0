Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:60979 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756602AbaDKJm1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Apr 2014 05:42:27 -0400
Received: from mfilter26-d.gandi.net (mfilter26-d.gandi.net [217.70.178.154])
	by relay4-d.mail.gandi.net (Postfix) with ESMTP id 3549117208C
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Apr 2014 11:42:26 +0200 (CEST)
Received: from relay4-d.mail.gandi.net ([217.70.183.196])
	by mfilter26-d.gandi.net (mfilter26-d.gandi.net [10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id aFF6jbe+6dG2 for <linux-btrfs@vger.kernel.org>;
	Fri, 11 Apr 2014 11:42:24 +0200 (CEST)
Received: from zafu.localnet (dhcp230.cr2i.univ-montp2.fr [162.38.105.230])
	(Authenticated sender: michel@bouissou.net)
	by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 74C12172097
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Apr 2014 11:42:24 +0200 (CEST)
From: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
To: linux-btrfs@vger.kernel.org
Subject: How to make BTRFS crawl
Date: Fri, 11 Apr 2014 11:42:23 +0200
Message-ID: <4171851.75rN5oGIof@zafu>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I was asked about situations "use cases" that would cause BTRFS to slow down 
to a crawl.

And it's exactly what happened to me yesterday when I was trying, on the 
contrary, to speed it up.

So here's the recipe for getting a "slow to the point it is unusable" BTRFS.


1/ Perform a clean, fresh install of a recent distro with a 3.13 kernel (i.e. 
Fedora 20) and a BTRFS root filesystem.

2/ Choose the version with a KDE interface

3/ Configure fstab mountpoints using such options (space_cache will have been 
manually activated once):

/ btrfs   subvol=FEDORA,noatime,compress=lzo,autodefrag

/home btrfs   subvol=HOME,noatime,compress=lzo,autodefrag


4/ Use "chattr +C" to make the following directories NOCOW (move the old 
directory elsewhere, create a new dir, make it nocow, copy files from the old 
one so they are recreated with nocow, check permissions...):

- /home/yourself/.cache
- /home/yourself/.local/share/akonadi

5/ Use IMAP mail in Kmail. Seriously process your email (it will be stored 
using akonadi mysql)

6/ Surf normally the web using Firefox

7/ Install SuSE "snapper" package that will perform a FS snapshot every hour. 
Configure it so it will snapshot both the root FS subvol and the /home subvol

8/ Use the system for 24 hours and you will know that "hardly usable" means... 
Especially every hour-on-the-hour when Kmail or Firefox will try to access 
files that have been recently snapshotted... Your system will be dead with 
saturated HD access for several *minutes*

...Hope this may help hunting this down...

Kind regards.

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E


