Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61E6F280331
	for <linux-btrfs@vger.kernel.org>; Thu, 21 May 2026 14:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779374720; cv=none; b=GcqBvrswLuAHVzyHsG7/LWhO2Dc4Pnz25C0uzt9cih/cdIzfBCDhQ9oxGpJEiNk7Gcim2hiE7hLFE74h1MPgiSnYP2BmNNoIuPoLOs2q0J1XW6ROedgfKVEPAVjw8HfLHZbNf+cKpp0Yxd5/kjKVQvJgKPx9XoT01vaZNliqYkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779374720; c=relaxed/simple;
	bh=6r2YErtxdN3EYCb7tEJOqQ8/7EhlK0FgCfEqLZsUUvU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EbMJk7FtK78bNecjpon4KVxkZbyKR5XpNWAXb89f3q7s/bT+G13xdPIF953/vN70gkTbp8omzfuU+LZn3mYQli+oGC/eiqUq64b5rZ5MFhCip7h1XMyxCS7+AQEag7vPUH/ZKo7J70H4HRKhW+mDkKuZc8YmeTqktMzfYCcqt8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cdt4sDdZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cdt4sDdZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09A401F00A3E
	for <linux-btrfs@vger.kernel.org>; Thu, 21 May 2026 14:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779374719;
	bh=nFqZZoAkM0ht/pG5sdImAy/lYSJgrZUg65Z8i3A50tc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Cdt4sDdZikcPlpQ+9giA6itw46CtrgfVoflFDBc4xBLfcZ4JFa3HvrgcwPc91w844
	 QReWOC8uJOkXAhmhuoT0aYyGPMX5isJX6bmfRtZ77BNv5PgdcSyQQbtolPGkCh03px
	 aC6IkTW4Ii5r6JapB8M6bZ+wFtowWh5VihjE+PpBW0Zw8wEryVlkeI8f1JJC2Tg4Bx
	 5iVBAXf4YdlyZDNVOgnIgtFLlin0u5gSDgAWh4LCAaGbt4z4YLIvW4yd4MDp5rWuDW
	 QVLKZnKa/A7q54DEBCvEa9UZhaIGN+2LeNfVy5gx6KhT532wwJsiYXG3WE9T3anIEN
	 19ZBEXdH6Ao4A==
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-bdbcc6c4500so176253466b.1
        for <linux-btrfs@vger.kernel.org>; Thu, 21 May 2026 07:45:18 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ94cZYV87yf2kqSgcSDjfq22N2uSqageeSY0MHyg01IqOl26cpwa+NeKSQIdKvfIgA7kLpWzCI9ehpaPA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyWvOYBSxYs2+5BnRmFZIV/GcGooxsJU4iQzxVaQBnVpo+lGy33
	6+IE3QPUl7BrWPYUxRk+ttnZUMP2mbg54cI+T9yoGBZsueuZZ+VipONlqJ9QFiwcSw7vtDRZlT/
	Tc33lBImbt26RLYmWPFiElVA6h1wYseE=
X-Received: by 2002:a17:907:d19:b0:bd4:f598:cc3d with SMTP id
 a640c23a62f3a-bdc15c318c9mr196734066b.41.1779374717653; Thu, 21 May 2026
 07:45:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ag8ARRwykv8bpJ87@stanley.mountain>
In-Reply-To: <ag8ARRwykv8bpJ87@stanley.mountain>
From: Filipe Manana <fdmanana@kernel.org>
Date: Thu, 21 May 2026 15:44:40 +0100
X-Gmail-Original-Message-ID: <CAL3q7H4kj29Bqh9cMF9d2K4E1-yGMecNVjbt2ZEvxgrsP7Am4Q@mail.gmail.com>
X-Gm-Features: AVHnY4IS85ocfJN09CwGDbXY3ZCRrNAFyImWNOsCta2-nrAo3TwmEDy0h3fCIWo
Message-ID: <CAL3q7H4kj29Bqh9cMF9d2K4E1-yGMecNVjbt2ZEvxgrsP7Am4Q@mail.gmail.com>
Subject: Re: [bug report] btrfs: refactor __btrfs_run_delayed_refs loop
To: Dan Carpenter <error27@gmail.com>
Cc: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 21, 2026 at 2:02=E2=80=AFPM Dan Carpenter <error27@gmail.com> w=
rote:
>
> [ 8 year old code and no one has complained...  It's surprising no
>   one has hit this in real life. - dan ]
>
> Hello Nikolay Borisov,
>
> Commit 0110a4c43451 ("btrfs: refactor __btrfs_run_delayed_refs loop")
> from Aug 15, 2018 (linux-next), leads to the following Smatch static
> checker warning:
>
>         fs/btrfs/extent-tree.c:2131 __btrfs_run_delayed_refs()
>         error: 'locked_ref' dereferencing possible ERR_PTR()
>
> fs/btrfs/extent-tree.c
>     2084 static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_=
handle *trans,
>     2085                                              u64 min_bytes)
>     2086 {
>     2087         struct btrfs_fs_info *fs_info =3D trans->fs_info;
>     2088         struct btrfs_delayed_ref_root *delayed_refs;
>     2089         struct btrfs_delayed_ref_head *locked_ref =3D NULL;
>     2090         int ret;
>     2091         unsigned long count =3D 0;
>     2092         unsigned long max_count =3D 0;
>     2093         u64 bytes_processed =3D 0;
>     2094
>     2095         delayed_refs =3D &trans->transaction->delayed_refs;
>     2096         if (min_bytes =3D=3D 0) {
>     2097                 /*
>     2098                  * We may be subject to a harmless race if some =
task is
>     2099                  * concurrently adding or removing a delayed ref=
, so silence
>     2100                  * KCSAN and similar tools.
>     2101                  */
>     2102                 max_count =3D data_race(delayed_refs->num_heads_=
ready);
>     2103                 min_bytes =3D U64_MAX;
>     2104         }
>     2105
>     2106         do {
>     2107                 if (!locked_ref) {
>     2108                         locked_ref =3D btrfs_select_ref_head(fs_=
info, delayed_refs);
>     2109                         if (IS_ERR_OR_NULL(locked_ref)) {
>     2110                                 if (PTR_ERR(locked_ref) =3D=3D -=
EAGAIN) {
>     2111                                         continue;
>
> In the old we set "locked_ref =3D NULL" on this path and I think we
> probably should restore that line.  Now it looks like a crash.
>
>     2112                                 } else {
>     2113                                         break;
>     2114                                 }
>     2115                         }
>     2116                         count++;
>     2117                 }
>     2118                 /*
>     2119                  * We need to try and merge add/drops of the sam=
e ref since we
>     2120                  * can run into issues with relocate dropping th=
e implicit ref
>     2121                  * and then it being added back again before the=
 drop can
>     2122                  * finish.  If we merged anything we need to re-=
loop so we can
>     2123                  * get a good ref.
>     2124                  * Or we can get node references of the same typ=
e that weren't
>     2125                  * merged when created due to bumps in the tree =
mod seq, and
>     2126                  * we need to merge them to prevent adding an in=
line extent
>     2127                  * backref before dropping it (triggering a BUG_=
ON at
>     2128                  * insert_inline_extent_backref()).
>     2129                  */
>     2130                 spin_lock(&locked_ref->lock);
>                                     ^^^^^^^^^^^^^^^^
> On the next iteration &locked_ref will be ERR_PTR(-EAGAIN).

Indeed.

Nikolay is no longer active in btrfs, so I've sent a fix for this:

https://lore.kernel.org/linux-btrfs/f33f040f3ced4b3813dba4ddb0b5377ab5aeac2=
9.1779374308.git.fdmanana@suse.com/

Thanks.

>
> --> 2131                 btrfs_merge_delayed_refs(fs_info, delayed_refs, =
locked_ref);
>     2132
>     2133                 ret =3D btrfs_run_delayed_refs_for_head(trans, l=
ocked_ref, &bytes_processed);
>     2134                 if (ret < 0 && ret !=3D -EAGAIN) {
>     2135                         /*
>     2136                          * Error, btrfs_run_delayed_refs_for_hea=
d already
>     2137                          * unlocked everything so just bail out
>     2138                          */
>     2139                         return ret;
>     2140                 } else if (!ret) {
>     2141                         /*
>     2142                          * Success, perform the usual cleanup of=
 a processed
>     2143                          * head
>     2144                          */
>     2145                         ret =3D cleanup_ref_head(trans, locked_r=
ef, &bytes_processed);
>     2146                         if (ret > 0 ) {
>     2147                                 /* We dropped our lock, we need =
to loop. */
>     2148                                 ret =3D 0;
>     2149                                 continue;
>     2150                         } else if (ret) {
>     2151                                 return ret;
>     2152                         }
>     2153                 }
>     2154
>     2155                 /*
>     2156                  * Either success case or btrfs_run_delayed_refs=
_for_head
>     2157                  * returned -EAGAIN, meaning we need to select a=
nother head
>     2158                  */
>     2159
>     2160                 locked_ref =3D NULL;
>     2161                 cond_resched();
>     2162         } while ((min_bytes !=3D U64_MAX && bytes_processed < mi=
n_bytes) ||
>     2163                  (max_count > 0 && count < max_count) ||
>     2164                  locked_ref);
>                           ^^^^^^^^^^
> We continue down to here and loop back since locked_ref is -EAGAIN.
>
>     2165
>     2166         return 0;
>     2167 }
>
> This email is a free service from the Smatch-CI project [smatch.sf.net].
>
> regards,
> dan carpenter
>
