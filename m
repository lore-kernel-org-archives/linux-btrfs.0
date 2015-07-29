Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:6145 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753291AbbG2IWB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Jul 2015 04:22:01 -0400
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: "'Chris Mason'" <clm@fb.com>, "'btrfs'" <linux-btrfs@vger.kernel.org>
CC: "'Qu Wenruo'" <quwenruo@cn.fujitsu.com>
References: <559C9A75.60506@cn.fujitsu.com> <55AF6250.8070602@cn.fujitsu.com> <20150723202155.GC28964@ret.masoncoding.com> <55B186D1.30109@cn.fujitsu.com> <20150724015738.GD28964@ret.masoncoding.com> <55B72AEA.8020808@cn.fujitsu.com>
In-Reply-To: <55B72AEA.8020808@cn.fujitsu.com>
Subject: RE: [GIT PULL] Fix for btrfs/070 checksum error
Date: Wed, 29 Jul 2015 16:21:33 +0800
Message-ID: <07c601d0c9d7$94522f30$bcf68d90$@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Chris

> -----Original Message-----
> From: linux-btrfs-owner@vger.kernel.org
> [mailto:linux-btrfs-owner@vger.kernel.org] On Behalf Of Qu Wenruo
> Sent: Tuesday, July 28, 2015 3:11 PM
> To: Chris Mason; btrfs
> Subject: Re: [GIT PULL] Fix for btrfs/070 checksum error
> 
> Chris Mason wrote on 2015/07/23 21:57 -0400:
> > On Fri, Jul 24, 2015 at 08:29:05AM +0800, Qu Wenruo wrote:
> >
> > [ deadlock with the 070 patches ]
> >
> >> Thanks Chris
> >>
> >> We will investigate it with highest priority.
> >>
> >> Thanks,
> >> Qu
> >>
> >
> > Thanks!  I'm doing a few more runs to make sure the lockup is new with
> > these patches.
> >
> > -chris
> >
> Hi Chris,
> 
> I'm very sorry that we are unable to fix the lockup in a short time, so it may not
> fit in the v4.2 merge window.
> 
> Please ignore this patchset for now.
> 

Sorry for taking quite a long time for investigate because it is
randomly happened.

We got reason of process blocking:
1: In some case, this patch caused __btrfs_cow_block()->btrfs_reloc_cow_block()
  failed from btrfs_balance operation.(need more investigation)

2: __btrfs_cow_block()'s error handle code hadn't unlock/free
  new_allocated tree block before return error.

3: do_relocation(), which is caller of __btrfs_cow_block(), have error handle
  code, but also can't work in this case, because new_allocated eb is not
  returned.

4: subsequent code in do_relocation() try to lock above eb again,
  and caused dead lock.

In short:
do_relocation()
-> __btrfs_cow_block() failed without unlock eb *1
...
-> btrfs_search_slot() try to lock above eb again
...
*1: this fail is caused by scrub

Because eb locking code is not normal lock, we can't get information
from lockldep in this case.

Things to do:
1: Fix this patch to avoid making __btrfs_cow_block() fails.
2: Fix __btrfs_cow_block() to do enough cleanup in error handle code.
3: Some enhance for eb locking, to report some information to helps
  similar error.

Thanks
Zhaolei

> Thanks,
> Qu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in the body
> of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html

