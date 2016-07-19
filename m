Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:15774 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751036AbcGST1V (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Jul 2016 15:27:21 -0400
Subject: Re: [PATCH 0/3] Btrfs: fix free space tree bitmaps+tests on
 big-endian systems
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        Omar Sandoval <osandov@osandov.com>
References: <cover.1468538030.git.osandov@fb.com>
 <399ec92c-9905-0ede-d5b0-ea3b0bf922e4@fb.com>
 <20160718223104.GA6681@vader.DHCP.thefacebook.com>
 <2544227.upOtQjWuiQ@localhost.localdomain>
CC: <linux-btrfs@vger.kernel.org>, <kernel-team@fb.com>
From: Chris Mason <clm@fb.com>
Message-ID: <83e50f77-ae10-4c8d-4a03-3c9af298d9c7@fb.com>
Date: Tue, 19 Jul 2016 15:25:16 -0400
MIME-Version: 1.0
In-Reply-To: <2544227.upOtQjWuiQ@localhost.localdomain>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/19/2016 12:06 PM, Chandan Rajendra wrote:
> On Monday, July 18, 2016 03:31:04 PM Omar Sandoval wrote:
>> Yeah, this should definitely not work. It's possible that things are
>> just silently failing and getting corrupted if the module isn't built
>> with CONFIG_BTRFS_ASSERT, but btrfsck v4.6.1 + my patch should catch
>> that.
>>
>> Chandan, is fsx creating enough fragmentation to trigger the switch to
>> bitmaps? You can check with `btrfs inspect dump-tree`; there should be
>> FREE_SPACE_BITMAP items. If there are only FREE_SPACE_EXTENT items, then
>> it's not testing the right code path.
>>
>> I have a script here [1] that I've been using to test the free space
>> tree. When I ran it with `--check` on MIPS, it failed on the old kernel
>> and passed with this series. If you stick a return after the call to
>> `unlink_every_other_file()`, you'll get a nice, fragmented filesystem to
>> feed to xfstests, as well.
>
> You are right, There were only FREE_SPACE_EXTENT items in the filesystem that
> was operated on by fsx. I executed fragment_free_space_tree.py to create a
> filesystem with FREE_SPACE_BITMAP items. When such a filesystem is created
> with the unpatched kernel, later mounted on a patched kernel and fsx executed
> on it, I see that we fail assertion statements in free-space-tree.c. For e.g.
>
> BTRFS error (device loop0): incorrect extent count for 289406976; counted 8186, expected 8192
> BTRFS: assertion failed: 0, file: /root/repos/linux/fs/btrfs/free-space-tree.c, line: 1485
>

Omar, looks like we need to make the patched kernel refuse to mount free 
space trees without a new incompat bit set.  That way there won't be any 
surprises for the people that have managed to get a free space tree 
saved.  Can it please printk a message about clearing the tree and 
mounting again?

-chris
