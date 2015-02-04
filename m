Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f169.google.com ([209.85.216.169]:58560 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161148AbbBDRbI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Feb 2015 12:31:08 -0500
Received: by mail-qc0-f169.google.com with SMTP id b13so2409653qcw.0
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Feb 2015 09:31:07 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 4 Feb 2015 12:31:07 -0500
Message-ID: <CAPs0Big=8SsBRFjrDPcradYW100GUnWEzC=ycvvDQScTSYKt5A@mail.gmail.com>
Subject: What does scrub tell me?
From: Sandy McArthur Jr <sandymac@gmail.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Does a btrfs scrub verify the integrity of the whole filesystem or
just the data in that filesystem?

I recently removed some unreliable drives from my multi-volume RAID1
btrfs filesystem and ran a scrub that completed with two corrected
errors (see below).  I've struggled with this filesystem due to poor
choices in hardware on my part and had to recover it several times. As
of now I've eliminated all older drives or drives labeled as "desktop"
drives. (Knowing what I know now, I'm impressed with how well btrfs
has preserved my data despite myself.)

I'm at a point where I can grow my existing btrfs filesystem as RAID1
or I can afford to migrate data to a new btrfs single filesystem and
then add drives back in to get back to RAID1 mirroring again. Is there
value to starting a fresh btrfs filesystem given my history?


# btrfs scrub status /mcmedia/ ; echo ; btrfs --version
scrub status for 94b3345e-2589-423c-a228-d569bf94ab58
scrub resumed at Mon Feb  2 22:03:14 2015 and finished after 204126 seconds
total bytes scrubbed: 23.38TiB with 2 errors
error details: csum=2
corrected errors: 2, uncorrectable errors: 0, unverified errors: 0

Btrfs v3.18.2

Both errors were from: [/dev/sdm1].corruption_errs 2

-- 
Sandy McArthur

"He who dares not offend cannot be honest."
- Thomas Paine
