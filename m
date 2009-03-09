From: Yien Zheng <esprout@gmail.com>
Subject: Re: [PATCH] Btrfs: take block group fragmentation into account for
	allocation
Date: Sun, 8 Mar 2009 20:03:36 -0600
Message-ID: <2c259a8f0903081903w7cebb98excfbf9a4ec5c147d8@mail.gmail.com>
References: <2c259a8f0903080742l6e2f6233g709b036281bf962c@mail.gmail.com>
	 <20090308163707.GC11787@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090308163707.GC11787@kernel.dk>
List-ID: <linux-btrfs.vger.kernel.org>

Thanks Jens!  My research had indicated something about 64-bit
division and using do_div, but you cleared it up for me.

The fragmentation_percent function ultimately does another divide to
get the percentage, so here's what I did to get the function to work:

static int fragmentation_percent(struct btrfs_block_group_cache *block_=
group)
{
        u64 max_fragments;
        u64 fragments_ratio;

        max_fragments =3D block_group->key.offset -
                btrfs_block_group_used(&block_group->item);
        do_div(max_fragments, block_group->fragment_size);
        fragments_ratio =3D block_group->fragments;
        do_div(fragments_ratio, max_fragments);
        return (fragments_ratio * 100);
}

On Sun, Mar 8, 2009 at 10:37 AM, Jens Axboe <jens.axboe@oracle.com> wro=
te:
> On Sun, Mar 08 2009, Yien Zheng wrote:
>> I tried applying this patch, but the fragmentation_percent function =
is
>> giving me:
>>
>> WARNING: "__udivdi3"
>> [/home/partition6/yien/git/linux-git/fs/btrfs/btrfs.ko] undefined!
>>
>> when I compile, and the module fails to load, even though the build
>> completes. =A0I've traced it to the calculation of max_fragments:
>>
>> max_fragments =3D (block_group->key.offset -
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 btrfs_block_group_used(&block_group->ite=
m)) /
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 block_group->fragment_size;
>>
>> It seems that accessing block_group in here is causing a reference t=
o
>> __udivdi3 somehow. =A0Any idea what's going on here?
>
> You can't to 64-bit divides on 32-bit archs. Make that
>
> max_fragments =3D block_group->key.offset - btrfs_block_group_used(&b=
lock_group->item);
> do_div(max_fragments, block_group->fragment_size);
>
> and it should work.
>
> --
> Jens Axboe
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
