Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailer.moparisthebest.com ([144.76.72.168]:38220 "EHLO
        mailer.moparisthebest.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758049AbcILNcm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Sep 2016 09:32:42 -0400
Subject: Re: btrfs kernel oops on mount
To: linux-btrfs@vger.kernel.org
References: <6fa4d5f1-1697-8817-c1b8-098afc011902@moparisthebest.com>
 <48fdc597-2431-0335-a6e5-da413615ecd0@gmail.com>
 <a6bbb384-f51a-34f8-0789-27a9945a20f6@moparisthebest.com>
 <e659931f-5af8-b60c-b71a-4dbf24a44c1d@gmail.com>
From: moparisthebest <admin@moparisthebest.com>
Message-ID: <8b56b4dd-3095-d59c-3760-a34fabb3d1f7@moparisthebest.com>
Date: Mon, 12 Sep 2016 09:32:30 -0400
MIME-Version: 1.0
In-Reply-To: <e659931f-5af8-b60c-b71a-4dbf24a44c1d@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/12/2016 07:37 AM, Austin S. Hemmelgarn wrote:
>> On 2016-09-09 15:23, moparisthebest wrote:
>> Didn't ubuntu on kernel 4.4 die in the same can_overcommit function?
>> (https://www.moparisthebest.com/btrfsoops.jpg) what kind of hardware
>> issues would cause a repeatable kernel crash like that?  Like am I
>> looking at memory issues or the SAS controller or what?
> It doesn't look like it died in can_overcommit, as that's not anywhere
> on the stack trace.  The second item on the stack though
> (btrfs_async_reclaim_metadata_space) at least partly reinforces the
> suspicion that something is messed up in the filesystems metadata (which
> could explain the allocations in GlobalReserve, which is a subset of the
> Metadata chunks).  It looks like each crash was in a different place,
> but at least the first two could easily be different parts of the kernel
> choking on the same thing.  As far as the crash in can_overcommit, that
> combined with the apparent corrupted metadata makes me think there may
> be a hardware problem.  The first thing I'd check in that respect is the
> cabling to the drives themselves, followed by system RAM, the PSU, and
> the the storage controller.  I generally check in that order because
> it's trivial to check the cabling, and not all that difficult to check
> the RAM and PSU (and RAM is more likely to go bad than the PSU), and
> properly checking a storage controller is extremely dificult unless you
> have another known working one you can swap it for (and even then, it's
> only practical to check if you know the state on disk won't cause the
> kernel to choke).

The first RIP: line (https://www.moparisthebest.com/btrfsoops.jpg) ends
in 'can_overcommit+0x1e/0xf0 [btrfs]', apologies for that being a
literal picture of a CRT instead of a searchable text file, doesn't
exactly make things easy... :(

Still I'm relieved that more points to bad metadata than to bad hardware.
