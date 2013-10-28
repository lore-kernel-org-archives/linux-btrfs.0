Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f179.google.com ([209.85.215.179]:57225 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755810Ab3J1TH0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Oct 2013 15:07:26 -0400
Received: by mail-ea0-f179.google.com with SMTP id b10so2393855eae.24
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Oct 2013 12:07:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <083917F8-3235-4B2D-92B3-5ECE01D4C7CC@colorremedies.com>
References: <20131027100022.4c76e1e7@virtall.com>
	<CAEezp7u4-iYN01oXcoodzqsy8_nJPYWL-i0rjFsOc=3C0eSz-g@mail.gmail.com>
	<CAEezp7txuxchURr1DFhFWeFjCG6_07SX78vZCeDz3sxrgz6SVw@mail.gmail.com>
	<F8C57341-B55A-49DF-BE61-AB62D9D1A869@colorremedies.com>
	<3458CB22-ED71-45F4-B688-09C0CB6F5330@colorremedies.com>
	<CAEezp7v__2EbhZ-1=FjDpfnF5b+ydKw3LRx4tW55g911804TXA@mail.gmail.com>
	<083917F8-3235-4B2D-92B3-5ECE01D4C7CC@colorremedies.com>
Date: Mon, 28 Oct 2013 20:07:24 +0100
Message-ID: <CAEezp7tD9fKOHkjr1Bu3-vuea+siGHgdkPTx7TLujywgrbVYgQ@mail.gmail.com>
Subject: Re: No space left on device, problem
From: Igor M <igork20@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 28, 2013 at 6:57 PM, Chris Murphy <lists@colorremedies.com> wrote:
>
> On Oct 28, 2013, at 1:40 AM, Igor M <igork20@gmail.com> wrote:
>>
>> dmesg: http://pastebin.com/t2H1QYye
>
>
> You've got a warning related to pcie bridge on boot, with a trace that follows. I don't know if this could be related to some problems.
>
> [    0.325976] ------------[ cut here ]------------
> [    0.326086] WARNING: CPU: 5 PID: 1 at drivers/pci/search.c:46 pci_find_upstream_pcie_bridge+0x50/0x70()
> [    0.326263] Modules linked in:
> [    0.326412] CPU: 5 PID: 1 Comm: swapper/0 Not tainted 3.11.6 #1
> [    0.326520] Hardware name: System manufacturer System Product Name/P8H77-V LE, BIOS 0601 06/06/2012
> [    0.326695]  0000000000000000 0000000000000009 ffffffff81449f86 0000000000000000
> [    0.327032]  ffffffff810514b1 ffff88040b031898 ffff88040b031800 ffff88040b031898
> [    0.327367]  0000000080000000 000077ff80000000 ffffffff812191a0 0000000000000004
> [    0.327704] Call Trace:
> [    0.327819]  [<ffffffff81449f86>] ? dump_stack+0x41/0x51
> [    0.327931]  [<ffffffff810514b1>] ? warn_slowpath_common+0x81/0xb0
> [    0.328040]  [<ffffffff812191a0>] ? pci_find_upstream_pcie_bridge+0x50/0x70
> [    0.328151]  [<ffffffff813333d3>] ? intel_iommu_add_device+0x43/0x210
> [    0.328261]  [<ffffffff81330510>] ? bus_set_iommu+0x60/0x60
> [    0.328370]  [<ffffffff8133053c>] ? add_iommu_group+0x2c/0x60
> [    0.328481]  [<ffffffff81292a3d>] ? bus_for_each_dev+0x4d/0x80
> [    0.328591]  [<ffffffff813304fa>] ? bus_set_iommu+0x4a/0x60
> [    0.328701]  [<ffffffff8163bc0d>] ? intel_iommu_init+0xb20/0xc45
> [    0.328812]  [<ffffffff81612919>] ? unpack_to_rootfs+0x24b/0x25b
> [    0.328922]  [<ffffffff816163c6>] ? pci_iommu_init+0xe/0x37
> [    0.329031]  [<ffffffff816163b8>] ? memblock_find_dma_reserve+0x148/0x148
> [    0.329142]  [<ffffffff810002f2>] ? do_one_initcall+0x102/0x150
> [    0.329252]  [<ffffffff81611e43>] ? kernel_init_freeable+0xfd/0x18e
> [    0.329362]  [<ffffffff816117cf>] ? do_early_param+0x83/0x83
> [    0.329471]  [<ffffffff81444480>] ? rest_init+0x70/0x70
> [    0.329579]  [<ffffffff81444489>] ? kernel_init+0x9/0xe0
> [    0.329688]  [<ffffffff8144f36c>] ? ret_from_fork+0x7c/0xb0
> [    0.329797]  [<ffffffff81444480>] ? rest_init+0x70/0x70
> [    0.329907] ---[ end trace 0946f959337cff8b ]---
>
>
> There are also numerous ACPI errors.
>
> ACPI Error: [DSSP] Namespace lookup failure
>
> check this:
> http://forums.gentoo.org/viewtopic-t-960476-start-0.html
>
>
> Anyway, I don't see any read or write failures for any of the drives which is what I was kinda expecting.
>
>
>>
>> dest disk: http://pastebin.com/ez9jALS2
>
> This is a new drive with only 71 power on hours yet I'm seeing this:
>
>         • 0x0009  2           27  Transition from drive PhyRdy to drive PhyNRdy
>         • 0x000a  2           27  Device-to-host register FISes sent due to a COMRESET
>
>
>
> That's unexpected but I don't know that it's releated. The dmesg doesn't report any phy issues with the drive. Maybe check syslog or journalctl with a case insensitive search for phy and see if you find anything.
>
>
>
>
> Chris Murphy
>

Drive should be ok. About pcie_bridge warning, I'm not sure how to
solve, otherwise this computer is stable.
There is no error if compression is turned off or non-compressible
file is copied.
I'll try on different computer and see if the same will happen.
