Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bay0-omc1-s8.bay0.hotmail.com ([65.54.190.19]:30564 "EHLO
	bay0-omc1-s8.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753240Ab2KFEMo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 5 Nov 2012 23:12:44 -0500
Message-ID: <BAY158-W653F2100594317287CCAECC06B0@phx.gbl>
From: "william L'Heureux" <wil_c_will@hotmail.com>
To: <linux-btrfs@vger.kernel.org>
Subject: slow after btrfs balance
Date: Mon, 5 Nov 2012 23:06:35 -0500
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hello,
 
Here is a little background of my setup. mdadm->lvm->dmcrypt->btrfs.
 
I had the btrfs in ext4 but I converted it.
When I first did the convert, everything was fine. After a moment, I did a btrfs balance and since that day,
the writing speed is very slow. When I do things like unzip/unrar, the load average flies to 15+.
That makes the system to be almost unusable. During the whole process I went from 3.2 wheezy to 3.5.
I went to back to 3.2 to check the stability, the results are the same.
I was asking myself if simply changing the chunk would solve my problem?
 
Thanks
 
William 		 	   		  