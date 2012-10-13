Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:52622 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940Ab2JMRv1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 13 Oct 2012 13:51:27 -0400
Message-ID: <5079AA18.6010103@zastrow4u.de>
Date: Sat, 13 Oct 2012 19:51:20 +0200
From: Alfred Zastrow <ml@zastrow4u.de>
MIME-Version: 1.0
To: Liu Bo <bo.li.liu@oracle.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS filesystem is not mountable after crash
References: <k0ub0m$pvp$1@ger.gmane.org> <k1cc36$tj$1@ger.gmane.org> <5039BF90.7070509@oracle.com>
In-Reply-To: <5039BF90.7070509@oracle.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 26.08.2012 08:17, schrieb Liu Bo:
> On 08/26/2012 01:27 PM, Alfred Zastrow wrote:
>
>
> Hello,
>
> has realy nobody a hint for me?
>
> Is compiling chris's latest for-linus helpful?
>
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git
>
> thanks,
> liubo

Hi dev's

I was not able to install chris's latest for-linus under F17, but I 
tried with the latest 3.6.1-Kernel with was recently released.
Same shit..  :-(


[root@z2 alfred]# mount /dev/sdb1 /mnt -o recovery,ro
mount: mount /dev/sdb1 on /mnt failed: Veraltete NFS-Dateizugriffsnummer

[root@z2 alfred]# dmesg

[...]

[41005.694357] device fsid 4d00f0e6-e9d7-42d9-8514-827d8f01f7d3 devid 1 
transid 192347 /dev/sdb1
[41005.696173] btrfs: enabling auto recovery
[41005.698539] btrfs: mismatching generation and generation_v2 found in 
root item. This root was probably mounted with an older kernel. 
Resetting all new fields.
[41005.698732] btrfs: mismatching generation and generation_v2 found in 
root item. This root was probably mounted with an older kernel. 
Resetting all new fields.
[41005.699307] btrfs: bdev /dev/sdb1 errs: wr 0, rd 0, flush 0, corrupt 
20, gen 0
[41005.741978] Btrfs detected SSD devices, enabling SSD mode
[41005.742459] btrfs bad tree block start 0 29450240
[41005.742514] btrfs bad tree block start 0 29450240

All the other tools (btrfs-restore, btrfsck, restore from Josef) gave me 
the same results as I  have written in my 1st mail.

Sadly I have realized, that some of my vacation pictures are still on 
the SSD - without backup...  :-(


Best regards
Alfred
