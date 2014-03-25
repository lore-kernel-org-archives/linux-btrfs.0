Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f178.google.com ([209.85.220.178]:37385 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915AbaCYS4J (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Mar 2014 14:56:09 -0400
Received: by mail-vc0-f178.google.com with SMTP id im17so1102208vcb.23
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Mar 2014 11:56:08 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 25 Mar 2014 14:56:08 -0400
Message-ID: <CAJtFHUQsQLD-vK-hy+HPfex_5RpxdoyOcu-9v20DbaXVHGRx+w@mail.gmail.com>
Subject: Bug in profile balance not present in normal balance
From: E V <eliventer@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Doing a profile balance over a given region will fail with enospc, but
then succeed for a regular balance. ie :

btrfs balance start
-dprofiles=raid0,convert=single,vrange=0..575600000000000 /mirror
Done, had to relocate 0 out of 58087 chunks

btrfs balance start
-dprofiles=raid0,convert=single,vrange=0..575700000000000 /mirror
ERROR: error during balancing '/mirror' - No space left on device
There may be more info in syslog - try dmesg | tail

btrfs balance start -dvrange=575600000000000..575700000000000 /mirror
Done, had to relocate 55 out of 58132 chunks

Plenty of meta data space and such:
Metadata, RAID1: total=134.00GiB, used=87.27GiB
Metadata, single: total=8.00MiB, used=0.00

 just seems to be some blocks that the profile covert fails on that a
regular balance process fine. This is using kernel 3.13.7 and
btrfs-progs 3.12. Any suggestions would be great, thanks,

-Eli
