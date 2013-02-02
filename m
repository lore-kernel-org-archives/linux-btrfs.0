Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:54891 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757684Ab3BBPQc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Feb 2013 10:16:32 -0500
Received: by mail-wi0-f170.google.com with SMTP id hm11so2823808wib.3
        for <linux-btrfs@vger.kernel.org>; Sat, 02 Feb 2013 07:16:31 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 2 Feb 2013 20:46:31 +0530
Message-ID: <CAMO4zuh+kV1V8fw=794sxOU2g8aH3tf59H1Hap3UZ-HuUfJmyg@mail.gmail.com>
Subject: Btrfs snapshot test case failed and crashed GUI
From: praneeth u <praneethu.u@gmail.com>
To: linux-btrfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
        Arne Jansen <sensille@gmx.net>
Cc: hemanth kumar <hemanthkumar51@gmail.com>, sunil kumar <skjmca51@gmail.com>,
        Chethan Y <chethan.casey@gmail.com>,
        ganesh kumar <ganeshkumar14@gmail.com>,
        Kiran Patil <kirantpatil@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have used opensuse12.2 GNOME

Execution procedure i followed.

1) Cloned xfstests and xfsprogs in to xfs_playground, then used
commands, make and make install-qa

2) set environment variables,
SCRATCH_DEV_POOL"/dev/sda8 /dev/sda9 /dev/sda10"
export TEST_DEV=/dev/sda6
export TEST_DIR=/home/praneeth/test
export SCRATCH_DEV=/dev/sda7
export SCRATCH_MNT=/home/praneeth/scratch

3) executed script 254.
./check 254

RESULT

* failed test 1 of 1.
* After next restart of system, GNOME3 interface is missing.
* Welcome to emergency mode, use "systemctl default" for default mode
and asking for root password. Again after giveing  password, same
problem persists.

IS THIS A BUG or AM I DOING ANY MISTAKES ?
--
Praneeth U
9448804728
