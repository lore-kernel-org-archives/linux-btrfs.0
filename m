Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:34644 "EHLO
	mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172AbcAAUHG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Jan 2016 15:07:06 -0500
Received: by mail-io0-f179.google.com with SMTP id 1so67731351ion.1
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Jan 2016 12:07:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <9E462AAE-481A-4A0D-9918-FF56A73D6F6D@rasmusa.net>
References: <9E462AAE-481A-4A0D-9918-FF56A73D6F6D@rasmusa.net>
Date: Fri, 1 Jan 2016 13:07:04 -0700
Message-ID: <CAJCQCtSCJ91FaJ20g-+TKMwGkXeQdEkn1yDf6w+H3=V_8_xshA@mail.gmail.com>
Subject: Re: Add big device, remove small device, read-only
From: Chris Murphy <lists@colorremedies.com>
To: Rasmus Abrahamsen <btrfs@rasmusa.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 1, 2016 at 4:47 AM, Rasmus Abrahamsen <btrfs@rasmusa.net> wrote:
> Happy New Year!
>
> I have a raid with a 1TB, .5TB, 1.5TB and recently added a 4TB and want to remove the 1.5TB. When saying btrfs dev delete it turned into readonly. I am on 4.2.5-1-ARCH and btrfs-progs v4.3.1 what can I do?

btrfs fi show
lsblk -f
btrfs fi usage <pathtomountpointforbtrfsvolumeunderdiscussion>


he remove, so I did --since=yesterday
> I am looking at the log now, please stnad by.
> This is my log
> http://pastebin.com/mCPi3y9r

What's this?

Dec 31 15:03:56 rasmusahome systemd-udevd[6340]: inotify_add_watch(9,
/dev/sdd1, 10) failed: No space left on device
Dec 31 15:04:01 rasmusahome kernel:  sdd: sdd1
Dec 31 15:04:01 rasmusahome systemd-udevd[6341]: inotify_add_watch(9,
/dev/sdd1, 10) failed: No space left on device
Dec 31 15:05:43 rasmusahome kernel: BTRFS info (device sdb1): disk
added /dev/sdd1

Why is udev first complaining about no space left on sdd1, but then
it's being added to the btrfs volume?



-- 
Chris Murphy
