Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:22601 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726660AbeHaGbn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Aug 2018 02:31:43 -0400
Subject: Re: fsck lowmem mode only: ERROR: errors found in fs roots
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <8d8c90d3edfcc9e73428d3730496d48b1160b39b.camel@scientia.net>
CC: Su Yue <Damenly_Su@gmx.com>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <a141cad2-0a08-555e-eb05-da2dceb54025@cn.fujitsu.com>
Date: Fri, 31 Aug 2018 10:33:26 +0800
MIME-Version: 1.0
In-Reply-To: <8d8c90d3edfcc9e73428d3730496d48b1160b39b.camel@scientia.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thank for the report.

On 08/31/2018 12:47 AM, Christoph Anton Mitterer wrote:
> Hey.
> 
> I've the following on a btrfs that's basically the system fs for my
> notebook:
> 
> 
> When booting from a USB stick with:
> # uname -a
> Linux heisenberg 4.17.0-3-amd64 #1 SMP Debian 4.17.17-1
> (2018-08-18) x86_64 GNU/Linux
> 
> # btrfs --version
> btrfs-progs v4.17
> 
> ... a lowmem mode fsck gives no error:
> 
> # btrfs check --mode=lowmem /dev/mapper/system ; echo $?
> Checking filesystem on /dev/mapper/system
> UUID: 6050ca10-e778-4d08-80e7-6d27b9c89b3c
> checking extents
> checking free space cache
> checking fs roots
> ERROR: errors found in fs roots
> found 495910952960 bytes used, error(s) found
> total csum bytes: 481840472
> total tree bytes: 2388819968
> total fs tree bytes: 1651097600
> total extent tree bytes: 161841152
> btree space waste bytes: 446707102
> file data blocks allocated: 6651878428672
>   referenced 542320984064
> 1
> 
> ... while a normal mode fsck doesn't give one:
> 
> # btrfs check /dev/mapper/system ; echo $?
> Checking filesystem on /dev/mapper/system
> UUID: 6050ca10-e778-4d08-80e7-6d27b9c89b3c
> checking extents
> checking free space cache
> checking fs roots
> checking only csum items (without verifying data)
> checking root refs
> found 495910952960 bytes used, no error found
> total csum bytes: 481840472
> total tree bytes: 2388819968
> total fs tree bytes: 1651097600
> total extent tree bytes: 161841152
> btree space waste bytes: 446707102
> file data blocks allocated: 6651878428672
>   referenced 542320984064
> 0
> 
> There were no unusual kernel log messages.
> 
> 
Humm, I think it's a bug of lowmem mode.
After looking through releated codes, I can't tell the cause.

Can you please fetch btrfs-progs from my repo and run lowmem check
in readonly?
Repo: https://github.com/Damenly/btrfs-progs/tree/lowmem_debug
It's based on v4.17.1 plus additonal output for debug only.

> Back in the normal system (no longer USB)... I spottet this:
> Aug 30 18:31:29 heisenberg kernel: BTRFS info (device dm-0): the free
> space cache file (22570598400) is invalid, skip it
> 
> but not sure whether it's related (probably not)... and I haven't seen
> such a free space cache file issue (or any other btrfs errors) in a
> long while (I usually watch my kernel log once after booting has
> finished).
>BTW, what's the mount option of USB?

> 
> Any ideas? Perhaps it's just yet another lowmem false positive...
> anything I can help in debugging this?
> 
> 
> Apart from this I haven't noticed any corruptions recently... just
> about to make a full backup of the fs (or better said a rw snapshot of
> the most of the data) with tar, so most data will be read soon at least
> once... an I would probably notice any further errors that are
> otherwise silent.
> 
Don't worry, since normal check didn't report any error, it may be just
a false alert.

Su
> 
> Cheers,
> Chris.
> 
> 
> 
