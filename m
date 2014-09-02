Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50115 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752518AbaIBMFw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 2 Sep 2014 08:05:52 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XOmqJ-0002mQ-6D
	for linux-btrfs@vger.kernel.org; Tue, 02 Sep 2014 14:05:47 +0200
Received: from pd953e79b.dip0.t-ipconnect.de ([217.83.231.155])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Sep 2014 14:05:47 +0200
Received: from holger.hoffstaette by pd953e79b.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Sep 2014 14:05:47 +0200
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Btrfs-progs-3.16: fs metadata is both single and dup?
Date: Tue, 2 Sep 2014 12:05:33 +0000 (UTC)
Message-ID: <pan.2014.09.02.12.05.33@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


I updated to progs-3.16 and noticed during testing:

root>losetup 
NAME       SIZELIMIT OFFSET AUTOCLEAR RO BACK-FILE
/dev/loop0         0      0         0  0 /tmp/img

root>mkfs.btrfs -f /dev/loop0
Btrfs v3.16
See http://btrfs.wiki.kernel.org for more information.

Performing full device TRIM (8.00GiB) ...
Turning ON incompat feature 'extref': increased hardlink limit per file 
to 65536
fs created label (null) on /dev/loop0
	nodesize 16384 leafsize 16384 sectorsize 4096 size 8.00GiB
root>mkdir /tmp/btrfs
root>mount /dev/loop0 /tmp/btrfs 

All fine until here..

root>btrfs filesystem df /tmp/btrfs 
Data, single: total=8.00MiB, used=64.00KiB
System, DUP: total=8.00MiB, used=16.00KiB
System, single: total=4.00MiB, used=0.00
Metadata, DUP: total=409.56MiB, used=112.00KiB
Metadata, single: total=8.00MiB, used=0.00

..wait, what? Let's be clear..

root>btrfs balance start -mconvert=dup /tmp/btrfs 
Done, had to relocate 4 out of 5 chunks

root>btrfs filesystem df /tmp/btrfs            
Data, single: total=8.00MiB, used=64.00KiB
System, DUP: total=32.00MiB, used=16.00KiB
Metadata, DUP: total=128.00MiB, used=112.00KiB

Now looking as expected.

root>btrfs balance start -mconvert=single -f /tmp/btrfs 
Done, had to relocate 2 out of 3 chunks

root>btrfs filesystem df /tmp/btrfs            
Data, single: total=8.00MiB, used=128.00KiB
System, single: total=32.00MiB, used=16.00KiB
Metadata, single: total=256.00MiB, used=112.00KiB

Looking good too (metadata doubled)

So where does the confusing initial display come from? I'm running this 
against a (very patched) 3.14.17, but don't remember ever seeing this 
with btrfs-progs-3.14.2.

Any ideas?

thanks
Holger

