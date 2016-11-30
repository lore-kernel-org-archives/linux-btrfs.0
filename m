Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:34939 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1422849AbcK3S7x (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Nov 2016 13:59:53 -0500
Received: by mail-yw0-f196.google.com with SMTP id b66so15185132ywh.2
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Nov 2016 10:59:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20161130190404.4f0e4bd5@natsu>
References: <10bbbf97-7f43-c972-a832-4a8cf054d5e5@xgm.de> <4ef63089-407d-0f18-b182-74c631874a02@gmail.com>
 <0d3d3ecd-44a4-fb7f-8f68-aca342d89d04@googlemail.com> <CAJCQCtSnt5yqm6kpA2AOz7p=wZFVxzUz8RH8r2o73ym45mYVFg@mail.gmail.com>
 <fce2df8b-0775-1ecf-c08d-960018822c20@googlemail.com> <20161130103808.74e5ae95@natsu>
 <d9a72702-0507-c085-3bed-7ee5f8063ae3@gmail.com> <20161130190404.4f0e4bd5@natsu>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 30 Nov 2016 11:59:51 -0700
Message-ID: <CAJCQCtTQmJ5rE5GqntDBZwuq4TqgbJJa_uWDie1nFG+mTvfHaQ@mail.gmail.com>
Subject: Re: Convert from RAID 5 to 10
To: Roman Mamedov <rm@romanrm.net>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Wilson Meier <wilson.meier@gmail.com>,
        Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 30, 2016 at 7:04 AM, Roman Mamedov <rm@romanrm.net> wrote:
> On Wed, 30 Nov 2016 07:50:17 -0500

> Also I don't know what is particularly insane about copying a 4-8 GB file onto
> a storage array. I'd expect both disks to write at the same time (like they
> do in pretty much any other RAID1 system), not one-after-another, effectively
> slowing down the entire operation by as much as 2x in extreme cases.

I don't experience this behavior. Writes take the same amount of time
to single profile volume as a two device raid1 profile volume. iotop
reports 2x the write bandwidth when writing to the raid1 volume, which
corresponds to simultaneous writes to both drives in the volume. It's
also not an elaborate setup by any means: two laptop drives, each in
cheap USB 3.0 cases using bus power only, connected to a USB 3.0 hub,
in turn connected to an Intel NUC.


>
> Comparing to Ext4, that one appears to have the "errors=continue" behavior by
> default, the user has to explicitly request "errors=remount-ro", and I have
> never seen anyone use or recommend the third option of "errors=panic", which
> is basically the equivalent of the current Btrfs practce.

I think in the context of degradedness, it may be appropriate to mount
degraded,ro by default rather than fail. But changing the default
isn't enough for the root fs use case, because the mount command isn't
even issued when udev's btrfs 'dev scan' fails to report back all
devices available. In this case there is a sort of "pre check" before
even mounting is attempted, and that is what fails.

Also,  Btrfs has fatal_errors=panic and it's not the default. Rather,
we just get mount failure. There really isn't anything quite like this
in the mdadm/lvm + other file system world where the array is active
degraded and the file system mounts anyway; if it doesn't mount it's
because the array isn't active, and doesn't even exist yet.


> Unplugging and replugging a SATA cable of a RAID1 member should never put your
> system under the risk of a massive filesystem corruption; you cannot say it
> absolutely doesn't with the current implementation.

I can't say it absolutely doesn't even with md. Of course it
shouldn't, but users do report corruptions on all of the other fs
lists (ext4, XFS, linux-raid) from time to time that are not the
result of user error.




-- 
Chris Murphy
