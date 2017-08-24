Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from demfloro.ru ([188.166.0.225]:38984 "EHLO demfloro.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751272AbdHXMYn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 Aug 2017 08:24:43 -0400
Date: Thu, 24 Aug 2017 15:24:18 +0300
From: Dmitrii Tcvetkov <demfloro@demfloro.ru>
To: master.b.at.raven@chefmail.de
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS RAID 1 not mountable: open_ctree failed,
 super_num_devices 3 mismatch with num_devices 2 found here
Message-ID: <20170824152418.542e9dfa@job>
In-Reply-To: <a49007a603563cf8d837d0ffa305fb35@email.freenet.de>
References: <a49007a603563cf8d837d0ffa305fb35@email.freenet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>  I rebootet with HWE K4.11
> 
> and took a pic of the error message (see attachment).
> 
> It seems btrfs still sees the removed NVME. 
> There is a mismatch from super_num_devices (3) to num_devices (2)
> with indicates something strage is going on here, imho. 
> 
> Then i returned and booted K4.4, which boots fine.
> 
> root@vHost1:~# btrfs dev stat /
> [/dev/nvme0n1p1].write_io_errs   0
> [/dev/nvme0n1p1].read_io_errs    0
> [/dev/nvme0n1p1].flush_io_errs   0
> [/dev/nvme0n1p1].corruption_errs 0
> [/dev/nvme0n1p1].generation_errs 0
> [/dev/sda1].write_io_errs   0
> [/dev/sda1].read_io_errs    0
> [/dev/sda1].flush_io_errs   0
> [/dev/sda1].corruption_errs 0
> [/dev/sda1].generation_errs 0
> 
> Btw i edited the subject to match the correct error.
> 
> 
> Sash

Thats very odd, if super_num_devices in superblocks don't match real number of devices
then 4.4 kernel shouldn't mount the filesystem too.

We probably need help from one of btrfs developers since I'm not one, I'm just btrfs user.
Can you provide outpus of:
btrfs inspect-internal dump-super -f /dev/sda1
btrfs inspect-internal dump-super -f /dev/nvme0n1p1

Depending on version of btrfs-progs you may need to use btrfs-dump-super instead of "btrfs inspect-internal dump-super"

>3rd i saw https://patchwork.kernel.org/patch/9419189/ from Roman. Did
>he receive any comments on his patch? This one could help on this
>problem, too. 

Don't know about this patch from Roman per se, but there is a patchset[1] which is aimed to be merged in 4.14 merge window AFAIK.

[1] https://www.spinics.net/lists/linux-btrfs/msg66891.html
