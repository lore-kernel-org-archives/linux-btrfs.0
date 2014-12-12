Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-05v.sys.comcast.net ([69.252.207.37]:46844 "EHLO
	resqmta-ch2-05v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750737AbaLLVg1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Dec 2014 16:36:27 -0500
Message-ID: <548B5FD6.5080306@pobox.com>
Date: Fri, 12 Dec 2014 13:36:22 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Tomasz Chmielewski <tch@virtall.com>, Josef Bacik <jbacik@fb.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: 3.18.0: kernel BUG at fs/btrfs/relocation.c:242!
References: <e4a8d9ba015981b895919256a2223950@admin.virtall.com> <542EE83D.8050701@fb.com> <999a300ed462a1e1388aee4d6f03a30e@admin.virtall.com> <438e043f73392614d1453892b7fe225c@admin.virtall.com> <0f30c49c7d208903ef84e31a928e4051@admin.virtall.com>
In-Reply-To: <0f30c49c7d208903ef84e31a928e4051@admin.virtall.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/12/2014 06:37 AM, Tomasz Chmielewski wrote:
> FYI, still seeing this with 3.18 (scrub passes fine on this filesystem).
>
> # time btrfs balance start /mnt/lxc2
> Segmentation fault
>
> real    322m32.153s
> user    0m0.000s
> sys     16m0.930s

> (...)

> [20306.981773] BTRFS (device sdd1): parent transid verify failed on
> 5568935395328 wanted 70315 found 102416
> [20306.983962] BTRFS (device sdd1): parent transid verify failed on
> 5568935395328 wanted 70315 found 102416

Uh... isn't fixing an invalid transaction id a job for btrfsck? I don't 
see anything in linux/fs/btrfs/*.c that would fix this sort of semantic 
error, like ever.

I think that this is a case of thing_a points to thing_b and thing_b is 
much newer (transaction 102416) than thing_a thinks it should be 
(transaction 70315).

In another thread [that was discussing SMART] you talked about replacing 
a drive and then needing to do some patching-up of the result because of 
drive failures. Is this the same filesystem where that happened? That 
kind of work could leave you in this state if thing_a was one of the 
damaged bits and the system had to go fall back to an earlier version.

So I'd run a btrfsck from the very recent btrfs-tools package. If it 
tells you to run it again with --repair, then do that.

By my reading balance is simply refusing to touch an extent that doesn't 
seem to make sense because it can't be sure it wouldn't undermine some 
active data if it relocated the block.

