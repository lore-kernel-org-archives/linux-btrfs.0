Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56836 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388884AbeHAOWZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 1 Aug 2018 10:22:25 -0400
Subject: Re: [PATCH 1/1] btrfs: Handle owner mismatch gracefully when walking
 up tree
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20180801080801.13024-1-wqu@suse.com>
 <e8a19507-1dbc-1192-338d-0c9d7692de3a@suse.com>
 <5e58b233-ab3a-6b53-994b-9fbfbb21b05d@gmx.com>
 <86ccc5d4-ecca-9887-257d-4dbe433a73bb@suse.com>
 <d3bc0a37-384b-eb57-8c5c-e30aa1190b1b@gmx.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <eba9c614-23c0-d752-2f56-f0dd505414ba@suse.com>
Date: Wed, 1 Aug 2018 15:36:45 +0300
MIME-Version: 1.0
In-Reply-To: <d3bc0a37-384b-eb57-8c5c-e30aa1190b1b@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  1.08.2018 15:19, Qu Wenruo wrote:
> 
> 
> On 2018年08月01日 20:12, Nikolay Borisov wrote:
>>
>>
>> On  1.08.2018 14:13, Qu Wenruo wrote:
>>>
>>>
>>> On 2018年08月01日 18:08, Nikolay Borisov wrote:
>>>>
>>>>
>>>> On  1.08.2018 11:08, Qu Wenruo wrote:
>>>>> [BUG]
>>>>> When mounting certain crafted image, btrfs will trigger kernel BUG_ON()
>>>>> when try to recover balance:
>>>>> ------
>>>>> ------------[ cut here ]------------
>>>>> kernel BUG at fs/btrfs/extent-tree.c:8956!
>>>>> invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
>>>>> CPU: 1 PID: 662 Comm: mount Not tainted 4.18.0-rc1-custom+ #10
>>>>> RIP: 0010:walk_up_proc+0x336/0x480 [btrfs]
>>>>> RSP: 0018:ffffb53540c9b890 EFLAGS: 00010202
>>>>> Call Trace:
>>>>>  walk_up_tree+0x172/0x1f0 [btrfs]
>>>>>  btrfs_drop_snapshot+0x3a4/0x830 [btrfs]
>>>>>  merge_reloc_roots+0xe1/0x1d0 [btrfs]
>>>>>  btrfs_recover_relocation+0x3ea/0x420 [btrfs]
>>>>>  open_ctree+0x1af3/0x1dd0 [btrfs]
>>>>>  btrfs_mount_root+0x66b/0x740 [btrfs]
>>>>>  mount_fs+0x3b/0x16a
>>>>>  vfs_kern_mount.part.9+0x54/0x140
>>>>>  btrfs_mount+0x16d/0x890 [btrfs]
>>>>>  mount_fs+0x3b/0x16a
>>>>>  vfs_kern_mount.part.9+0x54/0x140
>>>>>  do_mount+0x1fd/0xda0
>>>>>  ksys_mount+0xba/0xd0
>>>>>  __x64_sys_mount+0x21/0x30
>>>>>  do_syscall_64+0x60/0x210
>>>>>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
>>>>> ---[ end trace d4344e4deee03435 ]---
>>>>> ------
>>>>>
>>>>> [CAUSE]
>>>>> Another extent tree corruption.
>>>>>
>>>>> In this particular case, tree reloc root's owner is
>>>>> DATA_RELOC_TREE (should be TREE_RELOC_TREE), thus its backref is
>>>>> corrupted and we failed the owner check in walk_up_tree().
>>>>>
>>>>> [FIX]
>>>>> It's pretty hard to take care of every extent tree corruption, but at
>>>>> least we can remove such BUG_ON() and exit more gracefully.
>>>>>
>>>>> And since in this particular image, DATA_RELOC_TREE and TREE_RELOC_TREE
>>>>> shares the same root (which is obviously invalid), we needs to make
>>>>> __del_reloc_root() more robust to detect such invalid share to avoid
>>>>> possible NULL dereference as root->node can be NULL in this case.
>>>>>
>>>>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=200411
>>>>> Reported-by: Xu Wen <wen.xu@gatech.edu>
>>>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>>>> ---
>>>>> As always, the patch is also pushed to my github repo, along with other
>>>>> fuzzed images related fixes:
>>>>> https://github.com/adam900710/linux/tree/tree_checker_enhance
>>>>> (BTW, is it correct to indicate a branch like above?)
>>>>> ---
>>>>>  fs/btrfs/extent-tree.c | 27 +++++++++++++++++++--------
>>>>>  fs/btrfs/relocation.c  |  2 +-
>>>>>  2 files changed, 20 insertions(+), 9 deletions(-)
>>>>>
>>>>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>>>>> index da615ebc072e..5f4ca61348b5 100644
>>>>> --- a/fs/btrfs/extent-tree.c
>>>>> +++ b/fs/btrfs/extent-tree.c
>>>>> @@ -8949,17 +8949,26 @@ static noinline int walk_up_proc(struct btrfs_trans_handle *trans,
>>>>>  	}
>>>>>  
>>>>>  	if (eb == root->node) {
>>>>> -		if (wc->flags[level] & BTRFS_BLOCK_FLAG_FULL_BACKREF)
>>>>> +		if (wc->flags[level] & BTRFS_BLOCK_FLAG_FULL_BACKREF) {
>>>>>  			parent = eb->start;
>>>>> -		else
>>>>> -			BUG_ON(root->root_key.objectid !=
>>>>> -			       btrfs_header_owner(eb));
>>>>> +		} else if (root->root_key.objectid != btrfs_header_owner(eb)) {
>>>>> +			btrfs_err_rl(fs_info,
>>>>> +			"unexpected tree owner, have %llu expect %llu",
>>>>> +				     btrfs_header_owner(eb),
>>>>> +				     root->root_key.objectid);
>>>>> +			return -EINVAL;
>>>>
>>>> EINVAL or ECLEANUP?
>>>
>>> Yep, also my concern here.
>>>
>>> I have no bias here, and both makes its sense here.
>>>
>>> EUCLEAN means it's something unexpected, but normally it's used in
>>> static check, no sure if it suits for runtime check.
>>
>> My thinking goes if something is an on-disk error (and fuzzed images
>> fall in that category) then we should return EUCLEAN. If the owner can
>> be mismatched only as a result of erroneous data on-disk which is then
>> read and subsequently this code triggers then it's something induced due
>> to an on-disk error.
> 
> Makes sense.
> 
> Does it also mean later BUG_ON() convert would also use EUCLEAN as most
> BUG_ON() is either some real bug or corrupted/fuzzed images?

If you refer to the next hunk the patch then I'd say yes.
> 
> Thanks,
> Qu
> 
>>
>>>
>>> Although EINVAL looks more suitable for runtime error, it is not a
>>> perfect errno either, as it's not something invalid from user, but the
>>> fs has something unexpected.
>>>
>>> I'm all ears on this errno issue.
>>>
>>> Thanks,
>>> Qu
>>>
>>>>
>>>>> +		}
>>>>>  	} else {
>>>>> -		if (wc->flags[level + 1] & BTRFS_BLOCK_FLAG_FULL_BACKREF)
>>>>> +		if (wc->flags[level + 1] & BTRFS_BLOCK_FLAG_FULL_BACKREF) {
>>>>>  			parent = path->nodes[level + 1]->start;
>>>>> -		else
>>>>> -			BUG_ON(root->root_key.objectid !=
>>>>> -			       btrfs_header_owner(path->nodes[level + 1]));
>>>>> +		} else if (root->root_key.objectid !=
>>>>> +			   btrfs_header_owner(path->nodes[level + 1])) {
>>>>> +			btrfs_err_rl(fs_info,
>>>>> +			"unexpected tree owner, have %llu expect %llu",
>>>>> +				     btrfs_header_owner(eb),
>>>>> +				     root->root_key.objectid);
>>>>> +			return -EINVAL;
>>>> ditto
>>>>> +		}
>>>>>  	}
>>>>>  
>>>>>  	btrfs_free_tree_block(trans, root, eb, parent, wc->refs[level] == 1);
>>>>> @@ -9020,6 +9029,8 @@ static noinline int walk_up_tree(struct btrfs_trans_handle *trans,
>>>>>  			ret = walk_up_proc(trans, root, path, wc);
>>>>>  			if (ret > 0)
>>>>>  				return 0;
>>>>> +			if (ret < 0)
>>>>> +				return ret;
>>>>>  
>>>>>  			if (path->locks[level]) {
>>>>>  				btrfs_tree_unlock_rw(path->nodes[level],
>>>>> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
>>>>> index a2fc0bd83a40..c64051d33d05 100644
>>>>> --- a/fs/btrfs/relocation.c
>>>>> +++ b/fs/btrfs/relocation.c
>>>>> @@ -1321,7 +1321,7 @@ static void __del_reloc_root(struct btrfs_root *root)
>>>>>  	struct mapping_node *node = NULL;
>>>>>  	struct reloc_control *rc = fs_info->reloc_ctl;
>>>>>  
>>>>> -	if (rc) {
>>>>> +	if (rc && root->node) {
>>>>>  		spin_lock(&rc->reloc_root_tree.lock);
>>>>>  		rb_node = tree_search(&rc->reloc_root_tree.rb_root,
>>>>>  				      root->node->start);
>>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
> 
