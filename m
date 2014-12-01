Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f176.google.com ([209.85.220.176]:44316 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626AbaLAM4b (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Dec 2014 07:56:31 -0500
Received: by mail-vc0-f176.google.com with SMTP id hq12so4489983vcb.21
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Dec 2014 04:56:30 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 1 Dec 2014 13:56:30 +0100
Message-ID: <CAE8gLhm8Oma6kWdeJtdc1-U2e4+TJDzhmw2Vfr=CYwvJ78GRJQ@mail.gmail.com>
Subject: PROBLEM: #89121 BTRFS mixes up mounted devices with their snapshots
From: MegaBrutal <megabrutal@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I've reported the bug I've previously posted about in "BTRFS messes up
snapshot LV with origin" in the Kernel Bug Tracker.
https://bugzilla.kernel.org/show_bug.cgi?id=89121

Since the other thread went off into theoretical debates about UUIDs
and their generic relation to BTRFS, their everyday use cases, and the
philosophical meaning behind uniqueness of copies and UUIDs; I'd like
to specifically ask you to only post here about the ACTUAL problem at
hand. Don't get me wrong, I find the discussion in the other thread
really interesting, I'm following it, but it is only very remotely
related to the original issue, so please keep it there! If you're
interested to catch up about the actual bug symptoms, please read the
bug report linked above, and (optionally) reproduce the problem
yourself!

A virtual machine image on which I've already reproduced the
conditions can be downloaded here:
http://undead.megabrutal.com/kvm-reproduce-1391429.img.xz
(Download size: 113 MB; Unpacked image size: 2 GB.)

Re-tested with mainline kernel 3.18.0-rc7 just today.


Regards,
MegaBrutal
