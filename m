Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f169.google.com ([209.85.216.169]:50113 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268Ab3HVTXo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 Aug 2013 15:23:44 -0400
Received: by mail-qc0-f169.google.com with SMTP id m15so1243704qcq.14
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Aug 2013 12:23:43 -0700 (PDT)
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: Question: How can I recover this partition? (unable to find logical $hugenum len 4096)
From: Nicholas Lee <email@nickle.es>
In-Reply-To: <CAKcLGm_QXTjN3e-HtogM+XXygymG+1kjhuOAMNfj=ngSHx5T5Q@mail.gmail.com>
Date: Thu, 22 Aug 2013 15:23:33 -0400
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <5EB2ECAC-9A8C-4403-8630-944B646DE3B8@nickle.es>
References: <79471CD1-CDDD-4EDD-B255-40568B8446E2@nickle.es> <CAKcLGm_QXTjN3e-HtogM+XXygymG+1kjhuOAMNfj=ngSHx5T5Q@mail.gmail.com>
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After updating the kernel and using btrfs-progs-git from the AUR, I'm now getting this output. Does this yield any new insight?

[  473.305408] btrfs: failed to read tree root on dm-2
[  473.305555] BTRFS critical (device dm-2): unable to find logical 1781900460032 len 4096
[  473.305591] BTRFS emergency (device dm-2): No mapping for 1781900460032-1781900464128


On 22.08.2013, at 10:09, Mitch Harder <mitch.harder@sabayonlinux.org> wrote:

> On Thu, Aug 22, 2013 at 1:47 AM, Nicholas Lee <email@nickle.es> wrote:
> 
>> [   45.914275] ------------[ cut here ]------------
>> [   45.914406] kernel BUG at fs/btrfs/volumes.c:4417!
>> [   45.914489] invalid opcode: 0000 [#1] PREEMPT SMP
> 
> I can't say if this will fix your problem or not, but the 3.10.x
> kernel has a patch to pass this error back instead of halting with a
> BUG() at this point.

