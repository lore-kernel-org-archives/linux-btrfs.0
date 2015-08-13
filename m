Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42577 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750872AbbHMI3h (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Aug 2015 04:29:37 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZPntG-0006d2-9i
	for linux-btrfs@vger.kernel.org; Thu, 13 Aug 2015 10:29:34 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Aug 2015 10:29:34 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Aug 2015 10:29:34 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Deleted files cause btrfs-send to fail
Date: Thu, 13 Aug 2015 08:29:19 +0000 (UTC)
Message-ID: <pan$1dd35$9501221a$dce0e6ab$9d04fcea@cox.net>
References: <20150813003419.09f13c1a@thetick>
	<20150813090541.77f5c821@thetick>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc Joliet posted on Thu, 13 Aug 2015 09:05:41 +0200 as excerpted:

> Here's the actual output now, obtained via btrfs-progs 4.0.1 from an
> initramfs emergency shell:
> 
> checking extents checking free space cache checking fs roots root 5
> inode 8338813 errors 2000, link count wrong
>         unresolved ref dir 26699 index 50500 namelen 4 name root
>         filetype 0 errors 3, no dir item, no dir index
> root 5 inode 8338814 errors 2000, link count wrong
>         unresolved ref dir 26699 index 50502 namelen 6 name marcec
>         filetype 0 errors 3, no dir item, no dir index
> root 5 inode 8338815 errors 2000, link count wrong
>         unresolved ref dir 26699 index 50504 namelen 6 name systab
>         filetype 0 errors 3, no dir item, no dir index
> root 5 inode 8710030 errors 2000, link count wrong
>         unresolved ref dir 26699 index 59588 namelen 6 name marcec
>         filetype 0 errors 3, no dir item, no dir index
> root 5 inode 8710031 errors 2000, link count wrong
>         unresolved ref dir 26699 index 59590 namelen 4 name root
>         filetype 0 errors 3, no dir item, no dir index
> Checking filesystem on /dev/sda1 UUID:
> 0267d8b3-a074-460a-832d-5d5fd36bae64 found 63467610172 bytes used err is
> 1 total csum bytes: 59475016 total tree bytes: 1903411200 total fs tree
> bytes: 1691504640 total extent tree bytes: 130322432 btree space waste
> bytes: 442495212 file data blocks allocated: 555097092096
>  referenced 72887840768
> btrfs-progs v4.0.1
> 
> Again: is this fixable?

FWIW, root 5 (which you asked about upthread) is the main filesystem 
root.  So all these appear to be on the main filesystem, not on snapshots/
subvolumes.

As for the problem itself, noting that I'm not a dev, just a user/admin 
following the list, I believe...

There was a recent bug (early 4.0 or 4.1, IDR which) that (as I recall 
understanding it) would fail to decrement link count and would thus leave 
unnamed inodes hanging around in directories with no way to delete them.  
That looks very much like what you're seeing.  The bug has indeed been 
fixed in current, and a current btrfs check should fix it, but I don't 
believe that v4.0.1 userspace from the initramfs is new enough to have 
that fix.  The 4.1.2 userspace on your main system (from the first post) 
is current and should fix it, I believe, however.

But if it's critical, you may wish to wait and have someone else confirm 
that before acting on it, just in case I have it wrong.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

