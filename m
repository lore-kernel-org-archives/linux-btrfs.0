Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:62630 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab3JZUiK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Oct 2013 16:38:10 -0400
Received: by mail-we0-f182.google.com with SMTP id t61so5105673wes.41
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Oct 2013 13:38:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOcd+r1tHawUZyxqbbiN9KjtfpSRxnUxr0sWUV5UOMhNtmg7YQ@mail.gmail.com>
References: <1379075278-4417-1-git-send-email-anand.jain@oracle.com>
	<18D02621-2980-4EB9-8633-4B6BD397D6C1@gmail.com>
	<CAOcd+r1tHawUZyxqbbiN9KjtfpSRxnUxr0sWUV5UOMhNtmg7YQ@mail.gmail.com>
Date: Sat, 26 Oct 2013 23:38:08 +0300
Message-ID: <CAOcd+r2RTY9woc2urRWh3+4mjuGGDVBEwHY_5Uzz0iMXOrwN6Q@mail.gmail.com>
Subject: Re: [PATCH] btrfs-progs: calculate disk space that a subvol could
 free upon delete
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thinking about this more, I believe this way of checking for exclusive
data doesn't work. When a snapshot is created, btrfs doesn't go and
explicitly increment refcount on *all* relevant EXTENT_ITEMs in the
extent tree. This way creating a snapshot would take forever for large
subvolumes. Instead, it only does that on EXTENT_ITEMs, which are
pointed by EXTENT_DATAs in the root node of the snapshottted file
tree. For rest of nodes/leafs of a file tree, an "implicit" tree-block
references are added (not sure if "implicit" is the right term) for
top tree blocks only. This is accomplished by _btrfs_mod_ref() code,
called from btrfs_copy_root() during snapshot creation flow. Snapshot
deletion code is the one that is smart enough to properly "unshare"
shared tree blocks with such "implicit" references.

What do you think?

Alex.


On Sat, Oct 26, 2013 at 10:49 PM, Alex Lyakas
<alex.btrfs@zadarastorage.com> wrote:
> Hi Anand,
>
> 1) so let's say I have a subvolume and a snapshot of this subvolume.
> So in this case, I will see "Sole space = 0" for both of them,
> correct? Because all extents (except inline ones) are shared.
>
> 2) How is this in terms of responsiveness? On a huge subvolume, we
> need to iterate all the EXTENT_DATAs and then lookup their
> EXTENT_ITEMs.
>
> 3) So it's kind of poor man's replacement for quota groups, correct?
>
> I like that it's so easy to check for exclusive data, though:)
>
> Alex.
>
>
> On Fri, Sep 13, 2013 at 6:44 PM, Wang Shilong <wangshilong1991@gmail.com> wrote:
>>
>> Hello Anand,
>>
>>> (This patch is for review and comments only)
>>>
>>> This patch provides a way to know how much space can be
>>> relinquished if when subvol /snapshot is deleted.  With
>>> this sys admin can make better judgments in managing the
>>> filesystem when fs is near full.
>>>
>>
>> I think this is really *helpful* since users can not really know how much
>> space(Exclusive) in a subvolume .
>>
>> Thanks,
>> Wang
>>
>>> as shown below the parameter 'sole space' indicates the size
>>> which is freed when subvol is deleted. (any other better
>>> term for this?, pls suggest).
>>> ---------------------
>>> btrfs su show /btrfs/sv1
>>> /btrfs/sv1
>>>       Name:                   sv1
>>>       uuid:                   b078ba48-d4a5-2f49-ac03-9bd1d56cc768
>>>       Parent uuid:            -
>>>       Creation time:          2013-09-13 18:17:32
>>>       Object ID:              257
>>>       Generation (Gen):       18
>>>       Gen at creation:        17
>>>       Parent:                 5
>>>       Top Level:              5
>>>       Flags:                  -
>>>       Sole space:             1.56MiB <----
>>>       Snapshot(s):
>>>
>>> btrfs su snap /btrfs/sv1 /btrfs/ss2
>>> Create a snapshot of '/btrfs/sv1' in '/btrfs/ss2'
>>>
>>> btrfs su show /btrfs/sv1
>>> /btrfs/sv1
>>>       Name:                   sv1
>>>       uuid:                   b078ba48-d4a5-2f49-ac03-9bd1d56cc768
>>>       Parent uuid:            -
>>>       Creation time:          2013-09-13 18:17:32
>>>       Object ID:              257
>>>       Generation (Gen):       19
>>>       Gen at creation:        17
>>>       Parent:                 5
>>>       Top Level:              5
>>>       Flags:                  -
>>>       Sole space:             0.00  <-----
>>>       Snapshot(s):
>>>                               ss2
>>> ---------------------
>>>
>>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>>> ---
>>> cmds-subvolume.c |   5 ++
>>> utils.c          | 154 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>> utils.h          |   1 +
>>> 3 files changed, 160 insertions(+)
>>>
>>> diff --git a/cmds-subvolume.c b/cmds-subvolume.c
>>> index de246ab..2b02d66 100644
>>> --- a/cmds-subvolume.c
>>> +++ b/cmds-subvolume.c
>>> @@ -809,6 +809,7 @@ static int cmd_subvol_show(int argc, char **argv)
>>>       int fd = -1, mntfd = -1;
>>>       int ret = 1;
>>>       DIR *dirstream1 = NULL, *dirstream2 = NULL;
>>> +     u64 freeable_bytes;
>>>
>>>       if (check_argc_exact(argc, 2))
>>>               usage(cmd_subvol_show_usage);
>>> @@ -878,6 +879,8 @@ static int cmd_subvol_show(int argc, char **argv)
>>>               goto out;
>>>       }
>>>
>>> +     freeable_bytes = get_subvol_freeable_bytes(fd);
>>> +
>>>       ret = 0;
>>>       /* print the info */
>>>       printf("%s\n", fullpath);
>>> @@ -915,6 +918,8 @@ static int cmd_subvol_show(int argc, char **argv)
>>>       else
>>>               printf("\tFlags: \t\t\t-\n");
>>>
>>> +     printf("\tSole space: \t\t%s\n",
>>> +             pretty_size(freeable_bytes));
>>>       /* print the snapshots of the given subvol if any*/
>>>       printf("\tSnapshot(s):\n");
>>>       filter_set = btrfs_list_alloc_filter_set();
>>> diff --git a/utils.c b/utils.c
>>> index 22c3310..f01d580 100644
>>> --- a/utils.c
>>> +++ b/utils.c
>>> @@ -2019,3 +2019,157 @@ int is_dev_excl_op_free(int fd)
>>>       ret = ioctl(fd, BTRFS_IOC_CHECK_DEV_EXCL_OPS, NULL);
>>>       return ret > 0 ? ret : -errno;
>>> }
>>> +
>>> +/* gets the ref count for given extent
>>> + * 0 = didn't find the item
>>> + * n = number of references
>>> +*/
>>> +u64 get_extent_refcnt(int fd, u64 disk_blk)
>>> +{
>>> +     int ret = 0, i, e;
>>> +     struct btrfs_ioctl_search_args args;
>>> +     struct btrfs_ioctl_search_key *sk = &args.key;
>>> +     struct btrfs_ioctl_search_header sh;
>>> +     unsigned long off = 0;
>>> +
>>> +     memset(&args, 0, sizeof(args));
>>> +
>>> +     sk->tree_id = BTRFS_EXTENT_TREE_OBJECTID;
>>> +
>>> +     sk->min_type = BTRFS_EXTENT_ITEM_KEY;
>>> +     sk->max_type = BTRFS_EXTENT_ITEM_KEY;
>>> +
>>> +     sk->min_objectid = disk_blk;
>>> +     sk->max_objectid = disk_blk;
>>> +
>>> +     sk->max_offset = (u64)-1;
>>> +     sk->max_transid = (u64)-1;
>>> +
>>> +     while (1) {
>>> +             sk->nr_items = 4096;
>>> +
>>> +             ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
>>> +             e = errno;
>>> +             if (ret < 0) {
>>> +                     fprintf(stderr, "ERROR: search failed - %s\n",
>>> +                             strerror(e));
>>> +                     return 0;
>>> +             }
>>> +             if (sk->nr_items == 0)
>>> +                     break;
>>> +
>>> +             off = 0;
>>> +             for (i = 0; i < sk->nr_items; i++) {
>>> +                     struct btrfs_extent_item *ei;
>>> +                     u64 ref;
>>> +
>>> +                     memcpy(&sh, args.buf + off, sizeof(sh));
>>> +                     off += sizeof(sh);
>>> +
>>> +                     if (sh.type != BTRFS_EXTENT_ITEM_KEY) {
>>> +                             off += sh.len;
>>> +                             continue;
>>> +                     }
>>> +
>>> +                     ei = (struct btrfs_extent_item *)(args.buf + off);
>>> +                     ref = btrfs_stack_extent_refs(ei);
>>> +                     return ref;
>>> +             }
>>> +             sk->min_objectid = sh.objectid;
>>> +             sk->min_offset = sh.offset;
>>> +             sk->min_type = sh.type;
>>> +             if (sk->min_offset < (u64)-1)
>>> +                     sk->min_offset++;
>>> +             else if (sk->min_objectid < (u64)-1) {
>>> +                     sk->min_objectid++;
>>> +                     sk->min_offset = 0;
>>> +                     sk->min_type = 0;
>>> +             } else
>>> +                     break;
>>> +     }
>>> +     return 0;
>>> +}
>>> +
>>> +u64 get_subvol_freeable_bytes(int fd)
>>> +{
>>> +     int ret = 0, i, e;
>>> +     struct btrfs_ioctl_search_args args;
>>> +     struct btrfs_ioctl_search_key *sk = &args.key;
>>> +     struct btrfs_ioctl_search_header sh;
>>> +     unsigned long off = 0;
>>> +     u64 size_bytes = 0;
>>> +
>>> +     memset(&args, 0, sizeof(args));
>>> +
>>> +     sk->tree_id = 0;
>>> +
>>> +     sk->min_type = BTRFS_EXTENT_DATA_KEY;
>>> +     sk->max_type = BTRFS_EXTENT_DATA_KEY;
>>> +
>>> +     sk->max_objectid = (u64) -1;
>>> +     sk->max_offset = (u64)-1;
>>> +     sk->max_transid = (u64)-1;
>>> +
>>> +     while (1) {
>>> +             sk->nr_items = 4096;
>>> +
>>> +             ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
>>> +             e = errno;
>>> +             if (ret < 0) {
>>> +                     fprintf(stderr, "ERROR: search failed - %s\n",
>>> +                             strerror(e));
>>> +                     return 0;
>>> +             }
>>> +             if (sk->nr_items == 0)
>>> +                     break;
>>> +
>>> +             off = 0;
>>> +             for (i = 0; i < sk->nr_items; i++) {
>>> +                     struct btrfs_file_extent_item *efi;
>>> +                     u64 disk_bytenr = 0;
>>> +                     u64 num_bytes = 0;
>>> +                     u64 refcnt;
>>> +                     u8 type;
>>> +
>>> +                     memcpy(&sh, args.buf + off, sizeof(sh));
>>> +                     off += sizeof(sh);
>>> +
>>> +                     if (sh.type != BTRFS_EXTENT_DATA_KEY) {
>>> +                             off += sh.len;
>>> +                             continue;
>>> +                     }
>>> +
>>> +                     efi = (struct btrfs_file_extent_item *)(args.buf + off);
>>> +                     type = btrfs_stack_file_extent_type(efi);
>>> +
>>> +                     if (type == BTRFS_FILE_EXTENT_INLINE) {
>>> +                             size_bytes +=
>>> +                                     btrfs_stack_file_extent_ram_bytes(efi);
>>> +                             goto skip_extent_data;
>>> +                     }
>>> +                     disk_bytenr = btrfs_stack_file_extent_disk_bytenr(efi);
>>> +                     num_bytes = btrfs_stack_file_extent_num_bytes(efi);
>>> +
>>> +                     if (disk_bytenr) {
>>> +                             refcnt = get_extent_refcnt(fd, disk_bytenr);
>>> +                             if (refcnt == 1)
>>> +                                     size_bytes += num_bytes;
>>> +                     }
>>> +skip_extent_data:
>>> +                     off += sh.len;
>>> +             }
>>> +             sk->min_objectid = sh.objectid;
>>> +             sk->min_offset = sh.offset;
>>> +             sk->min_type = sh.type;
>>> +
>>> +             if (sk->min_offset < (u64)-1)
>>> +                     sk->min_offset++;
>>> +             else if (sk->min_objectid < (u64)-1) {
>>> +                     sk->min_objectid++;
>>> +                     sk->min_offset = 0;
>>> +                     sk->min_type = 0;
>>> +             } else
>>> +                     break;
>>> +     }
>>> +     return size_bytes;
>>> +}
>>> diff --git a/utils.h b/utils.h
>>> index 6952d34..0920bb3 100644
>>> --- a/utils.h
>>> +++ b/utils.h
>>> @@ -86,4 +86,5 @@ int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
>>>                          int verify);
>>> int get_btrfs_mount(const char *dev, char *mp, size_t mp_size);
>>> int is_dev_excl_op_free(int fd);
>>> +u64 get_subvol_freeable_bytes(int fd);
>>> #endif
>>> --
>>> 1.8.4.rc4.1.g0d8beaa
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
