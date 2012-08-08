Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33216 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751041Ab2HHGiF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 8 Aug 2012 02:38:05 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Syzu7-0003aM-46
	for linux-btrfs@vger.kernel.org; Wed, 08 Aug 2012 08:38:03 +0200
Received: from 176.50.251.106 ([176.50.251.106])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 08 Aug 2012 08:38:03 +0200
Received: from ksee.zelgadis by 176.50.251.106 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 08 Aug 2012 08:38:03 +0200
To: linux-btrfs@vger.kernel.org
From: Konstantin Dmitriev <ksee.zelgadis@gmail.com>
Subject: Re: severe hardlink bug
Date: Wed, 8 Aug 2012 06:37:50 +0000 (UTC)
Message-ID: <loom.20120808T083450-852@post.gmane.org>
References: <20100124015138.092c4959@simplux> <201001240909.44753.kreijack@libero.it> <20100124140837.5efcd526@simplux> <201001241415.47519.kreijack@inwind.it> <20100124142711.4afe8a81@simplux> <loom.20120729T205902-38@post.gmane.org> <501649E3.6010600@jan-o-sch.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Jan Schmidt <list.btrfs <at> jan-o-sch.net> writes:
> Please give the patch set "btrfs: extended inode refs" by Mark Fasheh a try
> (http://lwn.net/Articles/498226/). It eliminates the hard links per directory
> limit (introducing a rather random, artificial limit of 64k instead).

Hi, Jan!
I'm happy to see that there is something done on fixing that issue.
Unfortunately I cannot afford to have unstable patched kernel on the production
server. Probably I'll give another try to btrfs in 2013. ^__^
K.




