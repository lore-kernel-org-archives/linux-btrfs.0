From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: [BUG] can not allocate space for caching data
Date: Tue, 21 Dec 2010 08:33:16 +0800
Message-ID: <AANLkTik+OSuSTUOQTyaM6=Om0hJwD8UsOqjJcoc8Un4p@mail.gmail.com>
References: <4D0F4B26.7030406@cn.fujitsu.com>
	<1292848998-sup-5155@think>
	<4D0F566A.2020103@cn.fujitsu.com>
	<1292859261-sup-570@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: miaox <miaox@cn.fujitsu.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1292859261-sup-570@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 20, 2010 at 11:41 PM, Chris Mason <chris.mason@oracle.com> =
wrote:
> Excerpts from Miao Xie's message of 2010-12-20 08:13:14 -0500:
>> On Mon, 20 Dec 2010 07:44:06 -0500, Chris Mason wrote:
>> > Excerpts from Miao Xie's message of 2010-12-20 07:25:10 -0500:
>> >> Hi, Chris
>> >>
>> >> There is something wrong with this patch:
>> >>
>> >> commit 83a50de97fe96aca82389e061862ed760ece2283
>> >> Author: Chris Mason<chris.mason@oracle.com>
>> >> Date: =A0 Mon Dec 13 15:06:46 2010 -0500
>> >>
>> >> =A0 =A0 =A0Btrfs: prevent RAID level downgrades when space is low
>> >>
>> >> =A0 =A0 =A0The extent allocator has code that allows us to fill
>> >> =A0 =A0 =A0allocations from any available block group, even if it=
 doesn't
>> >> =A0 =A0 =A0match the raid level we've requested.
>> >>
>> >> Btrfs has added the space of single chunks and raid0 chunks into =
the space
>> >> information, so when we use btrfs_check_data_free_space() to chec=
k if there
>> >> is some space for storing file data, this function may return tru=
e. So we
>> >> write the data into the cache successfully. But, the extent alloc=
ator can
>> >> not allocate any space to store that cached data, and then the fi=
le system
>> >> panic.
>> >>
>> >> I think we subtract that space from the space information, or spl=
it the space
>> >> information into two types, one is used to manage the chunks with=
 duplication,
>> >> the other manages the other chunks.
>> >
>> > Ok, do you have a test case that triggers this? =A0I'll work out a=
 patch.
>> > Yan Zheng's original idea of 'the chunks should be readonly' shoul=
d help
>> > us deduct them from the total.
>>
>> # mkfs.btrfs -d raid1 /dev/sda9 /dev/sda10
>> # mount /dev/sda9 /mnt
>> # dd if=3D/dev/zero of=3D/mnt/tmpfile0 bs=3D4K count=3D9999999999999=
99999
>> =A0 =A0(fill the file system)
>> # umount /mnt
>> # mount /dev/sda9 /mnt
>> # dd if=3D/dev/zero of=3D/mnt/tmpfile1 bs=3D4K count=3D1000
>> # sync
>
> Looks like we've got an off by one bug in set_block_group_ro, which i=
s
> why our block group isn't getting set to ro. =A0With this patch, we'r=
e
> properly setting the block group ro, and the enospc accounting is don=
e
> correctly.
>
> It should also be able to replace my commit above. =A0Please take a l=
ook,
> Zheng does this look correct to you?
>
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 227e581..6f7d758 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -7970,13 +7970,14 @@ static int set_block_group_ro(struct btrfs_bl=
ock_group_cache *cache)
>
> =A0 =A0 =A0 =A0if (sinfo->bytes_used + sinfo->bytes_reserved + sinfo-=
>bytes_pinned +
> =A0 =A0 =A0 =A0 =A0 =A0sinfo->bytes_may_use + sinfo->bytes_readonly +
> - =A0 =A0 =A0 =A0 =A0 cache->reserved_pinned + num_bytes < sinfo->tot=
al_bytes) {
> + =A0 =A0 =A0 =A0 =A0 cache->reserved_pinned + num_bytes <=3D sinfo->=
total_bytes) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sinfo->bytes_readonly +=3D num_bytes;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sinfo->bytes_reserved +=3D cache->rese=
rved_pinned;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cache->reserved_pinned =3D 0;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cache->ro =3D 1;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D 0;
> =A0 =A0 =A0 =A0}
> +
> =A0 =A0 =A0 =A0spin_unlock(&cache->lock);
> =A0 =A0 =A0 =A0spin_unlock(&sinfo->lock);
> =A0 =A0 =A0 =A0return ret;
>

Looks good for me,

Yan, Zheng
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
