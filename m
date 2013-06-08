Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from koch.ro ([88.198.2.104]:38832 "EHLO koch.ro"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752481Ab3FHTs0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 8 Jun 2013 15:48:26 -0400
Received: from 44-25.106-92.cust.bluewin.ch ([92.106.25.44] helo=x121e.localnet)
	by koch.ro with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <thomas@koch.ro>)
	id 1UlOay-0005sU-PE
	for linux-btrfs@vger.kernel.org; Sat, 08 Jun 2013 21:14:36 +0200
From: Thomas Koch <thomas@koch.ro>
To: linux-btrfs@vger.kernel.org
Reply-To: thomas@koch.ro
Subject: Stale NFS file handle after power loss
Date: Sat, 08 Jun 2013 21:14:35 +0200
Message-ID: <65278856.dWSg6uQ8zb@x121e>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I had a power loss on my btrfs file system during package installation and now 
I found this:

<code>
% ls -l /var/lib/dpkg/tmp.ci
ls: cannot access /var/lib/dpkg/tmp.ci/conffiles: Stale NFS file handle
ls: cannot access /var/lib/dpkg/tmp.ci/md5sums: Stale NFS file handle
total 0
-????????? ? ? ? ?            ? conffiles
-????????? ? ? ? ?            ? md5sums
% sudo rm -rf /var/lib/dpkg/tmp.ci/conffiles
rm: cannot remove ‘/var/lib/dpkg/tmp.ci/conffiles’: Stale NFS file handle
</code>

I booted with a live system and ran btrfsck (without --repair!) but this did 
not change the situation. Unfortunately I wasn't clever enough to save the 
output of btrfsck somehow. Do you need it?

Could you help me to get rid of these bogus files, please?

Regards,

Thomas Koch, http://www.koch.ro
