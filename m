Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:34573 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798AbbLXTPW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Dec 2015 14:15:22 -0500
Received: by mail-oi0-f41.google.com with SMTP id o124so141650125oia.1
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Dec 2015 11:15:22 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 24 Dec 2015 13:15:22 -0600
Message-ID: <CACRRrm9SwfDzqHNpWjAGniuu6HDu5wo3vW_ETdzijrdYm7YGGw@mail.gmail.com>
Subject: Btrfs Check - "type mismatch with chunk"
From: Zach Fuller <conicawd@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I am currently running btrfs on a 2TB GPT drive. The drive is working
fine, still mounts correctly, and I have experienced no data
corruption. Whenever I run "btrfs check" on the drive, it returns
100,000+ messages stating "bad extent [###, ###), type mismatch with
chunk". Whenever I try to run "btrfs check --repair" it says that it
has fixed the errors, but whenever I run "btrfs check" again, the
errors return. Should I be worried about data/filesystem corruption,
or are these errors meaningless?

Here are the links to the output of "btrfs check"
(https://app.box.com/s/z2c4ikp6lsn7siezafkth3amo27acs4o) and "btrfs
check --repair"
(https://app.box.com/s/tgg3c4dpfas1wulk30zpudw4mt4bvwoa)
Also, whenever I run btrfs scrub on the drive, it says there are no errors.

I see that there have been other posts on the mailing list with this
same error, such as this one
(https://www.mail-archive.com/linux-btrfs%40vger.kernel.org/msg48325.html).

I have my data backed up on 2 different drives, so I can afford to
lose the entire btrfs drive temporarily.

Here is some info about my system:

$ uname -a
Linux comp 4.2.5-1-ARCH #1 SMP PREEMPT Tue Oct 27 08:13:28 CET 2015
x86_64 GNU/Linux


$ btrfs --version
btrfs-progs v4.3.1


$ sudo btrfs fi show
Another drive...

Label: 'backup'  uuid: 1a160f37-7206-43f9-9285-6217ee97a665
Total devices 1 FS bytes used 1.53TiB
devid    1 size 1.82TiB used 1.54TiB path /dev/sdc1


$ sudo btrfs fi df /backup
Data, single: total=1.53TiB, used=1.53TiB
System, DUP: total=32.00MiB, used=224.00KiB
Metadata, DUP: total=3.50GiB, used=2.36GiB
GlobalReserve, single: total=512.00MiB, used=0.00B


Drive Mounting Options from /etc/fstab:
LABEL=backup    /backup  btrfs  noatime,compress=lzo,autodefrag  0 0
