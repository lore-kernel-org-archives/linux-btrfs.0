Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44896 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752497AbaFFPww (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 6 Jun 2014 11:52:52 -0400
Message-ID: <5391E3D0.8050608@redhat.com>
Date: Fri, 06 Jun 2014 10:52:48 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Karel Zak <kzak@redhat.com>, Gui Hecheng <guihc.fnst@cn.fujitsu.com>
CC: util-linux@vger.kernel.org, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] mount: add btrfs to mount.8
References: <1401933919-23608-1-git-send-email-guihc.fnst@cn.fujitsu.com> <20140605080311.GW9000@x2.net.home> <1402036359.17740.33.camel@localhost.localdomain> <20140606094428.GA30975@x2.net.home> <20140606100302.GB30975@x2.net.home>
In-Reply-To: <20140606100302.GB30975@x2.net.home>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 6/6/14, 5:03 AM, Karel Zak wrote:
> On Fri, Jun 06, 2014 at 11:44:28AM +0200, Karel Zak wrote:
>>  I personally have no problem to maintain information about arbitrary
>>  FS in mount.8, the problem are updates. Unfortunately, kernel FS developers
>>  don't care about the man page at all and it's very often not up to date.
> 
>  Hmm.. another possible way would be to create a script for util-linux
>  that will analyze kernel Documentation/filesystems/<fsname>.txt and
>  report changes that is necessary to make to mount.8. It should be
>  relative simple with git. I'll try it..

I like that idea.  Maybe <fsname.txt> will need a defined format, though,
right?  Maybe asciidoc?

I've still been meaning (in theory) to produce a mount manpage just for xfs.
I'm still willing to do that if the above doesn't pan out.  I just need
to get to it.  I'd be happy to do it for extN as well.

-Eric

>     Karel
> 

