Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47206 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932172AbbDPSzF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Apr 2015 14:55:05 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YiowJ-0006zT-TM
	for linux-btrfs@vger.kernel.org; Thu, 16 Apr 2015 20:55:04 +0200
Received: from cpc69663-belf10-2-0-cust255.2-1.cable.virginm.net ([82.18.11.0])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Apr 2015 20:55:03 +0200
Received: from miguel.negrao-lists by cpc69663-belf10-2-0-cust255.2-1.cable.virginm.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Apr 2015 20:55:03 +0200
To: linux-btrfs@vger.kernel.org
From: Miguel =?utf-8?b?TmVncsOjbw==?=
	<miguel.negrao-lists@friendlyvirus.org>
Subject: corruption in USB harddrive - backup via send/receive - question
Date: Thu, 16 Apr 2015 18:48:43 +0000 (UTC)
Message-ID: <loom.20150416T202016-456@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I'm running a laptop, macbook pro 8,2, with ubuntu, on kernel
3.13.0-49-lowlatency. I have a USB enclosure containing two harddrives
(Icydock JBOD). Each harddrive runs their own btrfs file system, on top of
luks partitions. I backup one harddrive to the other using btrfs
send/receive with incremental sends (tests that I did indicated this setup
was too fragile for running btrfs RAID).

I've noticed that files on one of the harddrive start to get corrupted
sometimes. It's not many files, but it does happen from time to time. On the
irc I was told it could be the USB enclosure, it could be memory, etc. The
SMART data of the harddrives say they are fine, the quick SMART tests also
pass without problems.


 - Given that I'm running a laptop and comunicating with the harddrives via
USB, is it expected that I will get some corruption from time to time or is
this abnormal and there is something very wrong with some of my equipment
and if so how can track what is responsible ?
 - Is it possible to extract a file that has csum errors ? I work with audio
files, if I don't have a backup of file I would still like to get full
corrupted version, since most of the audio might still be perfectly fine.
Can I tell btrfs to do a new csum of the file has it is now, and just live
with the corruption ?

I've copied a file to the main USB harddrive on 2015-02-21, the file was
backed up to the other harddrive via send/receive on 2015-02-23. Now
(yesterday) when I try to access the file on the main harddrive it is corrupted:

Apr 16 19:20:35 miguel-MacBookPro kernel: [  835.944606] BTRFS info (device
dm-1): csum failed ino 136726 off 1067679744 csum 4135207512 expected csum
1128560616
Apr 16 19:20:35 miguel-MacBookPro kernel: [  835.948431] BTRFS info (device
dm-1): csum failed ino 136726 off 1067761664 csum 730461863 expected csum
1924299628
Apr 16 19:20:36 miguel-MacBookPro kernel: [  836.395372] BTRFS info (device
dm-1): csum failed ino 136726 off 1067679744 csum 4135207512 expected csum
1128560616
Apr 16 19:20:36 miguel-MacBookPro kernel: [  836.396682] BTRFS info (device
dm-1): csum failed ino 136726 off 1067679744 csum 4135207512 expected csum
1128560616

I can access it fine on the backup harddrive. 

Questions:

- Can I assume that that the corruption happened after the file was sent to
the backup hardrive ?
- Will btrfs send ever send a file with corrupted blocks ?
- I kept running more backups, but that particular file was not changed
since. I'm I correct in assuming that since the file was not changed it was
not sent again to the backup disk and that therefore the version I have in
the backup should be a good copy ?

Best regards,
Miguel

Label: 'huge-new'  uuid: 21d841c9-7c30-4d1b-b4c2-8c0e59e8959a
	Total devices 1 FS bytes used 1.04TiB
	devid    1 size 2.73TiB used 1.06TiB path /dev/mapper/huge-new

[/dev/mapper/huge-new].write_io_errs   0
[/dev/mapper/huge-new].read_io_errs    0
[/dev/mapper/huge-new].flush_io_errs   0
[/dev/mapper/huge-new].corruption_errs 1970
[/dev/mapper/huge-new].generation_errs 0

Btrfs v0.20-rc1-335-gf00dd83

Label: 'huge-new-backup'  uuid: 9af299bc-48b0-4e52-8078-82749627d9f4
	Total devices 1 FS bytes used 1.04TiB
	devid    1 size 2.73TiB used 1.05TiB path /dev/mapper/huge-new-backup

[/dev/mapper/huge-new-backup].write_io_errs   0
[/dev/mapper/huge-new-backup].read_io_errs    0
[/dev/mapper/huge-new-backup].flush_io_errs   0
[/dev/mapper/huge-new-backup].corruption_errs 0
[/dev/mapper/huge-new-backup].generation_errs 0

Btrfs v0.20-rc1-335-gf00dd83




