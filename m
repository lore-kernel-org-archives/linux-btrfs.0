Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:37065 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750802AbaFFKId (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Jun 2014 06:08:33 -0400
Message-ID: <1402049016.13997.11.camel@localhost.localdomain>
Subject: Re: [PATCH] mount: add btrfs to mount.8
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: Karel Zak <kzak@redhat.com>
CC: <util-linux@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>
Date: Fri, 6 Jun 2014 18:03:36 +0800
In-Reply-To: <20140606100302.GB30975@x2.net.home>
References: <1401933919-23608-1-git-send-email-guihc.fnst@cn.fujitsu.com>
	 <20140605080311.GW9000@x2.net.home>
	 <1402036359.17740.33.camel@localhost.localdomain>
	 <20140606094428.GA30975@x2.net.home> <20140606100302.GB30975@x2.net.home>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2014-06-06 at 12:03 +0200, Karel Zak wrote:
> On Fri, Jun 06, 2014 at 11:44:28AM +0200, Karel Zak wrote:
> >  I personally have no problem to maintain information about arbitrary
> >  FS in mount.8, the problem are updates. Unfortunately, kernel FS developers
> >  don't care about the man page at all and it's very often not up to date.
> 
>  Hmm.. another possible way would be to create a script for util-linux
>  that will analyze kernel Documentation/filesystems/<fsname>.txt and
>  report changes that is necessary to make to mount.8. It should be
>  relative simple with git. I'll try it..
Ah, if so, thanks very much!

-Gui

>     Karel
> 


