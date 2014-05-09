Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29167 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485AbaEIKyc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 May 2014 06:54:32 -0400
Date: Fri, 9 May 2014 18:54:25 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Kenny MacDermid <kenny.macdermid@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs issues in 3.14
Message-ID: <20140509105424.GC4250@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <CAEVbaUdcCQCWhZ-ZdBr_Dkv-WaMbtBkQ0n8HRfc0p9F0xw1+0A@mail.gmail.com>
 <20140507022245.GA15783@localhost.localdomain>
 <CAEVbaUcV-M9jnwR4ii3zR6RrbfpCtMmYAmhp8O01T4T6jJQN4A@mail.gmail.com>
 <20140508024803.GA3407@localhost.localdomain>
 <CAEVbaUctopBtA2Db6+OEt-=sYngXs+WJ-+Jyfc3RXWP_5eTowQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAEVbaUctopBtA2Db6+OEt-=sYngXs+WJ-+Jyfc3RXWP_5eTowQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 08, 2014 at 10:51:03AM -0300, Kenny MacDermid wrote:
> On Wed, May 7, 2014 at 11:48 PM, Liu Bo <bo.li.liu@oracle.com> wrote:
> >
> > On Wed, May 07, 2014 at 09:35:06AM -0300, Kenny MacDermid wrote:
> > > On Tue, May 6, 2014 at 11:22 PM, Liu Bo <bo.li.liu@oracle.com> wrote:
> > > >
> > > > What does sysrq+w say when the hang happens?
> > >
> > > The whole system isn't hung, I may have explained that wrong. The
> > > system will hang if I try to shutdown, and the process will hang if I
> > > try to kill -9 it.
> > >
> > > It looks like the browser is in this state currently so I did an 'echo
> > > w >/proc/sysrq-trigger' and have attached the full dmesg with the
> > > browser issues and the output.
> >
> > Those stacks show the blocked tasks are waiting for a page's writeback, but
> > they don't show what blocks the endio process of that page.
> >
> > I'd recommand you to try the lastest 3.15.0-rc4 or btrfs-next, as many fixes
> > are merged during this period.
> >
> 
> Thank you, I upgraded to the Arch package for 3.15.0-1-mainline (it's
> rc4) and I'll let you know if the errors reoccur.

FYI, this patch seems to address your problem.

Btrfs: fix hang on error (such as ENOSPC) when writing extent pages
https://patchwork.kernel.org/patch/4139971/

-liubo

> 
> Should the filesystem be rebuilt again?
> 
> A 'btrfs check' of it returned:
> 
> checking extents
> checking free space cache
> checking fs roots
> checking csums
> checking root refs
> Checking filesystem on /dev/mapper/home
> UUID: 9a60a25f-eeb4-494c-b1af-ebd8e4f79b6b
> free space inode generation (0) did not match free space cache generation (6409)
> free space inode generation (0) did not match free space cache generation (6397)
> found 41686685877 bytes used err is 0
> total csum bytes: 74074632
> total tree bytes: 907673600
> total fs tree bytes: 807567360
> total extent tree bytes: 18251776
> btree space waste bytes: 116552179
> file data blocks allocated: 112191107072
>  referenced 75535110144
> Btrfs v3.14.1
