Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:62096 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756926AbaC1BMc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Mar 2014 21:12:32 -0400
Message-ID: <1395968913.15142.2.camel@localhost.localdomain>
Subject: Re: [PATCH] btrfs: add btrfs resize unit t/p/e support
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: dsterba@suse.cz
Cc: Brendan Hide <brendan@swiftspirit.co.za>, linux-btrfs@vger.kernel.org
Date: Fri, 28 Mar 2014 09:08:33 +0800
In-Reply-To: <20140327152732.GX29256@twin.jikos.cz>
References: <1395888673-28433-1-git-send-email-guihc.fnst@cn.fujitsu.com>
	 <5333D4CD.6030605@swiftspirit.co.za> <20140327152732.GX29256@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2014-03-27 at 16:27 +0100, David Sterba wrote:
> On Thu, Mar 27, 2014 at 09:35:41AM +0200, Brendan Hide wrote:
> > On 2014/03/27 04:51 AM, Gui Hecheng wrote:
> > >[snip]
> > >
> > >We add t/p/e support by replacing lib/cmdline.c:memparse
> > >with btrfs_memparse. The btrfs_memparse copies memparse's code
> > >and add unit t/p/e parsing.
> > Is there a conflict preventing adding this to memparse directly?
> 
> Agreed, there's no reason do duplicate this function.
Yes, I will try to modify the original memparse soon.

Thanks all!

-Gui

