Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58203 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667AbaFFJoc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 6 Jun 2014 05:44:32 -0400
Date: Fri, 6 Jun 2014 11:44:28 +0200
From: Karel Zak <kzak@redhat.com>
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Cc: util-linux@vger.kernel.org, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] mount: add btrfs to mount.8
Message-ID: <20140606094428.GA30975@x2.net.home>
References: <1401933919-23608-1-git-send-email-guihc.fnst@cn.fujitsu.com>
 <20140605080311.GW9000@x2.net.home>
 <1402036359.17740.33.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1402036359.17740.33.camel@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 06, 2014 at 02:32:39PM +0800, Gui Hecheng wrote:
> But for now, there are btrfs *users* complaining that they cannot find
> any help by refering to the mount manpage when they want to mount their
> btrfs. Actually, not every btrfs user have the mood to check the
> Documentation/filesystems/btrfs.txt or anywhere else when they just want
> to use a simple mount cmd. 

 The kernel is the "ideal place", but it's more dream than anything
 else... what we use for example for NFS is to maintain FS specific
 man page in userspace FS package (e.g. nfs-utils).

 Wouldn't be possible to add the man page to btrfs-progs package? The
 package is maintained by btrfs guys and I guess all btrfs users have
 very probably installed the package.

> So, If it does not bother you much... 

 I personally have no problem to maintain information about arbitrary
 FS in mount.8, the problem are updates. Unfortunately, kernel FS developers
 don't care about the man page at all and it's very often not up to date.

 [My experience is very bad. Not sure why, but for many kernel devels
  commit into Linus' tree is end of their work, they don't care if there
  is usable userpsace util or docs for users, people like Eric Biederman
  or Lukas Czerner are rare exception.]
 
> And I think there are many btrfs developers who will be
> glad to continue helping correct the btrfs part.

 OK, we can try it, if you still prefer mount.8.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
