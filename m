Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:36334 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224AbaK3Wbz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Nov 2014 17:31:55 -0500
Received: by mail-ig0-f177.google.com with SMTP id z20so7891085igj.4
        for <linux-btrfs@vger.kernel.org>; Sun, 30 Nov 2014 14:31:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CANBHLUh9nXu4-wexFJimBvL-FtwPXQ7MeURi3COskJf-YJqGQA@mail.gmail.com>
References: <547B5724.1060507@libero.it>
	<CANBHLUh9nXu4-wexFJimBvL-FtwPXQ7MeURi3COskJf-YJqGQA@mail.gmail.com>
Date: Sun, 30 Nov 2014 16:31:55 -0600
Message-ID: <CAE5mzvhOAi_Y2icLHOiUzG121ZALLZCTYhpjY8mkio3AyHrECA@mail.gmail.com>
Subject: Re: [RFC][PATCH v2] mount.btrfs helper
From: cwillu <cwillu@cwillu.com>
To: Dimitri John Ledkov <xnox@debian.org>
Cc: "kreijack@inwind.it" <kreijack@inwind.it>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>,
        Zygo Blaxell <zblaxell@furryterror.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In ubuntu, the initfs runs a btrfs dev scan, which should catch
anything that would be missed there.

On Sun, Nov 30, 2014 at 4:11 PM, Dimitri John Ledkov <xnox@debian.org> wrote:
> Hello,
>
> On 30 November 2014 at 17:43, Goffredo Baroncelli <kreijack@libero.it> wrote:
>> Hi all,
>>
>> this patch provides a "mount.btrfs" helper for the mount command.
>> A btrfs filesystem could span several disks. This helper scans all the
>> partitions to discover all the disks required to mount a filesystem.
>> So it would not necessary any-more to "scan" the partitions to mount a filesystem.
>>
>
> I would welcome this, as a general idea. At the moment in debian &
> ubuntu, btrfs tools package ships udev rules to call "btrfs scan"
> whenever device nodes appear.
>
> If scan is built into mount, I would be able to drop that udev rule.
> There are also some reports (not yet re-verified) that such udev rule
> is not effective, that is btrfs mount fails when attempted before udev
> has attempted to be run - e.g. from initrdless boot trying to mount
> btrfs systems before udev-trigger has been run (to process "cold-plug"
> events).
>
> --
> Regards,
>
> Dimitri.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
