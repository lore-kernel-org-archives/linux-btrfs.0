Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx4-phx2.redhat.com ([209.132.183.25]:47671 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822Ab3BDEWZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Feb 2013 23:22:25 -0500
Content-Type: text/plain;
	charset=us-ascii
Subject: Re: Btrfs snapshot test case failed and crashed GUI
References: <CAMO4zuh+kV1V8fw=794sxOU2g8aH3tf59H1Hap3UZ-HuUfJmyg@mail.gmail.com> <510EC131.2010704@redhat.com> <CAMO4zuiJBkDFjG0nCm2nkCMCxjJr8yuY6Xap70_DvMBGDYerHg@mail.gmail.com>
From: Eric Sandeen <esandeen@redhat.com>
MIME-Version: 1.0
In-Reply-To: <CAMO4zuiJBkDFjG0nCm2nkCMCxjJr8yuY6Xap70_DvMBGDYerHg@mail.gmail.com>
Message-Id: <86E99654-9A30-4E5D-BEDD-6254AA1220A8@redhat.com>
Date: Sun, 3 Feb 2013 23:22:19 -0500 (EST)
To: praneeth u <praneethu.u@gmail.com>
Cc: Eric Sandeen <sandeen@redhat.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Chethan Y <chethan.casey@gmail.com>,
        ganesh kumar <ganeshkumar14@gmail.com>,
        hemanth kumar <hemanthkumar51@gmail.com>,
        Kiran Patil <kirantpatil@gmail.com>, Arne Jansen <sensille@gmx.net>,
        sunil kumar <skjmca51@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Feb 3, 2013, at 8:37 PM, praneeth u <praneethu.u@gmail.com> wrote:

> Root fs is ext4.
> Error after rebooting system is,
> "Welcome to emergency mode, use "systemctl default" for default mode"
> (ONLY ROOT CAN LOG IN)
> 
> only sda is system disk.

And you used at least some of sda for test, too.  Did it overlap?  -

"SCRATCH_DEV_POOL"/dev/sda8 /dev/sda9 /dev/sda10"
export TEST_DEV=/dev/sda6
export TEST_DIR=/home/praneeth/test
export SCRATCH_DEV=/dev/sda7
export "


> other disks sdb, sdc, sdd, sde and sdf are
> 1gb each and formated as btrfs
> and mounted in home directory.
> 
> Is mounting in home directory, a problem ?
> 

I don't know.  You still haven't really said what problem was encountered on boot....

Eric

> On Mon, Feb 4, 2013 at 1:27 AM, Eric Sandeen <sandeen@redhat.com> wrote:
>> On 2/2/13 9:16 AM, praneeth u wrote:
>>> I have used opensuse12.2 GNOME
>>> 
>>> Execution procedure i followed.
>>> 
>>> 1) Cloned xfstests and xfsprogs in to xfs_playground, then used
>>> commands, make and make install-qa
>>> 
>>> 2) set environment variables,
>>> SCRATCH_DEV_POOL"/dev/sda8 /dev/sda9 /dev/sda10"
>>> export TEST_DEV=/dev/sda6
>>> export TEST_DIR=/home/praneeth/test
>>> export SCRATCH_DEV=/dev/sda7
>>> export SCRATCH_MNT=/home/praneeth/scratch
>>> 
>>> 3) executed script 254.
>>> ./check 254
>>> 
>>> RESULT
>>> 
>>> * failed test 1 of 1.
>>> * After next restart of system, GNOME3 interface is missing.
>>> * Welcome to emergency mode, use "systemctl default" for default mode
>>> and asking for root password. Again after giveing  password, same
>>> problem persists.
>>> 
>>> IS THIS A BUG or AM I DOING ANY MISTAKES ?
>> 
>> No idea.
>> 
>> Running xfstests certainly should not result in a damaged system,
>> though.
>> 
>> But we have very little information to go on.
>> 
>> Where are your system disks?  What is the root fs on your system?
>> What errors did you encounter when you rebooted?  Etc.
>> 
>> If you told xfstests to use one of your system disks, then you
>> made a mistake.
>> 
>> If you didn't, then it sounds like a bug.
>> 
>> -Eric
>> 
>>> --
>>> Praneeth U
>>> 9448804728
> 
> 
> 
> -- 
> Praneeth U
> 9448804728
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
