Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:40996 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932369AbbCFKWL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Mar 2015 05:22:11 -0500
Received: by wiwl15 with SMTP id l15so2423122wiw.0
        for <linux-btrfs@vger.kernel.org>; Fri, 06 Mar 2015 02:22:09 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 6 Mar 2015 11:22:09 +0100
Message-ID: <CADurGxyF6g5Z+HNMry+q=b_oCKv1a6StDvp6pL20z=twK0BMHQ@mail.gmail.com>
Subject: Status: converting raid levels
From: Marcel Ritter <ritter.marcel@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

please, can someone comment on the current status of raid level migration?
(kernel 4.0.0-rc2, btrfs-progs 3.19-rc2)

I just started testing this feature, and it doesn't seem to work:

Starting with Raid1:

root@thunder[ ~/btrfs-progs ]# ./btrfs fi df /tmp/m
Data, RAID1: total=3.00GiB, used=512.00KiB
Data, single: total=8.00MiB, used=0.00B
System, RAID1: total=8.00MiB, used=16.00KiB
System, single: total=4.00MiB, used=0.00B
Metadata, RAID1: total=1.00GiB, used=112.00KiB
Metadata, single: total=8.00MiB, used=0.00B
GlobalReserve, single: total=16.00MiB, used=0.00B

Converting to Raid10:

root@thunder[ ~/btrfs-progs ]# ./btrfs balance start -dconvert=raid10
-mconvert=raid10 /tmp/m/
Done, had to relocate 9 out of 9 chunks

Still Raid1 ...:

root@thunder[ ~/btrfs-progs ]# ./btrfs fi df /tmp/m
Data, RAID1: total=35.00GiB, used=31.49GiB
System, RAID1: total=32.00MiB, used=16.00KiB
Metadata, RAID1: total=1.00GiB, used=33.86MiB
GlobalReserve, single: total=16.00MiB, used=0.00B

I also tried conversion of raid6 - but it did not work either
(according to btrfs fi df output).

Did I miss something, or is it a bug?

Bye,
    Marcel
