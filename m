From: Yan Zheng <yanzheng@21cn.com>
Subject: Re: [PATCH] brtfs: less- and greater than confusion
Date: Mon, 13 Jul 2009 21:43:09 +0800
Message-ID: <3d0408630907130643s4806d791sddb460c813860437@mail.gmail.com>
References: <4A5A6418.2070906@gmail.com> <20090713132252.GB4704@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Roel Kluin <roel.kluin@gmail.com>, linux-btrfs@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>, yan.zheng@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090713132252.GB4704@think>
List-ID: <linux-btrfs.vger.kernel.org>

2009/7/13 Chris Mason <chris.mason@oracle.com>:
> On Mon, Jul 13, 2009 at 12:30:48AM +0200, Roel Kluin wrote:
>> Without this the loop won't start
>>
>> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
>> ---
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index 3ab80e9..2c873c9 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -2795,7 +2795,7 @@ int btrfs_rmap_block(struct btrfs_mapping_tree=
 *map_tree,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 }
>>
>> - =A0 =A0 for (i =3D 0; i > nr; i++) {
>> + =A0 =A0 for (i =3D 0; i < nr; i++) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct btrfs_multi_bio *multi;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct btrfs_bio_stripe *stripe;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 int ret;
>
> Thanks, this does look buggy. =A0That second loop should just be to v=
erify
> the first loop didn't mess things up. =A0Yan Zheng, is there any reas=
on we
> shouldn't delete it?
>
It's OK to delete it.

Yan Zheng
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
