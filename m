Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from brockman.in8.de ([85.214.220.56]:38088 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121Ab2HANHa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 Aug 2012 09:07:30 -0400
Message-ID: <50192A11.3060109@jan-o-sch.net>
Date: Wed, 01 Aug 2012 15:07:29 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Liu Bo <liub.liubo@gmail.com>
CC: Stefan Behrens <sbehrens@giantdisaster.de>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: remove superblock writing after fatal error
References: <1343821552-28726-1-git-send-email-sbehrens@giantdisaster.de> <50191AD3.9080401@gmail.com>
In-Reply-To: <50191AD3.9080401@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, August 01, 2012 at 14:02 (+0200), Liu Bo wrote:
> On 08/01/2012 07:45 PM, Stefan Behrens wrote:
>> With commit acce952b0, btrfs was changed to flag the filesystem with
>> BTRFS_SUPER_FLAG_ERROR and switch to read-only mode after a fatal
>> error happened like a write I/O errors of all mirrors.
>> In such situations, on unmount, the superblock is written in
>> btrfs_error_commit_super(). This is done with the intention to be able
>> to evaluate the error flag on the next mount. A warning is printed
>> in this case during the next mount and the log tree is ignored.
>>
>> The issue is that it is possible that the superblock points to a root
>> that was not written (due to write I/O errors).
>> The result is that the filesystem cannot be mounted. btrfsck also does
>> not start and all the other btrfs-progs tools fail to start as well.
>> However, mount -o recovery is working well and does the right things
>> to recover the filesystem (i.e., don't use the log root, clear the
>> free space cache and use the next mountable root that is stored in the
>> root backup array).
>>
>> This patch removes the writing of the superblock when
>> BTRFS_SUPER_FLAG_ERROR is set, and removes the handling of the error
>> flag in the mount function.
>>
> 
> Yes, I have to admit that this can be a serious problem.
> 
> But we'll need to send the error flag stored in the super block into
> disk in the future so that the next mount can find it unstable and do
> fsck by itself maybe.

Hum, that's possible. However, I neither see

a) a safe way to get that flag to disk

nor

b) a situation where this flag would help. When we abort a transaction, we just
roll everything back to the last commit, i.e. a consistent state. So if we stop
writing a potentially corrupt super block, we should be fine anyway. Or am I
missing something?

-Jan
