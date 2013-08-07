Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56800 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753746Ab3HGPSC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 7 Aug 2013 11:18:02 -0400
Message-ID: <52026525.8030004@redhat.com>
Date: Wed, 07 Aug 2013 10:17:57 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Stefan Behrens <sbehrens@giantdisaster.de>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] btrfs-progs: mark static & remove unused from non-kernel
 code
References: <52019C6D.9050308@redhat.com> <52019D5F.3070301@redhat.com> <5201C3CC.8000303@redhat.com> <5201FD1D.7030200@giantdisaster.de>
In-Reply-To: <5201FD1D.7030200@giantdisaster.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 8/7/13 2:54 AM, Stefan Behrens wrote:
> On Tue, 06 Aug 2013 22:49:32 -0500, Eric Sandeen wrote:
>> On 8/6/13 8:05 PM, Eric Sandeen wrote:
>>> Mark many functions as static, and remove any resulting dead code.
>>>
>>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>>> ---
>> ...
>>
>> Actually, what the heck was this (note, this patch was against kdave's integration tree):
>>
>>> diff --git a/send-utils.c b/send-utils.c
>>> index 874f8a5..3d562a4 100644
>>> --- a/send-utils.c
>>> +++ b/send-utils.c
>>> @@ -255,15 +255,6 @@ static int btrfs_subvolid_resolve_sub(int fd, char *path, size_t *path_len,
>>>  	return 0;
>>>  }
>>>  
>>> -void subvol_uuid_search_add(struct subvol_uuid_search *s,
>>> -			    struct subvol_info *si)
>>> -{
>>> -	if (si) {
>>> -		free(si->path);
>>> -		free(si);
>>> -	}
>>> -}
>>> -
>>
>> That code above came into being with "[PATCH v4 3/5] Btrfs-progs: use UUID tree for send/receive" -
>>
>>  void subvol_uuid_search_add(struct subvol_uuid_search *s,
>>  			    struct subvol_info *si)
>>  {
>> -	int cnt;
>> -
>> -	tree_insert(&s->root_id_subvols, si, subvol_search_by_root_id);
>> -	tree_insert(&s->path_subvols, si, subvol_search_by_path);
>> -
>> -	cnt = count_bytes(si->uuid, BTRFS_UUID_SIZE, 0);
>> -	if (cnt != BTRFS_UUID_SIZE)
>> -		tree_insert(&s->local_subvols, si, subvol_search_by_uuid);
>> -	cnt = count_bytes(si->received_uuid, BTRFS_UUID_SIZE, 0);
>> -	if (cnt != BTRFS_UUID_SIZE)
>> -		tree_insert(&s->received_subvols, si,
>> -				subvol_search_by_received_uuid);
>> +	if (si) {
>> +		free(si->path);
>> +		free(si);
>> +	}
>>  }
>>
>> is that, um, really as intended, or did something get misapplied somewhere?
> 
> That was as intended. subvol_uuid_search_add() was not needed anymore
> after the UUID tree patch. But it's part of the btrfs library interface
> which I didn't want to break.

so you have a subvol_uuid_search_add() which . .  . frees things?

That's what was so confusing to me.  Ok, so it's an almost-no-op function
to maintain a symmetric interface, and the only remnant is to free
the things passed to it...

A comment to that effect would have been useful, I guess.  To a casual
code-reader, it just looked like a mistake.

And isn't it still a mistake?  I think it used to be that subvol_uuid_search_init()
would allocate the memory which must be freed, but that's no longer the case,
right?  So under what circumstances is it correct to call
subvol_uuid_search_add() which frees those pointers?

I'm probably missing something.

> Before the UUID tree patch, the send/receive code was creating a
> database (on the heap) of UUIDs, subvols and paths on each invocation.
> The ..._add() function was part of that code. This database building
> code was completely removed and replaced by code that uses the
> tree-search ioctl (this was possible after the addition of the UUID tree
> to the on-disk filesystem).
> 
> But subvol_uuid_search_add() is one of the exported btrfslib functions,
> therefore I tried to stay compatible and to not break the interface.

Oh, hohum.

> To add a BTRFSLIB_VERSION define was proposed some time ago which is
> updated with every interface change. I support this idea.

*nod*

Getting things organized in the tree, with a libbtrfs/ might help,
too.

thanks,
-Eric

> First thing I would like to change in the interface would be to add a
> "btrfs_" prefix to all exported symbols. Unfortunately this is a 30k+
> lines patch, I wrote a tiny sed script for it some time ago and this
> huge patch was the result which I then throw away afterwards.
> 

