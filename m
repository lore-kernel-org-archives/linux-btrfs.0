Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795006005;
	b=sM+loQ5p7by+nhsy/x+fwEoydHSwj3zLfQH/lTIAjlHyx9I7tCyz/ZjlpKykuwam1IU8
	 B0i3uAyIISz0JQGPB3+WAqS8PvIJ59TO+isRX89WhxZO25gnaZqqgNUfVBqlkD83NI45O
	 /F9FLHhbmSyyFfd9yywBmit7h1SEE+vxklNqSadxqJmW89dSUnM2kQIAcp4hvtz2IIUMI
	 XQYRL5zVslFfqKISwk897kobRO6mHQzaCDesHcVaVX76G6FlyJbBjBmeUj6vZ0rWu22bf
	 tdBgWgTM34f1V83EAHCCKVhdeTQFnjKpDgDGBMIpWOaYFNE/764YUQ3wQJNCOxdCj9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795006005;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=lhkOiVS50sHPp+vfdH7wwUpjclysrq4SPxCnSMpycBw=;
	b=4htZ1UqE1sqW56r6er0l4WcYNjVo7pey7nhBoWB0/gwpyZMd8mlbNmQPAcV7N4v3Z7jK
	 I6gleK5y9mh5NA/WBBn/xDKvbR8oLr+B2XnUCAxBaHPG0h4JeZ5cdJQ2bwRrQCQ/zeLr6
	 Q156wVYu6lPMaAMb0YVzA5Do3v3Eb4sUPQ5Fm6QhWOM6fJy5AgMczmo03sUB1E0KJZd9x
	 Cv5VPkgiDjj15jv29mbzH3fynooMRHzMal8FN4NDOid+KxeocbKY3g+ERAKi+dymDTAGQ
	 SBmdPjKpHOqmMQO7W2ExQ6TO45mNzKk355hUfoz5bpBBI8k4AsVrouCqeJ0RlkOq56A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UOBOVNcw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D658606A31C
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Nov 2026 12:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UOBOVNcw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18DAE1F000C4
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Nov 2026 12:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795006005;
	bh=lhkOiVS50sHPp+vfdH7wwUpjclysrq4SPxCnSMpycBw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=UOBOVNcw6A6OeoKteHs3vkOSnoN4BA4al2C0x29jgZ71EBB1voLSiNWqGFuA9pCzQ
	 FRnYILBH5mxifVv9SIak2PcslPccGEYtWzmhS3Pyk31Z3ckM2q5PnfWnoqp4316JUZ
	 qF5zhkp/Av4i9GUfsVW49fcBWjSqv9SxINGxg39CH4IuoyDGmVbN1o7spI9lR4mB+/
	 JxIrsX+aJI92Wxbfoj4LKcc8Kb/Cb+pB6KAfgLP0nJDb9Njp4mmibL8zGd8V77ltyB
	 0ab6YdgwMv+foqjibDuV4dqmkiakxCPxxyN6T6sNatopPWewxjbC9rwH2sUFvqhzDX
	 0EmIODyJ4BKvg==
Received: by mail-ua1-f46.google.com with SMTP id a1e0cc1a2514c-98301b325c4so299560241.1
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Nov 2026 04:46:45 -0800 (PST)
X-Gm-Message-State: APuU4Z8i20Hnol3dc2NnPkN4EseHs1rEFJFaGN2zfwDnnHvIzC56hrHH
	4FLwAsZaYk1kYt1AXZkUfHDDvaJGBPb+CZjQCPw7nSToA9Uy9rYWXCTTlevqxgwGUHe0ti92wU9
	m/9ocOAAujwDV9y8IxZuAjHvb+E9nh6U=
X-Received: by 2002:a05:6102:6f07:b0:7cc:2152:4f88 with SMTP id
 ada2fe7eead31-7d6ba3dcde0mr529916137.21.1795006004231; Wed, 18 Nov 2026
 04:46:44 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261114000234.339513-1-eliasjernberg@gmail.com> <20261118003719.1789633-1-eliasjernberg@gmail.com>
In-Reply-To: <20261118003719.1789633-1-eliasjernberg@gmail.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Wed, 18 Nov 2026 12:46:07 +0000
X-Gmail-Original-Message-ID: <CAL3q7H7GC-WSVB+syDBCmKBm6EVPcWAxETQhd4ij2QKKZQ4QSg@mail.gmail.com>
X-Gm-Features: Aa3M54rtq0huHpN3mV6XsUjgmQ4Cd7ySk_TYBLjc1X9MZKyoiBHwzK2gD_x_N3o
Message-ID: <CAL3q7H7GC-WSVB+syDBCmKBm6EVPcWAxETQhd4ij2QKKZQ4QSg@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: speed up steal_from_bitmap_to_front() with a
 backward word scan
To: Elias Jernberg <eliasjernberg@gmail.com>
Cc: linux-btrfs@vger.kernel.org, wqu@suse.com, dsterba@suse.com, 
	mason@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 18, 2026 at 12:38=E2=80=AFAM Elias Jernberg <eliasjernberg@gmai=
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
> Scan backwards from the bit below the entry one word at a time instead,
> so the cost follows the run of free sectors that ends there and not the
> number of allocated sectors below it. The result is the same for every
> index: a userspace copy of both versions agreed in about 11 million
> cases (bitmaps of 256, 32768 and 131072 bits, empty, full, random and
> long runs, word boundaries and the last bit). The index is still
> limited to BITS_PER_BITMAP - 1, as the old loop was.
>
> The workload that triggers the stall is the following fio sequence,
> run in a directory on the btrfs filesystem under test. Here
> "end_fsync=3D1" is the fio option that makes fio call fsync() once on the
> file, after the job's last write, before the job ends. Nothing is
> deleted while the file is open.
>
>   # 1. Write a 4 GiB file with 1 MiB direct writes.
>   fio --name=3Da --filename=3Df --rw=3Dwrite --bs=3D1M --direct=3D1 --siz=
e=3D4G \
>       --end_fsync=3D1
>   # 2. Rewrite it with random 4K direct writes for 15 seconds, to
>   #    fragment it into about one million 4K extents.
>   fio --name=3Dr --filename=3Df --rw=3Drandwrite --bs=3D4k --ioengine=3Dl=
ibaio \
>       --iodepth=3D32 --direct=3D1 --size=3D4G --time_based --runtime=3D15=
 \
>       --end_fsync=3D1
>   # 3. Sequential 4K direct writes for 15 seconds with an fsync() after
>   #    every write.
>   fio --name=3Ds --filename=3Df --rw=3Dwrite --bs=3D4k --direct=3D1 --siz=
e=3D4G \
>       --time_based --runtime=3D15 --fsync=3D1
>   # 4. Delete the file. No fd is open on it any more.
>   rm f
>   # 5. Write a new 4 GiB file with buffered 1 MiB writes and one fsync()
>   #    at the end. This fsync() commits the transaction that frees the
>   #    extents of the deleted file, which is where the time goes.
>   fio --name=3Db --filename=3Df --rw=3Dwrite --bs=3D1M --size=3D4G --end_=
fsync=3D1
>
> Only the last job is timed. Without this patch it ran at 119-147 MB/s
> (29-36 s for the 4 GiB). With the patch the same sequence ran it in
> 0.8-0.9 s (4613 and 5238 MB/s).
>
> Fixes: 200055239604 ("Btrfs: improve free space cache management and spac=
e allocation")
> Signed-off-by: Elias Jernberg <eliasjernberg@gmail.com>
> Reviewed-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Pushed it to the for-next branch on github, thanks.

> ---
>
> Changes in v2:
> - Expanded the changelog as requested by Filipe: explained end_fsync,
>   moved the reproducer and the measurements from below the --- line
>   into the changelog.
> - Added Qu's Reviewed-by.
> - No code changes.
>
> Notes:
> - The numbers above come from a 7.3-based tree (aurora-silicon/linux,
>   Apple M5 MacBook Pro, 16K pages) carrying this change in an
>   equivalent form. This version was build-tested on btrfs for-next
>   (3aefd67f08f8) as x86_64 UML with W=3D1, no new warnings, and the btrfs
>   self-tests pass (CONFIG_BTRFS_FS_RUN_SANITY_TESTS, including the
>   bitmap stealing tests).
> - On x86_64 with 4K pages I could not reproduce a clear stall with the
>   similar fragmenting workload (sync after the delete took 0.4-1.9 s),
>   so the effect looks tied to the larger bitmaps of 16K and 64K pages.
> - Prior art: Yun Levi suggested replacing this loop in December 2020 on
>   LKML, as a user of a proposed find_prev_zero_bit()
>   (https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg2402457.h=
tml).
>   That helper was never added and the loop is unchanged in for-next.
>   This version keeps the backward scan local to free-space-cache.c.
> - Tool use: the stall was profiled, the fix written and the changelog
>   drafted with an LLM coding assistant (Claude). I have reviewed the
>   change; the equivalence test and the measurements were run on my
>   machine.
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
> 2.56.0
>
