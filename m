Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:62778 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124AbaBJTi1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Feb 2014 14:38:27 -0500
Received: by mail-la0-f53.google.com with SMTP id e16so5030964lan.26
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Feb 2014 11:38:24 -0800 (PST)
Received: from melforce.localnet (melforce.xtsubasa.org. [2a02:578:5002:8062::2])
        by mx.google.com with ESMTPSA id rt7sm16853333lbb.0.2014.02.10.11.38.22
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Mon, 10 Feb 2014 11:38:23 -0800 (PST)
From: Pavel Volkov <negaipub@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Re: Error: could not do orphan cleanup -22
Date: Mon, 10 Feb 2014 23:38:20 +0400
Message-ID: <2081514.jGOau8LjKu@melforce>
In-Reply-To: <2047669.QmpNhlvBGM@melforce>
References: <2047669.QmpNhlvBGM@melforce>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Monday 10 February 2014 00:20:54 you wrote:
> There was a similar discussion about an error in January 2013 but it related
> to some kernel panic. I don't know if I encountered the same thing.
> 
> These errors from system journal bother me:
> 
>  2月 09 22:18:53 melforce kernel: BTRFS error (device sdb3): Error removing
> orphan entry, stopping orphan cleanup 2月 09 22:18:53 melforce kernel: BTRFS
> critical (device sdb3): could not do orphan cleanup -22
> 
> I run kernel 3.12.10.

Some update.
I tested with kernel 3.13.2 and still have the problem.
Also, I don't have the errors in kernel log anymore but now I can't delete my 
snapshots!

melforce mnt # ls btr2
home  vap-snap1  vap-snap2  var

melforce mnt # btrfs sub list btr2
ID 257 gen 6294 top level 5 path home
ID 258 gen 6294 top level 5 path var
ID 939 gen 6153 top level 5 path vap-snap1
ID 940 gen 6154 top level 5 path vap-snap2

melforce mnt # btrfs sub delete btr2/var-snap2
ERROR: error accessing 'btr2/var-snap2'

My /mnt/btr2/var is also mounted on /var.

There's plenty of space left on device (only ~590 GB allocated on 2.6 TB 
volume):

# btrfs fi df btr2
Data, single: total=591.01GiB, used=590.64GiB
System, DUP: total=8.00MiB, used=96.00KiB
System, single: total=4.00MiB, used=0.00
Metadata, DUP: total=1.50GiB, used=989.41MiB
Metadata, single: total=8.00MiB, used=0.00

# btrfs fi show 
Label: melforce_hdd  uuid: c3f3a649-d8c3-49e1-9962-9b3ca9f54f1d
        Total devices 1 FS bytes used 591.61GiB
        devid    1 size 2.61TiB used 594.04GiB path /dev/sdb3
