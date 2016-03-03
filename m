Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:38605 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755278AbcCCBZs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Mar 2016 20:25:48 -0500
Received: by mail-wm0-f53.google.com with SMTP id l68so12325647wml.1
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Mar 2016 17:25:47 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 2 Mar 2016 20:25:46 -0500
Message-ID: <CAD=QJKiB9m_F+6AgmSJT_Dsd9HLBhXjEDFAcy6wLQNzO1DOkbQ@mail.gmail.com>
Subject: incomplete conversion to RAID1?
From: Nicholas D Steeves <nsteeves@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I recently moved my main system to btrfs and had to shuffle everything
around in tricky ways while migrating from LVM while maintaining at
least two copies + backup of everything.  I'm using linux-4.4.3 with
btrfs-progs-4.4.1.  The end result, after adding sdc and then
converting both metadata and data to RAID1 is:

fdisk -l output:
/dev/sdb1                4096 1943359487   1943355392 926.7G 83 Linux
/dev/sdb2   1943359488 1953523711       10164224      4.9G 82 Linux
swap / Solaris

and

/dev/sdc1                4096 1943359487    1943355392 926.7G Linux filesystem
/dev/sdc2   1943359488 1951748095          8388608         4G Linux swap

btrfs fi show
Label: none  uuid: 2757c0b7-daf1-41a5-860b-9e4bc36417d3
        Total devices 2 FS bytes used 882.28GiB
        devid    1 size 926.66GiB used 886.03GiB path /dev/sdb1
        devid    2 size 926.66GiB used 887.03GiB path /dev/sdc1

But this is what's troubling:

btrfs fi df /.btrfs-admin/
Data, RAID1: total=882.00GiB, used=880.87GiB
Data, single: total=1.00GiB, used=0.00B
System, RAID1: total=32.00MiB, used=160.00KiB
Metadata, RAID1: total=4.00GiB, used=1.41GiB
GlobalReserve, single: total=496.00MiB, used=0.00B

Do I still have 1.00GiB that isn't in RAID1?

Best regards,
Nicholas
