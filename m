Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794678967;
	b=mC3uXvZT7clbg2DO75NQdsp6AxRc0bR4a37wVkAKgmTRrPj/GzJlR63IxIsOy9T26WD0
	 2/ulD2Fweucd6Gd/5la1iq/NSgPS0eeJY1kjTPjbEzPBco+zdRXcXy/TNhkIOAsL+tfW/
	 YrUG40Eq5HLUpSS2qC/C/sUBOsimuF+xhbkxOF/2HpLW+3BBa1d3u3xD4R17KAHFYO9sK
	 pbQ3pWF9NB8XA3bjNT1oYY9N/uE5X8YU1wR9RYR5EaHmQGRuGeJb6rFWDx5movoya6/7Q
	 oxRVihPHNlKEYYnZq/YodQ+JYXkvCTRx8M3vaQhrMfNAVIBaEskjMGPGs4FHD6s7RRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794678967;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=ZZGPtoFQkHPw8qXSIFOSJXaZROeyGgYFMRCEsoazu+8=;
	b=A0Vcw/ZCfALmj7MozMj9EQIi2ZCbvB5VJIyoreyi7kL1Omckdhs3DF3gxhTtkHcJcdOW
	 HIzQU//e9n0IQIgS3u+K+aiPpXvfldwsa7X8WMmcXIyZlMq20myPNJT0M6ta2Jm5jN9/s
	 7TggCD8NLaGXoTajIC/nbqxL81jF7fmM+Vz0gnYYzQBTyEHuyqTNaIx92UVTCKnxCJn0G
	 lXHLlE4iktYA+DZ+XA7ex32Zw6RJU9jczTC7CdcSYYUFn2yjrOsLXqNTsFAdnBlEm6Pfe
	 DWDD2ZuHrtWTDmCpn5HL4ctJJa61a4ZSgKNN0xP05mJzlssS3O6Z8kVmdkTBsR4JZ8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QGC+eSIn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2502F606A323
	for <linux-btrfs@vger.kernel.org>; Sat, 14 Nov 2026 17:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QGC+eSIn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFDAC1F000C4
	for <linux-btrfs@vger.kernel.org>; Sat, 14 Nov 2026 17:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794678966;
	bh=ZZGPtoFQkHPw8qXSIFOSJXaZROeyGgYFMRCEsoazu+8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=QGC+eSInfmz8JYW2KFchwPBmzqow/cWjnIjgPURsokDy45UOiVPiILXlGmzs4d6VV
	 oLJBLi0MG8HisIrodu/Kio+qoHeFlSIACPPBmPCKgHwuzFEoivyzMI2R18Jkqr5r9i
	 PNfWhT8BK11zfCyEeuBioHftYIMoaQMB0JNQoXrP+hq4n+0fuoqtbggLSe6e0R+fGQ
	 lsSrIkHSquhFT0thg0PFeNH8vmqkyA9NXm365wsYO0aG0gEa+vdKMwd03SLEDJThnd
	 /Q3x7H0gDEdUehNItg3WoC1DKItgT4NZfQH4O5wSLS1p7Cukb2asbYqUnM294v7ygI
	 8Q558dE/L2mQg==
Received: by mail-vk1-f182.google.com with SMTP id 71dfb90a1353d-5c9e7731b34so2782522e0c.2
        for <linux-btrfs@vger.kernel.org>; Sat, 14 Nov 2026 09:56:06 -0800 (PST)
X-Gm-Message-State: APuU4Z/XHle250WTZuZ13evWrNfBBfVj2g5L20oUTpZED/j3GxfhXdDK
	02RqQqW2REDJO+0yW5k03w2tWOANZhdHldwpi2EDLN7bOxoYuCb0lmmvh39VS33xe59GLMB86IP
	JrkZINU5kAJgwmesubvmDg3zq+vUNZoI=
X-Received: by 2002:a05:6102:4455:b0:7d2:b199:6710 with SMTP id
 ada2fe7eead31-7d64d76b330mr1595249137.15.1794678965911; Sat, 14 Nov 2026
 09:56:05 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261114000234.339513-1-eliasjernberg@gmail.com>
In-Reply-To: <20261114000234.339513-1-eliasjernberg@gmail.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Sat, 14 Nov 2026 17:55:29 +0000
X-Gmail-Original-Message-ID: <CAL3q7H5i1AopXwa8xDuuBKqsTyUAkajysNxYZMLmiGVXBf9paw@mail.gmail.com>
X-Gm-Features: AclHuK9BeAO7g08Z3c79J6pMdHzvGqakgW-9xh3IirLSz7Uyy1BqTyp_ZI7jCw4
Message-ID: <CAL3q7H5i1AopXwa8xDuuBKqsTyUAkajysNxYZMLmiGVXBf9paw@mail.gmail.com>
Subject: Re: [PATCH] btrfs: speed up steal_from_bitmap_to_front() with a
 backward word scan
To: Elias Jernberg <eliasjernberg@gmail.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>, 
	Filipe Manana <fdmanana@suse.com>, Chris Mason <mason@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 14, 2026 at 12:03=E2=80=AFAM Elias Jernberg <eliasjernberg@gmai=
l.com> wrote:
>
> steal_from_bitmap_to_front() looks for the last clear bit below the new
> extent entry by walking every clear bit of the bitmap from bit 0 with
> for_each_clear_bit_from(). In a bitmap that is mostly allocated that is
> one find_next_zero_bit() call per allocated sector below the entry, and
> it is done for every free space entry added next to a bitmap.
>
> With 16K pages a bitmap has 131072 bits. On an arm64 machine with 16K
> pages (Apple M5, 4K sectorsize, discard=3Dasync, compression on),
> deleting a 4 GiB file of about one million 4K extents, after scattered
> 4K rewrites had put the block group's free space into bitmaps, made the
> next fsync take 29 to 36 seconds of CPU. Three sysrq-l samples taken
> during the stall all showed:
>
>   _find_next_zero_bit
>   __btrfs_add_free_space
>   unpin_extent_range
>   btrfs_finish_extent_commit
>   btrfs_commit_transaction
>   btrfs_sync_file
>
> A buffered 4 GiB write with end_fsync right after the delete ran at

What is end_fsync? Do you mean writing all data, deleting the file
while there's an open fd on it and then calling fsync() on the fd?
Please be clear in the changelog, I can't tell what "end_fsync" is.

> 119-147 MB/s instead of about 4.7 GB/s.
>
> Scan backwards from the bit below the entry one word at a time instead,
> so the cost follows the run of free sectors that ends there and not the
> number of allocated sectors below it. The result is the same for every
> index: a userspace copy of both versions agreed in about 11 million
> cases (bitmaps of 256, 32768 and 131072 bits, empty, full, random and
> long runs, word boundaries and the last bit). The index is still
> limited to BITS_PER_BITMAP - 1, as the old loop was.
>
> With the change the same sequence ran the buffered write in 0.8-0.9 s
> (4613 and 5238 MB/s).
>
> Fixes: 200055239604 ("Btrfs: improve free space cache management and spac=
e allocation")
> Signed-off-by: Elias Jernberg <eliasjernberg@gmail.com>
> ---
>
> Notes:
>     - The numbers above come from a 7.3-based tree (aurora-silicon/linux,
>       Apple M5 MacBook Pro, 16K pages) carrying this change in an
>       equivalent form. This version was build-tested on btrfs for-next
>       (3aefd67f08f8) as x86_64 UML with W=3D1, no new warnings, and the b=
trfs
>       self-tests pass (CONFIG_BTRFS_FS_RUN_SANITY_TESTS, including the
>       bitmap stealing tests).
>     - On x86_64 with 4K pages I could not reproduce a clear stall with th=
e
>       similar fragmenting workload (sync after the delete took 0.4-1.9 s)=
, so the
>       effect looks tied to the larger bitmaps of 16K and 64K pages.
>     - Reproducer (fio, run on the btrfs filesystem under test):
>         fio --name=3Da --filename=3Df --rw=3Dwrite --bs=3D1M --direct=3D1=
 --size=3D4G --end_fsync=3D1
>         fio --name=3Dr --filename=3Df --rw=3Drandwrite --bs=3D4k --ioengi=
ne=3Dlibaio --iodepth=3D32 \
>             --direct=3D1 --size=3D4G --time_based --runtime=3D15 --end_fs=
ync=3D1
>         fio --name=3Ds --filename=3Df --rw=3Dwrite --bs=3D4k --direct=3D1=
 --size=3D4G \
>             --time_based --runtime=3D15 --fsync=3D1
>         rm f
>         fio --name=3Db --filename=3Df --rw=3Dwrite --bs=3D1M --size=3D4G =
--end_fsync=3D1
>       The last job takes 29-36 s without this patch and under 1 s with it=
.

The test used to measure performance, and the results, should be in
the changelog, not below the --- line.
It's useful information to have in the changelog.

The change itself looks good, thanks.


>     - Prior art: Yun Levi suggested replacing this loop in December 2020 =
on
>       LKML, as a user of a proposed find_prev_zero_bit()
>       (https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg24024=
57.html).
>       That helper was never added and the loop is unchanged in for-next.
>       This version keeps the backward scan local to free-space-cache.c.
>     - Tool use: the stall was profiled, the fix written and the changelog
>       drafted with an LLM coding assistant (Claude). I have reviewed the
>       change; the equivalence test and the measurements were run on my
>       machine.
>
>  fs/btrfs/free-space-cache.c | 30 ++++++++++++++++++++++--------
>  1 file changed, 22 insertions(+), 8 deletions(-)
>
> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
> index bff6e5b372d6..c599a8f25821 100644
> --- a/fs/btrfs/free-space-cache.c
> +++ b/fs/btrfs/free-space-cache.c
> @@ -1269,6 +1269,26 @@ static bool steal_from_bitmap_to_end(struct btrfs_=
free_space_ctl *ctl,
>         return true;
>  }
>
> +/*
> + * Return the index of the last clear bit at or below @bit, or ULONG_MAX=
 if
> + * bits 0 to @bit are all set.  Scan backwards a word at a time, so the =
cost
> + * follows the length of the run of set bits that ends at @bit rather th=
an the
> + * number of clear bits below it.
> + */
> +static unsigned long find_last_clear_bit_upto(const unsigned long *bitma=
p,
> +                                             unsigned long bit)
> +{
> +       unsigned long idx =3D BIT_WORD(bit);
> +       unsigned long word =3D ~bitmap[idx] & BITMAP_LAST_WORD_MASK(bit +=
 1);
> +
> +       while (!word) {
> +               if (idx =3D=3D 0)
> +                       return ULONG_MAX;
> +               word =3D ~bitmap[--idx];
> +       }
> +       return idx * BITS_PER_LONG + __fls(word);
> +}
> +
>  static bool steal_from_bitmap_to_front(struct btrfs_free_space_ctl *ctl,
>                                        struct btrfs_free_space *info,
>                                        bool update_stat)
> @@ -1277,7 +1297,6 @@ static bool steal_from_bitmap_to_front(struct btrfs=
_free_space_ctl *ctl,
>         struct btrfs_free_space *bitmap;
>         u64 bitmap_offset;
>         unsigned long i;
> -       unsigned long j;
>         unsigned long prev_j;
>         u64 bytes;
>
> @@ -1294,13 +1313,8 @@ static bool steal_from_bitmap_to_front(struct btrf=
s_free_space_ctl *ctl,
>                 return false;
>
>         i =3D offset_to_bit(bitmap->offset, unit, info->offset) - 1;
> -       j =3D 0;
> -       prev_j =3D (unsigned long)-1;
> -       for_each_clear_bit_from(j, bitmap->bitmap, BITS_PER_BITMAP) {
> -               if (j > i)
> -                       break;
> -               prev_j =3D j;
> -       }
> +       prev_j =3D find_last_clear_bit_upto(bitmap->bitmap,
> +                                         min(i, BITS_PER_BITMAP - 1));
>         if (prev_j =3D=3D i)
>                 return false;
>
> --
> 2.56.1
>
>
