Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47816 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932131AbeCISLg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 9 Mar 2018 13:11:36 -0500
Date: Fri, 9 Mar 2018 19:09:14 +0100
From: David Sterba <dsterba@suse.cz>
To: Andrei Borzenkov <arvidjaar@gmail.com>
Cc: bo.li.liu@oracle.com, linux-btrfs@vger.kernel.org
Subject: Re: Inconsistence between sender and receiver
Message-ID: <20180309180914.GB23693@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180307184930.GA26754@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
 <1a7f0c8f-9bf1-b6eb-ff5c-517d935b84e8@gmail.com>
 <20180309053808.GD26754@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
 <060e33f0-e0b7-649d-8696-75e5a1f7ce85@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <060e33f0-e0b7-649d-8696-75e5a1f7ce85@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 09, 2018 at 09:45:30AM +0300, Andrei Borzenkov wrote:
> 09.03.2018 08:38, Liu Bo пишет:
> > On Thu, Mar 08, 2018 at 09:15:50AM +0300, Andrei Borzenkov wrote:
> >> 07.03.2018 21:49, Liu Bo пишет:
> >>> Hi,
> >>>
> >>> In the following steps[1], if <parent> on receiver side has got
> >>> changed via 'btrfs property set', then after doing incremental
> >>> updates, receiver gets a different snapshot from what sender has sent.
> >>>
> >>> The reason behind it is that there is no change about file 'foo' in
> >>> the send stream, such that receiver simply creates a snapshot of
> >>> <parent> on its side with nothing to apply from the send stream.
> >>>
> >>> A possible way to avoid this is to check rtransid and ctranid of
> >>> <parent> on receiver side, but I'm not very sure whether the current
> >>> behavior is made deliberately, does anyone have an idea? 
> >>>
> >>> Thanks,
> >>>
> >>> -liubo
> >>>
> >>> [1]:
> >>> $ btrfs sub create /mnt/send/sub
> >>> $ touch /mnt/send/sub/foo
> >>> $ btrfs sub snap -r /mnt/send/sub /mnt/send/parent
> >>>
> >>> # send parent out
> >>> $ btrfs send /mnt/send/parent | btrfs receive /mnt/recv/
> >>>
> >>> # change parent and file under it
> >>> $ btrfs property set -t subvol /mnt/recv/parent ro false
> >>
> >> Is removing the ability to modify read-only property an option? What are
> >> use cases for it? What can it do that "btrfs sub snap read-only
> >> writable" cannot?
> >>
> > 
> > Tbh, I don't know any usecase for that, I just wanted to toggle off
> > the ro bit in order to change something inside <parent>.
> > 
> >>> $ truncate -s 4096 /mnt/recv/parent/foo
> >>>
> >>> $ btrfs sub snap -r /mnt/send/sub /mnt/send/update
> >>> $ btrfs send -p /mnt/send/parent /mnt/send/update | btrfs receive /mnt/recv
> >>>
> >>
> >> This should fail right away because /mnt/send/parent is not read-only.
> >> If it does not, this is really a bug.
> >>
> > 
> > It's not '/mnt/send/parent', but '/mnt/recv/parent' got changed.
> > 
> 
> Ah, sorry.
> 
> What happened to this patch which clears received_uuid when ro is
> flipped off?
> 
> https://patchwork.kernel.org/patch/9986521/

There are still things to fix:

"Shouldn't we also wipe the other related fields here, like stime, rtime,
stransid, rtransid?"
