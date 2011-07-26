From: Justin Ossevoort <justin@internetionals.nl>
Subject: Re: [PATCH 7/7] btrfs: don't BUG_ON allocation errors in btrfs_drop_snapshot
Date: Tue, 26 Jul 2011 15:14:59 +0200
Message-ID: <4E2EBDD3.4020106@internetionals.nl>
References: <1311277713-7747-1-git-send-email-mfasheh@suse.com> <1311277713-7747-2-git-send-email-mfasheh@suse.com> <1311277713-7747-3-git-send-email-mfasheh@suse.com> <1311277713-7747-4-git-send-email-mfasheh@suse.com> <1311277713-7747-5-git-send-email-mfasheh@suse.com> <1311277713-7747-6-git-send-email-mfasheh@suse.com> <1311277713-7747-7-git-send-email-mfasheh@suse.com> <1311277713-7747-8-git-send-email-mfasheh@suse.com> <4E28C81F.8020200@jp.fujitsu.com> <20110725211040.GE6911@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Tsutomu Itoh <t-itoh@jp.fujitsu.com>, linux-btrfs@vger.kernel.org,
	chris.mason@oracle.com
To: Mark Fasheh <mfasheh@suse.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110725211040.GE6911@wotan.suse.de>
List-ID: <linux-btrfs.vger.kernel.org>

On 25/07/11 23:10, Mark Fasheh wrote:
> On Fri, Jul 22, 2011 at 09:45:19AM +0900, Tsutomu Itoh wrote:
>> (2011/07/22 4:48), Mark Fasheh wrote:
>>> In addition to properly handling allocation failure from btrfs_alloc_path, I
>>> also fixed up the kzalloc error handling code immediately below it.
>>>
>>> Signed-off-by: Mark Fasheh <mfasheh@suse.com>
>>> ---
>>>  fs/btrfs/extent-tree.c |    8 ++++++--
>>>  1 files changed, 6 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>>> index ff339b2..4cf5257 100644
>>> --- a/fs/btrfs/extent-tree.c
>>> +++ b/fs/btrfs/extent-tree.c
>>> @@ -6271,10 +6271,14 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
>>>  	int level;
>>>  
>>>  	path = btrfs_alloc_path();
>>> -	BUG_ON(!path);
>>> +	if (!path)
>>> +		return -ENOMEM;
>>>  
>>>  	wc = kzalloc(sizeof(*wc), GFP_NOFS);
>>> -	BUG_ON(!wc);
>>> +	if (!wc) {
>>> +		btrfs_free_path(path);
>>> +		return -ENOMEM;
>>> +	}
>>>  
>>>  	trans = btrfs_start_transaction(tree_root, 0);
>>>  	BUG_ON(IS_ERR(trans));
>>
>> Currently, callers of btrfs_drop_snapshot() ignore the return code.
>> But btrfs_drop_snapshot() detects the error by BUG_ON.
>>
>> The caller still ignore the return code though your modification returns
>> the error code to the caller. 
>> So, we can not detect error. I don't think that it is good.
> 
> IMHO, this is a seperate issue that btrfs_drop_snapshot() has even without
> my patch. You can see in the code that it might return any number of errors,
> all of which get ignored by callers. So my patch is cleaning up some of the
> BUG_ON() usage, but not really solving the 2nd problem of ignored return
> codes. Of course that was on purpose as I like to fix one problem per patch
> if possible and practicle.
> 	--Mark

I Think Tsutomu's point was more that you've changed the behavior from a
BUG() on error to silently ignoring the error.

So you should at least add 'BUG_ON(ERR_PTR(...) == -ENOMEM)' in the
callers to maintain the current behavior while still pushing the check
up the call chain.

Regards,

	justin....
