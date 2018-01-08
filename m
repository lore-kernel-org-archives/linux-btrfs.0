Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57835 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756239AbeAHMaE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Jan 2018 07:30:04 -0500
Subject: Re: [PATCH 0/2] Remove custom crc32c init code from btrfs
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        herbert@gondor.apana.org.au
References: <1515404705-490-1-git-send-email-nborisov@suse.com>
 <CAGqmi771dsWiAJC8=xYn+cvkNoCaTA9uzosrAAhfp9ABxR9+bg@mail.gmail.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <5deadae2-3b0f-0a8e-e271-e53856af8810@suse.com>
Date: Mon, 8 Jan 2018 14:30:01 +0200
MIME-Version: 1.0
In-Reply-To: <CAGqmi771dsWiAJC8=xYn+cvkNoCaTA9uzosrAAhfp9ABxR9+bg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  8.01.2018 12:21, Timofey Titovets wrote:
> 2018-01-08 12:45 GMT+03:00 Nikolay Borisov <nborisov@suse.com>:
>> So here is a small 2 patch set which removes btrfs' manual initialisation of
>> the lower level crc32c module. Explanation why is ok can be found in Patch 2/2.
>>
>> Patch 1/2 just adds a function to the generic crc32c header which allows
>> querying the actual crc32c implementaiton used (i.e. software or hw-accelerated)
>> to retain current btrfs behavior. This is mainly used for debugging purposes
>> and is independent.
>>
>> Nikolay Borisov (2):
>>   libcrc32c: Add crc32c_impl function
>>   btrfs: Remove custom crc32c init code
>>
>>  fs/btrfs/Kconfig           |  3 +--
>>  fs/btrfs/Makefile          |  2 +-
>>  fs/btrfs/check-integrity.c |  4 ++--
>>  fs/btrfs/ctree.h           | 16 ++++++++++++++
>>  fs/btrfs/dir-item.c        |  1 -
>>  fs/btrfs/disk-io.c         |  4 ++--
>>  fs/btrfs/extent-tree.c     | 10 ++++-----
>>  fs/btrfs/hash.c            | 54 ----------------------------------------------
>>  fs/btrfs/hash.h            | 43 ------------------------------------
>>  fs/btrfs/inode-item.c      |  1 -
>>  fs/btrfs/inode.c           |  1 -
>>  fs/btrfs/props.c           |  2 +-
>>  fs/btrfs/send.c            |  4 ++--
>>  fs/btrfs/super.c           | 14 ++++--------
>>  fs/btrfs/tree-log.c        |  2 +-
>>  include/linux/crc32c.h     |  1 +
>>  lib/libcrc32c.c            |  6 ++++++
>>  17 files changed, 42 insertions(+), 126 deletions(-)
>>  delete mode 100644 fs/btrfs/hash.c
>>  delete mode 100644 fs/btrfs/hash.h
>>
>> --
>> 2.7.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> Reviewed-by: Timofey Titovets <nefelim4ag@gmail.com>
> 
> P.S.
> May that are overkill to remove hash.c completely?
> i.e. if we have a "plan" to support another hash algo,
> we still need some abstractions for that.

NAK.

Btrfs' code base has seen way too many instances of people dumping code
"in anticipation of feature X", only to result in said feature never
materializing. The end result is cruft being added. When/if someones
decides to add a new checksum algo they will have to account for the
existing crc32c and come up with appropriate abstraction. Until (if at
all) that time comes - we don't need any of the hash.[ch] stuff.

> 
> Inband dedup don't touch hash.* so, no one else must be affected.
> 
> Thanks.
> 
