Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41334 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751561AbbEZOJC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 May 2015 10:09:02 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YxBAy-0003nB-Qh
	for linux-btrfs@vger.kernel.org; Tue, 26 May 2015 11:29:33 +0200
Received: from 168.159.160.61 ([168.159.160.61])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 26 May 2015 11:29:32 +0200
Received: from toyours_sridhar by 168.159.160.61 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 26 May 2015 11:29:32 +0200
To: linux-btrfs@vger.kernel.org
From: sri <toyours_sridhar@yahoo.co.in>
Subject: Re: btrfs on disk stability
Date: Tue, 26 May 2015 09:29:25 +0000 (UTC)
Message-ID: <loom.20150526T112326-642@post.gmane.org>
References: <loom.20150526T103943-385@post.gmane.org> <20150526085246.GC16826@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills <hugo <at> carfax.org.uk> writes:

> 
> On Tue, May 26, 2015 at 08:45:06AM +0000, sri wrote:
> > Hi,
> > 
> > According to btrfs wiki page, under "Stability status" it is written 
that
> > 
> > "The filesystem disk format is no longer unstable".
> > 
> > Does this mean if there are more I/Os are going on a btrfs file 
system, 
> > copy of entire disk (all disk blocks) gives a stable disk?
> 
>    No, it means that the format isn't changing in incompatible ways
> any more. You're guaranteed that if you upgrade your kernel, the FS
> will still be readable on the new kernel. (And, if you don't enable
> any extra features with btrfstune, that the kernel will still be
> readable if you downgrade to the earlier kernel you were using).
> 
> > Just to elaborate more, if btrfs file system is created on 2 disks 
> > /dev/sda and /dev/sdb and if I start copying blocks of sda and sdb 
to sdc 
> > and sdc respectively by just opening file handlers of sda and sdb 
and 
> > mounting the new copy via /dev/sdc and /dev/sdd will give consistent 
file 
> > system??
> 
>    That's always the case, with the very large caveat that you remove
> /dev/sdc and /dev/sdd from the system before you try mounting anything
> related to that FS. Making block level copies of btrfs filesystems and
> leaving them visible to the same kernel as the originals is a very bad
> idea, and can cause massive FS corruption.
> 
>    It's OK to make the copy, but not to try mounting the FS with both
> copies present, as the kernel will see both copies as the same
> filesystem (because they have the same UUID), and it will get very
> confused about which device(s) it's meant to be writing to.
> 

  Thank you Hugo,
  copies of disk will not be there once block level copy is done. Assume 
that sdc and sdd (which are used for copy sda and sdb) are ISCSI disks 
from different machine and as soon as disk copy sda->sdc and sdb->sdd is 
done, I will remove both disks and use it on other machine.

In this case 
1) After copy at disk level whether the btrfs on sdc and sdd will be in 
consistent state? even though there are any IOs on original disks sda 
and sdb?
  My guess is no but I am not sure
2) new disks sdc and sdd can be mounted on another machine where btrfs 
fs is supported ?  

>    Hugo.
> 




