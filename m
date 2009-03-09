From: Simon Holm =?ISO-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
Subject: Re: [PATCH] Btrfs: take block group fragmentation into account for
 allocation
Date: Mon, 09 Mar 2009 14:56:33 +0100
Message-ID: <1236606993.7842.8.camel@odie.local>
References: <2c259a8f0903080742l6e2f6233g709b036281bf962c@mail.gmail.com>
	 <20090308163707.GC11787@kernel.dk>
	 <2c259a8f0903081903w7cebb98excfbf9a4ec5c147d8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-btrfs@vger.kernel.org,
	Josef Bacik <jbacik@redhat.com>
To: Yien Zheng <esprout@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <2c259a8f0903081903w7cebb98excfbf9a4ec5c147d8@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

s=C3=B8n, 08 03 2009 kl. 20:03 -0600, skrev Yien Zheng:
> Thanks Jens!  My research had indicated something about 64-bit
> division and using do_div, but you cleared it up for me.
>=20
> The fragmentation_percent function ultimately does another divide to
> get the percentage, so here's what I did to get the function to work:
>=20
> static int fragmentation_percent(struct btrfs_block_group_cache *bloc=
k_group)
> {
>         u64 max_fragments;
>         u64 fragments_ratio;
>=20
>         max_fragments =3D block_group->key.offset -
>                 btrfs_block_group_used(&block_group->item);
>         do_div(max_fragments, block_group->fragment_size);
>         fragments_ratio =3D block_group->fragments;
>         do_div(fragments_ratio, max_fragments);
>         return (fragments_ratio * 100);
> }
>=20
So the idea of the function is to return an integer in the range
[0,100]? The problem is that it will only return either 0 or 100, but
nothing in between, right?

Wouldn't something along the lines of the following be better?

u64 tmp =3D (block_group->key.offset -
	btrfs_block_group_used(&block_group->item);
u64 tmp2 =3D 100 * block_group->fragment_size * block_group->fragments;
do_div(tmp2, tmp);
return tmp2;


Simon Holm Th=C3=B8gersen

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
