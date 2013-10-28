Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56677 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753445Ab3J1WeG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Oct 2013 18:34:06 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VavNr-0005OW-DQ
	for linux-btrfs@vger.kernel.org; Mon, 28 Oct 2013 23:34:03 +0100
Received: from dyndsl-178-142-090-012.ewe-ip-backbone.de ([178.142.90.12])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Oct 2013 23:34:03 +0100
Received: from hurikhan77+btrfs by dyndsl-178-142-090-012.ewe-ip-backbone.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Oct 2013 23:34:03 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: memory leak in <=3.11.6
Date: Mon, 28 Oct 2013 23:34:12 +0100
Message-ID: <9c53ka-otf.ln1@hurikhan77.spdns.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello!

Is this output in slabtop normal after a few days uptime with a daily rsync 
(btrfs to btrfs) and some compiling (gentoo emerge):

 Active / Total Objects (% used)    : 1120836 / 1810907 (61,9%)
 Active / Total Slabs (% used)      : 42492 / 42492 (100,0%)
 Active / Total Caches (% used)     : 72 / 101 (71,3%)
 Active / Total Size (% used)       : 253898,56K / 324674,92K (78,2%)
 Minimum / Average / Maximum Object : 0,01K / 0,18K / 15,69K

  OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME                   
109220  99107  90%    0,98K   6830       16    109280K btrfs_inode

If I close all my desktop programs, my system stays at +12 GB RAM usage 
while after a fresh boot it has 12+ GB free (of 16 GB). Cache stays low at 2 
GB while after a few minutes uptime cache is about 5 GB.

This looks like memory leaking somewhere. Top does not show where all this 
memory went (biggest process is 500 MB RES, next is 200 MB and lower).

Thanks,
Kai

