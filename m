Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-18-i2.italiaonline.it ([212.48.25.198]:50660 "EHLO
	smtp-18.italiaonline.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933151AbaLJVCV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Dec 2014 16:02:21 -0500
Message-ID: <5488B526.1070102@inwind.it>
Date: Wed, 10 Dec 2014 22:03:34 +0100
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Robert White <rwhite@pobox.com>
CC: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: get more accurate output in fd command.
References: <B3CDA0F0-14F7-4539-B7FF-B2D2E5F7CAF2@colorremedies.com>	<1418124037-8210-1-git-send-email-yangds.fnst@cn.fujitsu.com>	<548743CE.1020403@inwind.it> <54879CFE.1090909@cn.fujitsu.com>	<54882634.4000809@pobox.com> <pan$5a1c1$2e13a998$8c1ffe18$ead381f2@cox.net> <5488AEBD.7030601@pobox.com>
In-Reply-To: <5488AEBD.7030601@pobox.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/10/2014 09:36 PM, Robert White wrote:
[...]
> I tested it and sure enough, it's RAID1...
> 
> I also noticed that the default for data goes from single to RAID0 in
> a two slice build.
> 
> I generally don't expect defaults to change in undocumented ways.
> Particularly since that makes make-plus-add orthogonal to
> make-as-multi.
> 
> Without other guidance I'd been assuming that
> 
> mkfs.btrfs d1 d2 d3 ... 
> --vs-- 
> mkfs.btrfs d1 
> btrfs dev add d2 
> btrfs dev add d3 ...
> 
> would net the same resultant system. I have only ever done the latter
> until today.
> 
> Does/Will the defaults change when three, four, or more slices are
> used to build the system?
> 
> I'll take a stab at updating the manual page.

Why not printing from mkfs.btrfs the raid profiles used ?


> 
> -- Rob.
> 
> 
> -- To unsubscribe from this list: send the line "unsubscribe
> linux-btrfs" in the body of a message to majordomo@vger.kernel.org 
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
