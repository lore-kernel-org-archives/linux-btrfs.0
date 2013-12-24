Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45921 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750914Ab3LXGul (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Dec 2013 01:50:41 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VvLp9-0003qx-L4
	for linux-btrfs@vger.kernel.org; Tue, 24 Dec 2013 07:50:39 +0100
Received: from md5i.com ([75.151.244.229])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Dec 2013 07:50:39 +0100
Received: from mwd by md5i.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Dec 2013 07:50:39 +0100
To: linux-btrfs@vger.kernel.org
From: Michael Welsh Duggan <mwd@md5i.com>
Subject: Use dedup to recover from messed up incremental send?
Date: Tue, 24 Dec 2013 01:50:28 -0500
Message-ID: <87mwjq3fpn.fsf@maru2.md5i.com>
Mime-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've been backing up my fs to another disk on a semi-regular basis.  I
make a readonly snapshot of the fs, and always keep the last snapshot.
I then do an incremental send to the backup fs, using "btrfs send -p".
I then delete the older of the two snapshots on the backed-up fs.

A couple of times I accidentally deleted the parent snapshot before
sending.  (I know I should be using a script to do this.  Mea culpa.)
My question is this:

Is it possible to use dedup to have files from a fresh snapshot on the
backup fs share blocks from previously saved snapshots?  My guess is
that since these are readonly snapshots, I can't do this directly.
But I thought I'd check.

-- 
Michael Welsh Duggan
(md5i@md5i.com)

