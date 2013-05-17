Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from brockman.in8.de ([85.214.220.56]:39537 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751537Ab3EQPnD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 May 2013 11:43:03 -0400
Message-ID: <51965005.6050703@jan-o-sch.net>
Date: Fri, 17 May 2013 17:43:01 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Kai Krakow <hurikhan77+btrfs@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: hard freezes with 3.9.0 during io-intensive loads
References: <6moh5a-knf.ln1@hurikhan.ath.cx> <2sci5a-n8p.ln1@hurikhan.ath.cx> <5187700F.20807@jan-o-sch.net> <3egl5a-al5.ln1@hurikhan.ath.cx> <51889A4D.8000201@jan-o-sch.net> <ch7o5a-g0b.ln1@hurikhan.ath.cx> <7jio5a-b5g.ln1@hurikhan.ath.cx> <518A318A.7060105@jan-o-sch.net> <15ot5a-f1m.ln1@hurikhan.ath.cx> <518C9B55.3050008@jan-o-sch.net> <btde6a-5an.ln1@hurikhan.ath.cx>
In-Reply-To: <btde6a-5an.ln1@hurikhan.ath.cx>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 16, 2013 at 09:19 (+0200), Kai Krakow wrote:
> 3.9.2 still does not fix anything. I'll go with autodefrag=off for the 
> moment until I hear some news in that regard. With this new information, is 
> it still helpful to get a metadata image from me? It should be reproducable 
> if you enable autodefrag or defragment cow'ed files.

Would still be helpful, yes. If you've got questions on the usage of
btrfs-image, your best bet is probably #btrfs on freenode, I haven't created any
usable images with that tool so far, but I've heard of people that succeeded.

Thanks!
-Jan
