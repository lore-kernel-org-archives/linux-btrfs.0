Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:35295 "EHLO
	mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468AbcBIUjU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Feb 2016 15:39:20 -0500
Received: by mail-io0-f181.google.com with SMTP id d63so170676ioj.2
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Feb 2016 12:39:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAKr9ZMFwxZ01gw7SAyFReOfXFb=hVzUXNgYoGcUc2xzLuo+9mg@mail.gmail.com>
References: <CAKr9ZMFwxZ01gw7SAyFReOfXFb=hVzUXNgYoGcUc2xzLuo+9mg@mail.gmail.com>
Date: Tue, 9 Feb 2016 13:39:20 -0700
Message-ID: <CAJCQCtQCadspcPie_f6nv=MvC=2=PxxpLbLqtkD3_hBjkBs-zw@mail.gmail.com>
Subject: Re: BTRFS RAM requirements, RAID 6 stability/write holes and
 expansion questions
From: Chris Murphy <lists@colorremedies.com>
To: Mackenzie Meyer <snackmasterx@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 5, 2016 at 12:36 PM, Mackenzie Meyer <snackmasterx@gmail.com> wrote:

>
> RAID 6 write holes?

I don't even understand the nature of the write hole on Btrfs. If
modification is still always COW, then either an fs block, a strip, or
whole stripe write happens, I'm not sure where the hole comes from. It
suggests some raid56 writes are not atomic.

If you're worried about raid56 write holes, then a.) you need a server
running this raid where power failures or crashes don't happen b.)
don't use raid56 c.) use ZFS.


> RAID 6 stability?
> Any articles I've tried looking for online seem to be from early 2014,
> I can't find anything recent discussing the stability of RAID 5 or 6.
> Are there or have there recently been any data corruption bugs which
> impact RAID 6? Would you consider RAID 6 safe/stable enough for
> production use?

It's not stable for your use case, if you have to ask others if it's
stable enough for your use case. Simple as that. Right now some raid6
users are experiencing remarkably slow balances, on the order of
weeks. If device replacement rebuild times are that long, I'd say it's
disqualifying for most any use case, just because there are
alternatives that have better fail over behavior than this. So far
there's no word from any developers what the problem might be, or
where to gather more information. So chances are they're already aware
of it but haven't reproduced it, or isolated it, or have a fix for it
yet.

If you're prepared to make Btrfs better in the event you have a
problem, with possibly some delay in getting that volume up and
running again (including the likelihood of having to rebuild it from a
backup), then it might be compatible with your use case.

> Do you still strongly recommend backups, or has stability reached a
> point where backups aren't as critical? I'm thinking from a data
> consistency standpoint, not a hardware failure standpoint.

You can't separate them. On completely stable hardware, stem to stern,
you'd have no backups, no Btrfs or ZFS, you'd just run linear/concat
arrays with XFS, for example. So you can't just hand wave the hardware
part away. There are bugs in the entire storage stack, there are
connectors that can become intermittent, the system could crash. All
of these affect data consistency.

Stability has not reach a point where backups aren't as critical. I
don't really even know what that means though. No matter Btrfs or not,
you need to be doing backups such that if the primary stack is a 100%
loss without notice, is not a disaster. Plan on having to use it. If
you don't like the sound of that, look elsewhere.


> I plan to start with a small array and add disks over time. That said,
> currently I have mostly 2TB disks and some 3TB disks. If I replace all
> 2TB disks with 3TB disks, would BTRFS then start utilizing the full
> 3TB capacity of each disk, or would I need to destroy and rebuild my
> array to benefit from the larger disks?

Btrfs, or LVM raid, or  mdraid, and ZFS all let you grow arrays, each
has different levels of ease of doing this and how long it will take,
without having to recreate the file system from scratch.


-- 
Chris Murphy
