Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:58336 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750914AbeCIGmF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Mar 2018 01:42:05 -0500
Date: Thu, 8 Mar 2018 22:39:26 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Filipe Manana <fdmanana@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Inconsistence between sender and receiver
Message-ID: <20180309053925.GE26754@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
Reply-To: bo.li.liu@oracle.com
References: <20180307184930.GA26754@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
 <CAL3q7H4JxSCi_qESBDK4o7wvbjDV1yNQz=9cst91hSnfYQ9opw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H4JxSCi_qESBDK4o7wvbjDV1yNQz=9cst91hSnfYQ9opw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 08, 2018 at 03:29:48PM +0000, Filipe Manana wrote:
> On Wed, Mar 7, 2018 at 6:49 PM, Liu Bo <bo.li.liu@oracle.com> wrote:
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
> > $ truncate -s 4096 /mnt/recv/parent/foo
> >
> > $ btrfs sub snap -r /mnt/send/sub /mnt/send/update
> > $ btrfs send -p /mnt/send/parent /mnt/send/update | btrfs receive /mnt/recv
> >
> > $ ls -l /mnt/send/update
> > total 0
> > -rw-r--r-- 1 root root 0 Mar  6 11:13 foo
> >
> > $ ls -l /mnt/recv/update
> > total 0
> > -rw-r--r-- 1 root root 4096 Mar  6 11:14 foo
> 
> Interesting. I wasn't aware of that and I'm surprised too, I wouldn't
> expect that behaviour (and I must see the code to figure out why it
> behaves like that).

The code about comparing rtransid and ctransid does exist in
cmds-receive.c, but had been commented.

Thanks,

-liubo
