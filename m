Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50391 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761743Ab3EBSdk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 May 2013 14:33:40 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UXyK2-00030c-T1
	for linux-btrfs@vger.kernel.org; Thu, 02 May 2013 20:33:39 +0200
Received: from 84-72-179-110.dclient.hispeed.ch ([84.72.179.110])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 02 May 2013 20:33:38 +0200
Received: from alexanders.mailinglists+nospam by 84-72-179-110.dclient.hispeed.ch with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 02 May 2013 20:33:38 +0200
To: linux-btrfs@vger.kernel.org
From: Alexander Skwar <alexanders.mailinglists+nospam@gmail.com>
Subject: Listing EVERYTHING BUT read only snapshots; and what are snapshots if compared with ZFS?
Date: Thu, 2 May 2013 18:33:21 +0000 (UTC)
Message-ID: <loom.20130502T194637-612@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello once more...

I'm on Ubuntu 13.04 with Ubuntu kernel 3.8.0-19-lowlatency and
Btrfs v0.20-rc1.

First a clarification question - if I compare btrfs with zfs (which I know
better...), how do snapshots compare? A read only snapshot is what ZFS calls
snapshots, and a read/write snapshot would be a clone. Is that about right?

Now to the real question - how can I *easily* list everything but the read
only snapshots? Is there command which does that? With "btrfs subv list -r
/home", I can list all read only snapshots under /home. It lists just the
read only snapshots.

But with "btrfs subv list /home", I see all subvolumes; not only the
read/write snaphots. Here's what I get:


root@ask-home:~# btrfs subv list /home
ID 257 gen 28776 top level 256 path a
root@ask-home:~# btrfs subv list -r /home

root@ask-home:~# btrfs subv snaps -r /home /home/foo
Create a readonly snapshot of '/home' in '/home/foo'

root@ask-home:~# btrfs subv list /home
ID 257 gen 28778 top level 256 path a
ID 347 gen 28778 top level 256 path foo
root@ask-home:~# btrfs subv list -r /home
ID 347 gen 28778 top level 256 path foo


Now I'd like to have a command which only shows me the "real" subvolumes.
How would I do that?

For a script, I came up with this:

( btrfs subv list -r "$mp" ; btrfs subv list "$mp" ) | sort | uniq -u

Eg:

( btrfs subv list -r /home ; btrfs subv list /home ) | sort | uniq -u
ID 257 gen 28788 top level 256 path a

Works, but is "somewhat" complicated (logic behind that - list only read
only subvolumes + list all subvolumes and then show only those, which appear
just once)...

Is there an easier, more straight forward way?

Thanks,
Alexander

