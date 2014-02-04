Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.py-ro.de ([89.238.75.159]:51123 "EHLO mail.py-ro.de"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752083AbaBDJbJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 4 Feb 2014 04:31:09 -0500
Received: from localhost (virt.py-ro.de [127.0.0.1])
	by mail.py-ro.de (Postfix) with ESMTP id 4CA1E49617
	for <linux-btrfs@vger.kernel.org>; Tue,  4 Feb 2014 10:31:08 +0100 (CET)
Received: from mail.py-ro.de ([127.0.0.1])
	by localhost (virt.py-ro.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3oOK50yVX7VZ for <linux-btrfs@vger.kernel.org>;
	Tue,  4 Feb 2014 10:31:04 +0100 (CET)
Received: from trediske.ws.office.manitu.net (unknown [IPv6:2a00:1828:0:1::9])
	by mail.py-ro.de (Postfix) with ESMTPA
	for <linux-btrfs@vger.kernel.org>; Tue,  4 Feb 2014 10:31:04 +0100 (CET)
Date: Tue, 4 Feb 2014 10:31:05 +0100
From: Tetja Rediske <tetja@tetja.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs raid5 unmountable
Message-ID: <20140204103105.16d09394@trediske.ws.office.manitu.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Duncan,

> Of course if you'd been following the list as btrfs testers really
> should still be doing at this point, you'd have seen all this covered
> before. And of course, if you had done pre-deployment testing before
> you stuck valuable data on that btrfs raid5, you'd have noted the
> problems, even without reading about it on-list or on the wiki.  But
> of course hindsight is 20/20, as they say, and at least you DO have
> backups, even if they'll take awhile to restore.  =:^) That's already
> vastly better than a lot of the reports we unfortunately get here.
> =:^\

yeah, i saw it. Main reason for me "toying" with btrfs is my work. We
rent Linux servers to customers. While they install and manage them by
them self, there will be questions about btrfs to our support, sooner or
later. So getting your hands on it early saves some headache later.

It is just inconvient for me now, so no big deal.

I first tried degraded, I also tried repair, no luck.

What I do now is, getting as much data from the broken fs with btrfs
recover and do a rsync after. It is just faster then downloading all
the data from my own mirror in the datacenter. ;)

After that I will even be so crazy and try it again. Next on my list is
send/receive. 

Tetja



