Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:7594 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751754AbbG2Owm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Jul 2015 10:52:42 -0400
Date: Wed, 29 Jul 2015 10:52:30 -0400
From: Chris Mason <clm@fb.com>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
CC: "'btrfs'" <linux-btrfs@vger.kernel.org>,
        "'Qu Wenruo'" <quwenruo@cn.fujitsu.com>
Subject: Re: [GIT PULL] Fix for btrfs/070 checksum error
Message-ID: <20150729145230.GB23543@ret.masoncoding.com>
References: <559C9A75.60506@cn.fujitsu.com>
 <55AF6250.8070602@cn.fujitsu.com>
 <20150723202155.GC28964@ret.masoncoding.com>
 <55B186D1.30109@cn.fujitsu.com>
 <20150724015738.GD28964@ret.masoncoding.com>
 <55B72AEA.8020808@cn.fujitsu.com>
 <07c601d0c9d7$94522f30$bcf68d90$@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <07c601d0c9d7$94522f30$bcf68d90$@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 29, 2015 at 04:21:33PM +0800, Zhao Lei wrote:
> Hi, Chris
> 
> > -----Original Message-----
> > From: linux-btrfs-owner@vger.kernel.org
> > [mailto:linux-btrfs-owner@vger.kernel.org] On Behalf Of Qu Wenruo
> > Sent: Tuesday, July 28, 2015 3:11 PM
> > To: Chris Mason; btrfs
> > Subject: Re: [GIT PULL] Fix for btrfs/070 checksum error
> > 
> > Chris Mason wrote on 2015/07/23 21:57 -0400:
> > > On Fri, Jul 24, 2015 at 08:29:05AM +0800, Qu Wenruo wrote:
> > >
> > > [ deadlock with the 070 patches ]
> > >
> > >> Thanks Chris
> > >>
> > >> We will investigate it with highest priority.
> > >>
> > >> Thanks,
> > >> Qu
> > >>
> > >
> > > Thanks!  I'm doing a few more runs to make sure the lockup is new with
> > > these patches.
> > >
> > > -chris
> > >
> > Hi Chris,
> > 
> > I'm very sorry that we are unable to fix the lockup in a short time, so it may not
> > fit in the v4.2 merge window.
> > 
> > Please ignore this patchset for now.
> > 
> 
> Sorry for taking quite a long time for investigate because it is
> randomly happened.
> 
> We got reason of process blocking:
> 1: In some case, this patch caused __btrfs_cow_block()->btrfs_reloc_cow_block()
>   failed from btrfs_balance operation.(need more investigation)
> 
> 2: __btrfs_cow_block()'s error handle code hadn't unlock/free
>   new_allocated tree block before return error.
> 
> 3: do_relocation(), which is caller of __btrfs_cow_block(), have error handle
>   code, but also can't work in this case, because new_allocated eb is not
>   returned.
> 
> 4: subsequent code in do_relocation() try to lock above eb again,
>   and caused dead lock.

Excellent, thanks for tracking this down.  I agree investigating #1 is
the top priority, since it's possible the patches are just making it
happen more often.

-chris
