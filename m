Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56427 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761194AbcALENv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jan 2016 23:13:51 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aIqL7-0002cx-HU
	for linux-btrfs@vger.kernel.org; Tue, 12 Jan 2016 05:13:49 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Jan 2016 05:13:49 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Jan 2016 05:13:49 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: About per-file dedup flag
Date: Tue, 12 Jan 2016 04:13:43 +0000 (UTC)
Message-ID: <pan$e524$5a11cd54$91431292$c1fe13df@cox.net>
References: <56946E63.1040502@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Qu Wenruo posted on Tue, 12 Jan 2016 11:09:23 +0800 as excerpted:

> Now we hope to add support to enable/disable dedup per-file.
> Much like current NODATACOW/NOCOMPRESS for inode.

How is this going to work?

NODATACOW/NOCOMPRESS can apply to a single file.  But a dup flag, by 
definition, needs two files, except for the special case of parts of a 
file duplicating other parts of the same file.  Is there going to be some 
background thread that checks for dups and reflinks duplicated extents if 
both files have the dup flag set?  What if one has it on and one has it 
off?

Presumably, if a file has it on and it is copied (so a new file), the 
copy would be reflinked.  But if the flag is off, does that make the file 
actually data-copy, by default, even if cp decides to do a reflink copy 
by default?  And does the copy automatically have the dup flag set as 
well, or does the original instance set dup, while the new copy, reflinked 
to the old one due to that dup flag, still have the dup flag unset, until 
the user sets it?

OTOH, I can see such an attribute for dirs making more sense, since it 
could be inherited much like the NOCOW attribute, and new files created 
there could automatically be checked against the current files to see if 
parts are dup, and reflink them if so.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

