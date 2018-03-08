Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f43.google.com ([209.85.215.43]:42129 "EHLO
        mail-lf0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965204AbeCHGPy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Mar 2018 01:15:54 -0500
Received: by mail-lf0-f43.google.com with SMTP id t204-v6so6737350lff.9
        for <linux-btrfs@vger.kernel.org>; Wed, 07 Mar 2018 22:15:54 -0800 (PST)
Subject: Re: Inconsistence between sender and receiver
To: bo.li.liu@oracle.com, linux-btrfs@vger.kernel.org
References: <20180307184930.GA26754@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <1a7f0c8f-9bf1-b6eb-ff5c-517d935b84e8@gmail.com>
Date: Thu, 8 Mar 2018 09:15:50 +0300
MIME-Version: 1.0
In-Reply-To: <20180307184930.GA26754@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

07.03.2018 21:49, Liu Bo пишет:
> Hi,
> 
> In the following steps[1], if <parent> on receiver side has got
> changed via 'btrfs property set', then after doing incremental
> updates, receiver gets a different snapshot from what sender has sent.
> 
> The reason behind it is that there is no change about file 'foo' in
> the send stream, such that receiver simply creates a snapshot of
> <parent> on its side with nothing to apply from the send stream.
> 
> A possible way to avoid this is to check rtransid and ctranid of
> <parent> on receiver side, but I'm not very sure whether the current
> behavior is made deliberately, does anyone have an idea? 
> 
> Thanks,
> 
> -liubo
> 
> [1]:
> $ btrfs sub create /mnt/send/sub
> $ touch /mnt/send/sub/foo
> $ btrfs sub snap -r /mnt/send/sub /mnt/send/parent
> 
> # send parent out
> $ btrfs send /mnt/send/parent | btrfs receive /mnt/recv/
> 
> # change parent and file under it
> $ btrfs property set -t subvol /mnt/recv/parent ro false

Is removing the ability to modify read-only property an option? What are
use cases for it? What can it do that "btrfs sub snap read-only
writable" cannot?

> $ truncate -s 4096 /mnt/recv/parent/foo
> 
> $ btrfs sub snap -r /mnt/send/sub /mnt/send/update
> $ btrfs send -p /mnt/send/parent /mnt/send/update | btrfs receive /mnt/recv
> 

This should fail right away because /mnt/send/parent is not read-only.
If it does not, this is really a bug.

Of course one may go one step further and set /mnt/send/parent read-only
again, then we get this issue.

> $ ls -l /mnt/send/update
> total 0
> -rw-r--r-- 1 root root 0 Mar  6 11:13 foo
> 
> $ ls -l /mnt/recv/update
> total 0
> -rw-r--r-- 1 root root 4096 Mar  6 11:14 foo
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

