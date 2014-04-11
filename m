Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:50362 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756585AbaDKJWC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Apr 2014 05:22:02 -0400
Received: from mfilter29-d.gandi.net (mfilter29-d.gandi.net [217.70.178.160])
	by relay5-d.mail.gandi.net (Postfix) with ESMTP id 85EA041C064
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Apr 2014 11:22:00 +0200 (CEST)
Received: from relay5-d.mail.gandi.net ([217.70.183.197])
	by mfilter29-d.gandi.net (mfilter29-d.gandi.net [10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id QjUzYIXG7Aqe for <linux-btrfs@vger.kernel.org>;
	Fri, 11 Apr 2014 11:21:59 +0200 (CEST)
Received: from zafu.localnet (dhcp230.cr2i.univ-montp2.fr [162.38.105.230])
	(Authenticated sender: michel@bouissou.net)
	by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id 7EFE241C091
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Apr 2014 11:21:57 +0200 (CEST)
From: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
To: linux-btrfs@vger.kernel.org
Subject: mount options ignored / unclear
Date: Fri, 11 Apr 2014 11:21:55 +0200
Message-ID: <1988570.7Waz7R0erI@zafu>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

(Still in my quest for BTRFS performance)

It is extremely unclear which BTRFS mount options are "filesystem wide" and 
will apply to each and every mountpoint in the BTRFS filesystem, and which 
options can be set per subvolume or per mountpoint.

As far as I can tell, there is no reliable documentation about this, is there 
any ?

(Kernel is 3.13, Fedora)


i.e. I have in fstab :

/dev/sda3 / btrfs subvol=FEDORA,noatime,compress=lzo,autodefrag

...So without suprise I get in /proc/self/mountinfo:

36 1 0:32 /FEDORA / rw,noatime shared:1 - btrfs /dev/sda3 
rw,seclabel,compress=lzo,space_cache,autodefrag


...But then I have in fstab:

/dev/sda3 /home/me/.cache  btrfs   
subvol=/NOCOW/me/.cache,nodatacow,compress=no,noatime

So it is with great suprise the I get in /proc/self/mountinfo:

49 47 0:32 /NOCOW/me/.cache /home/me/.cache rw,noatime shared:33 - btrfs 
/dev/sda3 rw,seclabel,compress=lzo,space_cache,autodefrag


...I'm not suprised to see "space_cache" which I would assume to be FS-wide, 
but what the hell does "autodefrag" do in there, or even worse "compress=lzo", 
where "compress=no" has been exlicitely specified in fstab ?

That's a bug, as far as I can tell.

Kind regards.

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E

