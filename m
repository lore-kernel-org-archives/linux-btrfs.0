Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:36844 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791AbbDKT74 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 11 Apr 2015 15:59:56 -0400
Received: by wizk4 with SMTP id k4so31138853wiz.1
        for <linux-btrfs@vger.kernel.org>; Sat, 11 Apr 2015 12:59:55 -0700 (PDT)
Received: from ?IPv6:2a02:1812:1980:9b00:79b7:d674:7af4:9c75? ([2a02:1812:1980:9b00:79b7:d674:7af4:9c75])
        by mx.google.com with ESMTPSA id yr1sm4094282wjc.37.2015.04.11.12.59.54
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 11 Apr 2015 12:59:54 -0700 (PDT)
Message-ID: <55297D36.8090808@sjeng.org>
Date: Sat, 11 Apr 2015 21:59:50 +0200
From: Gian-Carlo Pascutto <gcp@sjeng.org>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Big disk space usage difference, even after defrag, on identical
 data
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Linux mozwell 3.19.0-trunk-amd64 #1 SMP Debian 3.19.1-1~exp1
(2015-03-08) x86_64 GNU/Linux
btrfs-progs v3.19.1

I have a btrfs volume that's been in use for a week or 2. It has about
~560G of uncompressible data (video files, tar.xz, git repos, ...) and
~200G of data that compresses 2:1 with LZO (PostgreSQL db).

It's split into 2 subvolumes:
ID 257 gen 6550 top level 5 path @db
ID 258 gen 6590 top level 5 path @large

and mounted like this:
/dev/sdc /srv/db btrfs rw,noatime,compress=lzo,space_cache 0 0
/dev/sdc /srv/large btrfs rw,noatime,compress=lzo,space_cache 0 0

du -skh /srv
768G    /srv

df -h
/dev/sdc        1.4T  754G  641G  55% /srv/db
/dev/sdc        1.4T  754G  641G  55% /srv/large

btrfs fi df /srv/large
Data, single: total=808.01GiB, used=749.36GiB
System, DUP: total=8.00MiB, used=112.00KiB
System, single: total=4.00MiB, used=0.00B
Metadata, DUP: total=3.50GiB, used=1.87GiB
Metadata, single: total=8.00MiB, used=0.00B
GlobalReserve, single: total=512.00MiB, used=0.00B

So that's a bit bigger than perhaps expected (~750G instead of
~660G+metadata). I thought it might've been related to compress bailing
out too easily, but I've done a
btrfs fi defragment -r -v -clzo /srv/db /srv/large
and this doesn't change anything.

I recently copied this data to a new, bigger disk, and the result looks
worrying:

mount options:
/dev/sdd /mnt/large btrfs rw,noatime,compress=lzo,space_cache 0 0
/dev/sdd /mnt/db btrfs rw,noatime,compress=lzo,space_cache 0 0

btrfs fi df
Data, single: total=684.00GiB, used=683.00GiB
System, DUP: total=8.00MiB, used=96.00KiB
System, single: total=4.00MiB, used=0.00B
Metadata, DUP: total=3.50GiB, used=2.04GiB
Metadata, single: total=8.00MiB, used=0.00B
GlobalReserve, single: total=512.00MiB, used=0.00B

df
/dev/sdd        3.7T  688G  3.0T  19% /mnt/large
/dev/sdd        3.7T  688G  3.0T  19% /mnt/db

du
767G    /mnt

That's a 66G difference for the same data with the same compress option.
The used size here is much more in line with what I'd have expected
given the nature of the data.

I would think that compression differences or things like fragmentation
or bookending for modified files shouldn't affect this, because the
first filesystem has been defragmented/recompressed and didn't shrink.

So what can explain this? Where did the 66G go?

-- 
GCP
