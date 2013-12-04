Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40823 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084Ab3LDCPQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Dec 2013 21:15:16 -0500
Date: Wed, 4 Dec 2013 10:15:08 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: =?utf-8?B?U3rFkXRzIMOBa29z?= <szotsaki@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs-ino-cache runs on every boot for 6 minutes
Message-ID: <20131204021507.GH18095@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1531404.tFNCiHaLVH@linux-suse.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1531404.tFNCiHaLVH@linux-suse.hu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 03, 2013 at 12:28:26PM +0100, Szőts Ákos wrote:
> Dear list members,
> 
> I'm not sure if this a bug or an intended behaviour, since I've yet to find a 
> reliable source with Google search.
> 
> My problem is the following: with the 3.12 kernel on every single boot (even 
> when the computer was shut down clear) the process [btrfs-ino-cache] is 
> preventing the successful startup of X because it's running for 6 minutes.
> 
> I can see this in "iotop" and while that program runs the whole system is 
> being blocked. After 6 minutes I restart X and everyting goes normal from that 
> point on.

6min is way too much, something may go wrongly,
could you please run "echo w > /proc/sysrq-trigger" when that happens?

-liubo

> 
> My question is: is that necessary to regenerate the inode cache on every boot 
> or is this a bug? Of course if I remove the "inode_cache" option from fstab, 
> this phenomenon disappears.
> 
> Versions:
> - OS: openSUSE 13.1
> - Kernel: 3.12.0-6.ge7c00d8-desktop #1 SMP PREEMPT Tue Nov 12 13:09:24 UTC 
> 2013 (e7c00d8)
> - Mount options: compress=lzo,space_cache,inode_cache,noatime
> 
> Best regards,
> 
> Ákos
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
