From: Arne Jansen <sensille@gmx.net>
Subject: Re: [PATCH v3 1/6] btrfs: add READAHEAD extent buffer flag
Date: Wed, 29 Jun 2011 20:48:11 +0200
Message-ID: <4E0B736B.2050608@gmx.net>
References: <cover.1309364964.git.sensille@gmx.net> <9f3fd310a7f4fe6282c7ad154b918e8c17b0849e.1309364964.git.sensille@gmx.net> <4E0B6B33.6090308@redhat.com> <4E0B6DF3.6010906@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E0B6DF3.6010906@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 29.06.2011 20:24, Arne Jansen wrote:
> On 29.06.2011 20:13, Josef Bacik wrote:
>> On 06/29/2011 12:32 PM, Arne Jansen wrote:
>>> Add a READAHEAD extent buffer flag.
>>> Add a function to trigger a read with this flag set.
>>>
>>> Changes v2:
>>> - use extent buffer flags instead of extent state flags
>>>
>>> Signed-off-by: Arne Jansen<sensille@gmx.net>
>>> ---
>>> fs/btrfs/disk-io.c | 32 ++++++++++++++++++++++++++++++++
>>> fs/btrfs/disk-io.h | 2 ++
>>> fs/btrfs/extent_io.h | 1 +
>>> 3 files changed, 35 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>>> index 0339cc0..0195172 100644
>>> --- a/fs/btrfs/disk-io.c
>>> +++ b/fs/btrfs/disk-io.c
>>> @@ -945,6 +945,38 @@ int readahead_tree_block(struct btrfs_root
>>> *root, u64 bytenr, u32 blocksize,
>>> return ret;
>>> }
>>>
>>> +int reada_tree_block_flagged(struct btrfs_root *root, u64 bytenr,
>>> u32 blocksize,
>>> + int mirror_num, struct extent_buffer **eb)
>>> +{
>>> + struct extent_buffer *buf =3D NULL;
>>> + struct inode *btree_inode =3D root->fs_info->btree_inode;
>>> + struct extent_io_tree *io_tree =3D&BTRFS_I(btree_inode)->io_tree;
>>> + int ret;
>>> +
>>> + buf =3D btrfs_find_create_tree_block(root, bytenr, blocksize);
>>> + if (!buf)
>>> + return 0;
>>> +
>>> + set_bit(EXTENT_BUFFER_READAHEAD,&buf->bflags);
>>> +
>>> + ret =3D read_extent_buffer_pages(io_tree, buf, 0, 0, 1,
>>> btree_get_extent,
>>> + mirror_num);
>>
>> This patch doesn't compile for me, it says there are too many
>> arguments here.
>
> Ok, commit d1310b2e0cd98eb134 changed a lot here, I'll take a lot how=
 to
> rebase this and send a v4.

hm, no, that was bullshit, I just forgot to send the first patch in the
series :-/

>
> Thanks,
> Arne
>
>>
>> [root@destiny btrfs-work]# make M=3Dfs/btrfs
>> CC [M] fs/btrfs/disk-io.o
>> fs/btrfs/disk-io.c: In function =91reada_tree_block_flagged=92:
>> fs/btrfs/disk-io.c:963:6: warning: passing argument 5 of
>> =91read_extent_buffer_pages=92 makes pointer from integer without a =
cast
>> [enabled by default]
>> fs/btrfs/extent_io.h:244:5: note: expected =91struct extent_map *
>> (*)(struct inode *, struct page *, size_t, u64, u64, int)=92 but
>> argument is of type =91int=92
>> fs/btrfs/disk-io.c:963:6: warning: passing argument 6 of
>> =91read_extent_buffer_pages=92 makes integer from pointer without a =
cast
>> [enabled by default]
>> fs/btrfs/extent_io.h:244:5: note: expected =91int=92 but argument is=
 of
>> type =91struct extent_map * (*)(struct inode *, struct page *, size_=
t,
>> u64, u64, int)=92
>> fs/btrfs/disk-io.c:963:6: error: too many arguments to function
>> =91read_extent_buffer_pages=92
>> fs/btrfs/extent_io.h:244:5: note: declared here
>> make[1]: *** [fs/btrfs/disk-io.o] Error 1
>> make: *** [_module_fs/btrfs] Error 2
>>
>> Thanks,
>>
>> Josef
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
