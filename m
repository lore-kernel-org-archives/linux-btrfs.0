Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qe0-f52.google.com ([209.85.128.52]:60138 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105Ab3HVTo6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 Aug 2013 15:44:58 -0400
Received: by mail-qe0-f52.google.com with SMTP id a11so1367251qen.25
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Aug 2013 12:44:57 -0700 (PDT)
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: Question: How can I recover this partition? (unable to find logical $hugenum len 4096)
From: Nicholas Lee <email@nickle.es>
In-Reply-To: <5EB2ECAC-9A8C-4403-8630-944B646DE3B8@nickle.es>
Date: Thu, 22 Aug 2013 15:38:48 -0400
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <DD09B4EA-9F87-4D18-8B7A-EEF2FFD6A7FE@nickle.es>
References: <79471CD1-CDDD-4EDD-B255-40568B8446E2@nickle.es> <CAKcLGm_QXTjN3e-HtogM+XXygymG+1kjhuOAMNfj=ngSHx5T5Q@mail.gmail.com> <5EB2ECAC-9A8C-4403-8630-944B646DE3B8@nickle.es>
To: Nicholas Lee <email@nickle.es>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Full pastebin here: http://cwillu.com:8080/96.245.194.45#6

[   9.213212] Btrfs loaded
[    9.245673] device fsid 2ffb2450-f74f-4cfb-a3be-bb5e3c6d32ec devid 1 transid 23568 /dev/dm-1
[  102.886834] device fsid 2ffb2450-f74f-4cfb-a3be-bb5e3c6d32ec devid 1 transid 23568 /dev/mapper/main--storage--vg-root
[  102.888348] btrfs: enabling auto recovery
[  102.888354] btrfs: disabling disk space caching
[  102.888357] btrfs: disabling disk space caching
[  102.911068] BTRFS critical (device dm-1): unable to find logical 1781900460032 len 4096
[  102.911103] BTRFS emergency (device dm-1): No mapping for 1781900460032-1781900464128

[  102.911108] btrfs: failed to read tree root on dm-1
[  102.911186] BTRFS critical (device dm-1): unable to find logical 1781900460032 len 4096
[  102.911217] BTRFS emergency (device dm-1): No mapping for 1781900460032-1781900464128

[  102.911222] btrfs: failed to read tree root on dm-1
[  102.911235] BTRFS critical (device dm-1): unable to find logical 1198824710144 len 4096
[  102.911240] BTRFS emergency (device dm-1): No mapping for 1198824710144-1198824714240

[  102.911243] btrfs: failed to read tree root on dm-1
[  102.911255] BTRFS critical (device dm-1): unable to find logical 1198518919168 len 4096
[  102.911286] BTRFS emergency (device dm-1): No mapping for 1198518919168-1198518923264

[  102.911290] btrfs: failed to read tree root on dm-1
[  102.911302] BTRFS critical (device dm-1): unable to find logical 582755782656 len 4096
[  102.911308] BTRFS emergency (device dm-1): No mapping for 582755782656-582755786752

[  102.911311] btrfs: failed to read tree root on dm-1
[  102.986797] btrfs: open_ctree failed


On 22.08.2013, at 15:23, Nicholas Lee <email@nickle.es> wrote:

> After updating the kernel and using btrfs-progs-git from the AUR, I'm now getting this output. Does this yield any new insight?
> 
> [  473.305408] btrfs: failed to read tree root on dm-2
> [  473.305555] BTRFS critical (device dm-2): unable to find logical 1781900460032 len 4096
> [  473.305591] BTRFS emergency (device dm-2): No mapping for 1781900460032-1781900464128
> 
> 
> On 22.08.2013, at 10:09, Mitch Harder <mitch.harder@sabayonlinux.org> wrote:
> 
>> On Thu, Aug 22, 2013 at 1:47 AM, Nicholas Lee <email@nickle.es> wrote:
>> 
>>> [   45.914275] ------------[ cut here ]------------
>>> [   45.914406] kernel BUG at fs/btrfs/volumes.c:4417!
>>> [   45.914489] invalid opcode: 0000 [#1] PREEMPT SMP
>> 
>> I can't say if this will fix your problem or not, but the 3.10.x
>> kernel has a patch to pass this error back instead of halting with a
>> BUG() at this point.
> 

