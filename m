Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f44.google.com ([209.85.219.44]:36005 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499Ab3AUP4H (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Jan 2013 10:56:07 -0500
Received: by mail-oa0-f44.google.com with SMTP id n5so6251905oag.3
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Jan 2013 07:56:04 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 21 Jan 2013 15:48:04 +0000
Message-ID: <CAJ-05NPaeLsv5YL3eSYtL-Kc5Sh-2xECJKFFa8z=cnMjdy7GyQ@mail.gmail.com>
Subject: Tracking down causes of btrfs thread activity
From: =?UTF-8?B?QWxleCBCZW5uw6ll?= <kernel-hacker@bennee.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I've been running btrfs on one of my machines for a few months now but
I keep hitting performance issues. My system quite frequently freezes
due to IO starvation. Looking at iotop it tends to show the large
majority of the disk I/O being taken up with various btrfs tasks
peeking at 7-8M/s, namely:

    btrfs-endio-wri
    btrfs-delayed-m
    btrfs-transacti
    btrfs-cleaner

I've already tracked down some sub-optimal performance to the fact I'm
hosting a large number of RRDs which I've attempted to mitigate with
moving them to a nocow sub-volume and performing the appropriate
chattr magic on the host directories. However I'm still seeing these
spikes occur at seemingly random times.

My next suspect is our build directories which contain about 400Mb of
build artefacts that are shuffled around each build. However before
going through a tedious exercise of eliminating all sources of I/O on
the machine some questions:

Is there is any way to identify the higher level file activity behind
the btrfs kernel threads?
Would it be possible to hook into some of the btrfs code paths with
perf to dump something like this?

Secondary questions:

Does a truncate and write of an existing file (as a build would do)
trigger a cow event?
What about a write($FILE~), rename ($FILE~, $FILE)?

I'm currently running 3.7 + the btrfs-next merged at the time I built it.

--
Alex, homepage: http://www.bennee.com/~alex/
