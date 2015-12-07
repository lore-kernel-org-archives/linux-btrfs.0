Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59358 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753520AbbLGR3Y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Dec 2015 12:29:24 -0500
Subject: Re: [PATCH] btrfs: Introduce new mount option to disable tree log
 replay
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
References: <1449468402-27914-1-git-send-email-quwenruo@cn.fujitsu.com>
 <5665B359.2050906@redhat.com> <2856934.1tulUexfpA@localhost.localdomain>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <5665C1F2.8020407@redhat.com>
Date: Mon, 7 Dec 2015 11:29:22 -0600
MIME-Version: 1.0
In-Reply-To: <2856934.1tulUexfpA@localhost.localdomain>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/7/15 10:52 AM, Chandan Rajendra wrote:
> On Monday 07 Dec 2015 10:27:05 Eric Sandeen wrote:
>> On 12/7/15 12:06 AM, Qu Wenruo wrote:
>>> Introduce a new mount option "nologreplay" to co-operate with "ro" mount
>>> option to get real readonly mount, like "norecovery" in ext* and xfs.
>>>
>>> Since the new parse_options() need to check new flags at remount time,
>>> so add a new parameter for parse_options().
>>>
>>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>>> ---
>>>
>>>  Documentation/filesystems/btrfs.txt |  5 +++++
>>>  fs/btrfs/ctree.h                    |  4 +++-
>>>  fs/btrfs/disk-io.c                  |  7 ++++---
>>>  fs/btrfs/super.c                    | 20 +++++++++++++++++---
>>>  4 files changed, 29 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/Documentation/filesystems/btrfs.txt
>>> b/Documentation/filesystems/btrfs.txt index c772b47..ac4ed68 100644
>>> --- a/Documentation/filesystems/btrfs.txt
>>> +++ b/Documentation/filesystems/btrfs.txt
>>> @@ -168,6 +168,11 @@ Options with (*) are default options and will not
>>> show in the mount options.> 
>>>    notreelog
>>>  	
>>>  	Enable/disable the tree logging used for fsync and O_SYNC writes.
>>>
>>> +  nologreplay
>>> +	Disable the log tree replay at mount time for real read-only mount.
>>> +	Must be use with "ro" mount option and can't be disabled by mount
>>> +	option.
>>
>> This documentation is not clear to me - "can't be disabled by mount option?"
>>
>> I think you mean to talk about remount here?  Perhaps something like:
>>
>> "... Must be used with 'ro' mount option.  A filesystem mounted with the
>> 'nologreplay' option cannot transition to a read-write mount via
>> remount,rw - the filesystem must be unmounted and remounted if read-write
>> access is desired."
>>
> Eric, I had assumed the same logic with respect to the transition from 'ro' to
> 'rw' via remount. But when doing so, btrfs_remount() flags an error only when
> a valid 'tree log' tree is present in the filesystem
> i.e. btrfs_super_block->log_root has a non-zero value. Otherwise,
> btrfs_remount() does not seem to have any problem with the transition from
> 'ro' to 'rw'.

Ok, I don't know if that's intended - but I think the docs should be clarified
to explicitly state the expected behavior in any case.

FWIW, new mount options and their descriptions should be added to BTRFS-MOUNT(5) 
as well.

-Eric

