Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45985 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756049AbaBRQGm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Feb 2014 11:06:42 -0500
Message-ID: <5303850C.7030008@fb.com>
Date: Tue, 18 Feb 2014 11:06:36 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Alex Lyakas <alex.btrfs@zadarastorage.com>
CC: Liu Bo <bo.li.liu@oracle.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix a deadlock on chunk mutex
References: <1355363557-2962-1-git-send-email-bo.li.liu@oracle.com>	<20121218135242.GC2403@localhost.localdomain> <CAOcd+r2q6+RU_8k_m8=7wr5cjBZ3hLXr1QZCmvWB1hLZyRfoZQ@mail.gmail.com>
In-Reply-To: <CAOcd+r2q6+RU_8k_m8=7wr5cjBZ3hLXr1QZCmvWB1hLZyRfoZQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1



On 02/18/2014 10:47 AM, Alex Lyakas wrote:
> Hello Josef,
> 
> On Tue, Dec 18, 2012 at 3:52 PM, Josef Bacik <jbacik@fusionio.com>
> wrote:
>> On Wed, Dec 12, 2012 at 06:52:37PM -0700, Liu Bo wrote:
>>> An user reported that he has hit an annoying deadlock while
>>> playing with ceph based on btrfs.
>>> 
>>> Current updating device tree requires space from METADATA
>>> chunk, so we -may- need to do a recursive chunk allocation when
>>> adding/updating dev extent, that is where the deadlock comes
>>> from.
>>> 
>>> If we use SYSTEM metadata to update device tree, we can avoid
>>> the recursive stuff.
>>> 
>> 
>> This is going to cause us to allocate much more system chunks
>> than we used to which could land us in trouble.  Instead let's
>> just keep us from re-entering if we're already allocating a
>> chunk.  We do the chunk allocation when we don't have enough
>> space for a cluster, but we'll likely have plenty of space to
>> make an allocation.  Can you give this patch a try Jim and see if
>> it fixes your problem? Thanks,
>> 
>> Josef
>> 
>> 
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c 
>> index e152809..59df5e7 100644 --- a/fs/btrfs/extent-tree.c +++
>> b/fs/btrfs/extent-tree.c @@ -3564,6 +3564,10 @@ static int
>> do_chunk_alloc(struct btrfs_trans_handle *trans, int
>> wait_for_alloc = 0; int ret = 0;
>> 
>> +       /* Don't re-enter if we're already allocating a chunk */ 
>> +       if (trans->allocating_chunk) +               return
>> -ENOSPC; + space_info = __find_space_info(extent_root->fs_info,
>> flags); if (!space_info) { ret =
>> update_space_info(extent_root->fs_info, flags, @@ -3606,6 +3610,8
>> @@ again: goto again; }
>> 
>> +       trans->allocating_chunk = true; + /* * If we have mixed
>> data/metadata chunks we want to make sure we keep * allocating
>> mixed chunks instead of individual chunks. @@ -3632,6 +3638,7 @@
>> again: check_system_chunk(trans, extent_root, flags);
>> 
>> ret = btrfs_alloc_chunk(trans, extent_root, flags); +
>> trans->allocating_chunk = false; if (ret < 0 && ret != -ENOSPC) 
>> goto out;
>> 
>> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c 
>> index e6509b9..47ad8be 100644 --- a/fs/btrfs/transaction.c +++
>> b/fs/btrfs/transaction.c @@ -388,6 +388,7 @@ again: 
>> h->qgroup_reserved = qgroup_reserved; h->delayed_ref_elem.seq =
>> 0; h->type = type; +       h->allocating_chunk = false; 
>> INIT_LIST_HEAD(&h->qgroup_ref_list); 
>> INIT_LIST_HEAD(&h->new_bgs);
>> 
>> diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h 
>> index 0e8aa1e..69700f7 100644 --- a/fs/btrfs/transaction.h +++
>> b/fs/btrfs/transaction.h @@ -68,6 +68,7 @@ struct
>> btrfs_trans_handle { struct btrfs_block_rsv *orig_rsv; short
>> aborted; short adding_csums; +       bool allocating_chunk; enum
>> btrfs_trans_type type; /* * this root is only needed to validate
>> that the root passed to
> 
> I hit this problem in a following scenario: - a data chunk
> allocation is triggered, and locks chunk_mutex - the same thread
> now also wants to allocate a metadata chunk, so it recursively
> calls do_chunk_alloc, but cannot lock the chunk_mutex => deadlock -
> btrfs has only one metadata chunk, the one that was initially 
> allocated by mkfs, it has: total_bytes=8388608 bytes_used=8130560 
> bytes_pinned=77824 bytes_reserved=180224 so bytes_used +
> bytes_pinned + bytes_reserved == total_bytes
> 
> Your patch would have returned ENOSPC and avoid the deadlock, but 
> there would be a failure to allocate a tree block for metadata. So
> the transaction would have probably aborted.
> 
> How such situation should be handled?
> 
> Idea1: - lock chunk mutex, - if we are allocating a data chunk,
> check whether the metadata space is below some threshold. If yes,
> go and allocate a metadata chunk first and then only a data chunk.
> 
> Idea2: - check if we are the same thread that already locked the
> chunk mutex. If yes, allow recursive call but don't attempt to
> lock/unlock the chunk_mutex this time
> 
> Or some other way?
> 

I fixed this with the delayed chunk allocation stuff which doesn't
actually do the block group creation stuff until we end the
transaction, so we can allocate metadata chunks without any issue.
Thanks,

Josef
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTA4UMAAoJEANb+wAKly3B+KEP/RdlEyJWydetjQxllF0cgHY1
UraqWBl+mSSHlwZlHyGjmAu6cK6n+QfTZtdIBhihdY50UcvMuWtVmz2JzlbxeO5+
88dBevADmW+QQoRl0yyQgnjlLWm+LvMTgOd1r+DZqlGs6sdX05dMI207+fQOW+c4
P+UKbT/eUYRVC4K//J1GUk4Yh3Q70U25321RWCehSUciwDVJO2LztD9VBAgh3qUc
o5uh5syshS3RbEi0hnUQ8tDKXWvdZQBA2RF4loXACCmQO95e84mxVpoYPd9S1yYs
J+wf+Bak5hKZxmXJkOVcjLj4GsVQFJWTBTj6FvOFrm5TAFEGSyzrEzL8xW361+VS
I1q8GPSVN1fGKkVypddylLIXLHmqXb57UElvGhoBM0otxNd8+xfSpLZ045vv5qLx
RKwhJI1gIWD59kBre0fdSkUJZDeYSmLWOiwG6hG3A7Yy93c6/1RLHRnHq5NEe12R
nrqZKBnkvDKnL/21eVqpOMo7i/AzCB7N+ojfaql2WvWcLkCpomhLBgC18Q1RiSzZ
nfmafQIUPunM4l/fLXsbYFdiUu2jSZWZuTpOV71lYUqfrUydqBCZqTpWAlmfkNQ7
C4BHMtgfiRn6CI2KzpP6DpdGJbxjExEWzwheaswffN5TzOxEHQeRvHOKI41ln1i7
UfdifDhUx+zZl0TxMesQ
=elae
-----END PGP SIGNATURE-----
