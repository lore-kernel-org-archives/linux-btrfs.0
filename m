Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtprelay02.ispgateway.de ([80.67.31.25]:44645 "EHLO
	smtprelay02.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbcF0N2q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jun 2016 09:28:46 -0400
Received: from [77.13.67.154] (helo=hermione.invalid)
	by smtprelay02.ispgateway.de with esmtpsa (TLSv1.2:AES256-GCM-SHA384:256)
	(Exim 4.84)
	(envelope-from <envelope@m-berberich.de>)
	id 1bHWag-0006WJ-Ex
	for linux-btrfs@vger.kernel.org; Mon, 27 Jun 2016 15:28:42 +0200
Received: from berberic by hermione.invalid with local (Exim 4.87)
	(envelope-from <envelope@m-berberich.de>)
	id 1bHWaf-0007DI-Ut
	for linux-btrfs@vger.kernel.org; Mon, 27 Jun 2016 15:28:41 +0200
Date: Mon, 27 Jun 2016 15:28:41 +0200
From: M G Berberich <btrfs@oss.m-berberich.de>
To: linux-btrfs@vger.kernel.org
Subject: Bug in 'btrfs filesystem du' ?
Message-ID: <20160627132841.GA11661@invalid>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

after a balance ‘btrfs filesystem du’ probably shows false data about
shared data.

To reproduce, create a (smal) btrfs-filesystem, copy some data in a
directory, then ‘cp -a --reflink’ the data. Now all data is shared and
‘btrfs fi du’ shows it correct. In my case:

     Total   Exclusive  Set shared  Filename
  59.38MiB    29.69MiB    29.69MiB  .

after a balance ‘btrfs fi du’ shows no shared data any more, but all
data as exclusive. In my case:

     Total   Exclusive  Set shared  Filename
  59.38MiB    59.38MiB       0.00B  .

As ‘btrfs fi df’ still shows used=29.69MiB, the problem probabaly is
in btrfs-tools.

Test-session log:

# dd if=/dev/urandom of=dev-btrfs bs=4K count=100000
100000+0 Datensätze ein
100000+0 Datensätze aus
409600000 bytes (410 MB, 391 MiB) copied, 24.7574 s, 16.5 MB/s

# mkfs.btrfs dev-btrfs
btrfs-progs v4.5.2
See http://btrfs.wiki.kernel.org for more information.
 
Label:              (null)
UUID:               698a2755-8ecb-468d-9577-9a48947361ea
Node size:          16384
Sector size:        4096
Filesystem size:    390.62MiB
Block group profiles:
  Data:             single            8.00MiB
  Metadata:         DUP              40.00MiB
  System:           DUP              12.00MiB
SSD detected:       no
Incompat features:  extref, skinny-metadata
Number of devices:  1
Devices:
   ID        SIZE  PATH
    1   390.62MiB  dev-btrfs
 

# mount /tmp/dev-btrfs /mnt/

# cd /mnt/

# btrfs fi du -s .
     Total   Exclusive  Set shared  Filename
     0.00B       0.00B       0.00B  .

# cp -a /scratch/kernel/linux-4.6/drivers/usb .

# btrfs fi du -s .
     Total   Exclusive  Set shared  Filename
  28.96MiB    28.96MiB       0.00B  .

# btrfs fi df .
Data, single: total=56.00MiB, used=3.61MiB
System, DUP: total=8.00MiB, used=16.00KiB
Metadata, DUP: total=32.00MiB, used=192.00KiB
GlobalReserve, single: total=16.00MiB, used=0.00B

# btrfs fi usage .
Overall:
    Device size:                 390.62MiB
    Device allocated:            136.00MiB
    Device unallocated:          254.62MiB
    Device missing:                  0.00B
    Used:                         32.06MiB
    Free (estimated):            280.94MiB      (min: 153.62MiB)
    Data ratio:                       1.00
    Metadata ratio:                   2.00
    Global reserve:               16.00MiB      (used: 0.00B)
 
Data,single: Size:56.00MiB, Used:29.69MiB
   /dev/loop0     56.00MiB
 
Metadata,DUP: Size:32.00MiB, Used:1.17MiB
   /dev/loop0     64.00MiB
 
System,DUP: Size:8.00MiB, Used:16.00KiB
   /dev/loop0     16.00MiB
 
Unallocated:
   /dev/loop0    254.62MiB

# cp -a --reflink usb usb2

# btrfs fi du -s .
     Total   Exclusive  Set shared  Filename
  59.38MiB    29.69MiB    29.69MiB  .

# btrfs fi df .
Data, single: total=56.00MiB, used=29.69MiB
System, DUP: total=8.00MiB, used=16.00KiB
Metadata, DUP: total=32.00MiB, used=1.17MiB
GlobalReserve, single: total=16.00MiB, used=0.00B

# btrfs fi usage .
Overall:
    Device size:                 390.62MiB
    Device allocated:            136.00MiB
    Device unallocated:          254.62MiB
    Device missing:                  0.00B
    Used:                         32.06MiB
    Free (estimated):            280.94MiB      (min: 153.62MiB)
    Data ratio:                       1.00
    Metadata ratio:                   2.00
    Global reserve:               16.00MiB      (used: 0.00B)
 
Data,single: Size:56.00MiB, Used:29.69MiB
   /dev/loop0     56.00MiB
 
Metadata,DUP: Size:32.00MiB, Used:1.17MiB
   /dev/loop0     64.00MiB
 
System,DUP: Size:8.00MiB, Used:16.00KiB
   /dev/loop0     16.00MiB
 
Unallocated:
   /dev/loop0    254.62MiB

# btrfs balance start .
WARNING:
 
        Full balance without filters requested. This operation is very
        intense and takes potentially very long. It is recommended to
        use the balance filters to narrow down the balanced data.
        Use 'btrfs balance start --full-balance' option to skip this
        warning. The operation will start in 10 seconds.
        Use Ctrl-C to stop it.
10 9 8 7 6 5 4 3 2 1
Starting balance without any filters.
Done, had to relocate 4 out of 4 chunks

# btrfs fi du -s .
     Total   Exclusive  Set shared  Filename
  59.38MiB    59.38MiB       0.00B  .

# btrfs fi df .
Data, single: total=48.00MiB, used=29.69MiB
System, DUP: total=24.00MiB, used=16.00KiB
Metadata, DUP: total=24.00MiB, used=2.08MiB
GlobalReserve, single: total=16.00MiB, used=0.00B

# btrfs fi usage .
Overall:
    Device size:                 390.62MiB
    Device allocated:            144.00MiB
    Device unallocated:          246.62MiB
    Device missing:                  0.00B
    Used:                         33.88MiB
    Free (estimated):            264.94MiB      (min: 141.62MiB)
    Data ratio:                       1.00
    Metadata ratio:                   2.00
    Global reserve:               16.00MiB      (used: 0.00B)
 
Data,single: Size:48.00MiB, Used:29.69MiB
   /dev/loop0     48.00MiB
 
Metadata,DUP: Size:24.00MiB, Used:2.08MiB
   /dev/loop0     48.00MiB
 
System,DUP: Size:24.00MiB, Used:16.00KiB
   /dev/loop0     48.00MiB
 
Unallocated:
   /dev/loop0    246.62MiB

	MfG
	bmg

-- 
„Des is völlig wurscht, was heut beschlos- | M G Berberich
 sen wird: I bin sowieso dagegn!“          | mail@m-berberich.de
(SPD-Stadtrat Kurt Schindler; Regensburg)  | 
