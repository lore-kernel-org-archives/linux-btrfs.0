Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:36235 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab2KKP26 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 11 Nov 2012 10:28:58 -0500
Message-ID: <509FC436.6080205@petaramesh.org>
Date: Sun, 11 Nov 2012 16:28:54 +0100
From: =?UTF-8?B?U3fDom1pIFBldGFyYW1lc2g=?= <swami@petaramesh.org>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: BTRFS cache problem
References: <509ED1D6.8010903@petaramesh.org> <20121111152006.GA5604@carfax.org.uk>
In-Reply-To: <20121111152006.GA5604@carfax.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 11/11/2012 16:20, Hugo Mills a écrit :
> You only need to mount with space_cache once, and after that it's
> "sticky". What's probably happening is that you're mounting with
> space_cache, which rebuilds the cache. Then, if you reboot before it's
> finished rebuilding the cache, the cache isn't complete, and (I think)
> it causes the above message -- which is harmless. The same applies to
> the inode cache options. Try mounting with clear_cache *once*, then
> remounting with space_cache,inode_cache *once*, and waiting for it to
> finish rebuilding the cache. Finally, remove all mention of the caches
> from your fstab and kernel command line before you next mount the FS.
> Hugo. 

Thanks very much Hugo, I'll give this a try. Should I assume that the
cache clearing / building is complete as soon as the disk is idle ?

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E
Ne cherchez pas : Je ne suis pas sur Facebook.

