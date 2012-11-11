Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:55743 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442Ab2KKQVb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 11 Nov 2012 11:21:31 -0500
Received: from mfilter17-d.gandi.net (mfilter17-d.gandi.net [217.70.178.145])
	by relay3-d.mail.gandi.net (Postfix) with ESMTP id E5533A807A
	for <linux-btrfs@vger.kernel.org>; Sun, 11 Nov 2012 17:21:30 +0100 (CET)
Received: from relay3-d.mail.gandi.net ([217.70.183.195])
	by mfilter17-d.gandi.net (mfilter17-d.gandi.net [10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id 5R5ZMbZ-919B for <linux-btrfs@vger.kernel.org>;
	Sun, 11 Nov 2012 17:21:29 +0100 (CET)
Received: from [192.168.1.66] (AMontpellier-156-1-30-101.w90-0.abo.wanadoo.fr [90.0.61.101])
	(Authenticated sender: swami@petaramesh.org)
	by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 21E96A8097
	for <linux-btrfs@vger.kernel.org>; Sun, 11 Nov 2012 17:21:29 +0100 (CET)
Message-ID: <509FD088.402@petaramesh.org>
Date: Sun, 11 Nov 2012 17:21:28 +0100
From: =?UTF-8?B?U3fDom1pIFBldGFyYW1lc2g=?= <swami@petaramesh.org>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS cache problem
References: <509ED1D6.8010903@petaramesh.org> <20121111152006.GA5604@carfax.org.uk>
In-Reply-To: <20121111152006.GA5604@carfax.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 11/11/2012 16:20, Hugo Mills a écrit :
> Try mounting with clear_cache *once*, then remounting with
> space_cache,inode_cache *once*, and waiting for it to finish
> rebuilding the cache. Finally, remove all mention of the caches from
> your fstab and kernel command line before you next mount the FS.
Unfortunately, same issue after applying your suggestions...

[  752.943532] btrfs: free space inode generation (0) did not match free
space cache generation (203710)


-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E
Ne cherchez pas : Je ne suis pas sur Facebook.

