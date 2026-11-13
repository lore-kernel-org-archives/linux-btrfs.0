Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794588858;
	b=awoda+eFfbjPFC6Zrbck08vvUq6iw741Bzl/peWoPkbVO7yBuBxCREUDwTXel1d7xgBX
	 DkVgz3e3VUtt0aoWeQ3jsV4Ln1w2m/1pktjtuRYeT05zUvk/2zI6aDAcqjQdmi7dkL2Wf
	 UbysTeQzMh6UQfqgeFfQw/50Wa0WlA5/2//EXt5GGC8Mjjzcoe0kPuEEInr4odARNtoUC
	 snhe0WMTCRigaICnyQKybyAAQmdjewByMCLAxjuMpKFK0qDdboEx/TnH79hq34JD9fypm
	 xLPRm3ao9cKdK5YYQBsQk3SjhQrfvsvOvf6aAOem5RmeHIUyUtsB8kvpy54ONpawtAA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794588858;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=/5xuuDo2JJA0oZRgLF5xo6KrSQ2DLrDbY5NdhzWKU8s=;
	b=R4z2HrW2lm7mwYjDFIESAzUgiYR3Y40Bx9wQuUEORBgbYMkzsqG9CrA6S2Tss18naF1g
	 tBcCwW1w2+bu/sMg+sfofauZ3D8vcT12FoWrxhoh0UysIh1RtL/iER3wXQgrTGPvKlXiv
	 7YgSJ56/hpKxG2dCaxgGNDnn+TG3lSmL+2K1QweK8aw1mvDGHRIhAVHGjM6UH+Fb+CYC3
	 KDyNI5qg+V6ZO1K+jStsLz/PW/fYPcCll9KYiTV5f5BmECUF+6xTQrGFGh5vNBICiur0g
	 cNAA9MHXK0mG8KnQRyEQGtxaOI5MGh97NdLMBiXa6n19pPkwfnXWHu01MWLIquVGbXw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=YopVL1Ai;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.45
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D892606A886
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 16:54:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5D892606A886
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=YopVL1Ai
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-49134c8509fso1409214f8f.1
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 08:54:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794588857; cv=none;
        d=google.com; s=arc-20260327;
        b=oNgzK436yMnub4qDADSYeha3eezNNvMSu6gsy1UbQq7jtmUsNhVvflNttevnnCm4i5
         46tl8XNlWYmEnIcnLtIW9ZHJ7mrvTW9nD7Z3MNOQqfPFYBvLyD+nAb1ECFeGBadn8DKp
         0kSbsC2Y9n/ww882lmig/df00wKyLzc6zdWURpPC1qGJ+E2S/y1w996sQKYhZ07xuc4M
         QKHu2+9MNmDGY9SMXbk1j7J96pUFc789jldvjdyQiiAM5h22Vp35nNHyxs4laRvLb71N
         7LOtNJyDfE5Qq7RqFyEMrmhb9J7Ch65htcDbofVDqh41j8vWkidER9P28qYcorjYF4qj
         4t6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/5xuuDo2JJA0oZRgLF5xo6KrSQ2DLrDbY5NdhzWKU8s=;
        fh=v5SypDb7dwdS4FGwcK5CeDhaQb47iUab0gtYlsnNpvI=;
        b=ovQbT2CcM8vwPlWzWrKFjT5HXKbELQsu81l77nN2SgTPzNXix6HMvGDuXnOMmvuW0f
         nrQX5824L5zLEgWvMm/0mHshn2L0kmTKbYqOzO/3W0Rov36CAHmHVrzC/ZAL9XiZIhfx
         fzAolqKm+okAwB2QX55cfbljQAFXCP+OPbkeEfqBrbmK6C1pJ3rEWvL2+HXFA6+oFm7J
         EUOIWLCUtPu05D6cYlv++ptgYKgjh4wcQ2UeluoNDtvQqtmnBt2Gp12fOsENtY9Rnq0i
         UD2Z1qsc6FYDTxnCXWw0qBbSNy0AkSZNrSJD09Z3rsq/l6J1LX2ANuchHYJ0DG/Q1KXA
         kC1g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1794588857; x=1795193657; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/5xuuDo2JJA0oZRgLF5xo6KrSQ2DLrDbY5NdhzWKU8s=;
        b=YopVL1AiFRFr9DSiwXHMWFbUEn/Y74LzY8E8LFlb+MoI+16XPzQW1V05wZKo472UVD
         P+VgSRF2Kt4MGdGESdjQVkOGm3LBwGUki84qhXbZsRP5JWEee3Z3GhHatNy6wdDdePfq
         Aq7ofOfC42SKLzKbAbze5glXssu7u3KoJgUVxNlPjQrBQ5Pjo5fx3tzQhCQnSPQ9mbxA
         uooza4Dvg0Du0AiJo4CnvxBzjCk7EvWzaVym+VJXdBaK1CAg8nNeHF61F4/NLNclwVY5
         p0oX1GnByTU8W5P8CvGnAr0f5TO8LEjxdvQhM5gWzH+yqJt7yGMVebsgJJSG+jnMo0+1
         b0OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794588857; x=1795193657;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/5xuuDo2JJA0oZRgLF5xo6KrSQ2DLrDbY5NdhzWKU8s=;
        b=Dmro+yZXlBdOwu4PlYEuuinBxajPaqcRuA4Qb3cBTp2d8EtJhYBHgMJiJ1VZbB8JhQ
         2F2MXn121hvoaGVvell7iCPbZK9RTNhWgBtKae4hjBsEw4Sjxr0WgpxMJEA+oTVG5yYg
         htX/fdh5Xo/zS7CfYkJHKnK97c7SvSFX7GTcChSc0C5xj2n1kfK7wRF8NdZ4SchtJtmt
         5n6LlVsxDy9v1thTuZsaOzIIGJyxZOyW4sOlrXZ3nIBeFg3bO54MXI39/ywoAOyuhKoU
         hLwGSq6h0u7vqSNHwHbtEBrFHKsqt8gi7nikxEVyERcHrh/8PRh1WBI8i14Sd6bWhLfy
         gz0Q==
X-Gm-Message-State: APuU4Z/Pzs80xa9+XBIQg+BwT7HBtQ/z6bloL8DdmFE9hhVJGtXvbYsv
	cgupEsPq+NMtfMwTFteZEkEzAkHTjuSqanPz5qmZt09upS/G4poFmrGZPDQq7Mn0bPItM4QMYu3
	wk7kqRUaytJrF5xb0jv141TkioK/W1V2P70QSi+/fdBlpPq8tF3F+DOA=
X-Gm-Gg: AYBFou09NXAxb8RpzOeSacl3pDv7Ha/ENy7DKzPE079RSVY95R7ffYFFHBu4H9UKGN+
	yZCBeNVvvu4OvQtU5jNGvKQjlkg/hn0I8uAREYv8dYdwaEz6Ghq39eeG6aYsDzkbIGyuRencC6I
	YelQo2ev7H4ywwinCUl6/sQa66YB9wN16uBQw8aMzCHsfxQGH34UtMA0lHvSat3i2R0Bdqpw92B
	SNd026cKNTNCgp7+tG4sBWoOl4PVkJEVEVLk5kKygvhsuCHfijC9CfnCY1Li1Z/NppaR/ESNsqr
	UQ9cmb+sgBDkEJOgIHP93DSS6L/k56pcApRSyXM/DpMyerlOvFSAQURPiiZeAPiWk7xC+bQ+xX5
	Eg9niBeX6JWUoNDs26ibcve2EMmoCcnVCr5WafbiQxHUUwLJeNycX+tyndYgmFB+vAGynK5mIYj
	IXmgQ+cySddW3D6l4lQ0iHFm1d17Q0cJyBpA==
X-Received: by 2002:a05:6000:1615:b0:48c:466e:9d08 with SMTP id
 ffacd0b85a97d-49c72e8536dmr4114770f8f.43.1794588856572; Fri, 13 Nov 2026
 08:54:16 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <b9bd6d147c0e40d4f3c2d8df1bbd8f8f11f2ed31.1794419436.git.fdmanana@suse.com>
 <70526c96c1d0dbcf1f251f3ca40a55ec902cfe6b.1794502890.git.fdmanana@suse.com>
 <CAPjX3FekA6cHKqOaR=EDPKo1qPKJ2JbozuZA9X54yehS74E9LA@mail.gmail.com> <CAL3q7H6vKzb=uy8SpH1xiga0F1ieJbMjMNTCqnZa2Jawy+TUYw@mail.gmail.com>
In-Reply-To: <CAL3q7H6vKzb=uy8SpH1xiga0F1ieJbMjMNTCqnZa2Jawy+TUYw@mail.gmail.com>
From: Daniel Vacek <neelx@suse.com>
Date: Fri, 13 Nov 2026 17:54:05 +0100
X-Gm-Features: AclHuK_pOWksV1ZZW5VI-s99028GCePCwRrjObYwEelBZx-U_o8WYE9DSqCHi94
Message-ID: <CAPjX3FfyK8vptm4B7RaYEWXQ_5XzTh-AKGe8ZgXLPj2u5Hk62w@mail.gmail.com>
Subject: Re: [PATCH v4] btrfs: fix RCU usage in btrfs_ioctl_dev_info()
To: Filipe Manana <fdmanana@kernel.org>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 13 Nov 2026 at 16:47, Filipe Manana <fdmanana@kernel.org> wrote:
> On Fri, Nov 13, 2026 at 2:29=E2=80=AFPM Daniel Vacek <neelx@suse.com> wro=
te:
> > On Thu, 12 Nov 2026 at 18:09, <fdmanana@kernel.org> wrote:
> > > From: Filipe Manana <fdmanana@suse.com>
> > >
> > > We are using a RCU read section but then we call btrfs_find_device() =
which
> > > iterates the device lists using a plain list_for_each_entry() and tha=
t is
> > > not safe it can result in loading uninitialized or torn pointers, lea=
ding
> > > to arbitrary memory dereferences, use-after-free conditions, and kern=
el
> > > panics.
> > >
> > > Update btrfs_find_device() to use list_for_each_entry_rcu().
> > > We also have manipulations of the devices and seed_list lists that ar=
e not
> > > RCU safe, in btrfs_init_dev_replace_tgtdev(), btrfs_rm_device(),
> > > btrfs_setup_sprout() and btrfs_rollback_sprout(), so update those pla=
ces
> > > to use proper RCU list manipulation variants.
> > >
> > > Link: https://sashiko.dev/#/bug/linux-96a9e36b-a712-491c-b210-91c8c4f=
6070f
> > > Fixes: c5593ca3c8a8 ("btrfs: switch to RCU for device traversal in bt=
rfs_ioctl_dev_info")
> > > Signed-off-by: Filipe Manana <fdmanana@suse.com>
> > > ---
> > >
> > > V4: Update stale changelog and fix a use-after-free on a device after
> > >     removing it (both identified by Sashiko).
> > >
> > > V3: Fix some more RCU related issues pointed by Sashiko.
> > >
> > > V2: Fix other existing RCU issues pointed by Sashiko.
> > >
> > >
> > >  fs/btrfs/dev-replace.c |  2 +-
> > >  fs/btrfs/ioctl.c       |  2 +-
> > >  fs/btrfs/volumes.c     | 93 +++++++++++++++++++++++++++++++---------=
--
> > >  fs/btrfs/volumes.h     |  2 +
> > >  4 files changed, 73 insertions(+), 26 deletions(-)
> > >
> > > diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
> > > index 3c48cc714fef..6f04d0a49d86 100644
> > > --- a/fs/btrfs/dev-replace.c
> > > +++ b/fs/btrfs/dev-replace.c
> > > @@ -319,7 +319,7 @@ static int btrfs_init_dev_replace_tgtdev(struct b=
trfs_fs_info *fs_info,
> > >                 goto error;
> > >
> > >         mutex_lock(&fs_devices->device_list_mutex);
> > > -       list_add(&device->dev_list, &fs_devices->devices);
> > > +       list_add_rcu(&device->dev_list, &fs_devices->devices);
> > >         fs_devices->num_devices++;
> > >         fs_devices->open_devices++;
> > >         mutex_unlock(&fs_devices->device_list_mutex);
> > > diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> > > index 651a780dd7b1..3fc30649d01a 100644
> > > --- a/fs/btrfs/ioctl.c
> > > +++ b/fs/btrfs/ioctl.c
> > > @@ -2791,7 +2791,7 @@ static long btrfs_ioctl_dev_info(const struct b=
trfs_fs_info *fs_info,
> > >                 args.uuid =3D di_args->uuid;
> > >
> > >         rcu_read_lock();
> > > -       dev =3D btrfs_find_device(fs_info->fs_devices, &args);
> > > +       dev =3D btrfs_find_device_rcu(fs_info->fs_devices, &args);
> > >         if (!dev) {
> > >                 ret =3D -ENODEV;
> > >                 goto out;
> > > diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> > > index a494c913ad12..b9504b637068 100644
> > > --- a/fs/btrfs/volumes.c
> > > +++ b/fs/btrfs/volumes.c
> > > @@ -2358,6 +2358,7 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_in=
fo,
> > >         struct btrfs_fs_devices *fs_devices =3D fs_info->fs_devices;
> > >         u64 num_devices;
> > >         int ret =3D 0;
> > > +       bool free_cur_devices =3D false;
> > >
> > >         if (btrfs_fs_incompat(fs_info, EXTENT_TREE_V2)) {
> > >                 btrfs_err(fs_info, "device remove not supported on ex=
tent tree v2 yet");
> > > @@ -2483,8 +2484,25 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_i=
nfo,
> > >
> > >         num_devices =3D btrfs_super_num_devices(fs_info->super_copy) =
- 1;
> > >         btrfs_set_super_num_devices(fs_info->super_copy, num_devices)=
;
> > > +
> > > +       /*
> > > +        * This can happen if cur_devices is the private seed devices=
 list.  We
> > > +        * cannot call close_fs_devices() here because it expects the=
 uuid_mutex
> > > +        * to be held, but in fact we don't need that for the private
> > > +        * seed_devices, we can simply decrement cur_devices->opened =
and then
> > > +        * remove it from our list and free the fs_devices.
> > > +        */
> > > +       if (cur_devices->num_devices =3D=3D 0) {
> > > +               list_del_rcu(&cur_devices->seed_list);
> > > +               ASSERT(cur_devices->opened =3D=3D 1, "opened=3D%d", c=
ur_devices->opened);
> > > +               cur_devices->opened--;
> > > +               free_cur_devices =3D true;
> > > +       }
> > > +
> > >         mutex_unlock(&fs_devices->device_list_mutex);
> > >
> > > +       *bdev_file =3D device->bdev_file;
> > > +
> > >         /*
> > >          * At this point, the device is zero sized and detached from =
the
> > >          * devices list.  All that's left is to zero out the old supe=
rs and
> > > @@ -2503,23 +2521,10 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_=
info,
> > >                 }
> > >         }
> > >
> > > -       *bdev_file =3D device->bdev_file;
> > >         synchronize_rcu();
> > >         btrfs_free_device(device);
> > > -
> > > -       /*
> > > -        * This can happen if cur_devices is the private seed devices=
 list.  We
> > > -        * cannot call close_fs_devices() here because it expects the=
 uuid_mutex
> > > -        * to be held, but in fact we don't need that for the private
> > > -        * seed_devices, we can simply decrement cur_devices->opened =
and then
> > > -        * remove it from our list and free the fs_devices.
> > > -        */
> > > -       if (cur_devices->num_devices =3D=3D 0) {
> > > -               list_del_init(&cur_devices->seed_list);
> > > -               ASSERT(cur_devices->opened =3D=3D 1, "opened=3D%d", c=
ur_devices->opened);
> > > -               cur_devices->opened--;
> > > +       if (free_cur_devices)
> > >                 free_fs_devices(cur_devices);
> > > -       }
> > >
> > >         return btrfs_commit_transaction(trans);
> > >
> > > @@ -2799,7 +2804,7 @@ static void btrfs_setup_sprout(struct btrfs_fs_=
info *fs_info,
> > >         fs_devices->open_devices =3D 0;
> > >         fs_devices->missing_devices =3D 0;
> > >         fs_devices->rotating =3D false;
> > > -       list_add(&seed_devices->seed_list, &fs_devices->seed_list);
> > > +       list_add_rcu(&seed_devices->seed_list, &fs_devices->seed_list=
);
> > >
> > >         generate_random_uuid(fs_devices->fsid);
> > >         memcpy(fs_devices->metadata_uuid, fs_devices->fsid, BTRFS_FSI=
D_SIZE);
> > > @@ -2821,11 +2826,15 @@ static void btrfs_rollback_sprout(struct btrf=
s_fs_info *fs_info,
> > >         lockdep_assert_held(&uuid_mutex);
> > >         lockdep_assert_held(&fs_devices->device_list_mutex);
> > >
> > > -       list_del_init(&seed_devices->seed_list);
> > > -       list_splice_init_rcu(&seed_devices->devices, &fs_devices->dev=
ices, synchronize_rcu);
> > > -       list_for_each_entry(device, &fs_devices->devices, dev_list) {
> > > +       list_del_rcu(&seed_devices->seed_list);
> > > +       /*
> > > +        * Before splicing seed_devices, update the fs_devices of eac=
h seed
> > > +        * device, otherwise a concurrent RCU reader could get a use-=
after-free
> > > +        * on device->fs_devices still pointing to seed_devices.
> > > +        */
> > > +       list_for_each_entry(device, &seed_devices->devices, dev_list)
> > >                 device->fs_devices =3D fs_devices;
> > > -       }
> > > +       list_splice_init_rcu(&seed_devices->devices, &fs_devices->dev=
ices, synchronize_rcu);
> > >
> > >         fs_devices->seeding =3D true;
> > >         fs_devices->num_devices =3D seed_devices->num_devices;
> > > @@ -7549,23 +7558,47 @@ static bool dev_args_match_device(const struc=
t btrfs_dev_lookup_args *args,
> > >   * If devid and uuid are both specified, the match must be exact, ot=
herwise
> > >   * only devid is used.
> > >   */
> > > -struct btrfs_device *btrfs_find_device(const struct btrfs_fs_devices=
 *fs_devices,
> > > -                                      const struct btrfs_dev_lookup_=
args *args)
> > > +static struct btrfs_device *btrfs_find_device_int(
> > > +                                 const struct btrfs_fs_devices *fs_d=
evices,
> > > +                                 const struct btrfs_dev_lookup_args =
*args,
> > > +                                 bool in_rcu)
> > >  {
> > >         struct btrfs_device *device;
> > >         struct btrfs_fs_devices *seed_devs;
> > > +       /* If !CONFIG_PROVE_RCU_LIST we get variable unused warning. =
*/
> > > +       bool rcu_cond __maybe_unused;
> > > +
> > > +       /*
> > > +        * We are called in several contextes, sometimes protected by=
 the
> > > +        * device_list_mutex, by being in an exclusive operation, in =
a context
> > > +        * where no concurrency can happen (so without any locking) o=
r while
> > > +        * under an RCU read section.
> > > +        */
> > > +       if (in_rcu) {
> > > +               /*
> > > +                * rcu_read_lock_held() always returns true when
> > > +                * CONFIG_DEBUG_LOCK_ALLOC is not enabled.
> > > +                */
> > > +               ASSERT(rcu_read_lock_held());
> > > +               rcu_cond =3D false;
> > > +       } else {
> > > +               rcu_cond =3D true;
> >
> > This is very wrong and dangerous! Hardwiring `true` is just bypassing
> > the protection.
> > This really needs to be
> >
> > rcu_cond =3D lock_is_held(&fs_devices->device_list_mutex) ||
> > lock_is_held(&uuid_mutex);
> >
> > as I suggested before. The API is designed so that you have to
> > annotate which locks protect the structure outside of RCU. And it's
> > also a good documentation by itself.
> >
> > Moreover this monster is not exactly nice. The one-liner I suggested
> > before looked much cleaner.
>
> I have told you before, and it's noted in the comments - those locks
> are not held in all contexts.

And that's fine. rcu_read_lock section passes by default. And when you
want to explicitly bypass the check, that's what the new parameter is
for.

Did you get my original suggestion? Does it miss anything? (Apart from
marking all the places where we really want to bypass the check? I
only showed one example)

> > --nX
> >
> > > +       }
> > >
> > >         if (dev_args_match_fs_devices(args, fs_devices)) {
> > > -               list_for_each_entry(device, &fs_devices->devices, dev=
_list) {
> > > +               list_for_each_entry_rcu(device, &fs_devices->devices,=
 dev_list,
> > > +                                       rcu_cond) {
> > >                         if (dev_args_match_device(args, device))
> > >                                 return device;
> > >                 }
> > >         }
> > >
> > > -       list_for_each_entry(seed_devs, &fs_devices->seed_list, seed_l=
ist) {
> > > +       list_for_each_entry_rcu(seed_devs, &fs_devices->seed_list, se=
ed_list,
> > > +                               rcu_cond) {
> > >                 if (!dev_args_match_fs_devices(args, seed_devs))
> > >                         continue;
> > > -               list_for_each_entry(device, &seed_devs->devices, dev_=
list) {
> > > +               list_for_each_entry_rcu(device, &seed_devs->devices, =
dev_list,
> > > +                                       rcu_cond) {
> > >                         if (dev_args_match_device(args, device))
> > >                                 return device;
> > >                 }
> > > @@ -7574,6 +7607,18 @@ struct btrfs_device *btrfs_find_device(const s=
truct btrfs_fs_devices *fs_devices
> > >         return NULL;
> > >  }
> > >
> > > +struct btrfs_device *btrfs_find_device(const struct btrfs_fs_devices=
 *fs_devices,
> > > +                                      const struct btrfs_dev_lookup_=
args *args)
> > > +{
> > > +       return btrfs_find_device_int(fs_devices, args, false);
> > > +}
> > > +
> > > +struct btrfs_device *btrfs_find_device_rcu(const struct btrfs_fs_dev=
ices *fs_devices,
> > > +                                          const struct btrfs_dev_loo=
kup_args *args)
> > > +{
> > > +       return btrfs_find_device_int(fs_devices, args, true);
> > > +}
> > > +
> > >  static struct btrfs_device *add_missing_dev(struct btrfs_fs_devices =
*fs_devices,
> > >                                             u64 devid, u8 *dev_uuid)
> > >  {
> > > diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> > > index 891bc2432870..2319789635a3 100644
> > > --- a/fs/btrfs/volumes.h
> > > +++ b/fs/btrfs/volumes.h
> > > @@ -773,6 +773,8 @@ int btrfs_grow_device(struct btrfs_trans_handle *=
trans,
> > >                       struct btrfs_device *device, u64 new_size);
> > >  struct btrfs_device *btrfs_find_device(const struct btrfs_fs_devices=
 *fs_devices,
> > >                                        const struct btrfs_dev_lookup_=
args *args);
> > > +struct btrfs_device *btrfs_find_device_rcu(const struct btrfs_fs_dev=
ices *fs_devices,
> > > +                                          const struct btrfs_dev_loo=
kup_args *args);
> > >  int btrfs_shrink_device(struct btrfs_device *device, u64 new_size);
> > >  int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char =
*path);
> > >  struct file *btrfs_open_device_deny_freeze(struct btrfs_fs_info *fs_=
info,
> > > --
> > > 2.53.0
> > >
> > >
