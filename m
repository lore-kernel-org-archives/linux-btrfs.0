From: Christian Brunner <chb@muc.de>
Subject: Re: WARNING: at fs/btrfs/extent-tree.c:5980
Date: Tue, 13 Dec 2011 09:10:00 +0100
Message-ID: <CAO47_-8yPzQwKO8Kgp+9HvKNBdRm+1zA-bcLr1xxpasC4TmjHA@mail.gmail.com>
References: <CAO47_--mEi_vQNt5TE3vZWAWRVtqsJnMc=jQUNJLSvw8S8=jiA@mail.gmail.com>
Reply-To: chb@muc.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAO47_--mEi_vQNt5TE3vZWAWRVtqsJnMc=jQUNJLSvw8S8=jiA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Sorry - I forgot to mention, that I'm still seeing this with:

[PATCH] Btrfs: update global block_rsv when creating a new block group

Christian

2011/12/13 Christian Brunner <chb@muc.de>:
> Hi,
>
> with the latest btrfs for-linus I'm seeing seeing occasional
> btrfs_alloc_free_block warnings on several nodes in our ceph cluster.
>
> Before the warning there is an additional block rsv -28 message, but
> there is plenty of free space on the disk.
>
>
> [201653.774412] btrfs: block rsv returned -28
> [201653.774415] ------------[ cut here ]------------
> [201653.779846] WARNING: at fs/btrfs/extent-tree.c:5980
> btrfs_alloc_free_block+0x347/0x360 [btrfs]()
>
> The complte trace is here:
>
> http://pastebin.com/0SFeZReg
>
> The extent-tree.c:5980 is in use_block_rsv():
>
> 5974 =A0 =A0 =A0 =A0 if (ret) {
> 5975 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 static DEFINE_RATELIMIT_STATE(_r=
s,
> 5976 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
DEFAULT_RATELIMIT_INTERVAL,
> 5977 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
/*DEFAULT_RATELIMIT_BURST*/ 2);
> 5978 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (__ratelimit(&_rs)) {
> 5979 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_DEBU=
G "btrfs: block rsv
> returned %d\n", ret);
> 5980 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 WARN_ON(1);
> 5981 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> 5982 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D reserve_metadata_bytes(r=
oot, block_rsv,
> blocksize, 0);
>
> Thanks,
> Christian
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
