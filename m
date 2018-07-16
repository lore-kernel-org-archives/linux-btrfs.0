Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:54187 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726937AbeGPIl3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Jul 2018 04:41:29 -0400
Subject: Re: [PATCH] btrfs-progs: inspect-internal: add option '-k u64,u8,u64'
 of dump-tree
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20180716055507.31708-1-suy.fnst@cn.fujitsu.com>
 <556c8890-2908-7277-961f-8b5335179381@gmx.com>
 <b6dad5b4-6a37-5835-0491-19bda9aa7e5a@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <45a23aef-d93b-fdfc-562d-d6705455324d@gmx.com>
Date: Mon, 16 Jul 2018 16:15:00 +0800
MIME-Version: 1.0
In-Reply-To: <b6dad5b4-6a37-5835-0491-19bda9aa7e5a@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018年07月16日 16:14, Su Yue wrote:
> 
> 
> On 07/16/2018 03:45 PM, Qu Wenruo wrote:
>>
>>
>> On 2018年07月16日 13:55, Su Yue wrote:
>>> For big filesystems, there are many items in trees(extent tree
>>> specially).
>>> For example, to dump one extent, we usually dump extent tree then pipe
>>> result to grep. The time-consuming part is that dump tree traverses
>>> items. And it eats cpu and memory too.
>>>
>>> This patch introduces an option '-k u64,u8,u64' for users(developer more
>>> likely) to appoint a specific key to search and dump, then the path
>>> from root node down the leaf will be dumped.
>>> The search of the key costs most time of this way.
>>
>> Indeed a pretty useful debug oriented feature.
>>
>>>
>>> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
>>> ---
>>> In my experiment, not usual case though.
>>> Image was provided by Chris Murphy, thanks.
>>>
>>> #btrfs filesystem df /mnt
>>> Data, single: total=767.00GiB, used=766.58GiB
>>> System, DUP: total=32.00MiB, used=112.00KiB
>>> Metadata, DUP: total=5.50GiB, used=4.69GiB
>>> Metadata, single: total=16.00MiB, used=0.00B
>>> GlobalReserve, single: total=512.00MiB, used=0.00B
>>>
>>> Before:
>>> #time bash -c 'btrfs inspect-internal dump-tree -t 2 ~/test/test.img
>>> | grep "1295194308608" >> /dev/null'
>>> real    0m34.024s
>>> user    0m3.269s
>>> sys     0m4.047s
>>>
>>> Patched and use -k:
>>> #time bash -c './btrfs inspect-internal dump-tree -t 2  -k
>>> 1295194308608,0,0 ~/test/test.img >> /dev/null'
>>>
>>> real    0m1.408s
>>> user    0m0.006s
>>> sys     0m0.014s
>>>
>>> The new way is 34 times faster than 'grep' way, uses less memory and
>>> cpu, and it prints path useful for debug.
>>>
>>> ---
>>>   cmds-inspect-dump-tree.c |  54 +++++++++++++++++--
>>>   print-tree.c             | 112 +++++++++++++++++++++++++++++++++++++++
>>>   print-tree.h             |   2 +
>>>   3 files changed, 163 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/cmds-inspect-dump-tree.c b/cmds-inspect-dump-tree.c
>>> index c8acd55a0c3a..2a1a40c8270d 100644
>>> --- a/cmds-inspect-dump-tree.c
>>> +++ b/cmds-inspect-dump-tree.c
>>> @@ -184,6 +184,21 @@ static u64 treeid_from_string(const char *str,
>>> const char **end)
>>>       return id;
>>>   }
>>>   +static int parse_key(struct btrfs_key *key)
>>> +{
>>> +
>>> +    int ret = sscanf(optarg, "%llu,%hhu,%llu", &key->objectid,
>>> +             &key->type, &key->offset);
>>> +    if (ret != 3) {
>>> +        error("error parsing key '%s'\n", optarg);
>>> +        ret = -EINVAL;
>>> +    } else {
>>> +        ret = 0;
>>> +    }
>>> +
>>> +    return ret;
>>> +}
>>> +
>>>   const char * const cmd_inspect_dump_tree_usage[] = {
>>>       "btrfs inspect-internal dump-tree [options] device",
>>>       "Dump tree structures from a given device",
>>> @@ -199,6 +214,7 @@ const char * const cmd_inspect_dump_tree_usage[] = {
>>>       "-u|--uuid              print only the uuid tree",
>>>       "-b|--block <block_num> print info from the specified block only",
>>>       "-t|--tree <tree_id>    print only tree with the given id
>>> (string or number)",
>>> +    "-k|--key <u64,u8,u64>  search the specific key then print path,
>>> must with -t",
>>
>> Shouldn't it conflict with -b and -r?
>>
>>>       "--follow               use with -b, to show all children tree
>>> blocks of <block_num>",
>>>       NULL
>>>   };
>>> @@ -224,8 +240,10 @@ int cmd_inspect_dump_tree(int argc, char **argv)
>>>       unsigned open_ctree_flags;
>>>       u64 block_only = 0;
>>>       struct btrfs_root *tree_root_scan;
>>> +    struct btrfs_key spec_key = { 0 };
>>>       u64 tree_id = 0;
>>>       bool follow = false;
>>> +    bool is_key_spec = false;
>>
>> What about @key_set? @is_key_spec looks a little strange here.
>>
> Ok, will call it is_spec_key_set in next version.
> 
>>>         /*
>>>        * For debug-tree, we care nothing about extent tree (it's just
>>> backref
>>> @@ -248,10 +266,11 @@ int cmd_inspect_dump_tree(int argc, char **argv)
>>>               { "block", required_argument, NULL, 'b'},
>>>               { "tree", required_argument, NULL, 't'},
>>>               { "follow", no_argument, NULL, GETOPT_VAL_FOLLOW },
>>> +            {"key", required_argument, NULL, 'k'},
>>
>> Small alignment mismatch, missing a space before "key".
>>
>>>               { NULL, 0, NULL, 0 }
>>>           };
>>>   -        c = getopt_long(argc, argv, "deb:rRut:", long_options, NULL);
>>> +        c = getopt_long(argc, argv, "deb:rRut:k:", long_options, NULL);
>>>           if (c < 0)
>>>               break;
>>>           switch (c) {
>>> @@ -300,6 +319,12 @@ int cmd_inspect_dump_tree(int argc, char **argv)
>>>               }
>>>               break;
>>>               }
>>> +        case 'k':
>>> +            ret = parse_key(&spec_key);
>>> +            if (ret)
>>> +                exit(1);
>>> +            is_key_spec = true;
>>> +            break;
>>>           case GETOPT_VAL_FOLLOW:
>>>               follow = true;
>>>               break;
>>> @@ -308,6 +333,9 @@ int cmd_inspect_dump_tree(int argc, char **argv)
>>>           }
>>>       }
>>>   +    if (!tree_id && is_key_spec)
>>> +        usage(cmd_inspect_dump_tree_usage);
>>> +
>>>       if (check_argc_exact(argc - optind, 1))
>>>           usage(cmd_inspect_dump_tree_usage);
>>>   @@ -398,7 +426,11 @@ again:
>>>               goto close_root;
>>>           }
>>>           printf("root tree\n");
>>> -        btrfs_print_tree(info->tree_root->node, 1);
>>> +        if (is_key_spec)
>>> +            btrfs_print_spec_key(info, BTRFS_ROOT_TREE_OBJECTID,
>>> +                         &spec_key);
>>> +        else
>>> +            btrfs_print_tree(info->tree_root->node, 1);
>>>           goto close_root;
>>>       }
>>>   @@ -408,7 +440,11 @@ again:
>>>               goto close_root;
>>>           }
>>>           printf("chunk tree\n");
>>> -        btrfs_print_tree(info->chunk_root->node, 1);
>>> +        if (is_key_spec)
>>> +            btrfs_print_spec_key(info, BTRFS_CHUNK_TREE_OBJECTID,
>>> +                         &spec_key);
>>> +        else
>>> +            btrfs_print_tree(info->chunk_root->node, 1);
>>>           goto close_root;
>>>       }
>>>   
>>
>> I really don't thing we need to put btrfS_print_spec_key() here.
>>
>> It's in fact a special case, no need to nest it into the loop.
>> Not to mention it appears 3 times in the main loop.
>>
> Not understood what you mean.

I mean, just put the function call of btrfs_print_spec_key() just after
open_ctree_fs_info().
So it should looks like:

info = open_ctree_fs_info();
if (!info){
	/* error handling */
}
if (is_spec_key_set) {
	ret = btrfs_print_spec_key(info, tree_id, &spec_key);
	if (ret < 0) {
		/* Error handling */
	}
	goto close_root;
}

...

Thanks,
Qu

> 
>>> @@ -418,7 +454,11 @@ again:
>>>               goto close_root;
>>>           }
>>>           printf("log root tree\n");
>>> -        btrfs_print_tree(info->log_root_tree->node, 1);
>>> +        if (is_key_spec)
>>> +            btrfs_print_spec_key(info, BTRFS_TREE_LOG_OBJECTID,
>>> +                         &spec_key);
>>> +        else
>>> +            btrfs_print_tree(info->log_root_tree->node, 1);
>>>           goto close_root;
>>>       }
>>>   @@ -564,7 +604,11 @@ again:
>>>                              btrfs_header_level(buf));
>>>                   } else {
>>>                       printf(" \n");
>>> -                    btrfs_print_tree(buf, 1);
>>> +                    if (is_key_spec)
>>> +                        btrfs_print_spec_key(info,
>>> +                             found_key.objectid, &spec_key);
>>> +                    else
>>> +                        btrfs_print_tree(buf, 1);
>>>                   }
>>>               }
>>>               free_extent_buffer(buf);
>>> diff --git a/print-tree.c b/print-tree.c
>>> index a09ecfbb28f0..f3a19fed8591 100644
>>> --- a/print-tree.c
>>> +++ b/print-tree.c
>>> @@ -1459,3 +1459,115 @@ void btrfs_print_tree(struct extent_buffer
>>> *eb, int follow)
>>>         return;
>>>   }
>>> +
>>> +void btrfs_print_spec_key(struct btrfs_fs_info *fs_info, u64
>>> root_objectid,
>>> +              struct btrfs_key *skey)
>>> +{
>>> +    int i;
>>> +    u32 nr;
>>> +    u32 ptr_num;
>>> +    int ret;
>>> +    int level;
>>> +    struct btrfs_root *root;
>>> +    struct btrfs_disk_key disk_key;
>>> +    struct btrfs_key key;
>>> +    struct extent_buffer *next;
>>> +    struct extent_buffer *eb;
>>> +    struct btrfs_path path;
>>> +
>>> +    key.objectid = root_objectid;
>>> +    key.type = BTRFS_ROOT_ITEM_KEY;
>>> +    key.offset = (u64)-1;
>>> +
>>> +    if (key.objectid == BTRFS_TREE_RELOC_OBJECTID)
>>> +        root = btrfs_read_fs_root_no_cache(fs_info, &key);
>>> +    else
>>> +        root = btrfs_read_fs_root(fs_info, &key);
>>> +
>>> +    if (IS_ERR(root) || !root) {
>>> +        error("failed to read tree: %lld", key.objectid);
>>> +        return;
>>> +    }
>>> +
>>> +    btrfs_init_path(&path);
>>> +    ret = btrfs_search_slot(NULL, root, skey, &path, 0, 0);
>>> +    if (ret < 0) {
>>> +        error("error search the key [%llu, %u, %llu] in root %llu",
>>> +              skey->objectid, skey->type, skey->offset,
>>> root->objectid);
>>> +        goto out;
>>> +    }
>>> +
>>> +    if (ret > 0) {
>>> +        if (path.slots[0] > btrfs_header_nritems(path.nodes[0])) {
>>> +            ret = btrfs_next_item(root, &path);
>>> +            if (ret) {
>>> +                error(
>>> +    "error search the key [%llu, %u, %llu] in root %llu, no next key",
>>> +                    skey->objectid, skey->type,
>>> +                    skey->offset, root->objectid);
>>> +                goto out;
>>> +            }
>>> +        }
>>> +
>>> +        btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
>>> +        printf("next to search key is [%llu, %u, %llu]\n",
>>> +               key.objectid, key.type, key.offset);
>>> +    }
>>> +
>>> +    level = btrfs_header_level(root->node);
>>> +    for (; level >= 0 ; --level) {
>>> +        eb = path.nodes[level];
>>> +        next = path.nodes[level - 1];
>>> +        nr = btrfs_header_nritems(eb);
>>
>> In fact, btrfs_print_tree() could replace all the following code.
>> Which should further shrink the code size.
>>
> Oh..just saw it, the code is copied and pasted from it though.
> 
> Thanks,
> Su
>> Thanks,
>> Qu
>>
>>> +        if (btrfs_is_leaf(eb)) {
>>> +            btrfs_print_leaf(eb);
>>> +            goto out;
>>> +        }
>>> +
>>> +        /* We are crossing eb boundary, this node must be corrupted */
>>> +        if (nr > BTRFS_NODEPTRS_PER_EXTENT_BUFFER(eb))
>>> +            warning(
>>> +        "node nr_items corrupted, has %u limit %u, continue anyway",
>>> +                nr, BTRFS_NODEPTRS_PER_EXTENT_BUFFER(eb));
>>> +        printf(
>>> +        "node %llu level %d items %d free %u generation %llu owner ",
>>> +               (unsigned long long)eb->start,
>>> +               btrfs_header_level(eb), nr,
>>> +               (u32)BTRFS_NODEPTRS_PER_EXTENT_BUFFER(eb) - nr,
>>> +               (unsigned long long)btrfs_header_generation(eb));
>>> +        print_objectid(stdout, btrfs_header_owner(eb), 0);
>>> +        printf("\n");
>>> +        print_uuids(eb);
>>> +        fflush(stdout);
>>> +        ptr_num = BTRFS_NODEPTRS_PER_EXTENT_BUFFER(eb);
>>> +        for (i = 0; i < nr && i < ptr_num; i++) {
>>> +            u64 blocknr = btrfs_node_blockptr(eb, i);
>>> +
>>> +            btrfs_node_key(eb, &disk_key, i);
>>> +            btrfs_disk_key_to_cpu(&key, &disk_key);
>>> +            printf("\t");
>>> +            btrfs_print_key(&disk_key);
>>> +            printf(" block %llu (%llu) gen %llu\n",
>>> +                   (unsigned long long)blocknr,
>>> +                   (unsigned long long)blocknr / eb->len,
>>> +                   (unsigned long long)btrfs_node_ptr_generation(eb,
>>> i));
>>> +            fflush(stdout);
>>> +        }
>>> +
>>> +        if (btrfs_header_level(next) != btrfs_header_level(eb) - 1) {
>>> +            warning(
>>> +                "eb corrupted: parent bytenr %llu slot %d level %d
>>> child bytenr %llu level has %d expect %d, skipping the slot",
>>> +                btrfs_header_bytenr(eb), i,
>>> +                btrfs_header_level(eb),
>>> +                btrfs_header_bytenr(next),
>>> +                btrfs_header_level(next),
>>> +                btrfs_header_level(eb) - 1);
>>> +            continue;
>>> +        }
>>> +    }
>>> +
>>> +out:
>>> +    if (root_objectid == BTRFS_TREE_RELOC_OBJECTID)
>>> +        btrfs_free_fs_root(root);
>>> +    btrfs_release_path(&path);
>>> +}
>>> diff --git a/print-tree.h b/print-tree.h
>>> index 62667d7f6195..94f231875a6c 100644
>>> --- a/print-tree.h
>>> +++ b/print-tree.h
>>> @@ -26,4 +26,6 @@ void print_chunk_item(struct extent_buffer *eb,
>>> struct btrfs_chunk *chunk);
>>>   void print_extent_item(struct extent_buffer *eb, int slot, int
>>> metadata);
>>>   void print_objectid(FILE *stream, u64 objectid, u8 type);
>>>   void print_key_type(FILE *stream, u64 objectid, u8 type);
>>> +void btrfs_print_spec_key(struct btrfs_fs_info *info, u64
>>> root_objectid,
>>> +              struct btrfs_key *key);
>>>   #endif
>>>
>>
>>
> 
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
