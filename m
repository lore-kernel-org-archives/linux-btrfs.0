Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:61950 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624Ab2JRJDF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Oct 2012 05:03:05 -0400
Received: by mail-la0-f46.google.com with SMTP id h6so5642401lag.19
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Oct 2012 02:03:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <507F62B8.9090607@cn.fujitsu.com>
References: <CAOcd+r2VUEjti7uNht-vaa603ZHE5XDXUdW1zODhrfO4iPMxUA@mail.gmail.com>
	<507F62B8.9090607@cn.fujitsu.com>
Date: Thu, 18 Oct 2012 11:03:04 +0200
Message-ID: <CAOcd+r1BVcRS=7ReveuRGDXyuEXivNB=7TP--p3KaxYNAfHPGQ@mail.gmail.com>
Subject: Re: [PATCH] Btrfs-progs: Filter out deleting or already-deleted
 subvolumes in lookup_ino_path.
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: miaox@cn.fujitsu.com
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Stefan Priebe <s.priebe@profihost.ag>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Miao,


On Thu, Oct 18, 2012 at 4:00 AM, Miao Xie <miaox@cn.fujitsu.com> wrote:
> On Wed, 17 Oct 2012 18:06:52 +0200, Alex Lyakas wrote:
>> -static int __list_subvol_fill_paths(int fd, struct root_lookup *root_lookup)
>> +static int __list_subvol_fill_paths(int fd, struct root_lookup *root_lookup,
>> +     struct root_lookup *root_lookup_final)
>>  {
>>       struct rb_node *n;
>>
>> +     root_lookup_init(root_lookup_final);
>> +
>>       n = rb_first(&root_lookup->root);
>>       while (n) {
>>               struct root_info *entry;
>>               int ret;
>>               entry = rb_entry(n, struct root_info, rb_node);
>>               ret = lookup_ino_path(fd, entry);
>> -             if(ret < 0)
>> +             if(ret < 0 && ret != -ENOENT)
>>                       return ret;
>> -             n = rb_next(n);
>> +             rb_erase(&entry->rb_node, &root_lookup->root);
>> +             /*
>> +              * If lookup_ino_path() returned ENOENT, some of the path
>> +              * components are missing. Let's consider this subvolume
>> +              * as deleted then.
>> +              */
>> +             if (ret == -ENOENT)
>> +                     __free_root_info(entry);
>> +             else
>> +                     root_tree_insert(root_lookup_final, entry);
>> +             n = rb_first(&root_lookup->root);
>
> I don't think we need a final rb-tree since we have removed the deleted root entries from
> the tree and freed them.
I just did not want to start the search from the beginning of the same
tree (although it will be cheaper, because lookup_ino_path has a
shortcut).

>
> Beside that, this patch didn't fix the problem completely. Consider the following case:
> Subv0
>   |-> Subv1
>         |-> Subv2
>
> When we fill the path, we may deal with Subv2 firstly, and then deal with Subv1. But
> if someone deletes Subv2 and Subv1 after we fill the path of Subv2 and before we fill
> the path of Subv1, we may deal with Subv2 successfully, then we will find Subv1 has been
> deleted, so we will clean up Subv2 entry.
I don't see where we will clean the Subv2 entry? Once we have filled
Subv2's path successfully in lookup_ino_path(), we consider it as
existing and won't check ever again, I think.

 If so, we will fail to resolve the full path of
> Subv2 because we can not find Subv1.

Note that in your particular example, I think we will never fail to
fill the paths (even if all three subvolumes are deleted), because of
the following code in btrfs_search_path_in_tree():
	if (dirid == BTRFS_FIRST_FREE_OBJECTID) {
		name[0]='\0';
		return 0;
	}
You need to have a regular subdirectory in-between the two roots for
btrfs_search_path_in_tree() to really check the path. I noted that in
the commit message.

>
> My partner made a patch which can fix the above problem, I will send it out later.
Perfect!


Thanks,
Alex.

>
> Thanks
> Miao
>
>>       }
>>
>>       return 0;
>> @@ -1446,6 +1472,7 @@ int btrfs_list_subvols(int fd, struct
>> btrfs_list_filter_set *filter_set,
>>                      int is_tab_result)
>>  {
>>       struct root_lookup root_lookup;
>> +     struct root_lookup root_lookup_final;
>>       struct root_lookup root_sort;
>>       int ret;
>>
>> @@ -1460,15 +1487,15 @@ int btrfs_list_subvols(int fd, struct
>> btrfs_list_filter_set *filter_set,
>>        * now we have an rbtree full of root_info objects, but we need to fill
>>        * in their path names within the subvol that is referencing each one.
>>        */
>> -     ret = __list_subvol_fill_paths(fd, &root_lookup);
>> +     ret = __list_subvol_fill_paths(fd, &root_lookup, &root_lookup_final);
>>       if (ret < 0)
>>               return ret;
>>
>> -     __filter_and_sort_subvol(&root_lookup, &root_sort, filter_set,
>> +     __filter_and_sort_subvol(&root_lookup_final, &root_sort, filter_set,
>>                                comp_set, fd);
>>
>>       print_all_volume_info(&root_sort, is_tab_result);
>> -     __free_all_subvolumn(&root_lookup);
>> +     __free_all_subvolumn(&root_lookup_final);
>>       return ret;
>>  }
>>
>> @@ -1655,6 +1682,7 @@ int btrfs_list_find_updated_files(int fd, u64
>> root_id, u64 oldest_gen)
>>  char *btrfs_list_path_for_root(int fd, u64 root)
>>  {
>>       struct root_lookup root_lookup;
>> +     struct root_lookup root_lookup_final;
>>       struct rb_node *n;
>>       char *ret_path = NULL;
>>       int ret;
>> @@ -1664,16 +1692,16 @@ char *btrfs_list_path_for_root(int fd, u64 root)
>>       if (ret < 0)
>>               return ERR_PTR(ret);
>>
>> -     ret = __list_subvol_fill_paths(fd, &root_lookup);
>> +     ret = __list_subvol_fill_paths(fd, &root_lookup, &root_lookup_final);
>>       if (ret < 0)
>>               return ERR_PTR(ret);
>>
>> -     n = rb_last(&root_lookup.root);
>> +     n = rb_last(&root_lookup_final.root);
>>       while (n) {
>>               struct root_info *entry;
>>
>>               entry = rb_entry(n, struct root_info, rb_node);
>> -             resolve_root(&root_lookup, entry, top_id);
>> +             resolve_root(&root_lookup_final, entry, top_id);
>>               if (entry->root_id == root) {
>>                       ret_path = entry->full_path;
>>                       entry->full_path = NULL;
>> @@ -1681,7 +1709,7 @@ char *btrfs_list_path_for_root(int fd, u64 root)
>>
>>               n = rb_prev(n);
>>       }
>> -     __free_all_subvolumn(&root_lookup);
>> +     __free_all_subvolumn(&root_lookup_final);
>>
>>       return ret_path;
>>  }
>>
>
>
