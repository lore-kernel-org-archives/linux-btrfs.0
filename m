Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:37271 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbbIQOwe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Sep 2015 10:52:34 -0400
Received: by wicfx3 with SMTP id fx3so30861332wic.0
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2015 07:52:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55F9C136.3080800@gmail.com>
References: <20150916144355.GA1285@invalid>
	<55F988A6.8070109@gmail.com>
	<CABL_Pd8nOj7B1_64Us+goP=corZkCtw_WJW8eMQpiP6iQpw=HA@mail.gmail.com>
	<55F9C136.3080800@gmail.com>
Date: Thu, 17 Sep 2015 15:52:33 +0100
Message-ID: <CAHb+SPDaU-FBD2b2UN+ecubZcmzX=7KKk_7PgstCpUgmVb=YuQ@mail.gmail.com>
Subject: Re: FYIO: A rant about btrfs
From: Aneurin Price <aneurin.price@gmail.com>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Martin Tippmann <martin.tippmann@gmail.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 16 September 2015 at 20:21, Austin S Hemmelgarn <ahferroin7@gmail.com> wrote:
> ZFS has been around for much longer, it's been mature and feature complete for more than a decade, and has had a long time to improve performance wise.  It is important to note though, that on low-end hardware, BTRFS can (and often does in my experience) perform better than ZFS, because ZFS is a serious resource hog (I have yet to see a stable ZFS deployment with less than 16G of RAM, even with all the fancy features turned off).

If you have a real example of ZFS becoming unstable with, say, 4 or
8GB of memory, that doesn't involve attempting deduplication (which I
guess is what you mean by 'all the fancy features') on a many-TB pool,
I'd be interested to hear about it. (Psychic debugger says 'possibly
somebody trying to use a large L2ARC on a pool with many/large zvols')

My home fileserver has been running zfs for about 5 years, on a system
maxed out at 4GB RAM. Currently up to ~9TB of data. The only stability
problems I ever had were towards the beginning when I was using
zfs-fuse because zfsonlinux wasn't ready then, *and* I was trying out
deduplication.

I have a couple of work machines with 2GB RAM and pools currently
around 2.5TB full; no problems with these either in the couple of
years they've been in use, though granted these are lightly loaded
machines since what they mostly do is receive backup streams.

Bear in mind that these are Linux machines, and zfsonlinux's memory
management is known to be inferior to ZFS on Solaris and FreeBSD
(because it does not integrate with the page cache and instead grabs a
[configurable] chunk of memory, and doesn't always do a great job of
dropping it in response to memory pressure).
