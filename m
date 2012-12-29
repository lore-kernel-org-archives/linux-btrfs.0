Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:43613 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070Ab2L2Pi7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Dec 2012 10:38:59 -0500
Received: by mail-pb0-f44.google.com with SMTP id uo1so6377911pbc.3
        for <linux-btrfs@vger.kernel.org>; Sat, 29 Dec 2012 07:38:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CACCfv7r5zVx7UGWNLyeHT9t6VT8rWW8WgQwAb+ffjiUOyi6C2g@mail.gmail.com>
References: <CACCfv7ot+WTV1eiBCujcyPkSt7SGqVvVCKpFo4rn8Y=FEZu_7w@mail.gmail.com>
	<CAE5mzvhOMZopeVqb4A7PihLuyM2zo_ETN1G3wE_OJi27NfSzVg@mail.gmail.com>
	<CACCfv7oFanOd1Yg=UgqEVhfHbD=JGkGT3CZy9KpQMgrsWixX=w@mail.gmail.com>
	<CACCfv7r5zVx7UGWNLyeHT9t6VT8rWW8WgQwAb+ffjiUOyi6C2g@mail.gmail.com>
Date: Sat, 29 Dec 2012 09:38:59 -0600
Message-ID: <CAE5mzvjDycff5X7sL=WGPRcLi2BJOMVDE2gQZJmkVOSBhRsC_A@mail.gmail.com>
Subject: Re: parent transid verify failed on -- After moving btrfs closer to
 the beginning of drive with dd
From: cwillu <cwillu@cwillu.com>
To: Jordan Windsor <jordanw2@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Dec 29, 2012 at 7:14 AM, Jordan Windsor <jordanw2@gmail.com> wrote:
> Also here's the output of btrfs-find-root:
>
> ./btrfs-find-root /dev/sdb1
> Super think's the tree root is at 1229060866048, chunk root 1259695439872
> Went past the fs size, exiting
>
> Not sure where to go from here.

I can't say for certain, but that suggests that the move-via-dd didn't
succeed / wasn't correct, and/or the partitioning changes didn't
match, and/or the dd happened from a mounted filesystem (which would
also explain the transid errors, if there wasn't an unclean umount
involved).

btrfs-restore might be able to pick out files, but you may be in
restore-from-backup territory.
