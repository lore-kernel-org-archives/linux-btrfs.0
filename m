Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f175.google.com ([209.85.217.175]:46678 "EHLO
        mail-ua0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754678AbeCHP3t (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Mar 2018 10:29:49 -0500
Received: by mail-ua0-f175.google.com with SMTP id d1so24724ual.13
        for <linux-btrfs@vger.kernel.org>; Thu, 08 Mar 2018 07:29:49 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20180307184930.GA26754@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
References: <20180307184930.GA26754@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
From: Filipe Manana <fdmanana@gmail.com>
Date: Thu, 8 Mar 2018 15:29:48 +0000
Message-ID: <CAL3q7H4JxSCi_qESBDK4o7wvbjDV1yNQz=9cst91hSnfYQ9opw@mail.gmail.com>
Subject: Re: Inconsistence between sender and receiver
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 7, 2018 at 6:49 PM, Liu Bo <bo.li.liu@oracle.com> wrote:
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
> $ truncate -s 4096 /mnt/recv/parent/foo
>
> $ btrfs sub snap -r /mnt/send/sub /mnt/send/update
> $ btrfs send -p /mnt/send/parent /mnt/send/update | btrfs receive /mnt/recv
>
> $ ls -l /mnt/send/update
> total 0
> -rw-r--r-- 1 root root 0 Mar  6 11:13 foo
>
> $ ls -l /mnt/recv/update
> total 0
> -rw-r--r-- 1 root root 4096 Mar  6 11:14 foo

Interesting. I wasn't aware of that and I'm surprised too, I wouldn't
expect that behaviour (and I must see the code to figure out why it
behaves like that).
No idea if it's intentional or not, but at a first glance it seems not.

>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

“Whether you think you can, or you think you can't — you're right.”
