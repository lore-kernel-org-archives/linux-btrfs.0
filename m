Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:34769 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbbCaSzu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 Mar 2015 14:55:50 -0400
Received: by wgbdm7 with SMTP id dm7so29614466wgb.1
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Mar 2015 11:55:49 -0700 (PDT)
MIME-Version: 1.0
From: Martin Langhoff <martin.langhoff@gmail.com>
Date: Tue, 31 Mar 2015 14:55:29 -0400
Message-ID: <CACPiFCJwQTsVcU2CJpSMyGyL1jsEQooMvOHooZriM70SsmGgVA@mail.gmail.com>
Subject: F21 fails to mount root part, btrfs check: Couldn't open file system
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi BTRFS folks,

one of my dev boxes is a Thinkpad x220, with a single hybrid
(HDD+Flash) disk, running F21 with BTRFS partitions for /home and / .

After losing power (ran out of battery, possibly while trying to
hibernate) -- the system will not boot. The initrd breaks out to a
shell where I find that the partition holding / is failing to mount.

 - journalctl/dmesg doesn't show anything of interest, though it says
there is no hibernate image to restore, and that it cannot mount
sysroot
 - btrfs rescue super-recover says there's no problem, all superblocks ok
 - btrfs rescue chunk-recover -vy takes a while, and says there's
nothing to recover
 - btrfs check (tried all options) -- says Couldn't open file system
 - kernel is 3.1.9-200.fc21
 - btrfs tools 3.18.1
 - disk is a Seagate 500GB Thin SSHD SATA 6Gb/s 64MB Cache 2.5-Inch
(ST500LM000) -- cost ~$100 about 2y ago

Is there anything I can do here? Anything to recover the partition?
Anything to diagnose things in a way that is useful to btrfs
development, and understanding of dataloss crashes? A failure of the
HDD cannot be ruled out, low power conditions, cheap consumer part...

There is no valuable data here, just have to reinstall F21.

cheers,


martin [ I am not on the list, CC appreciated... ]
-- 
 martin.langhoff@gmail.com
 -  ask interesting questions
 - don't get distracted with shiny stuff  - working code first
 ~ http://docs.moodle.org/en/User:Martin_Langhoff
