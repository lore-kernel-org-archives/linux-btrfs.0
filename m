Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:35483 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751875AbeDIO3v (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 9 Apr 2018 10:29:51 -0400
Subject: Re: [PATCH] btrfs-progs: Use more loose open ctree flags for
 dump-tree and restore
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180406063919.11771-1-wqu@suse.com>
 <20180409141235.GP8557@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <a75a16c3-eb04-5c64-a861-e370aa144606@gmx.com>
Date: Mon, 9 Apr 2018 22:29:34 +0800
MIME-Version: 1.0
In-Reply-To: <20180409141235.GP8557@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018年04月09日 22:12, David Sterba wrote:
> On Fri, Apr 06, 2018 at 02:39:19PM +0800, Qu Wenruo wrote:
>> Corrupted extent tree (either the root node or leaf) can normally block
>> us from open the fs.
>> As normally open_ctree() has the following call chain:
>> __open_ctree_fd()
>> |- btrfs_setup_all_roots()
>>    |- btrfs_read_block_groups()
>>       And we will search block group items in extent tree.
>>
>> And considering how block group items are scattered around the whole
>> extent tree, any error would block the fs from being mounted.
>>
>> Fortunately, we already have OPEN_CTREE_NO_BLOCK_GROUPS flags to disable
>> block group items search, which will not only allow us to open some
>> fs, but also hugely speed up open time.
>>
>> Currently dump-tree and btrfs-restore is ensured that they care nothing
>> about block group items. So specify OPEN_CTREE_NO_BLOCK_GROUPS flag as
>> default.
>>
>> Also fix a typo where dump-tree is using OPEN_CTREE_FS_PARTIAL, which
>> should be OPEN_CTREE_PARTIAL.
>> This makes dump-tree do more check and can sometimes fail to open
>> certain filesystems.
> 
> Oh, that's too easy to get wrong, we should rename one or the other.

Of course, I'll add extra patches for this.

> 
>> Reported-by: Christoph Anton Mitterer <calestyo@scientia.net>
>> Fixes: 8698a2b9ba89 ("btrfs-progs: Allow inspect dump-tree to show specified tree block even some tree roots are corrupted")
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  cmds-inspect-dump-tree.c | 4 +++-
>>  cmds-restore.c           | 3 ++-
>>  2 files changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/cmds-inspect-dump-tree.c b/cmds-inspect-dump-tree.c
>> index 7defb7164a49..8be976041543 100644
>> --- a/cmds-inspect-dump-tree.c
>> +++ b/cmds-inspect-dump-tree.c
>> @@ -303,7 +303,9 @@ int cmd_inspect_dump_tree(int argc, char **argv)
>>  	int uuid_tree_only = 0;
>>  	int roots_only = 0;
>>  	int root_backups = 0;
>> -	unsigned open_ctree_flags = OPEN_CTREE_FS_PARTIAL;
>> +	/* Speed up open_ctree() and continue if extent tree is corrupted */
>> +	unsigned open_ctree_flags = OPEN_CTREE_PARTIAL |
>> +				    OPEN_CTREE_NO_BLOCK_GROUPS;
> 
> We could consider that separatelly, whether to allow dumping a partially
> created filesystem, ie. OPEN_CTREE_FS_PARTIAL added by a new option.

For dump-tree, there is really no limitation here.
As long as chunk tree is OK, we should be OK to do "-b" dump.

For "-t" or all tree (default) dump, with chunk tree opened only, we
could try our best to print any good trees.
So I don't get the point to read all other trees.

Thanks,
Qu

> This would be really for debugging/testing purposes, but could be useful
> when the filesystem is prefilled with files or if we enable the runtime
> features and the final write fails for some reason.
> 
>>  	u64 block_bytenr;
>>  	struct btrfs_root *tree_root_scan;
>>  	u64 tree_id = 0;
>> diff --git a/cmds-restore.c b/cmds-restore.c
>> index ade35f0f880f..b43bd2ac6502 100644
>> --- a/cmds-restore.c
>> +++ b/cmds-restore.c
>> @@ -1282,7 +1282,8 @@ static struct btrfs_root *open_fs(const char *dev, u64 root_location,
>>  	for (i = super_mirror; i < BTRFS_SUPER_MIRROR_MAX; i++) {
>>  		bytenr = btrfs_sb_offset(i);
>>  		fs_info = open_ctree_fs_info(dev, bytenr, root_location, 0,
>> -					     OPEN_CTREE_PARTIAL);
>> +					     OPEN_CTREE_PARTIAL |
>> +					     OPEN_CTREE_NO_BLOCK_GROUPS);
>>  		if (fs_info)
>>  			break;
>>  		fprintf(stderr, "Could not open root, trying backup super\n");
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
