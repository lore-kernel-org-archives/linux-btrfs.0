Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62751 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249Ab3HTORy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Aug 2013 10:17:54 -0400
Message-ID: <52137A8D.40805@redhat.com>
Date: Tue, 20 Aug 2013 09:17:49 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Chris Mason <chris.mason@fusionio.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/12] Btrfs: Remove superfluous casts from u64 to unsigned
 long long
References: <1376997618-13573-1-git-send-email-geert@linux-m68k.org> <1376997618-13573-2-git-send-email-geert@linux-m68k.org> <52137A5A.8060207@redhat.com>
In-Reply-To: <52137A5A.8060207@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 8/20/13 9:16 AM, Eric Sandeen wrote:
> On 8/20/13 6:20 AM, Geert Uytterhoeven wrote:
>> u64 is "unsigned long long" on all architectures now, so there's no need to
>> cast it when formatting it using the "ll" length modifier.
>>
>> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>> ---
>>  fs/btrfs/backref.c          |   24 ++--
>>  fs/btrfs/check-integrity.c  |  294 ++++++++++++++-----------------------------
>>  fs/btrfs/compression.c      |    5 +-
>>  fs/btrfs/ctree.c            |    6 +-
>>  fs/btrfs/delayed-inode.c    |   10 +-
>>  fs/btrfs/dev-replace.c      |    2 +-
>>  fs/btrfs/disk-io.c          |   25 ++--
>>  fs/btrfs/extent-tree.c      |   47 +++----
>>  fs/btrfs/extent_io.c        |   30 ++---
>>  fs/btrfs/file-item.c        |    4 +-
>>  fs/btrfs/free-space-cache.c |    6 +-
>>  fs/btrfs/inode.c            |   24 ++--
>>  fs/btrfs/ioctl.c            |   10 +-
>>  fs/btrfs/ordered-data.c     |   11 +-
>>  fs/btrfs/print-tree.c       |   80 +++++-------
>>  fs/btrfs/qgroup.c           |   10 +-
>>  fs/btrfs/relocation.c       |    7 +-
>>  fs/btrfs/root-tree.c        |    3 +-
>>  fs/btrfs/scrub.c            |   16 +--
>>  fs/btrfs/super.c            |   10 +-
>>  fs/btrfs/transaction.c      |    3 +-
>>  fs/btrfs/volumes.c          |   19 ++-
>>  22 files changed, 222 insertions(+), 424 deletions(-)
>>
>> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
>> index 8bc5e8c..c1a518e 100644
>> --- a/fs/btrfs/backref.c
>> +++ b/fs/btrfs/backref.c
>> @@ -295,10 +295,9 @@ static int __resolve_indirect_ref(struct btrfs_fs_info *fs_info,
>>  	ret = btrfs_search_old_slot(root, &ref->key_for_search, path, time_seq);
>>  	pr_debug("search slot in root %llu (level %d, ref count %d) returned "
>>  		 "%d for key (%llu %u %llu)\n",
>> -		 (unsigned long long)ref->root_id, level, ref->count, ret,
>> -		 (unsigned long long)ref->key_for_search.objectid,
>> -		 ref->key_for_search.type,
>> -		 (unsigned long long)ref->key_for_search.offset);
>> +		 ref->root_id, level, ref->count, ret,
>> +		 ref->key_for_search.objectid, ref->key_for_search.type,
>> +		 ref->key_for_search.offset);
>>  	if (ret < 0)
>>  		goto out;
>>  
>> @@ -1326,8 +1325,7 @@ int extent_from_logical(struct btrfs_fs_info *fs_info, u64 logical,
>>  	     found_key->type != BTRFS_METADATA_ITEM_KEY) ||
>>  	    found_key->objectid > logical ||
>>  	    found_key->objectid + size <= logical) {
>> -		pr_debug("logical %llu is not within any extent\n",
>> -			 (unsigned long long)logical);
>> +		pr_debug("logical %llu is not within any extent\n", logical);
> 
> ...
> 
> Many platforms use "long" for u64, so without these casts, they'll generate
> compile-time printf-format warnings.  See int-l64.h, and the various
> arch/*/include/uapi/asm/types.h files that include it - ia64, ppc, etc.

Sorry, should have read your commit message first ;)  I didn't know that this
had changed...

-Eric

> -Eric
> 

