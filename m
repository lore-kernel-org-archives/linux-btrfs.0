Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37871 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754318AbaDKLXr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Apr 2014 07:23:47 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WYZYd-0001dx-GC
	for linux-btrfs@vger.kernel.org; Fri, 11 Apr 2014 13:23:43 +0200
Received: from 78-32-127-104.static.enta.net ([78.32.127.104])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Apr 2014 13:23:43 +0200
Received: from alex by 78-32-127-104.static.enta.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Apr 2014 13:23:43 +0200
To: linux-btrfs@vger.kernel.org
From: Alex <alex@bpmit.com>
Subject: What does scrub do?
Date: Fri, 11 Apr 2014 11:23:31 +0000 (UTC)
Message-ID: <loom.20140411T105444-935@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

Debian testing/Jessie-to-be; except kernels/btrfs-tools are from unstable so
usually couple of weeks later than you/Linus publish.
Linux XX 3.13-1-amd64 #1 SMP Debian 3.13.7-1 (2014-03-25) x86_64
Btrfs-tools v3.12 Debian standard (not particularly messed with looks like) 

I've never had scrub report anything other than 0 (zero) errors. Ever.
Yet I've had more than one ( ;-) ) problem which required btrfs-zero-log
and/or btrfs --repair. This are usually my fault - fixed it 'til it broke.

root@XX ~ # btrfs scrub status /
scrub status for f8152a67-3c2e-4da1-812e-9a6ab2ad1102
scrub started at Fri Apr 11 09:55:36 2014 and finished after 44 seconds
total bytes scrubbed: 1.40GiB with 0 errors

[    7.502338] btrfs: device label china devid 1 transid 938773 /dev/vda1
[    7.514213] btrfs: device label china devid 1 transid 938773 /dev/vda1
[    7.530893] btrfs: disk space caching is enabled
[    7.530897] btrfs: has skinny extents
[    7.720288] btrfs: bdev /dev/vda1 errs: wr 0, rd 0, flush 0, corrupt 66,
gen 2
[   18.967319] btrfs: device label china devid 1 transid 938773 /dev/vda1
[   19.360767] btrfs: device label china devid 1 transid 938773 /dev/vda1

This scrub and dmesg were taken within minutes of each other. So what it the
utility of running scrub? Or have I got the the wrong idea of what scrub
should report. This VM guest doesn't get messed with often, and is kept 

Very small KVM virtual machine - easy to send you a btrfs dump. Almost
vanilla set-up too. Just say the word.

Have been running btrfs here for quite some while (years, since Linux3.1 I
think) on server. Very very stable (lzo compression sometimes not quite as
stable as zlib and I only run it on the desktop m/c).

People: for auto snapshots use Snapper (a la SUSE) which is now in Debian et
al. Only peculiarity is that clear-down of daily snapshots only happens in
the night so you don't need to put many/any hourly snapshots in.

Thank you. And well done/thank you to the contributors.

Al.

PS: please get the 3.14 tools release out - perhaps the fixes have 
already gone through the tree and I am just shouting at the wind.

