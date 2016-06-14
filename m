Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32301 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932254AbcFNSVH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jun 2016 14:21:07 -0400
Reply-To: ashish.samant@oracle.com
Subject: Re: [PATCH] Btrfs-progs: add check-only option for balance
References: <1465508801-14163-1-git-send-email-ashish.samant@oracle.com>
 <575B2760.30109@mendix.com>
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        linux-btrfs@vger.kernel.org
Cc: bo.li.liu@oracle.com
From: Ashish Samant <ashish.samant@oracle.com>
Message-ID: <57604B3F.3060600@oracle.com>
Date: Tue, 14 Jun 2016 11:21:51 -0700
MIME-Version: 1.0
In-Reply-To: <575B2760.30109@mendix.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/10/2016 01:47 PM, Hans van Kranenburg wrote:
> Hi,
>
> Correct me if I'm wrong,
>
> On 06/09/2016 11:46 PM, Ashish Samant wrote:
>> +/* return 0 if balance can remove a data block group, otherwise 
>> return 1 */
>> +static int search_data_bgs(const char *path)
>> +{
>> +    struct btrfs_ioctl_search_args args;
>> +    struct btrfs_ioctl_search_key *sk;
>> +    struct btrfs_ioctl_search_header *header;
>> +    struct btrfs_block_group_item *bg;
>> +    unsigned long off = 0;
>> +    DIR *dirstream = NULL;
>> +    int e;
>> +    int fd;
>> +    int i;
>> +    u64 total_free = 0;
>> +    u64 min_used = (u64)-1;
>> +    u64 free_of_min_used = 0;
>> +    u64 bg_of_min_used = 0;
>> +    u64 flags;
>> +    u64 used;
>> +    int ret = 0;
>> +    int nr_data_bgs = 0;
>> +
>> +    fd = btrfs_open_dir(path, &dirstream, 1);
>> +    if (fd < 0)
>> +        return 1;
>> +
>> +    memset(&args, 0, sizeof(args));
>> +    sk = &args.key;
>> +
>> +    sk->tree_id = BTRFS_EXTENT_TREE_OBJECTID;
>> +    sk->min_objectid = sk->min_offset = sk->min_transid = 0;
>> +    sk->max_objectid = sk->max_offset = sk->max_transid = (u64)-1;
>> +    sk->max_type = sk->min_type = BTRFS_BLOCK_GROUP_ITEM_KEY;
>> +    sk->nr_items = 65536;
>
> This search returns not only block group information, but also 
> everything else. You're first retrieving the complete extent tree to 
> userspace, in buffers...
>
>> +
>> +    while (1) {
>> +        ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
>> +        e = errno;
>> +        if (ret < 0) {
>> +            fprintf(stderr, "ret %d error '%s'\n", ret,
>> +                strerror(e));
>> +            return ret;
>> +        }
>> +        /*
>> +         * it should not happen.
>> +         */
>> +        if (sk->nr_items == 0)
>> +            break;
>> +
>> +        off = 0;
>> +        for (i = 0; i < sk->nr_items; i++) {
>> +            header = (struct btrfs_ioctl_search_header *)(args.buf
>> +                                      + off);
>> +
>> +            off += sizeof(*header);
>> +            if (header->type == BTRFS_BLOCK_GROUP_ITEM_KEY) {
>
> ...and then just throwing 99.999999% of the results away again. This 
> is going to take a phenomenal amount of effort on a huge filesystem, 
> copying unnessecary data around between the kernel and your program.
>
> The first thing I learned myself when starting to play with the search 
> ioctl is that the search doesn't happen in some kind of 3 dimensional 
> space. You can't just filter on a type of object when walking the tree.
>
> http://logs.tvrrug.org.uk/logs/%23btrfs/2016-02-13.html#2016-02-13T22:32:52 
>
>
> The sk->max_type = sk->min_type = BTRFS_BLOCK_GROUP_ITEM_KEY only 
> makes the search space start somewhere halfway objid 0 and end halfway 
> objid max, including all other possible values for the type field for 
> all objids in between.
>
>> +                bg = (struct btrfs_block_group_item *)
>> +                    (args.buf + off);
>> +                flags = btrfs_block_group_flags(bg);
>> +                if (flags & BTRFS_BLOCK_GROUP_DATA) {
>> +                    nr_data_bgs++;
>> +                    used = btrfs_block_group_used(bg);
>> +                    printf(
>> +                    "block_group %15llu (len %11llu used %11llu)\n",
>> +                            header->objectid,
>> +                            header->offset, used);
>> +                    total_free += header->offset - used;
>> +                    if (min_used >= used) {
>> +                        min_used = used;
>> +                        free_of_min_used =
>> +                            header->offset - used;
>> +                        bg_of_min_used =
>> +                            header->objectid;
>> +                    }
>> +                }
>> +            }
>> +
>> +            off += header->len;
>> +            sk->min_objectid = header->objectid;
>> +            sk->min_type = header->type;
>> +            sk->min_offset = header->offset;
>
> When the following is a part of your extent tree...
>
> key (289406976 EXTENT_ITEM 19193856) itemoff 15718 itemsize 53
> extent refs 1 gen 11 flags DATA
> extent data backref root 5 objectid 258 offset 0 count 1
>
> key (289406976 BLOCK_GROUP_ITEM 1073741824) itemoff 15694 itemsize 24
> block group used 24612864 chunk_objectid 256 flags DATA
>
> ...and when the extent_item just manages to squeeze in as last result 
> into the current result buffer from the ioctl...
>
> ...then your search key looks like (289406976 168 19193856) after 
> copying the values from the last seen object...
>
>> +        }
>> +        sk->nr_items = 65536;
>> +
>> +        if (sk->min_objectid < sk->max_objectid)
>> +            sk->min_objectid += 1;
>
> ...and now it's (289406977 168 19193856), which means you're 
> continuing your search *after* the block group item!
>
> (289406976 168 19193856) is actually (289406976 << 72) + (168 << 64) + 
> 19193856, which is 1366685806470112827871857008640
>
> The search is continued at 1366685811192479310741502222336, which 
> skips 4722366482869645213696 possible places where an object could 
> live in the tree.
Ah, yes you are right.
>
>> +        else
>> +            break;
>> +    }
>> +
>> +    if (nr_data_bgs <= 1) {
>> +        printf("Data block groups in fs = %d, no need to do 
>> balance.\n",
>> +                nr_data_bgs);
>> +        return 1;
>> +    }
>> +
>> +    printf("total bgs %d total_free %llu min_used bg %llu has 
>> (min_used %llu free %llu)\n",
>> +            nr_data_bgs, total_free, bg_of_min_used, min_used,
>> +            free_of_min_used);
>> +    if (total_free - free_of_min_used > min_used) {
>> +        printf("run 'btrfs balance start -dvrange=%llu..%llu 
>> <mountpoint>'\n",
>> +                bg_of_min_used, bg_of_min_used + 1);
>> +        ret = 0;
>> +    } else {
>> +        printf("Please don't balance data block groups, it won't 
>> work.\n");
>> +        ret = 1;
>> +    }
>> +
>> +    return ret;
>> +}
>
> A more efficient way to do this search is to first look at the chunk 
> tree, and for every chunk listed in there look up 1 exact match in the 
> extent tree, and then read the used value of it.
>
> Ironically, this is exact the thing that I was looking for when that 
> IRC conversation referenced above happened, resulting in a very 
> similar thing, playing around with searches, done in python instead of 
> C. :-]
>
> https://github.com/knorrie/btrfs-heatmap (see show_usage.py)
Thanks, will take a look.

Ashish
>
> Moo! Have fun,
>

