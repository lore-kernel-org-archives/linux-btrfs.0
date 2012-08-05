Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from licorne.daevel.fr ([178.32.94.222]:44140 "EHLO
	licorne.daevel.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754427Ab2HEOLq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Aug 2012 10:11:46 -0400
Message-ID: <501E7F23.3040401@daevel.fr>
Date: Sun, 05 Aug 2012 16:11:47 +0200
From: Olivier Bonvalet <btrfs.list@daevel.fr>
MIME-Version: 1.0
To: Chris Samuel <chris@csamuel.org>
CC: linux-btrfs@vger.kernel.org
Subject: Re: kernel BUG at fs/btrfs/extent-tree.c:5038 (linux 3.4.7)
References: <501987FF.9080304@daevel.fr> <20120802132259.GO17430@twin.jikos.cz> <501A836F.90506@daevel.fr> <20120802135354.GQ17430@twin.jikos.cz> <501AA842.5080300@daevel.fr> <501C53B7.30601@daevel.fr> <501E3578.4030809@csamuel.org>
In-Reply-To: <501E3578.4030809@csamuel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/08/2012 10:57, Chris Samuel wrote:
> On 08/04/2012 08:41 AM, Olivier Bonvalet wrote:
> 
>> Is there something I can do to fix that ? (the mount
>> option "recovery" didn't help here)
> 
> I've seen someone (perhaps Marc Merlin) report that the
> 3.5.x kernel was able to mount a filesystem that 3.4.x
> couldn't, so it might be worth a shot here!
> 
> Best of luck,
> Chris

Thanks for the idea, but same result :

Aug  5 16:10:12 backup2 kernel: [   58.630481] device fsid a5dfe512-c8a3-46f0-bc8c-6365b8eccdcb devid 1 transid 110425 /dev/mapper/vg--backupplug-backup
Aug  5 16:10:12 backup2 kernel: [   58.631346] btrfs: force zlib compression
Aug  5 16:10:12 backup2 kernel: [   58.631357] btrfs: not using ssd allocation scheme
Aug  5 16:10:12 backup2 kernel: [   58.631366] btrfs: enabling auto recovery
Aug  5 16:10:12 backup2 kernel: [   58.670972] btrfs: no dev_stats entry found for device /dev/mapper/vg--backupplug-backup (devid 1) (OK on first mount after mkfs)
Aug  5 16:10:12 backup2 kernel: [   58.674758] parent transid verify failed on 615015833600 wanted 110423 found 110424
Aug  5 16:10:12 backup2 kernel: [   58.675090] parent transid verify failed on 615015833600 wanted 110423 found 110424
Aug  5 16:10:12 backup2 kernel: [   58.675523] btrfs read error corrected: ino 1 off 615015833600 (dev /dev/mapper/vg--backupplug-backup sector 1209083504)
Aug  5 16:10:12 backup2 kernel: [   58.675536] Failed to read block groups: -5
Aug  5 16:10:12 backup2 kernel: [   58.704720] btrfs: open_ctree failed
