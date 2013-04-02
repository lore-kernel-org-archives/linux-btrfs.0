Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:52569 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761123Ab3DBRPD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Apr 2013 13:15:03 -0400
Message-ID: <515B120F.6000004@petaramesh.org>
Date: Tue, 02 Apr 2013 19:14:55 +0200
From: =?UTF-8?B?U3fDom1pIFBldGFyYW1lc2g=?= <swami@petaramesh.org>
MIME-Version: 1.0
To: Roman Mamedov <rm@romanrm.ru>,
        "BTRFS, Linux" <linux-btrfs@vger.kernel.org>,
        zfs-discuss@zfsonlinux.org
Subject: Re: Moving...
References: <515A95C7.5090607@petaramesh.org> <20130402230421.016afe58@natsu>
In-Reply-To: <20130402230421.016afe58@natsu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 02/04/2013 19:04, Roman Mamedov a écrit :
> but at this point I trust my data to BTRFS more, than I would trust ZFS.

My experience with ZFS on Linux is still somewhat limited, the only
thing that I can say is that I've used it for about 2 years and a half
on my (quite loaded) home server without ever encoutering a single issue
(besides some tricky Ubuntu version upgrades, only due to the fact that
ZFS is "not in the standard kernel" by opposition to BTRFS).

On the BTRFS side, I've used it on 5 machine for about a year on a daily
basis ; I've completely lost a filesystem, beyond repair, twice ; I
found myself with a machine that wouldn't boot anymore and would
necessitate serious and tricky FS maintenance, 3 times, I had to
completely reinstall the FS because of extremely degraded performance, 4
times.

Add to this that the FS management tools and properly working FS
features are an order of magnitude better in ZFS than in BTRFS...

That's enough for me...

I've already converted 2 machines from BTRFS to ZFS since yesterday.

My netbook (now ZFS) boots to GDM in less than 30 seconds. My son's same
machine (except for the FS) takes 75 MORE seconds.

You get it.

Kind regards.

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E
Ne cherchez pas : Je ne suis pas sur Facebook.

