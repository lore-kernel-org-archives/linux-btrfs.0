Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:15168 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750763AbaIVIel (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Sep 2014 04:34:41 -0400
Message-ID: <1411374836.8147.3.camel@localhost.localdomain>
Subject: Re: fs corruption report
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: Marc Dietrich <marvin24@gmx.de>
CC: Zooko Wilcox-OHearn <zooko@leastauthority.com>,
        <linux-btrfs@vger.kernel.org>
Date: Mon, 22 Sep 2014 16:33:56 +0800
In-Reply-To: <14406058.nMoj3Kabx5@fb07-iapwap2>
References: <CAM_a8JxJBFQykuF13UF1Fi9jbM-=yromXbQ5PrWM5JPR7u6pXA@mail.gmail.com>
	 <CAM_a8JzKth0_zG6cGoQeWHB3Dpro42wfEtS5QJXtFZT1xNoZYQ@mail.gmail.com>
	 <1411090230.28980.6.camel@localhost.localdomain>
	 <14406058.nMoj3Kabx5@fb07-iapwap2>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2014-09-22 at 10:19 +0200, Marc Dietrich wrote:
> Hi,
> 
> Am Freitag, 19. September 2014, 09:30:30 schrieb Gui Hecheng:
> > On Thu, 2014-09-18 at 12:47 +0000, Zooko Wilcox-OHearn wrote:
> > > Thank you! I will try to restore using this patch.
> > > 
> > > What branch of what btrfs tools git repo should I apply the patch to?
> > > 
> > > Regards,
> > > 
> > > Zooko
> > 
> > At least I think the following repo/v3.17.x branch has all
> > restore-related patches included.
> > 
> > git://github.com/kdave/btrfs-progs.git
> > 
> > This is a mirror of the latest devel repo that I am on.
> 
> restore of my corrupted partition finished. No "bad compress" nor valgrind
> errors anymore. I'll close the bug.
> 
> Many thanks!
> 
> Marc

Hi Marc,
I'm very glad to hear the result.
I've sent a v2 patch which adopts your idea. I also add your
sign-off-by, please help me to check whether it matches your thoughts,
or more could be done to improve.

Thanks,
-Gui

