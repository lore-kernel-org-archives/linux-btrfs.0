Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:34912 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbbJTEQQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Oct 2015 00:16:16 -0400
Received: by lbbes7 with SMTP id es7so5595593lbb.2
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Oct 2015 21:16:15 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 20 Oct 2015 00:16:15 -0400
Message-ID: <CA+X5Wn6Wu3RfX6rM6fpp9b4ZQQNm5WCbSOzxyOnE=+jDb0xDoA@mail.gmail.com>
Subject: Expected behavior of bad sectors on one drive in a RAID1
From: james harvey <jamespharvey20@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Background -----

My fileserver had a "bad event" last week.  Shut it down normally to
add a new hard drive, and it would no longer post.  Tried about 50
times, doing the typical everything non-essential unplugged, trying 1
of 4 memory modules at a time, and 1 of 2 processors at a time.  Got
no where.

Inexpensive HP workstation, so purchased a used identical model
(complete other than hard drives) on eBay.  Replacement arrived today.
Posts fine.  Moved hard drives over (again, identical model, and Arch
Linux not Windows) and it started giving "Watchdog detected hard
LOCKUP" type errors I've never seen before.

Decided I'd diagnose which part in the original server was bad.  By
sitting turned off for a week, it suddenly started posting just fine.
But, with the hard drives back in it, I'm getting the same hard lockup
errors.

An Arch ISO DVD runs stress testing perfectly.

Btrfs-specific -----

The current problem I'm having must be a bad hard drive or corrupted data.

3 drive btrfs RAID1 (data and metadata.)  sda has 1GB of the 3GB of
data, and 1GB of the 1GB of metadata.

sda appears to be going bad, with my low threshold of "going bad", and
will be replaced ASAP.  It just developed 16 reallocated sectors, and
has 40 current pending sectors.

I'm currently running a "btrfs scrub start -B -d -r /terra", which
status on another term shows me has found 32 errors after running for
an hour.

Question 1 - I'm expecting if I re-run the scrub without the read-only
option, that it will detect from the checksum data which sector is
correct, and re-write to the drive with bad sectors the data to a new
sector.  Correct?

Question 2 - Before having ran the scrub, booting off the raid with
bad sectors, would btrfs "on the fly" recognize it was getting bad
sector data with the checksum being off, and checking the other
drives?  Or, is it expected that I could get a bad sector read in a
critical piece of operating system and/or kernel, which could be
causing my lockup issues?

Question 3 - Probably doesn't matter, but how can I see which files
(or metadata to files) the 40 current bad sectors are in?  (On extX,
I'd use tune2fs and debugfs to be able to see this information.)

I do have hourly snapshots, from when it was properly running, so once
I'm that far in the process, I can also compare the most recent
snapshots, and see if there's any changes that happened to files that
shouldn't have.
