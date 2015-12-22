Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59229 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453AbbLVBc3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Dec 2015 20:32:29 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aBBoS-0003wX-1k
	for linux-btrfs@vger.kernel.org; Tue, 22 Dec 2015 02:32:28 +0100
Received: from ip5f5ae08a.dynamic.kabel-deutschland.de ([95.90.224.138])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Dec 2015 02:32:28 +0100
Received: from hurikhan77 by ip5f5ae08a.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Dec 2015 02:32:28 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: Ideas on unified real-ro mount option across all filesystems
Date: Tue, 22 Dec 2015 02:32:21 +0100
Message-ID: <20151222023221.56a89345@jupiter.sol.kaishome.de>
References: <567212DA.8050808@cn.fujitsu.com>
	<567228EF.80007@redhat.com>
	<5673616C.1040706@cn.fujitsu.com>
	<1450404066.6498.70.camel@scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Fri, 18 Dec 2015 03:01:06 +0100
schrieb Christoph Anton Mitterer <calestyo@scientia.net>:

> The manpage says:
> > ro     Mount the filesystem read-only.
> > rw     Mount the filesystem read-write.  

That means: the filesystem... Not the block device...

Sorry, it's kinda nitpicking. But actually, the file system IS
read-only: You cannot modify files from user's view.

What you actually want is not modifying the underlying storage which is
the block device and includes stuff like meta and journal data (which
is only indirectly visible to users at best).

You can argue that man pages are not particularly end-user friendly.
But for an admin this makes sense without being an fs developer.

-- 
Regards,
Kai

Replies to list-only preferred.


