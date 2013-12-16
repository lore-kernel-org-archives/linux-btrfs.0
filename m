Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48767 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752245Ab3LPDpF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 15 Dec 2013 22:45:05 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VsP79-0002VP-JS
	for linux-btrfs@vger.kernel.org; Mon, 16 Dec 2013 04:45:03 +0100
Received: from md5i.com ([75.151.244.229])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Dec 2013 04:45:03 +0100
Received: from mwd by md5i.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Dec 2013 04:45:03 +0100
To: linux-btrfs@vger.kernel.org
From: Michael Welsh Duggan <mwd@md5i.com>
Subject: btrfs send in 3.12 : can't find snapshot?
Date: Sun, 15 Dec 2013 22:40:55 -0500
Message-ID: <87y53lqx88.fsf@maru2.md5i.com>
Mime-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I built the new btrfs-progs 3.12 recently.  I note that the version
information doesn't seem to match this:

    # ./btrfs --version
    Btrfs v0.20-rc1-358-g194aa4a

Regardless, I was trying to use btrfs send (which worked in the older
btrfs), and failed.  Here's an example:

    # ./btrfs send -vvv -p /snapshots/bo /snapshots/bp  > /dev/null
    At subvol /snapshots/bp
    ERROR: open @/snapshots/bp failed. No such file or directory

Any idea what might be going on here?

Here's the volume information:

    # ./btrfs sub show /
    /
            Name:                   @
            uuid:                   e5e505d6-1309-8447-b51e-73f08c9401d1
            Parent uuid:            156f93b9-1175-dc42-a1ee-65c00c5dcc2a
            Creation time:          2013-07-17 20:44:46
            Object ID:              259
            Generation (Gen):       296321
            Gen at creation:        20
            Parent:                 5
            Top Level:              5
            Flags:                  -
            Snapshot(s):
                                    snapshots/bo
                                    snapshots/bp

Kernel information:

    # uname -a
    Linux maru2 3.11-2-amd64 #1 SMP Debian 3.11.10-1 (2013-12-04) x86_64 GNU/Linux

-- 
Michael Welsh Duggan
(md5i@md5i.com)

