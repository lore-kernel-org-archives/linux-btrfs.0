Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:47458 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab3BDCc7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Feb 2013 21:32:59 -0500
Received: by mail-wi0-f182.google.com with SMTP id hi18so1103941wib.15
        for <linux-btrfs@vger.kernel.org>; Sun, 03 Feb 2013 18:32:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <510EC131.2010704@redhat.com>
References: <CAMO4zuh+kV1V8fw=794sxOU2g8aH3tf59H1Hap3UZ-HuUfJmyg@mail.gmail.com>
	<510EC131.2010704@redhat.com>
Date: Mon, 4 Feb 2013 07:57:28 +0530
Message-ID: <CAMO4zuiJBkDFjG0nCm2nkCMCxjJr8yuY6Xap70_DvMBGDYerHg@mail.gmail.com>
Subject: Re: Btrfs snapshot test case failed and crashed GUI
From: praneeth u <praneethu.u@gmail.com>
To: Eric Sandeen <sandeen@redhat.com>, linux-btrfs@vger.kernel.org
Cc: Chethan Y <chethan.casey@gmail.com>,
        ganesh kumar <ganeshkumar14@gmail.com>,
        hemanth kumar <hemanthkumar51@gmail.com>,
        Kiran Patil <kirantpatil@gmail.com>, Arne Jansen <sensille@gmx.net>,
        sunil kumar <skjmca51@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Root fs is ext4.
Error after rebooting system is,
"Welcome to emergency mode, use "systemctl default" for default mode"
(ONLY ROOT CAN LOG IN)

only sda is system disk. other disks sdb, sdc, sdd, sde and sdf are
1gb each and formated as btrfs
and mounted in home directory.

Is mounting in home directory, a problem ?

On Mon, Feb 4, 2013 at 1:27 AM, Eric Sandeen <sandeen@redhat.com> wrote:
> On 2/2/13 9:16 AM, praneeth u wrote:
>> I have used opensuse12.2 GNOME
>>
>> Execution procedure i followed.
>>
>> 1) Cloned xfstests and xfsprogs in to xfs_playground, then used
>> commands, make and make install-qa
>>
>> 2) set environment variables,
>> SCRATCH_DEV_POOL"/dev/sda8 /dev/sda9 /dev/sda10"
>> export TEST_DEV=/dev/sda6
>> export TEST_DIR=/home/praneeth/test
>> export SCRATCH_DEV=/dev/sda7
>> export SCRATCH_MNT=/home/praneeth/scratch
>>
>> 3) executed script 254.
>> ./check 254
>>
>> RESULT
>>
>> * failed test 1 of 1.
>> * After next restart of system, GNOME3 interface is missing.
>> * Welcome to emergency mode, use "systemctl default" for default mode
>> and asking for root password. Again after giveing  password, same
>> problem persists.
>>
>> IS THIS A BUG or AM I DOING ANY MISTAKES ?
>
> No idea.
>
> Running xfstests certainly should not result in a damaged system,
> though.
>
> But we have very little information to go on.
>
> Where are your system disks?  What is the root fs on your system?
> What errors did you encounter when you rebooted?  Etc.
>
> If you told xfstests to use one of your system disks, then you
> made a mistake.
>
> If you didn't, then it sounds like a bug.
>
> -Eric
>
>> --
>> Praneeth U
>> 9448804728
>>
>



-- 
Praneeth U
9448804728
