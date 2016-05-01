Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:34290 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbcEANyp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 May 2016 09:54:45 -0400
Received: by mail-oi0-f52.google.com with SMTP id k142so165455312oib.1
        for <linux-btrfs@vger.kernel.org>; Sun, 01 May 2016 06:54:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$1c3f$713ccc59$ba5354e3$ceefdfd6@cox.net>
References: <20160501090046.638fc2c6@jupiter.sol.kaishome.de>
	<pan$1c3f$713ccc59$ba5354e3$ceefdfd6@cox.net>
Date: Sun, 1 May 2016 14:54:44 +0100
Message-ID: <CAMU1PDj99OSwFy7Ep9g43uezNLEGoziqPn3kzhUUqeEMRNTWgg@mail.gmail.com>
Subject: Re: commands like "du", "df", and "btrfs fs sync" hang
From: Mike Fleetwood <mike.fleetwood@googlemail.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 1 May 2016 at 13:47, Duncan <1i5t5.duncan@cox.net> wrote:
> Direct from that section of my /etc/sysctl.conf:
>
> ################################################################################
> # Virtual-machine: swap, write-cache

Hi Duncan,

You mean virtual memory.

Quoting from the kernel documentation
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/sysctl/vm.txt
"
This file contains the documentation for the sysctl files in
/proc/sys/vm and is valid for Linux kernel version 2.6.29.

The files in this directory can be used to tune the operation
of the virtual memory (VM) subsystem of the Linux kernel and
the writeout of dirty data to disk.
"

> # vm.vfs_cache_pressure = 100
> # vm.laptop_mode = 0
> # vm.swappiness = 60
> vm.swappiness = 100
>
> # write-cache, foreground/background flushing
> # vm.dirty_ratio = 10 (% of RAM)
> # make it 3% of 16G ~ half a gig
> vm.dirty_ratio = 3
> # vm.dirty_bytes = 0
>
> # vm.dirty_background_ratio = 5 (% of RAM)
> # make it 1% of 16G ~ 160 M
> vm.dirty_background_ratio = 1
> # vm.dirty_background_bytes = 0
>
> # vm.dirty_expire_centisecs = 2999 (30 sec)
> # vm.dirty_writeback_centisecs = 499 (5 sec)
> # make it 10 sec
> vm.dirty_writeback_centisecs = 1000
> ################################################################################

Thanks,
Mike
