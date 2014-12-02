Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f177.google.com ([209.85.220.177]:43862 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714AbaLBFrd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Dec 2014 00:47:33 -0500
Received: by mail-vc0-f177.google.com with SMTP id ij19so5411857vcb.36
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Dec 2014 21:47:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <547CE175.6060409@web.de>
References: <CAE8gLhm8Oma6kWdeJtdc1-U2e4+TJDzhmw2Vfr=CYwvJ78GRJQ@mail.gmail.com>
	<547CE175.6060409@web.de>
Date: Tue, 2 Dec 2014 06:47:32 +0100
Message-ID: <CAE8gLhmVRn1OPsMgXAPSxg=3ROvNig+73d6dZpTs6fAz-02G2A@mail.gmail.com>
Subject: Re: PROBLEM: #89121 BTRFS mixes up mounted devices with their snapshots
From: MegaBrutal <megabrutal@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Cc: Konstantin <newsbox1026@web.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2014-12-01 22:45 GMT+01:00 Konstantin <newsbox1026@web.de>:
>
> MegaBrutal schrieb am 01.12.2014 um 13:56:
>> Hi all,
>>
>> I've reported the bug I've previously posted about in "BTRFS messes up
>> snapshot LV with origin" in the Kernel Bug Tracker.
>> https://bugzilla.kernel.org/show_bug.cgi?id=89121
> Hi MegaBrutal. If I understand your report correctly, I can give you
> another example where this bug is appearing. It is so bad that it leads
> to freezing the system and I'm quite sure it's the same thing. I was
> thinking about filing a bug but didn't have the time for that yet. Maybe
> you could add this case to your bug report as well.
>
> The bug appears also when using mdadm RAID1 - when one of the drives is
> detached from the array then the OS discovers it and after a while (not
> directly, it takes several minutes) it appears under /proc/mounts:
> instead of /dev/md0p1 I see there /dev/sdb1. And usually after some hour
> or so (depending on system workload) the PC completely freezes. So
> discussion about the uniqueness of UUIDs or not, a crashing kernel is
> telling me that there is a serious bug.
>

Hmm, I also suspect our symptoms have the same root cause. It seems
the same thing happens: the BTRFS module notices another device with
the same file system and starts to report it as the root device. It
seems like it has no idea that it's part of a RAID configuration or
anything.
