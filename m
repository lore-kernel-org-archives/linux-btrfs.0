Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp06.smtpout.orange.fr ([80.12.242.128]:58302 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825Ab2JHGWc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Oct 2012 02:22:32 -0400
Message-ID: <50727125.4010501@petaramesh.org>
Date: Mon, 08 Oct 2012 08:22:29 +0200
From: =?UTF-8?B?U3fDom1pIFBldGFyYW1lc2g=?= <swami@petaramesh.org>
MIME-Version: 1.0
To: Martin Steigerwald <Martin@lichtvoll.de>
CC: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS, getting darn slower everyday
References: <50714AC8.4010100@petaramesh.org> <loom.20121007T141248-114@post.gmane.org> <50718151.8090506@petaramesh.org> (sfid-20121007_163445_311645_DBA4D8EF) <201210071644.19815.Martin@lichtvoll.de>
In-Reply-To: <201210071644.19815.Martin@lichtvoll.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 07/10/2012 16:44, Martin Steigerwald a écrit :
> I think you need to backup, reformat and restore from backup for now. 
No way. 4 machines on each of which 2 to 4 different OSes are sharing
the same BTRFS volume !

If I ever need to reformat/reinstall all this, the new format won't be
BTRFS ! I would be pissed off to a point where I would stick to either
ext4 or ZFS, all of which work nicely (I have a complex system that has
been running very fine on ZFS for 1.5 year)...

> How did you measure this? Is this just the boot times you mentioned in
> the original article? 

No highly scientific measurement. I don't live with benchmarks, but with
the impression that my machine is nicely swift or painfully slow.

When it comes to 4 minutes for boot, 40 seconds for opening a brower, 1+
minute for Thunderbird... 15 minutes for installing an innocent set of
updates... I'm under the impression that it's painfully slow.

Kind regards.

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E
Ne cherchez pas : Je ne suis pas sur Facebook.

