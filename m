From: Stoyan Gaydarov <stoyboyker@gmail.com>
Subject: Re: [PATCH 01/25] [btrfs] BUG to BUG_ON changes
Date: Tue, 10 Mar 2009 13:16:02 -0500
Message-ID: <6d291e080903101116i32f13c33nf272e4adafc32477@mail.gmail.com>
References: <1236661850-8237-1-git-send-email-stoyboyker@gmail.com>
	 <1236661850-8237-2-git-send-email-stoyboyker@gmail.com>
	 <49B62FF2.7020607@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-kernel@vger.kernel.org, chris.mason@oracle.com,
	linux-btrfs@vger.kernel.org
To: davidjonx@gmail.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <49B62FF2.7020607@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 10, 2009 at 4:16 AM, David John <davidjonx@gmail.com> wrote=
:
> Stoyan Gaydarov wrote:
>> Signed-off-by: Stoyan Gaydarov <stoyboyker@gmail.com>
>> ---
>> =C2=A0fs/btrfs/ctree.c =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| =C2=
=A0 =C2=A03 +--
>> =C2=A0fs/btrfs/extent-tree.c =C2=A0 =C2=A0 =C2=A0| =C2=A0 =C2=A03 +-=
-
>> =C2=A0fs/btrfs/free-space-cache.c | =C2=A0 =C2=A03 +--
>> =C2=A0fs/btrfs/tree-log.c =C2=A0 =C2=A0 =C2=A0 =C2=A0 | =C2=A0 =C2=A0=
3 +--
>> =C2=A04 files changed, 4 insertions(+), 8 deletions(-)
>>
>> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
>> index 37f31b5..2c590b0 100644
>> --- a/fs/btrfs/ctree.c
>> +++ b/fs/btrfs/ctree.c
>> @@ -2174,8 +2174,7 @@ static int insert_ptr(struct btrfs_trans_handl=
e *trans, struct btrfs_root
>> =C2=A0 =C2=A0 =C2=A0 BUG_ON(!path->nodes[level]);
>> =C2=A0 =C2=A0 =C2=A0 lower =3D path->nodes[level];
>> =C2=A0 =C2=A0 =C2=A0 nritems =3D btrfs_header_nritems(lower);
>> - =C2=A0 =C2=A0 if (slot > nritems)
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 BUG();
>> + =C2=A0 =C2=A0 BUG_ON(slot > nritems);
>> =C2=A0 =C2=A0 =C2=A0 if (nritems =3D=3D BTRFS_NODEPTRS_PER_BLOCK(roo=
t))
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 BUG();
>
> ^ You seem to have missed one.

Actually that one was left on purpose because BUG_ON calls are not to
have any side effects and I do not know enough about btrfs to know
what BTRFS_NODEPTRS_PER_BLOCK does so it was left as is.

>
>> =C2=A0 =C2=A0 =C2=A0 if (slot !=3D nritems) {
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index 9abf81f..0314ab6 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -672,8 +672,7 @@ static noinline int insert_extents(struct btrfs_=
trans_handle *trans,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 keys+i, data_size+i, total-i);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 BUG_ON(ret < 0);
>>
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (last && ret > 1)
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 BUG();
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 BUG_ON(last && ret > 1);
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 leaf =3D path->node=
s[0];
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 for (c =3D 0; c < r=
et; c++) {
>> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache=
=2Ec
>> index d1e5f0e..b0c7661 100644
>> --- a/fs/btrfs/free-space-cache.c
>> +++ b/fs/btrfs/free-space-cache.c
>> @@ -267,8 +267,7 @@ static int __btrfs_add_free_space(struct btrfs_b=
lock_group_cache *block_group,
>> =C2=A0out:
>> =C2=A0 =C2=A0 =C2=A0 if (ret) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk(KERN_ERR "bt=
rfs: unable to add free space :%d\n", ret);
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ret =3D=3D -EEXIST)
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 BUG();
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 BUG_ON(ret =3D=3D -EEXIS=
T);
>> =C2=A0 =C2=A0 =C2=A0 }
>>
>> =C2=A0 =C2=A0 =C2=A0 kfree(alloc_info);
>> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
>> index 9c462fb..2c892f6 100644
>> --- a/fs/btrfs/tree-log.c
>> +++ b/fs/btrfs/tree-log.c
>> @@ -1150,8 +1150,7 @@ insert:
>> =C2=A0 =C2=A0 =C2=A0 ret =3D insert_one_name(trans, root, path, key-=
>objectid, key->offset,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 name, name_len, log_type, &log_key);
>>
>> - =C2=A0 =C2=A0 if (ret && ret !=3D -ENOENT)
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 BUG();
>> + =C2=A0 =C2=A0 BUG_ON(ret && ret !=3D -ENOENT);
>> =C2=A0 =C2=A0 =C2=A0 goto out;
>> =C2=A0}
>>
>
>

--=20

-Stoyan
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
