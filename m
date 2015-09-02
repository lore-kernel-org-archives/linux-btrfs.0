Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cc-smtpout1.netcologne.de ([89.1.8.211]:40606 "EHLO
	cc-smtpout1.netcologne.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187AbbIBKe6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Sep 2015 06:34:58 -0400
Received: from cc-smtpin1.netcologne.de (cc-smtpin1.netcologne.de [89.1.8.201])
	by cc-smtpout1.netcologne.de (Postfix) with ESMTP id C2FDD123EE
	for <linux-btrfs@vger.kernel.org>; Wed,  2 Sep 2015 12:29:06 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by cc-smtpin1.netcologne.de (Postfix) with ESMTP id B49C711E2E
	for <linux-btrfs@vger.kernel.org>; Wed,  2 Sep 2015 12:29:06 +0200 (CEST)
Received: from [194.8.193.239] (helo=cc-smtpin1.netcologne.de)
	by localhost with ESMTP (eXpurgate 4.0.9)
	(envelope-from <crohmann@netcologne.de>)
	id 55e6cf72-095f-7f0000012729-7f000001ea8c-1
	for <linux-btrfs@vger.kernel.org>; Wed, 02 Sep 2015 12:29:06 +0200
Received: from [194.8.193.239] (sys-239.netcologne.de [194.8.193.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by cc-smtpin1.netcologne.de (Postfix) with ESMTPSA
	for <linux-btrfs@vger.kernel.org>; Wed,  2 Sep 2015 12:29:06 +0200 (CEST)
To: linux-btrfs@vger.kernel.org
From: Christian Rohmann <crohmann@netcologne.de>
Subject: How to properly and efficiently balance RAID6 after more drives are
 added?
Message-ID: <55E6CF72.5070005@netcologne.de>
Date: Wed, 2 Sep 2015 12:29:06 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello btrfs-enthusiasts,

I have a rather big btrfs RAID6 with currently 12 devices. It used to be
only 8 drives 4TB each, but I successfully added 4 more drives with 1TB
each at some point. What I am trying to find out, and that's my main
reason for posting this, is how to balance the data on the drives now.

I am wondering what I should read from this "btrfs filesystem show" output:

--- cut ---
        Total devices 12 FS bytes used 19.23TiB
        devid    1 size 3.64TiB used 3.64TiB path /dev/sdc
        devid    2 size 3.64TiB used 3.64TiB path /dev/sdd
        devid    3 size 3.64TiB used 3.64TiB path /dev/sde
        devid    4 size 3.64TiB used 3.64TiB path /dev/sdf
        devid    5 size 3.64TiB used 3.64TiB path /dev/sdh
        devid    6 size 3.64TiB used 3.64TiB path /dev/sdi
        devid    7 size 3.64TiB used 3.64TiB path /dev/sdj
        devid    8 size 3.64TiB used 3.64TiB path /dev/sdb
        devid    9 size 931.00GiB used 535.48GiB path /dev/sdg
        devid   10 size 931.00GiB used 535.48GiB path /dev/sdk
        devid   11 size 931.00GiB used 535.48GiB path /dev/sdl
        devid   12 size 931.00GiB used 535.48GiB path /dev/sdm

btrfs-progs v4.1.2
--- cut ---


First of all I wonder why the first 8 disks are shown as "full" as "used
= size", but there is 5.3TB of free space for the fs shown by "df":

--- cut ---
Filesystem      Size  Used Avail Use% Mounted on
/dev/sdc         33T   20T  5.3T  79% /somemountpointsomewhere
--- cut ---

Also "btrfs filesystem df" doesn't give me any clues on the matter:

--- cut ---
btrfs filesystem df /srv/mirror/
Data, single: total=8.00MiB, used=0.00B
Data, RAID6: total=22.85TiB, used=19.19TiB
System, single: total=4.00MiB, used=0.00B
System, RAID6: total=12.00MiB, used=1.34MiB
Metadata, single: total=8.00MiB, used=0.00B
Metadata, RAID6: total=42.09GiB, used=38.42GiB
GlobalReserve, single: total=512.00MiB, used=1.58MiB
--- cut ---




What I am very certain about is that the "load" of I/O requests is not
equal yet, as iostat clearly shows:

--- cut ---
Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdc              21.40     4.41   42.22   12.71  3626.12   940.79
166.29     3.82   69.38   42.83  157.60   5.98  32.82
sdb              22.35     4.45   41.29   12.71  3624.20   941.27
169.09     4.22   77.88   46.75  178.97   6.10  32.96
sdd              22.03     4.44   41.60   12.73  3623.76   943.22
168.13     3.79   69.45   42.53  157.48   6.05  32.85
sde              21.21     4.43   42.30   12.74  3621.39   943.36
165.88     3.82   69.28   42.99  156.62   5.98  32.90
sdf              22.19     4.42   41.42   12.75  3623.65   940.63
168.51     3.77   69.36   42.64  156.13   6.05  32.79
sdh              21.35     4.46   42.25   12.68  3623.12   940.28
166.14     3.95   71.72   43.61  165.40   6.02  33.06
sdi              21.92     4.38   41.67   12.79  3622.03   942.91
167.63     3.49   63.83   40.23  140.74   6.02  32.77
sdj              21.31     4.41   42.26   12.72  3625.32   941.50
166.12     3.99   72.25   44.50  164.44   6.00  33.01
sdg               8.90     4.97   12.53   21.16  1284.47  1630.08
173.02     0.83   24.61   27.31   23.02   1.77   5.95
sdk               9.14     4.94   12.30   21.19  1284.61  1630.02
174.07     0.79   23.41   26.59   21.57   1.76   5.91
sdl               8.88     4.95   12.58   21.19  1284.46  1630.06
172.62     0.80   23.80   25.68   22.68   1.78   6.00
sdm               9.07     4.85   12.35   21.29  1284.43  1630.01
173.26     0.79   23.57   26.57   21.83   1.77   5.94

--- cut ---



Should I run btrfs balance on the filesystem? If so, what FILTERS would
I then use in order for the data and therefore requests to be better
distributed?




With regards and thanks in advance,


Christian
