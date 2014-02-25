Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44575 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752522AbaBYTj1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Feb 2014 14:39:27 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WINqd-0003i0-NI
	for linux-btrfs@vger.kernel.org; Tue, 25 Feb 2014 20:39:23 +0100
Received: from 131-028-005-185.ip-addr.ew-goldbach-hoesbach.de ([84.19.169.15])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Feb 2014 20:39:23 +0100
Received: from jannis_achstetter by 131-028-005-185.ip-addr.ew-goldbach-hoesbach.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Feb 2014 20:39:23 +0100
To: linux-btrfs@vger.kernel.org
From: Jannis Achstetter <jannis_achstetter@web.de>
Subject: Re: [RFC PATCH v8 00/14] Online(inband) data deduplication
Date: Tue, 25 Feb 2014 19:39:01 +0000 (UTC)
Message-ID: <loom.20140225T203650-877@post.gmane.org>
References: <1388391175-29539-1-git-send-email-bo.li.liu@oracle.com> <loom.20140225T201641-262@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Jannis Achstetter <jannis_achstetter <at> web.de> writes:

> 
> Hello Liu, hello list,
> 
> Liu Bo <bo.li.liu <at> oracle.com> writes:
> > Here is the New Year patch bomb 
> 

Some more info I forgot: I set the dedup block size to 128k but I forgot it
the first time:

> btrfs dedup enable /mnt/steamdir
> btrfs dedup on /mnt/steamdir
> btrfs dedup off /mnt/steamdir
> btrfs dedup on -b 128k /mnt/steamdir

The data written to the file system seems not to get corrupted. I copied a
>20GB file to the fs two times with different names and the sha1sum is
identical both time and matches the source file.

