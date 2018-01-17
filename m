Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42723 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753337AbeAQO3U (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Jan 2018 09:29:20 -0500
Subject: Re: [PATCH 2/3] btrfs-progs: dir-item: Allow dir item and dir index
 lookup to ignore found problem
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20180117051710.16853-1-wqu@suse.com>
 <20180117051710.16853-3-wqu@suse.com>
 <091f7f35-5ac1-810d-46f0-b375ce96203a@suse.com>
 <156ff191-29a7-271a-11be-e611557edb79@gmx.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <1489f365-a844-a2bb-0edc-2d3fe4397ef1@suse.com>
Date: Wed, 17 Jan 2018 16:29:17 +0200
MIME-Version: 1.0
In-Reply-To: <156ff191-29a7-271a-11be-e611557edb79@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 17.01.2018 16:23, Qu Wenruo wrote:
> 
> 
> On 2018年01月17日 21:13, Nikolay Borisov wrote:
>>
>>
>> On 17.01.2018 07:17, Qu Wenruo wrote:
>>> For functions btrfs_lookup_dir_index() and btrfs_lookup_dir_item(), they
>>> will check if the dir item/index is valid before doing further check.
>>>
>>> The behavior is pretty good for healthy fs, but calling them on
>>> corrupted fs with incorrect dir item/index will also return NULL, making
>>> repair code unable to reuse them.
>>>
>>> This patch add a new parameter @verify to address the problem.
>>> For normal operation, @verify should be set to true to keep the old
>>> behavior.
>>>
>>> While for some functions used in repair, like btrfs_unlink(), they can
>>> set @verify to false, so repair code can locate corrupted dir index/item
>>> and do what they should do (either repair or just delete).
>>>
>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>
>> I'm not satisfied with the approach taken. A boolean parameter is
>> sprinkled around the code just so that we decide whether we invoke
>> verify_dir_item or not. My idea (which dunno how sensible it is for this
>> patch series) is to have 2 sets of public API functions:
>>
>> 1. Augmented checking ones (equivalent to the boolean parameter set to
>> true i.e. btrfs_lookup_dir_index_verify or somesuch). The idea is they
>> should be used in contexts where we want extended validation and it
>> should be explicit we require this. Likely we'd use them during the
>> check phase
>>
>> 2. Same api but without the _verify (or whatever suffix, I don't mind)
>>
>> The two sets of apis should be really slim and implemented from
>> composable low-level/private functions. To put things concretely I
>> believe btrfs_match_dir_item_name in this case to be the
>> "low-level/private" function and the above 2 version to consist of the
>> private version + additional code necessary to satisfy their interfaces.
>>
>> This comment should really be considered in the broader context of your
>> lowmem/original mode refactoring work, not necessarily for this patch
>> set. But in the long term we should really strive to avoid horrendous
>> function interface where we add a parameter for tweaking every little
>> bit of behavior.
> 
> Yes, when writing the patch I'm also not satisfied with the bool
> parameter, but had no better solution.
> 
> (My alternative was change bool to something like #define VERIFY 1, but
> that's either satisfying)
> 
> Your idea is much better than any of my alternatives, but I'm not really
> sure if this is expendable enough.
> 
> One of the biggest challenge here is, if later we need another parameter
> to, for example skip another check, we need 4 definitions, and 8 for
> another.

So my point is that we should avoid working at a granularity where we
have to device "do we want check X or check Y or both". We should either
have defensive versions (aggressive validation) or no additional
validation at all. The private versions, that constitute the core
functionality, should of course have the minimal amount of error
checking to make the code correct but not necessarily overly hardened.

> 
> I'm OK with current _verify suffix, but I'm really not sure what the
> situation will be in the future.
> 
> Thanks,
> Qu
> 
> 
>>
>>> ---
>>>  cmds-check.c   |  2 +-
>>>  convert/main.c |  2 +-
>>>  ctree.h        |  4 ++--
>>>  dir-item.c     | 34 ++++++++++++++++++++++++++--------
>>>  inode.c        | 14 +++++++-------
>>>  5 files changed, 37 insertions(+), 19 deletions(-)
>>>
>>> diff --git a/cmds-check.c b/cmds-check.c
>>> index f302724dd840..59575506c83e 100644
>>> --- a/cmds-check.c
>>> +++ b/cmds-check.c
>>> @@ -3074,7 +3074,7 @@ static int delete_dir_index(struct btrfs_root *root,
>>>  	btrfs_init_path(&path);
>>>  	di = btrfs_lookup_dir_index(trans, root, &path, backref->dir,
>>>  				    backref->name, backref->namelen,
>>> -				    backref->index, -1);
>>> +				    backref->index, -1, false);
>>>  	if (IS_ERR(di)) {
>>>  		ret = PTR_ERR(di);
>>>  		btrfs_release_path(&path);
>>> diff --git a/convert/main.c b/convert/main.c
>>> index 89f9261172ca..102ba4fc5ae2 100644
>>> --- a/convert/main.c
>>> +++ b/convert/main.c
>>> @@ -1580,7 +1580,7 @@ static int do_rollback(const char *devname)
>>>  	/* Search the image file */
>>>  	root_dir = btrfs_root_dirid(&image_root->root_item);
>>>  	dir = btrfs_lookup_dir_item(NULL, image_root, &path, root_dir,
>>> -			image_name, strlen(image_name), 0);
>>> +			image_name, strlen(image_name), 0, true);
>>>  
>>>  	if (!dir || IS_ERR(dir)) {
>>>  		btrfs_release_path(&path);
>>> diff --git a/ctree.h b/ctree.h
>>> index ef422ea60031..02529f4cb021 100644
>>> --- a/ctree.h
>>> +++ b/ctree.h
>>> @@ -2679,12 +2679,12 @@ struct btrfs_dir_item *btrfs_lookup_dir_item(struct btrfs_trans_handle *trans,
>>>  					     struct btrfs_root *root,
>>>  					     struct btrfs_path *path, u64 dir,
>>>  					     const char *name, int name_len,
>>> -					     int mod);
>>> +					     int mod, bool verify);
>>>  struct btrfs_dir_item *btrfs_lookup_dir_index(struct btrfs_trans_handle *trans,
>>>  					      struct btrfs_root *root,
>>>  					      struct btrfs_path *path, u64 dir,
>>>  					      const char *name, int name_len,
>>> -					      u64 index, int mod);
>>> +					      u64 index, int mod, bool verify);
>>>  int btrfs_delete_one_dir_name(struct btrfs_trans_handle *trans,
>>>  			      struct btrfs_root *root,
>>>  			      struct btrfs_path *path,
>>> diff --git a/dir-item.c b/dir-item.c
>>> index 462546c0eaf4..31ad1eca29d5 100644
>>> --- a/dir-item.c
>>> +++ b/dir-item.c
>>> @@ -24,7 +24,7 @@
>>>  
>>>  static struct btrfs_dir_item *btrfs_match_dir_item_name(struct btrfs_root *root,
>>>  			      struct btrfs_path *path,
>>> -			      const char *name, int name_len);
>>> +			      const char *name, int name_len, bool verify);
>>>  
>>>  static struct btrfs_dir_item *insert_with_overflow(struct btrfs_trans_handle
>>>  						   *trans,
>>> @@ -43,7 +43,8 @@ static struct btrfs_dir_item *insert_with_overflow(struct btrfs_trans_handle
>>>  	ret = btrfs_insert_empty_item(trans, root, path, cpu_key, data_size);
>>>  	if (ret == -EEXIST) {
>>>  		struct btrfs_dir_item *di;
>>> -		di = btrfs_match_dir_item_name(root, path, name, name_len);
>>> +		di = btrfs_match_dir_item_name(root, path, name, name_len,
>>> +					       true);
>>>  		if (di)
>>>  			return ERR_PTR(-EEXIST);
>>>  		ret = btrfs_extend_item(root, path, data_size);
>>> @@ -196,7 +197,7 @@ struct btrfs_dir_item *btrfs_lookup_dir_item(struct btrfs_trans_handle *trans,
>>>  					     struct btrfs_root *root,
>>>  					     struct btrfs_path *path, u64 dir,
>>>  					     const char *name, int name_len,
>>> -					     int mod)
>>> +					     int mod, bool verify)
>>>  {
>>>  	int ret;
>>>  	struct btrfs_key key;
>>> @@ -227,14 +228,31 @@ struct btrfs_dir_item *btrfs_lookup_dir_item(struct btrfs_trans_handle *trans,
>>>  	    found_key.offset != key.offset)
>>>  		return NULL;
>>>  
>>> -	return btrfs_match_dir_item_name(root, path, name, name_len);
>>> +	return btrfs_match_dir_item_name(root, path, name, name_len, verify);
>>>  }
>>>  
>>> +/*
>>> + * Lookup dir index
>>> + * 
>>> + * @dir:	dir inode number
>>> + * @name:	the filename we're looking for
>>> + * @name_len:	name length
>>> + * @index:	dir index
>>> + *
>>> + * Normally (@root, @dir, @index) should be enough to locate a dir index in a
>>> + * *healthy* fs.
>>> + * But with @name and @name_len, we can even handle corrupted fs with
>>> + * duplicated DIR_INDEX.
>>
>> Put this description text after you documented the members.
>>
>>> + *
>>> + * @mod:	if we're going to modify the dir_index, needs @trans
>>> + * @verify:	if we need to verify the dir_item before search
>>> + * 		useful for check to delet corrupted dir index.
>>> + */
>>>  struct btrfs_dir_item *btrfs_lookup_dir_index(struct btrfs_trans_handle *trans,
>>>  					      struct btrfs_root *root,
>>>  					      struct btrfs_path *path, u64 dir,
>>>  					      const char *name, int name_len,
>>> -					      u64 index, int mod)
>>> +					      u64 index, int mod, bool verify)
>>>  {
>>>  	int ret;
>>>  	struct btrfs_key key;
>>> @@ -251,7 +269,7 @@ struct btrfs_dir_item *btrfs_lookup_dir_index(struct btrfs_trans_handle *trans,
>>>  	if (ret > 0)
>>>  		return ERR_PTR(-ENOENT);
>>>  
>>> -	return btrfs_match_dir_item_name(root, path, name, name_len);
>>> +	return btrfs_match_dir_item_name(root, path, name, name_len, verify);
>>>  }
>>>  
>>>  /*
>>> @@ -323,7 +341,7 @@ static int verify_dir_item(struct btrfs_root *root,
>>>  
>>>  static struct btrfs_dir_item *btrfs_match_dir_item_name(struct btrfs_root *root,
>>>  			      struct btrfs_path *path,
>>> -			      const char *name, int name_len)
>>> +			      const char *name, int name_len, bool verify)
>>>  {
>>>  	struct btrfs_dir_item *dir_item;
>>>  	unsigned long name_ptr;
>>> @@ -335,7 +353,7 @@ static struct btrfs_dir_item *btrfs_match_dir_item_name(struct btrfs_root *root,
>>>  	leaf = path->nodes[0];
>>>  	dir_item = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_dir_item);
>>>  	total_len = btrfs_item_size_nr(leaf, path->slots[0]);
>>> -	if (verify_dir_item(root, leaf, dir_item))
>>> +	if (verify && verify_dir_item(root, leaf, dir_item))
>>>  		return NULL;
>>>  
>>>  	while(cur < total_len) {
>>> diff --git a/inode.c b/inode.c
>>> index 2398bca4a109..7b9a40062bb3 100644
>>> --- a/inode.c
>>> +++ b/inode.c
>>> @@ -123,7 +123,7 @@ int check_dir_conflict(struct btrfs_root *root, char *name, int namelen,
>>>  
>>>  	/* Name conflicting? */
>>>  	dir_item = btrfs_lookup_dir_item(NULL, root, path, dir, name,
>>> -					 namelen, 0);
>>> +					 namelen, 0, true);
>>>  	if (IS_ERR(dir_item)) {
>>>  		ret = PTR_ERR(dir_item);
>>>  		goto out;
>>> @@ -136,7 +136,7 @@ int check_dir_conflict(struct btrfs_root *root, char *name, int namelen,
>>>  
>>>  	/* Index conflicting? */
>>>  	dir_item = btrfs_lookup_dir_index(NULL, root, path, dir, name,
>>> -					  namelen, index, 0);
>>> +					  namelen, index, 0, true);
>>>  	if (IS_ERR(dir_item) && PTR_ERR(dir_item) == -ENOENT)
>>>  		dir_item = NULL;
>>>  	if (IS_ERR(dir_item)) {
>>> @@ -301,7 +301,7 @@ int btrfs_unlink(struct btrfs_trans_handle *trans, struct btrfs_root *root,
>>>  	btrfs_release_path(path);
>>>  
>>>  	dir_item = btrfs_lookup_dir_item(NULL, root, path, parent_ino,
>>> -					 name, namelen, 0);
>>> +					 name, namelen, 0, false);
>>>  	if (IS_ERR(dir_item)) {
>>>  		ret = PTR_ERR(dir_item);
>>>  		goto out;
>>> @@ -311,7 +311,7 @@ int btrfs_unlink(struct btrfs_trans_handle *trans, struct btrfs_root *root,
>>>  	btrfs_release_path(path);
>>>  
>>>  	dir_item = btrfs_lookup_dir_index(NULL, root, path, parent_ino,
>>> -					  name, namelen, index, 0);
>>> +					  name, namelen, index, 0, false);
>>>  	/*
>>>  	 * Since lookup_dir_index() will return -ENOENT when not found,
>>>  	 * we need to do extra check.
>>> @@ -370,7 +370,7 @@ int btrfs_unlink(struct btrfs_trans_handle *trans, struct btrfs_root *root,
>>>  	if (del_dir_index) {
>>>  		dir_item = btrfs_lookup_dir_index(trans, root, path,
>>>  						  parent_ino, name, namelen,
>>> -						  index, -1);
>>> +						  index, -1, false);
>>>  		if (IS_ERR(dir_item)) {
>>>  			ret = PTR_ERR(dir_item);
>>>  			goto out;
>>> @@ -403,7 +403,7 @@ int btrfs_unlink(struct btrfs_trans_handle *trans, struct btrfs_root *root,
>>>  
>>>  	if (del_dir_item) {
>>>  		dir_item = btrfs_lookup_dir_item(trans, root, path, parent_ino,
>>> -						 name, namelen, -1);
>>> +						 name, namelen, -1, false);
>>>  		if (IS_ERR(dir_item)) {
>>>  			ret = PTR_ERR(dir_item);
>>>  			goto out;
>>> @@ -532,7 +532,7 @@ int btrfs_mkdir(struct btrfs_trans_handle *trans, struct btrfs_root *root,
>>>  		ret_ino = *ino;
>>>  
>>>  	dir_item = btrfs_lookup_dir_item(NULL, root, path, parent_ino,
>>> -					 name, namelen, 0);
>>> +					 name, namelen, 0, true);
>>>  	if (IS_ERR(dir_item)) {
>>>  		ret = PTR_ERR(dir_item);
>>>  		goto out;
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
