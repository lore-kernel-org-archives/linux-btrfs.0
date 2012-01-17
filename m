From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: [PATCH] Btrfs: fix enospc error caused by wrong checks of the
 chunk allocation
Date: Tue, 17 Jan 2012 10:31:00 -0600
Message-ID: <CAKcLGm_HRMWcg4Aze59EFjQARbnQTSCxyfyPB4bS3f2R4kfvuQ@mail.gmail.com>
References: <4F153E33.8070803@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: miaox@cn.fujitsu.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F153E33.8070803@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 17, 2012 at 3:24 AM, Miao Xie <miaox@cn.fujitsu.com> wrote:
> When we did sysbench test for inline files, enospc error happened eas=
ily though
> there was lots of free disk space which could be allocated for new ch=
unks.
>
> Reproduce steps:
> =A0# mkfs.btrfs -b $((2 * 1024 * 1024 * 1024)) <test partition>
> =A0# mount <test partition> /mnt
> =A0# ulimit -n 102400
> =A0# cd /mnt
> =A0# sysbench --num-threads=3D1 --test=3Dfileio --file-num=3D81920 \
> =A0> --file-total-size=3D80M --file-block-size=3D1K --file-io-mode=3D=
sync \
> =A0> --file-test-mode=3Dseqwr prepare
> =A0# sysbench --num-threads=3D1 --test=3Dfileio --file-num=3D81920 \
> =A0> --file-total-size=3D80M --file-block-size=3D1K --file-io-mode=3D=
sync \
> =A0> --file-test-mode=3Dseqwr run
> =A0<soon later, BUG_ON() was triggered by enospc error>
>
> The reason of this bug is:
> Now, we can reserve space which is larger than the free space in the =
chunks if
> we have enough free disk space which can be used for new chunks. By t=
his way,
> the space allocator should allocate a new chunk by force if there is =
no free
> space in the free space cache. But there are two wrong checks which b=
reak this
> operation.
>
> One is
> =A0 =A0 =A0 =A0if (ret =3D=3D -ENOSPC && num_bytes > min_alloc_size)
> in btrfs_reserve_extent(), it is wrong, we should try to allocate a n=
ew chunk
> even we fail to allocate free space by minimum allocable size.
>
> The other is
> =A0 =A0 =A0 =A0if (space_info->force_alloc)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0force =3D space_info->force_alloc;
> in do_chunk_alloc(). It makes the allocator ignore CHUNK_ALLOC_FORCE =
If someone
> sets ->force_alloc to CHUNK_ALLOC_LIMITED, and makes the enospc error=
 happen.
>
> Fix these two wrong checks. Especially the second one, we fix it by c=
hanging
> the value of CHUNK_ALLOC_LIMITED and CHUNK_ALLOC_FORCE, and make
> CHUNK_ALLOC_FORCE greater than CHUNK_ALLOC_LIMITED since CHUNK_ALLOC_=
=46ORCE has
> higher priority. And if the value which is passed in by the caller is=
 greater
> than ->force_alloc, use the passed value.
>
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
> This patch is based on the new viro branch.

After applying this patch to the re-based integration branch, I was
able to clear an EFBIG error (that seemed to be related to chunk
allocation) I had previously been receiving while trying to balance a
partially corrupted partition.

I was receiving this bug from the btrfs_add_system_chunk() function
which had do_chunk_alloc() close up in the callback list.

Thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
