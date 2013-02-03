Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56154 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753453Ab3BCT5q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 3 Feb 2013 14:57:46 -0500
Message-ID: <510EC131.2010704@redhat.com>
Date: Sun, 03 Feb 2013 13:57:37 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: praneeth u <praneethu.u@gmail.com>
CC: linux-btrfs@vger.kernel.org, Arne Jansen <sensille@gmx.net>,
        hemanth kumar <hemanthkumar51@gmail.com>,
        sunil kumar <skjmca51@gmail.com>, Chethan Y <chethan.casey@gmail.com>,
        ganesh kumar <ganeshkumar14@gmail.com>,
        Kiran Patil <kirantpatil@gmail.com>
Subject: Re: Btrfs snapshot test case failed and crashed GUI
References: <CAMO4zuh+kV1V8fw=794sxOU2g8aH3tf59H1Hap3UZ-HuUfJmyg@mail.gmail.com>
In-Reply-To: <CAMO4zuh+kV1V8fw=794sxOU2g8aH3tf59H1Hap3UZ-HuUfJmyg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2/2/13 9:16 AM, praneeth u wrote:
> I have used opensuse12.2 GNOME
> 
> Execution procedure i followed.
> 
> 1) Cloned xfstests and xfsprogs in to xfs_playground, then used
> commands, make and make install-qa
> 
> 2) set environment variables,
> SCRATCH_DEV_POOL"/dev/sda8 /dev/sda9 /dev/sda10"
> export TEST_DEV=/dev/sda6
> export TEST_DIR=/home/praneeth/test
> export SCRATCH_DEV=/dev/sda7
> export SCRATCH_MNT=/home/praneeth/scratch
> 
> 3) executed script 254.
> ./check 254
> 
> RESULT
> 
> * failed test 1 of 1.
> * After next restart of system, GNOME3 interface is missing.
> * Welcome to emergency mode, use "systemctl default" for default mode
> and asking for root password. Again after giveing  password, same
> problem persists.
> 
> IS THIS A BUG or AM I DOING ANY MISTAKES ?

No idea.

Running xfstests certainly should not result in a damaged system,
though.

But we have very little information to go on.

Where are your system disks?  What is the root fs on your system?
What errors did you encounter when you rebooted?  Etc.

If you told xfstests to use one of your system disks, then you
made a mistake.

If you didn't, then it sounds like a bug.

-Eric

> --
> Praneeth U
> 9448804728
> 

