Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:37490 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755991Ab2HGSOB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Aug 2012 14:14:01 -0400
Message-ID: <50215AFF.1080800@gmx.net>
Date: Tue, 07 Aug 2012 20:14:23 +0200
From: Arne Jansen <sensille@gmx.net>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>
CC: linux-btrfs@vger.kernel.org
Subject: Re: btrfs panic in 3.5.0
References: <20120807174047.GE24635@merlins.org>
In-Reply-To: <20120807174047.GE24635@merlins.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/07/2012 07:40 PM, Marc MERLIN wrote:
> Unfortunately I only have a screenshot.
> 
> Apparently the panic was in 
> btrfs_set_lock_blocking_rw
> with a RIP in btrfs_cow_block
> 

Can you please resolve btrfs_cow_block+0x3b to a line number?

gdb btrfs.ko
(gdb) info line *btrfs_cow_block+0x3b

Thanks,
Arne

> Screenshot here:
> http://marc.merlins.org/tmp/btrfs_oops.jpg
> 
> Because the display looks a bit messed up, I can't tell if the ata error
> happened before or after the oops.
> 
> System rebooted ok.
> 
> Was there a better way to get this ooops if I didn't have serial console?
> 
> Marc
> 

