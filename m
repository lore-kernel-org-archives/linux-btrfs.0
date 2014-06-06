Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:11480 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750730AbaFFGhg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Jun 2014 02:37:36 -0400
Message-ID: <1402036359.17740.33.camel@localhost.localdomain>
Subject: Re: [PATCH] mount: add btrfs to mount.8
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: Karel Zak <kzak@redhat.com>
CC: <util-linux@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>
Date: Fri, 6 Jun 2014 14:32:39 +0800
In-Reply-To: <20140605080311.GW9000@x2.net.home>
References: <1401933919-23608-1-git-send-email-guihc.fnst@cn.fujitsu.com>
	 <20140605080311.GW9000@x2.net.home>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2014-06-05 at 10:03 +0200, Karel Zak wrote:
> On Thu, Jun 05, 2014 at 10:05:19AM +0800, Gui Hecheng wrote:
> > Based on Documentation/filesystems/btrfs.txt
> > 
> > Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
> > ---
> >  sys-utils/mount.8 | 186 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 186 insertions(+)
> 
>  Thanks, but I'm not sure this is the right way. It would be better to
>  create BTRFS specific btrfs.5 man page and maintain it together with
>  another BTRFS stuff rather then within util-linux. In the mount.8
>  should be only a note about btrfs.5.
> 
>  My long time goal is to remove all FS specific sections (at least for
>  mainstream filesystems) from mount.8, because we duplicate effort
>  here. The primary and well maintained is usually kernel
>  Documentation/filesystems/ and unfortunately FS developers don't care
>  about mount.8 at all.
> 
>  The ideal solution would be to generate the FS man pages from kernel
>  docs (for example from asciidoc etc.)
> 
>  See 6 years old discussions: http://marc.info/?t=122767310200002&r=1&w=2
> 
Hi Karel,

Thanks your comments. I do agree that this is *not* the best way. I
think that your long time goal is really exciting to the FS developers.

But for now, there are btrfs *users* complaining that they cannot find
any help by refering to the mount manpage when they want to mount their
btrfs. Actually, not every btrfs user have the mood to check the
Documentation/filesystems/btrfs.txt or anywhere else when they just want
to use a simple mount cmd. 

I think that adding the btrfs stuff into mount.8 do a certain help to
the common btrfs users. By the way, I've checked the recent commmits of
util-linux tree and found that there are still enthusiastic contributers
making really meaningful changes to the mount.8.

So, If it does not bother you much... 

Our btrfs users are really looking forward to a more kind and helpful
mount manpage for btrfs. And then they will feel really happy that they
could mount their btrfs in various ways easily as they like *just as the
ext4 users do*. And I think there are many btrfs developers who will be
glad to continue helping correct the btrfs part.

Thanks
-Gui

>     Karel
> 


