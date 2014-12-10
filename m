Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:59361 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932087AbaLJSi5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Dec 2014 13:38:57 -0500
Received: by mail-wi0-f172.google.com with SMTP id n3so12180495wiv.17
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Dec 2014 10:38:56 -0800 (PST)
Message-ID: <5488938B.6030709@gmail.com>
Date: Wed, 10 Dec 2014 19:40:11 +0100
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Anand Jain <anand.jain@oracle.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH V2][BTRFS-PROGS] Don't use LVM snapshot device
References: <1417718382-6753-1-git-send-email-kreijack@inwind.it> <5487FBAF.9090902@oracle.com>
In-Reply-To: <5487FBAF.9090902@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/10/2014 08:52 AM, Anand Jain wrote:
> 
> 
>> This patch allows btrfs to skip LVM snapshot during the device scan
>> phase.
> 
>  Its better to generalize the problem and fix it. The fix here is very
>  specific to LVM use case. This does not work in cases where device is
>  cloned using dd (device is unmounted).

See patch #5; this aborts btrfs[progs] when two devices have the same
dev.uuid and fsid.

Unfortunately this patch doesn't work with "btrfs dev scan"; this
because each device is discovered/registered alone. See my patches about 
mount.btrfs for an alternative approach.

> As mentioned we need to depend on the device wwn as provided by the
> device target driver.
> 
> Thanks, Anand
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
