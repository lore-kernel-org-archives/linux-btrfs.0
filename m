Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54589 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752152AbaERXRZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 18 May 2014 19:17:25 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WmAKa-0002pZ-5q
	for linux-btrfs@vger.kernel.org; Mon, 19 May 2014 01:17:24 +0200
Received: from md5i.com ([75.151.244.229])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 19 May 2014 01:17:24 +0200
Received: from mwd by md5i.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 19 May 2014 01:17:24 +0200
To: linux-btrfs@vger.kernel.org
From: Michael Welsh Duggan <mwd@md5i.com>
Subject: btrfs send ioctl failed with -5: Input/output error
Date: Sun, 18 May 2014 19:17:06 -0400
Message-ID: <8761l2he31.fsf@maru2.md5i.com>
Mime-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I am now getting the following error when trying to do a btrfs send:

root@maru2:/usr/local/src/btrfs-progs# ./btrfs send /usr/local/snapshots/2014-05-15 > /backup/intermediate
At subvol /usr/local/snapshots/2014-05-15
ERROR: send ioctl failed with -5: Input/output error

I'm running a 3.14.4 kernel, and Btrfs progs v3.14.1.

root@maru2:/usr/local/src/btrfs-progs# uname -a
Linux maru2 3.14-1-amd64 #1 SMP Debian 3.14.4-1 (2014-05-13) x86_64 GNU/Linux

root@maru2:/usr/local/src/btrfs-progs# ./btrfs --version
Btrfs v3.14.1

Is there anything I can do to help debug this issue?

-- 
Michael Welsh Duggan
(md5i@md5i.com)

