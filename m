Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38143 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934359AbcCKISP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Mar 2016 03:18:15 -0500
Subject: Re: [PATCH 00/15] Device delete by id
To: dsterba@suse.cz, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, clm@fb.com
References: <cover.1455556900.git.dsterba@suse.com>
 <20160225175905.GJ23746@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <56E27EF8.1080408@oracle.com>
Date: Fri, 11 Mar 2016 16:16:56 +0800
MIME-Version: 1.0
In-Reply-To: <20160225175905.GJ23746@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 02/26/2016 01:59 AM, David Sterba wrote:
> On Mon, Feb 15, 2016 at 06:33:56PM +0100, David Sterba wrote:
>> this patchset extends the ioctl arugments to take an id so we can delete a
>> device by it. It reuses the existing structure btrfs_ioctl_vol_args_v2 and
>> extends it in na backward-compatible way so that we don't need to introduce
>> another one.
>>
>> The core patchset is from Anand, I did some cleanups as I went through the
>> series again and made some cleanups and minor naming tweaks to the interface.
>>
>> I'll add the branch to for-next and if everything goes fine I'll send a pull
>> request for 4.6 in a week.
>
> This patchset is causing crashes in my setup, based on linux-next tree
> with my for-next. I did a test round without it and it passes, so I'm
> removing it from 4.6 queue. We need more time to find and fix it.

  (crash.. are you ref to the below ?)
  BUG: unable to handle kernel NULL pointer dereference
  scrub_setup_ctx.isra.19+0x1f6/0x260 [btrfs]

  Current status: as of now there is nothing that tells me the
  above crash was due to the set of patches in here, if there
  are further data I will be happy to review, also this wasn't
  reproducible.


  Also:
  Most of the xfstest btrfs/tests aren't designed to generate a
  consistent result, it can be consistent with a sequence of tests,
  but when this sequence of tests is altered, it may generate
  different results.

  As xfstest results also depends on the factors like state of
  stale FSID on the devices and state of btrfs_device list with
  in the kernel, which depends on the previous tests.

  And looks like following changes can make it consistent.
    Before each test/sub-test:
    . wipefs -a of all scratch pool dev
    . modprobe -r btrfs && modprobe btrfs
  So that kernel will have a clean state of btrfs_device list.

  Which means all the btrfs tests especially which are grouped
  under replace should be updated with the above change, So that
  we can ensure kernel and devices are in the same state each
  time the test is run.

  Any idea?

Thanks, Anand
