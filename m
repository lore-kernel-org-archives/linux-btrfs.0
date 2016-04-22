Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:36741 "EHLO
	mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbcDVVAL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Apr 2016 17:00:11 -0400
Received: by mail-wm0-f44.google.com with SMTP id v188so34457077wme.1
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Apr 2016 14:00:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRUtwY8zcRMoq2xCVgm=_rTeU5zxvM4_=1VrYtva7m6iw@mail.gmail.com>
References: <022276ed-577c-5616-abc0-3e1a7644f31e@zoner.cz>
	<CAJCQCtRUtwY8zcRMoq2xCVgm=_rTeU5zxvM4_=1VrYtva7m6iw@mail.gmail.com>
Date: Fri, 22 Apr 2016 17:00:09 -0400
Message-ID: <CAD=QJKhDJ+OgwJXUv3Rizzs4jFtzt=4HwD9b7E6y324fd_vVHQ@mail.gmail.com>
Subject: Re: btrfs forced readonly + errno=-28 No space left
From: Nicholas D Steeves <nsteeves@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 21 April 2016 at 18:44, Chris Murphy <lists@colorremedies.com> wrote:
> On Thu, Apr 21, 2016 at 6:53 AM, Martin Svec <martin.svec@zoner.cz> wrote:
>> Hello,
>>
>> we use btrfs subvolumes for rsync-based backups. During backups btrfs often fails with "No space
>> left" error and goes to readonly mode (dmesg output is below) while there's still plenty of
>> unallocated space:
>
> Are you snapshotting near the time of enospc? If so it's a known
> problem that's been around for a while. There are some suggestions in
> the archives but I think the main thing is to back off on the workload
> momentarily, take the snapshot, and then resume the workload. I don't
> think it has to come to a complete stop but it's a lot more
> reproducible with heavy writes.

Is this known problem specific to heavy writes + take a snapshot + -o
compress (either zlib or lzo), or does this enospc also affect the
more simple heavy writes + take a snapshot case?  Is there a greater
likelyhood of running into it if using compression?

As for a workaround...is there a command like batch that can be used
to schedule things for periods of low IO?  Can a sync, btrfs fi sync
/mountpoint, or btrfs sub sync /sub_mountpoint before taking a
snapshot prevent it?  If the answer to all of these is no, which of
the following would be a good candidate for adding this support to:
http://gnqs.sourceforge.net/docs/starter_pack/alternatives/index.html

Best regards,
Nicholas
