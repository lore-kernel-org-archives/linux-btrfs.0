Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f41.google.com ([209.85.213.41]:48456 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbaKZFL3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Nov 2014 00:11:29 -0500
Received: by mail-yh0-f41.google.com with SMTP id a41so999835yho.0
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Nov 2014 21:11:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan$8a1fe$cae59052$c5e19c35$9858d5fc@cox.net>
References: <27BDAC3B-789C-4477-B065-E703CE425F54@colorremedies.com>
	<546B68F8.6080008@ubuntu.com>
	<FC0BA13C-21E3-44DD-A87C-4BEAE4FBF9EA@colorremedies.com>
	<546BA96D.4050805@ubuntu.com>
	<2A57F99C-80AA-4FD4-AA41-57F02AD4E1A2@colorremedies.com>
	<546CB531.2060509@ubuntu.com>
	<20141121042814.GR17395@hungrycats.org>
	<5470C92E.1070607@inwind.it>
	<20141123001927.GO17380@hungrycats.org>
	<5474AF87.6090702@inwind.it>
	<20141125202948.GP17380@hungrycats.org>
	<5474FBD9.5070709@inwind.it>
	<pan$8a1fe$cae59052$c5e19c35$9858d5fc@cox.net>
Date: Tue, 25 Nov 2014 22:11:28 -0700
Message-ID: <CAJCQCtRn7d4PHWJMexOA3SLhOnNMREk7N8aZR4VGXZbxeqpgRw@mail.gmail.com>
Subject: Re: BTRFS messes up snapshot LV with origin
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 25, 2014 at 8:22 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> From my perspective, however, btrfs is simply incompatible with lvm
> snapshots, because the basic assumptions are incompatible.  Btrfs assumes
> UUIDs will be exactly what they say on the label, /unique/, while lvm's
> snapshot feature directly breaks that uniqueness by copying the (former)
> UUID, thus making the former UUID no longer unique and thus no longer
> truly UUID.

The seed device has a mechanism to change volume UUID without
rewriting a bunch of stuff in the original, the gotcha is that it
requires adding a device.

man fsfreeze says "fsfreeze is unncessary for device-mapper devices.
The device-mapper (and LVM) automatically freezes filesystem on the
device when a snapshot creation is requested." So if it's possible to
communicate snapshotting/freezing to the fs at snapshot time, then
maybe btrfs could 'btrfstune -S 1' the volume in the snapshot. That
way that snapshot actually contains a btrfs seed device, which is read
only. At least the snapshot copy isn't going to get obliterated in an
accident; even though most people would probably want the origin LV to
be protected while considering the snapshot disposable.



-- 
Chris Murphy
