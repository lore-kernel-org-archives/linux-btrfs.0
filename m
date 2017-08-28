Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-17-i6.italiaonline.it ([212.48.14.163]:51072 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751230AbdH1R3x (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 Aug 2017 13:29:53 -0400
Reply-To: kreijack@inwind.it
Subject: Re: [PATCH 1/1] btrfs-progs: mkfs: add subvolume support to mkfs
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Yingyi Luo <yingyil@google.com>,
        linux-btrfs@vger.kernel.org
References: <20170825232101.10859-1-yingyil@google.com>
 <20170825232101.10859-2-yingyil@google.com>
 <0744c469-3e3f-9568-a60e-50c1872f71c1@gmx.com>
From: Goffredo Baroncelli <kreijack@libero.it>
Message-ID: <baa82a76-adb3-a4ef-b0b0-bc34d8a62f77@libero.it>
Date: Mon, 28 Aug 2017 19:29:50 +0200
MIME-Version: 1.0
In-Reply-To: <0744c469-3e3f-9568-a60e-50c1872f71c1@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi All,


unfortunately, your patch crashes on my PC

$ truncate -s 100G /tmp/disk.img
$ sudo losetup -f /tmp/disk.img

$ # good case
$ sudo ./mkfs.btrfs -f -r /tmp/empty/  /dev/loop0
btrfs-progs v4.12.1-1-gf80d059c
See http://btrfs.wiki.kernel.org for more information.

Making image is completed.
Label:              (null)
UUID:               7cb4927c-d24a-41b3-8151-277ad9064008
Node size:          16384
Sector size:        4096
Filesystem size:    28.00MiB
Block group profiles:
  Data:             single           10.75MiB
  System:           DUP               4.00MiB
SSD detected:       no
Incompat features:  extref, skinny-metadata
Number of devices:  1
Devices:
   ID        SIZE  PATH
    1    28.00MiB  /dev/loop0

$ # bad case
$ sudo ./mkfs.btrfs -f -S prova -r /tmp/empty/  /dev/loop0
btrfs-progs v4.12.1-1-gf80d059c
See http://btrfs.wiki.kernel.org for more information.

ERROR: failed to create subvolume: -17
transaction.h:42: btrfs_start_transaction: BUG_ON `fs_info->running_transaction` triggered, value 884442943152
./mkfs.btrfs(+0x15674)[0xcdeb52c674]
./mkfs.btrfs(close_ctree_fs_info+0x313)[0xcdeb52e80f]
./mkfs.btrfs(main+0x1028)[0xcdeb52381e]
/lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf1)[0x7f85a5d1f2e1]
./mkfs.btrfs(_start+0x2a)[0xcdeb520e9a]
Aborted


Below some further comments

On 08/28/2017 01:39 AM, Qu Wenruo wrote:
> 
> 
> On 2017年08月26日 07:21, Yingyi Luo wrote:
>> From: yingyil <yingyil@google.com>
>>
>> Add -S/--subvol [NAME] option to configure. It enables users to create a
>> subvolume under the toplevel volume and populate the created subvolume
>> with files from the rootdir specified by -r/--rootdir option.
>>
>> Two functions link_subvol() and create_subvol() are moved from
>> convert/main.c to utils.c to enable code reuse.
> 
> What about split the patch as the code move of link/create_subvol() makes review a little difficult.
> 
> BTW, if exporting link/create_subvol(), what about adding "btrfs_" prefix?
> 
> Thanks,
> Qu
>>
>> Signed-off-by: yingyil <yingyil@google.com>
>> ---
[...]
>> --- a/mkfs/main.c
>> +++ b/mkfs/main.c
>> @@ -365,6 +365,7 @@ static void print_usage(int ret)
>>       printf("  creation:\n");
>>       printf("\t-b|--byte-count SIZE    set filesystem size to SIZE (on the first device)\n");
>>       printf("\t-r|--rootdir DIR        copy files from DIR to the image root directory\n");
>> +    printf("\t-S|--subvol NAME        create a sunvolume with NAME and copy files from ROOTDIR to the subvolume\n");
>>       printf("\t-K|--nodiscard          do not perform whole device TRIM\n");
>>       printf("\t-f|--force              force overwrite of existing filesystem\n");
>>       printf("  general:\n");
>> @@ -413,6 +414,18 @@ static char *parse_label(const char *input)
>>       return strdup(input);
>>   }
>>   +static char *parse_subvol_name(const char *input)
>> +{
>> +    int len = strlen(input);
>> +
>> +    if (len >= BTRFS_SUBVOL_NAME_MAX) {
>> +        error("subvolume name %s is too long (max %d)",
>> +            input, BTRFS_SUBVOL_NAME_MAX - 1);
>> +        exit(1);
>> +    }
>> +    return strdup(input);

why use strdup ?

>> +}
>> +
[...]

>> @@ -1517,6 +1533,10 @@ int main(int argc, char **argv)
>>                           PACKAGE_STRING);
>>                   exit(0);
>>                   break;
>> +            case 'S':
>> +                subvol_name = parse_subvol_name(optarg);
>> +                subvol_name_set = 1;
>> +                break;
>>               case 'r':
>>                   source_dir = optarg;
>>                   source_dir_set = 1;
>> @@ -1537,6 +1557,11 @@ int main(int argc, char **argv)
>>           }
>>       }
>> +    if (subvol_name_set && !source_dir_set) {
>> +        error("root directory needs to be set");
>> +        exit(1);
>> +    }
>> +

To me it seems reasonable to create an empty subvolume (below more comments)

>>       if (verbose) {
>>           printf("%s\n", PACKAGE_STRING);
>>           printf("See %s for more information.\n\n", PACKAGE_URL);
>> @@ -1876,10 +1901,48 @@ raid_groups:
>>               goto out;
>>           }
[...]

>>       ret = cleanup_temp_chunks(fs_info, &allocation, data_profile,
>> diff --git a/utils.c b/utils.c
>> index bb04913..c9bbbed 100644
>> --- a/utils.c
>> +++ b/utils.c
>> @@ -2574,3 +2574,164 @@ u8 rand_u8(void)
>>   void btrfs_config_init(void)
>>   {
>>   }
>> +
>> +struct btrfs_root *link_subvol(struct btrfs_root *root,
>> +        const char *base, u64 root_objectid)
>> +{
>> +    struct btrfs_trans_handle *trans;
[....]

>> +
>> +    memcpy(buf, base, len);
>> +    for (i = 0; i < 1024; i++) {
>> +        ret = btrfs_insert_dir_item(trans, root, buf, len,
>> +                        dirid, &key, BTRFS_FT_DIR, index);
>> +        if (ret != -EEXIST)
>> +            break;
>> +        len = snprintf(buf, ARRAY_SIZE(buf), "%s%d", base, i);
>> +        if (len < 1 || len > BTRFS_NAME_LEN) {
>> +            ret = -EINVAL;
>> +            break;
>> +        }
>> +    }

Does make sense this ? If the subvolume creation fails, what is the reason to try to create another subvolume with the same name followed by a number ? I suppose that there is some corner case for the convert code...

>> +    if (ret)
>> +        goto fail;
>> +
>> +    btrfs_set_inode_size(leaf, inode_item, len * 2 +
>> +                 btrfs_inode_size(leaf, inode_item));
>> +    btrfs_mark_buffer_dirty(leaf);
>> +    btrfs_release_path(&path);
[...]


If possible I would like to ask another feature: an option to mark default the created subvolume. Use case: usually the root filesystem is stored inside the subvolid=5; this is a complication if you want to swap it with a snapshot. I think that it would be useful if the mkfs.btrfs creates a "default" subvolume inside the root subvolume (id=5), and set it as default. So a subsequent snapshot+swap will be more easy. 

Ideally it would be useful if this could be the default behavior. But I suppose that someone (i.e. the distribution installer) could encounter some regressions.


BR
G.Baroncelli

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
