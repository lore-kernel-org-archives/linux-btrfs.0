Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:36469 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664AbbLNHUz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Dec 2015 02:20:55 -0500
Received: by mail-ig0-f169.google.com with SMTP id ph11so76625965igc.1
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Dec 2015 23:20:55 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 14 Dec 2015 00:20:54 -0700
Message-ID: <CAJCQCtTfF8NO8ih7c2Jk0V=7P_vJt=QmNyivWBMK1PV6CsQjgA@mail.gmail.com>
Subject: btrfs check inconsistency with raid1, backstory, part 2
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(sdb&sdc are a raid0, btrfs receive destination, they don't come up in
this dmesg at all)

sdd&sde are a raid1, btrfs send source

All four devices are in USB enclosures on a new Intel NUC that's had
~32 hours burnin with memtest. Both file systems had received many
scrubs before with zero errors all time, include most recently within
the past few days. What's new about today's setup is the NUC, and the
fact all four drives are directly connected, not to a USB hub. So
right off the bat I'm going to suspect hardware problems are due to
insufficient USB bus power.

kernel messages:
https://drive.google.com/open?id=0B_2Asp8DGjJ9Z0hhbVUwakF5Y2c

Lines 6-28
I'm pretty sure what happens first is sdd is producing spurious data
(bad tree block start). I can't tell if the 'read error correct'
messages are fixing sde or sdd? In any case, since the last thing that
happened before this was a passing scrub, none of these corrections
written to disk are warranted and are suspect. Maybe what happens is
the reads are bad but the writes back to the device (corrections) are
OK.

Next, line 29 to 48, looks like there is a USB bus reset, sde vanishes
off the bus, and reappears as sdf, at which point thousands of write
errors ensue. And then I became aware of all of this, did an abrupt
shutdown (poweroff -f) at which point the journal ends.

And then we go to part 1 for what I did next to try to recover.

-- 
Chris Murphy
