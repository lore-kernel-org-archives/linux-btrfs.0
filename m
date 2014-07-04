Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:51436 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755557AbaGDBJu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jul 2014 21:09:50 -0400
Message-ID: <53B5FF18.7060801@cn.fujitsu.com>
Date: Fri, 4 Jul 2014 09:10:48 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/4] Add superblock checksum check for btrfs-progs
References: <1404380198-25948-1-git-send-email-quwenruo@cn.fujitsu.com> <20140703175727.GK1553@twin.jikos.cz>
In-Reply-To: <20140703175727.GK1553@twin.jikos.cz>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH 0/4] Add superblock checksum check for btrfs-progs
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2014年07月04日 01:57
> On Thu, Jul 03, 2014 at 05:36:34PM +0800, Qu Wenruo wrote:
>> Before this patchset, btrfs-progs will overall ignore the superblock
>> checksum and continue the routine.
>> Sometimes this may cause disasters like checking a btrfs with corrupted
>> superblock will lead to crash in btrfs-progs.
>>
>> This patch introduces superblock checksum check into btrfs_read_dev_super(),
>> making btrfs-progs much more restricted and robust.
>> To allow super-recover to open devices, add options to scan all 3
>> superblocks when using super-recover.
>> Also updated the related error string and fix a bug in chunk-recover that
>> will not be triggered until superblock csum is calculated.
>>
>> Qu Wenruo (4):
>>    btrfs-progs: Check superblock's checsum when read dev super
>>    btrfs-progs: Allow btrfs_read_dev_super() to read all 3 super for
>>      super_recover.
>>    btrfs-progs: Add more meaningful return value for
>>      btrfs_read_dev_super()     and corresponding error string.
>>    btrfs-progs: Fix size for malloc for superblock checksum.
> Nice work. I've added 1, 2 and 4 it to integration. Please update the
> patch 3 (printf/fprintf).
Thanks for the review and minor tweak for patch 2.

I'll send v2 version of patch 3 soon.

Thank,
Qu
