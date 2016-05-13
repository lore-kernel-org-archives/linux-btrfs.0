Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52295 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752001AbcEMH6i (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 May 2016 03:58:38 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1b17zT-0001Dd-7c
	for linux-btrfs@vger.kernel.org; Fri, 13 May 2016 09:58:31 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 13 May 2016 09:58:31 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 13 May 2016 09:58:31 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Undelete deleted subvolume?
Date: Fri, 13 May 2016 07:58:23 +0000 (UTC)
Message-ID: <pan$26950$4baf2649$1281af15$8e5cfec@cox.net>
References: <CAA91j0XRtuyJd12CgDTBXEaOKdN0Ff1Bt2_wT=nGUJy9r=usyg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Andrei Borzenkov posted on Thu, 12 May 2016 17:19:11 +0300 as excerpted:

> I accidentally deleted wrong snapshot using SUSE snapper. Is it possible
> to undelete subvolume? I know that it is possible to extract files from
> old tree (although SLES12 does not seem to offer btrfs-find-root), but
> is it possible to "reconnect" subvolume back?

I don't know of a way to do it directly, altho the devs may be able to 
suggest something exotic, but...

You should at least be able to /emulate/ it, by using btrfs restore (with 
the filesystem unmounted) to write the files elsewhere (the part you 
suggested), then mounting the filesystem, creating a new subvolume, and 
copying the restored files back into it.

That does lose the reflinks of a snapshot if that's what you deleted, so 
will take more space, but if you then run one of the btrfs dedupers on 
it, you should be able to re-reflink it, sharing extents via reflink and 
reducing the exclusive space used, once again.  (Tho I have no personal 
experience with the dedupers so can't give you specific help in that 
regard.)

But if you were using it as the reference parent for send/receive, or 
something, I think it's gone from that regard, as the emulation above 
would of course have a different subvolume ID.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

