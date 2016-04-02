Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39180 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353AbcDBJAL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 2 Apr 2016 05:00:11 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1amHPb-0002sG-TG
	for linux-btrfs@vger.kernel.org; Sat, 02 Apr 2016 11:00:07 +0200
Received: from ip5f5ae008.dynamic.kabel-deutschland.de ([95.90.224.8])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 02 Apr 2016 11:00:07 +0200
Received: from hurikhan77 by ip5f5ae008.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 02 Apr 2016 11:00:07 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: btrfsck: backpointer mismatch (and multiple other errors)
Date: Sat, 2 Apr 2016 11:00:01 +0200
Message-ID: <20160402110001.0ec354b5@jupiter.sol.kaishome.de>
References: <20160331224452.0753d5c7@jupiter.sol.kaishome.de>
	<CAPmG0jZ6hs4TA_0ozNEP4x6ucn971Nj-6+uempGi1VwTWAdCYQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Fri, 1 Apr 2016 01:27:21 +0200
schrieb Henk Slager <eye1tm@gmail.com>:

> It is not clear to me what 'Gentoo patch-set r1' is and does. So just
> boot a vanilla v4.5 kernel from kernel.org and see if you get csum
> errors in dmesg.

It is the gentoo patchset, I don't think anything there relates to
btrfs:
https://dev.gentoo.org/~mpagano/genpatches/trunk/4.5/

> Also, where does 'duplicate object' come from? dmesg ? then please
> post its surroundings, straight from dmesg.

It was in dmesg. I already posted it in the other thread and Qu took
note of it. Apparently, I didn't manage to capture anything else than:

btrfs_run_delayed_refs:2927: errno=-17 Object already exists

It hit me unexpected. This was the first time btrfs went RO for me. It
was with kernel 4.4.5 I think.

I suspect this is the outcome of unnoticed corruptions that sneaked in
earlier over some period of time. The system had no problems until this
incident, and only then I discovered the huge pile of corruptions when I
ran btrfsck.

I'm also pretty convinced now that VirtualBox itself is not the problem
but only victim of these corruptions, that's why it primarily shows up
in the VDI file.

However, I now found csum errors in unrelated files (see other post in
this thread), even for files not touched in a long time.

-- 
Regards,
Kai

Replies to list-only preferred.

