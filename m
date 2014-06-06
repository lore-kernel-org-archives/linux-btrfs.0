Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:18934 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750802AbaFFKHH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Jun 2014 06:07:07 -0400
Message-ID: <1402048931.13997.10.camel@localhost.localdomain>
Subject: Re: [PATCH] mount: add btrfs to mount.8
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: Karel Zak <kzak@redhat.com>
CC: <util-linux@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>
Date: Fri, 6 Jun 2014 18:02:11 +0800
In-Reply-To: <20140606094428.GA30975@x2.net.home>
References: <1401933919-23608-1-git-send-email-guihc.fnst@cn.fujitsu.com>
	 <20140605080311.GW9000@x2.net.home>
	 <1402036359.17740.33.camel@localhost.localdomain>
	 <20140606094428.GA30975@x2.net.home>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2014-06-06 at 11:44 +0200, Karel Zak wrote:
> On Fri, Jun 06, 2014 at 02:32:39PM +0800, Gui Hecheng wrote:
> > But for now, there are btrfs *users* complaining that they cannot find
> > any help by refering to the mount manpage when they want to mount their
> > btrfs. Actually, not every btrfs user have the mood to check the
> > Documentation/filesystems/btrfs.txt or anywhere else when they just want
> > to use a simple mount cmd. 
> 
>  The kernel is the "ideal place", but it's more dream than anything
>  else... what we use for example for NFS is to maintain FS specific
>  man page in userspace FS package (e.g. nfs-utils).
Ah, thanks for explaining so much to me, I can't agree more.

>  Wouldn't be possible to add the man page to btrfs-progs package? The
>  package is maintained by btrfs guys and I guess all btrfs users have
>  very probably installed the package.
Actually, we just would like to see btrfs "staying with" ext4, xfs and
other fs together. We feel a bit sad that ext4 and xfs both have stuff
in mount.8 but btrfs doesn't.

> > So, If it does not bother you much... 
> 
>  I personally have no problem to maintain information about arbitrary
>  FS in mount.8, the problem are updates. Unfortunately, kernel FS developers
>  don't care about the man page at all and it's very often not up to date.
> 
>  [My experience is very bad. Not sure why, but for many kernel devels
>   commit into Linus' tree is end of their work, they don't care if there
>   is usable userpsace util or docs for users, people like Eric Biederman
>   or Lukas Czerner are rare exception.]
Thanks for sharing the story with me, I really get a lot.

> > And I think there are many btrfs developers who will be
> > glad to continue helping correct the btrfs part.
> 
>  OK, we can try it, if you still prefer mount.8.
Our guys will try our best to keep the mount.8 for btrfs up-to-date.
At least, you have my promise.

Thanks,
-Gui

>     Karel
> 


