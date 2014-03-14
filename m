Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:63929 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755117AbaCNOoq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Mar 2014 10:44:46 -0400
Received: by mail-ie0-f174.google.com with SMTP id rp18so2634878iec.33
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Mar 2014 07:44:45 -0700 (PDT)
Message-ID: <532315E1.3060804@gmail.com>
Date: Fri, 14 Mar 2014 10:44:49 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: george@chinilu.com, Duncan <1i5t5.duncan@cox.net>,
        linux-btrfs@vger.kernel.org
Subject: Re: Incremental backup for a raid1
References: <1564384.fRV1HUkfCq@fuchsia>	<pan$60e7c$45de97e1$2fb9daeb$288befdc@cox.net>	<1549230.7yEi5AM4H9@fuchsia> <pan$4e795$762009e5$6f734697$16ccd0b0@cox.net> <5323082B.50600@chinilu.com>
In-Reply-To: <5323082B.50600@chinilu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014-03-14 09:46, George Mitchell wrote:
> Actually, an interesting concept would be to have the initial two drive
> RAID 1 mirrored by 2 additional drives in 4-way configuration on a
> second machine at a remote location on a private high speed network with
> both machines up 24/7.  In that case, if such a configuration would
> work, either machine could be obliterated and the data would survive
> fully intact in full duplex mode.  It would just need to be remounted
> from the backup system and away it goes.  Just thinking of interesting
> possibilities with n-way mirroring.  Oh how I would love to have n-way
> mirroring to play with!
That can already be done, albeit slightly differently by stacking btrfs
RAID 1 on top of a pair of DRBD devices.  Of course, this doesn't
provide quite the same degree of safety as your suggestion, but it does
work (and DRBD makes the remote copy write-mostly for the local system
automatically).
