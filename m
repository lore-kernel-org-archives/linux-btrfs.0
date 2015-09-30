Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from walhalla.sjomar.eu ([141.105.125.198]:52295 "EHLO
	mail.sjomar.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753526AbbI3Qt1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Sep 2015 12:49:27 -0400
Received: from hoefnix.localnet (a83-163-227-207.adsl.xs4all.nl [83.163.227.207])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: sjoerd@sjomar.eu)
	by mail.sjomar.eu (Postfix) with ESMTPSA id 166805B653
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2015 18:49:22 +0200 (CEST)
From: Sjoerd <sjoerd@sjomar.eu>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: RAID5 doesn't mount on boot, but you can afterwards?
Date: Wed, 30 Sep 2015 18:49:21 +0200
Message-ID: <1627746.fEEz2JqgZk@hoefnix>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi All,

A RAID5 setup on raw devices doesn't want to automount on boot. After I skip 
mounting I can log in (Ubuntu server 14.04 on kernel 4.1.8) and just do a 
"sudo mount -a" to get all mounted fine. So the array doesn't seem to be 
broken. "btrfs fi show /data" doesn't show anything wrong either.

The only weird thing I see in the syslog is :

BTRFS info (device sdd): disk space caching is enabled
BTRFS: has skinny extents
BTRFS: failed to read the system array on sdd
BTRFS: open_ctree failed
 
If I reboot the machine the drive in the log changed and looks random (i've 
seen in 3 boots sda, sdc and sde passing by)

I am using btrfs-progs 4.2.1 if that matters in this case...

Anyone have a clue whyt it's not automounting? Or something I can do to 
troubleshoot?

Thanks in advance.

Cheers,
Sjoerd

