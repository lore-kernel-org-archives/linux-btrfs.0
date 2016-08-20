Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:34985 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752835AbcHTPVJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 20 Aug 2016 11:21:09 -0400
Received: by mail-oi0-f41.google.com with SMTP id 4so100404912oih.2
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Aug 2016 08:21:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMPo9spd+GF18K7sDZDsfvqLQJYwt_YuYM_05KOnVFmw_Vsrhw@mail.gmail.com>
References: <CAMPo9spd+GF18K7sDZDsfvqLQJYwt_YuYM_05KOnVFmw_Vsrhw@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 20 Aug 2016 09:21:03 -0600
Message-ID: <CAJCQCtTQAG+0M9AsNj5LNWXTAKd8V-6DL=5kS80dPt59S1uiAA@mail.gmail.com>
Subject: Re: Mixing partitioned and non-partitioned discs in a RAID?
To: =?UTF-8?B?QmVhcmNhdCDFnsOhbmRvcg==?= <bearcatsandor@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 19, 2016 at 10:00 PM, Bearcat Şándor
<bearcatsandor@gmail.com> wrote:
> I have a btrfs non-raid file system that i'd like to convert to
> raid10. This single device has my efi boot partion on it, so it's
> partitioned into sda1 and sda2. I have 3 other discs (sdc-sde) that
> i'd like to make partition-less systems and then add them to the first
> disc (sda) using the steps in the conversion section of the wiki
> (https://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devices#Conversion).
>
> My concern in that i'll be mixing a partitioned and partition-less
> system.  Will that work or will i hose myself?

That will work, but you'll likely be in a hosed situation later should
you ever lose a drive so I don't recommend this layout.

a. You have the ESP on only one drive, so it's still a single point of
failure. If that drive dies you can't boot. There are various ways
around that but they all pretty much suck right now from an end user
perspective. Basically redundant boot on UEFI with Linux right now is
pretty much shit. You have to be a bootloader expert to set it up,
maintain it with software updates, and fix it should things go bad.

b. Current udev and btrfs device ready code means degraded boot isn't
possible, because any missing device means the volume isn't ready, so
systemd won't even try to mount it (even with -o degraded). If you
deleted this udev rule, you run the risk of some boots sometimes
having a slightly delayed drive becoming available and the volume
wrongly being mounted degraded when it's not necessary. And since
Btrfs does not automatically fix up delayed devices later, you run the
risk of data loss later on; or worse, corruption of the entire file
system is possible if more than one device becomes stale at the same
time.

Between a. and b. it requires so much attention that it's just not
worth it at all. If you're really doing this to avoid downtime and the
ability to reboot degraded, the only two fairly easy and reliable ways
to do this on UEFI is firmware or hardware RAID. Firmware RAID permits
assembly of the RAID in firmware, so even the ESP can be mirrored, and
then there's a handoff during boot to the md driver during normal
operation and is managed by mdadm.


-- 
Chris Murphy
