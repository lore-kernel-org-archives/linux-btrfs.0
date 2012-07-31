Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:61823 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753826Ab2GaCAg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Jul 2012 22:00:36 -0400
Message-ID: <50173C37.9090607@cn.fujitsu.com>
Date: Tue, 31 Jul 2012 10:00:23 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
MIME-Version: 1.0
To: Kyle Gates <kylegates@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: balance disables nodatacow
References: <CA+M2DjmS0xB8zinvELi5SBg1QRxabvHfpd1MqJxqCB65qq1ceA@mail.gmail.com>
In-Reply-To: <CA+M2DjmS0xB8zinvELi5SBg1QRxabvHfpd1MqJxqCB65qq1ceA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/31/2012 03:55 AM, Kyle Gates wrote:

> I have a 3 disk raid1 filesystem mounted with nodatacow. I have a
> folder in said filesystem with the 'C' NOCOW & 'Z' Not_Compressed
> flags set for good measure. I then copy in a large file and proceed to
> make random modifications. Filefrag shows no additional extents
> created, good so far. A big thank you to the those devs who got that
> working.
> However, after a balance run (which crashed btw), modifications to the
> file result in increasing extent counts, ie. no longer obeying
> nodatacow mount option nor the 'C' flag.
> I realize that a balance will cow the data but it should not disable
> the ability to make nodatacow inline changes to a file.
> 
> I'm currently running 3.5.0 mainline Ubuntu kernel with the latest
> master of btrfs-progs from a ppa.
> 


hmm, I want to know if your 3.5.0 mainline ubuntu kernel has the commit:

Btrfs: make btrfs's allocation smoothly with preallocation

This commit may help you out of trouble.
Please let us know the result.

thanks,
liubo

> Thank you.
> Kyle Gates
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


