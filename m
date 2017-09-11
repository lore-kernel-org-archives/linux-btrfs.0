Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:32912 "EHLO
        mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750969AbdIKStK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Sep 2017 14:49:10 -0400
Received: by mail-io0-f177.google.com with SMTP id y123so32303279iod.0
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Sep 2017 11:49:09 -0700 (PDT)
Subject: Re: Storage and snapshots as historical yearly
To: =?UTF-8?Q?Sen=c3=a9n_Vidal_Blanco?= <senenvidal@sgisoft.com>,
        linux-btrfs@vger.kernel.org
References: <9208764.SjP1vfhOIA@pcsenen>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <07ff0aeb-d4a8-ffb9-3a13-695ab9b2e65f@gmail.com>
Date: Mon, 11 Sep 2017 14:49:05 -0400
MIME-Version: 1.0
In-Reply-To: <9208764.SjP1vfhOIA@pcsenen>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-09-11 14:17, Senén Vidal Blanco wrote:
> I am trying to implement a system that stores the data in a unit (A) with
> BTRFS format that is untouchable and that future files and folders created or
> modified are stored in another physical unit (B) with BTRFS format.
> Each year the new files will be moved to store A and start over.
>   
> The idea is that a duplicate of disk A can be made to keep it in a safe place
> and that the files stored there can not be modified until the mixture of (A) and
> (B) is made.
Before I get into anything further, I would like to comment that this is 
a very odd use case.  Yearly granularity doesn't make sense for backups 
unless you generate very little data throughout the year (otherwise 
backups will take forever) and can afford to lose multiple months of 
that data.

The timescale you're talking about combined with the requirement that 
files not be modifiable on A except during the times when you sync 
changes indicates you will probably be much better served by proper 
off-line archival storage than some online configuration as you appear 
to be trying to create.
>   
> I have looked for information on this but I do not see it very clear. Both
> "SEND" and "RECEIVE" do the opposite case to what interests me.
If you can afford to operate at a shorter timescale (even monthly), then 
BTRFS snapshots plus send and receive probably are one of the best 
options.  Perhaps you could explain your understanding of send and 
receive and why you think it won't work, and I (and possibly other 
people on the list as well) could confirm whether or not you understand 
correctly.
>   
> I have also seen that you could try to get a RAID 0 but I am afraid that the
> data in A will not remain intact if the system performs a "BALANCE" at some
> point and mixes data between (A) and (B).
>   
> It is assumed that both the (A) and (B) data will be displayed in the same
> structure transparently, for example in "/ home".
>   
> -------------------------------
> |             HOME            |
> | ------------   ------------ |
> | |          |   |          | |
> | |          |   |          | |
> | | DISK (A) |   | DISK (B) | |
> | |  BTRFS   |   |  BTRFS   | |
> | |          |   |          | |
> | ------------   ------------ |
> -------------------------------
What you are describing here is called an overlay or union mount. 
Source A would be your lower directory, and B would be your upper 
directory.  Unmodified data is passed through from the lower directory 
until a file is changed.  When changes are made to the overlay mount, 
they are reflected on the upper directory.  Special files called 
'whiteout' files are used in the upper directory to represent deleted items.

Unfortunately, I don't know of any overlay mount implementation that 
works correctly and reliably with BTRFS.  I know for a fact that 
OverlayFS (the upstream in-kernel implementation) does not work, and I 
believe that AUFS3 and UnionFS (the third-party options that are used by 
most LiveCD's) don't work either.  UnionFS-FUSE (a userspace 
implementation completely unrelated to UnionFS) might work, but I've 
never tested it and it will likely have performance issues because it's 
implemented in userspace.  As far as I know, whiteout support is the 
primary missing piece here, but I may be mistaken.

Alternatively, this could be done with a seed device.  The concept is 
pretty similar to an overlay mount, but it operates at a lower level, 
and it's a BTRFS specific feature.  Unfortunately, it's not well 
documented, and I'm not confident that I could explain how to do it 
correctly.
