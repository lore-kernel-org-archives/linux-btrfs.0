Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:60241 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755218AbbJ1Blp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Oct 2015 21:41:45 -0400
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <dsterba@suse.cz>
CC: <linux-btrfs@vger.kernel.org>
References: <fff170b03b5707d4b4457f36da271fadf4bdeade.1444732174.git.zhaolei@cn.fujitsu.com> <20151027142011.GT13624@twin.jikos.cz>
In-Reply-To: <20151027142011.GT13624@twin.jikos.cz>
Subject: RE: [PATCH] btrfs-progs: mkfs: Enable -d dup for single device
Date: Wed, 28 Oct 2015 09:41:30 +0800
Message-ID: <008101d11121$c5ee0b40$51ca21c0$@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, David Sterba

> -----Original Message-----
> From: David Sterba [mailto:dsterba@suse.cz]
> Sent: Tuesday, October 27, 2015 10:20 PM
> To: Zhao Lei <zhaolei@cn.fujitsu.com>
> Cc: linux-btrfs@vger.kernel.org
> Subject: Re: [PATCH] btrfs-progs: mkfs: Enable -d dup for single device
> 
> On Tue, Oct 13, 2015 at 06:29:41PM +0800, Zhao Lei wrote:
> > Current code don't support dup profile in single device, except it is
> > in mixed mode, because following reason:
> > 1: In some ssd with deduplication function, it have no effect.
> > 2: For a physical device, it the entire disk broken, -d dup can
> >    not help.
> > 3: Half performance comparing with single profile.
> > 4: We have a workaround: Create multi-partition in single device,
> >    and btefs will treat them as multi device.
> >
> > Instead of refuse -d dup, we have a better choise:
> > Give user a chance to select, and output a warning to notice above
> > problem.
> >
> > Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> 
> FYI, I've queued the patch for 4.4 (or later) whenever we're ready on the kernel
> side.
Thanks.

I'm doing relative tests(xfstests, userland tools, functions as scrub, balance, ...)
on it.

Thanks
Zhaolei

