Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:59404 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750970AbeCIGku (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Mar 2018 01:40:50 -0500
Date: Thu, 8 Mar 2018 22:38:09 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Andrei Borzenkov <arvidjaar@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Inconsistence between sender and receiver
Message-ID: <20180309053808.GD26754@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
Reply-To: bo.li.liu@oracle.com
References: <20180307184930.GA26754@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
 <1a7f0c8f-9bf1-b6eb-ff5c-517d935b84e8@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1a7f0c8f-9bf1-b6eb-ff5c-517d935b84e8@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 08, 2018 at 09:15:50AM +0300, Andrei Borzenkov wrote:
> 07.03.2018 21:49, Liu Bo пишет:
> > Hi,
> > 
> > In the following steps[1], if <parent> on receiver side has got
> > changed via 'btrfs property set', then after doing incremental
> > updates, receiver gets a different snapshot from what sender has sent.
> > 
> > The reason behind it is that there is no change about file 'foo' in
> > the send stream, such that receiver simply creates a snapshot of
> > <parent> on its side with nothing to apply from the send stream.
> > 
> > A possible way to avoid this is to check rtransid and ctranid of
> > <parent> on receiver side, but I'm not very sure whether the current
> > behavior is made deliberately, does anyone have an idea? 
> > 
> > Thanks,
> > 
> > -liubo
> > 
> > [1]:
> > $ btrfs sub create /mnt/send/sub
> > $ touch /mnt/send/sub/foo
> > $ btrfs sub snap -r /mnt/send/sub /mnt/send/parent
> > 
> > # send parent out
> > $ btrfs send /mnt/send/parent | btrfs receive /mnt/recv/
> > 
> > # change parent and file under it
> > $ btrfs property set -t subvol /mnt/recv/parent ro false
> 
> Is removing the ability to modify read-only property an option? What are
> use cases for it? What can it do that "btrfs sub snap read-only
> writable" cannot?
>

Tbh, I don't know any usecase for that, I just wanted to toggle off
the ro bit in order to change something inside <parent>.

> > $ truncate -s 4096 /mnt/recv/parent/foo
> > 
> > $ btrfs sub snap -r /mnt/send/sub /mnt/send/update
> > $ btrfs send -p /mnt/send/parent /mnt/send/update | btrfs receive /mnt/recv
> > 
> 
> This should fail right away because /mnt/send/parent is not read-only.
> If it does not, this is really a bug.
>

It's not '/mnt/send/parent', but '/mnt/recv/parent' got changed.

Thanks,

-liubo

> Of course one may go one step further and set /mnt/send/parent read-only
> again, then we get this issue.
> 
> > $ ls -l /mnt/send/update
> > total 0
> > -rw-r--r-- 1 root root 0 Mar  6 11:13 foo
> > 
> > $ ls -l /mnt/recv/update
> > total 0
> > -rw-r--r-- 1 root root 4096 Mar  6 11:14 foo
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
