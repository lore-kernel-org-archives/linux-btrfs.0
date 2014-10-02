Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60616 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364AbaJBK7L (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Oct 2014 06:59:11 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XZe6E-0007Vt-VG
	for linux-btrfs@vger.kernel.org; Thu, 02 Oct 2014 12:59:06 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Oct 2014 12:59:06 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Oct 2014 12:59:06 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs check segfaults after flipping 2 Bytes
Date: Thu, 2 Oct 2014 10:58:55 +0000 (UTC)
Message-ID: <pan$e396c$9b931048$23407b27$a2637e92@cox.net>
References: <542C6443.1010809@niklasfi.de>
	<pan$36400$3ee14aa9$ee1e5a94$415ce7b2@cox.net>
	<542CE7CC.4020904@swiftspirit.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Brendan Hide posted on Thu, 02 Oct 2014 07:51:08 +0200 as excerpted:

> A reasonable workaround to get the filesystem back into a usable or
> recoverable state might be to mount read-only and ignore checksums. That
> would keep the filesystem intact, though the system has no way to know
> whether or not the folder structures are also corrupt.
> 
> I'm not sure if there is a mount option for this use case however. The
> option descriptions for "nodatasum" and "nodatacow" imply that *new*
> checksums are not generated. In this case the checksums already exist.

>From a certain viewpoint that's sort of what btrfs restore does, except 
that it doesn't mount the filesystem; it simply lets you retrieve files 
already there without mounting, if the filesystem isn't mountable.

Also see btrfs check --init-csum-tree, which basically wipes out the 
csums, after which the filesystem should mount, but entirely without 
checksums.  Of course this option kills all the csums and there's 
presently nothing that actually recalculates and rebuilds the csum tree 
(tho there's a very recent patch that I believe adds that functionality), 
so once they're gone, there' gone.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

