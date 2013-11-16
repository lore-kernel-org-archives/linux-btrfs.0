Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:42408 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248Ab3KPRJO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Nov 2013 12:09:14 -0500
Received: by mail-wg0-f49.google.com with SMTP id x13so4605908wgg.4
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Nov 2013 09:09:13 -0800 (PST)
Received: from venice.bhome (ppp-80-52.24-151.libero.it. [151.24.52.80])
        by mx.google.com with ESMTPSA id e1sm6584799wij.6.2013.11.16.09.09.12
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 16 Nov 2013 09:09:12 -0800 (PST)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] BTRFS-PROG: recursively subvolume snapshot and delete
Date: Sat, 16 Nov 2013 18:09:00 +0100
Message-Id: <1384621747-25441-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi All,

the following patches implement the recursively snapshotting and
deleting of a subvolume. 

To snapshot recursively you must pass the -R switch:

# btrfs subvolume create sub1
Create subvolume './sub1'
# btrfs subvolume create sub1/sub2
Create subvolume 'sub1/sub2'

# btrfs subvolume snapshot -R sub1 sub1-snap
Create a snapshot of 'sub1' in './sub1-snap'
Create a snapshot of 'sub1/sub2' in './sub1-snap/sub2'

To recursively delete subvolumes, you must pass the switch '-R':

# btrfs subvolume create sub1
Create subvolume './sub1'
# btrfs subvolume create sub1/sub2
Create subvolume 'sub1/sub2'

# btrfs subvolume delete -R sub1
Delete subvolume '/root/sub1/sub2'
Delete subvolume '/root/sub1'


Some caveats:
1) the recursively behaviour need the root capability
This because how the subvolume are discovered

2) it is not possible to recursively snapshot a subvolume
in read-only mode
This because when a subvolume is snapshotted, its 
nested subvolumes appear as directory in the snapshot.
These directories are removed before snapshotting the 
nested subvolumes. This is incompatible with a read
only subvolume.

BR
G.Baroncelli

