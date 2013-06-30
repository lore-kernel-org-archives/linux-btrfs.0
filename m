Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51091 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261Ab3F3IAL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Jun 2013 04:00:11 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UtCYF-0005WY-Ur
	for linux-btrfs@vger.kernel.org; Sun, 30 Jun 2013 10:00:03 +0200
Received: from mnsr-4db102d5.pool.mediaways.net ([77.177.2.213])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 30 Jun 2013 10:00:03 +0200
Received: from stefanp by mnsr-4db102d5.pool.mediaways.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 30 Jun 2013 10:00:03 +0200
To: linux-btrfs@vger.kernel.org
From: Stefan Paletta <stefanp@cabal1.net>
Subject: why check f_path.mnt is equal for source and dest in btrfs_ioctl_clone()?
Date: Sun, 30 Jun 2013 09:55:26 +0200
Message-ID: <kqoobm$jq4$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This gives EXDEV for clone operations that btrfs could otherwise execute 
and with slight change of circumstances will actually execute fine.

Imagine we have a btrfs on /dev/mapper/foobar with subvols /foo and 
/bar. Let’s also imagine top of said fs in mounted at /mnt. In this 
case, a cross-subvol clone of /mnt/foo/srcfile to /mnt/bar/dstfile will 
succeed.

However, if only the individual subvols were mounted like this:
	/dev/mapper/foobar on /mnt (subvol=foo)
	/dev/mapper/foobar on /mnt2 (subvol=bar),
then a clone of /mnt/srcfile to /mnt2/dstfile will fail with EXDEV even 
though it is otherwise equal to the former clone operation.

Would anyone care to shed some light on this? Is it due to legacy 
policy? Am I missing something?

Thanks
–Stefan

