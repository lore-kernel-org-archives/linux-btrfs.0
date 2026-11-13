Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794584878;
	b=1e9AMA6ScNmEhP3eR8TphRKDK6TwZ5m0yWI0ugixXvfaPJ/A6xyIU5xPFISVV/6K2JFV
	 Upt6F5sCxFwVPPl6eMyWIWtK4qR3fvjT0yT77W+E6gqK8W3RkrP3nFTs+GsdsNPzKGUYm
	 Gspc/gUaZN4XZlVXHwgGhgvc3TX7t6FdRsH3tgB+GbpnaPrBXH9poHGihgTTOr+aVGIWk
	 V4dVdJyKpflAh+ZW3pRP5r2D5KfZuVjXIk3SToDYtjjqP4QYlVtB0hKXIhP4anZ/3A5Ig
	 ApN5Saf2DFrGcGl33EnbF2S1jSRxO7K52YI5bQN7RZnC3hVDLPkd45oFI1pY1Td+P6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794584878;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=zu6FEcK7bX5wxklxAI3Oa42hW9p1e16iibuf8ppocaI=;
	b=BwsTgEgDos4cw6SygT4jr65F9CtsLgq8tVBzAtZlPGh8yHw59BW6RnqUQCi3IPQ4lzRB
	 qNdmjv5WV+0Bc+614kSKDA8+bI08onv6JwT9hwcU0L0S+tjUerCMxh8gCKR0Kb9iTMpsS
	 00maP4YlyTQmCg8+/GD+StMlgHRLREwHy/qEl7O9paY6HwbZAcMyh39bwF/ku1HRi8xB9
	 MhL7bp0wE628SKyKlSWGqR1Kr0hdmQ7Hk8yTOYuiknglx/u2jbDmMLYF/BCxJTkB3nxUg
	 1UM3Akt6osgI+NH1KyBrp/aEdg7VIdWC0awv7h/0HJuTPW6F2QxGxqL745ABUzeyXbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QWQ+pOIc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2120606A331
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 15:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QWQ+pOIc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B8D71F000C5
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 15:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794584878;
	bh=zu6FEcK7bX5wxklxAI3Oa42hW9p1e16iibuf8ppocaI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=QWQ+pOIcM/oMHzL/ISo58YTLI8GsrUXAmc11b/Ebzlthfy4uGFF+HXkyhiqV9C2y2
	 EX06b5qiMfhyI4BqeqtTEQChw0iUSj6kCuDyrJs79ZHPeyXdgojvuqK1oc+t9L67r3
	 e+VKd3kKoKZrN/UGzXaremeUreQoj2JqNsIDOrlwGp3fpVtRVZpDxw1O8hT8WXfRKR
	 qVEp+YXDUA1vDTgvqbbXH29MQdMrEHrfFHusdznOOzi1/LJAts/TzYyhRIM55DM6JE
	 apTDqZ50nkLqP7PjW40K8GSH1FPyrqk5UHBhmvUfIrpHDWZ9ohOIoerNb88+gDzyK0
	 rkXEB+3naoNVw==
Received: by mail-vs1-f41.google.com with SMTP id ada2fe7eead31-7777fa8f1ccso340283137.3
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 07:47:58 -0800 (PST)
X-Gm-Message-State: APuU4Z8aa+RwqubNgx6ryUxAn6ceOeAtdDDoOiCoLGkaERG8AKhE1/AB
	i7HIbAIUDndRdkfbvl0fI7IpG/6/0QRhZhWPN9LO9H8hA1rAfRt1SsjnLXcyU/Y/uTqog4iSA6c
	/zAdTdrWZbaRVvLxN6s0hSdX9B7VMMJo=
X-Received: by 2002:a67:e111:0:b0:7cc:2152:4f72 with SMTP id
 ada2fe7eead31-7d64d47dc72mr745750137.1.1794584877632; Fri, 13 Nov 2026
 07:47:57 -0800 (PST)
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
 <70526c96c1d0dbcf1f251f3ca40a55ec902cfe6b.1794502890.git.fdmanana@suse.com> <CAPjX3FekA6cHKqOaR=EDPKo1qPKJ2JbozuZA9X54yehS74E9LA@mail.gmail.com>
In-Reply-To: <CAPjX3FekA6cHKqOaR=EDPKo1qPKJ2JbozuZA9X54yehS74E9LA@mail.gmail.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Fri, 13 Nov 2026 15:47:20 +0000
X-Gmail-Original-Message-ID: <CAL3q7H6vKzb=uy8SpH1xiga0F1ieJbMjMNTCqnZa2Jawy+TUYw@mail.gmail.com>
X-Gm-Features: AclHuK9_y5Ykv8UDXMA3rDG2eiOIsxTzC88OcJ5Ni_WqWRF2hqfnMUKVfeTqBYY
Message-ID: <CAL3q7H6vKzb=uy8SpH1xiga0F1ieJbMjMNTCqnZa2Jawy+TUYw@mail.gmail.com>
Subject: Re: [PATCH v4] btrfs: fix RCU usage in btrfs_ioctl_dev_info()
To: Daniel Vacek <neelx@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 13, 2026 at 2:29=E2=80=AFPM Daniel Vacek <neelx@suse.com> wrote=
:
>
> On Thu, 12 Nov 2026 at 18:09, <fdmanana@kernel.org> wrote:
> > From: Filipe Manana <fdmanana@suse.com>
> >
> > We are using a RCU read section but then we call btrfs_find_device() wh=
ich
> > iterates the device lists using a plain list_for_each_entry() and that =
is
> > not safe it can result in loading uninitialized or torn pointers, leadi=
ng
> > to arbitrary memory dereferences, use-after-free conditions, and kernel
> > panics.
> >
> > Update btrfs_find_device() to use list_for_each_entry_rcu().
> > We also have manipulations of the devices and seed_list lists that are =
not
> > RCU safe, in btrfs_init_dev_replace_tgtdev(), btrfs_rm_device(),
> > btrfs_setup_sprout() and btrfs_rollback_sprout(), so update those place=
s
> > to use proper RCU list manipulation variants.
> >
> > Link: https://sashiko.dev/#/bug/linux-96a9e36b-a712-491c-b210-91c8c4f60=
70f
> > Fixes: c5593ca3c8a8 ("btrfs: switch to RCU for device traversal in btrf=
s_ioctl_dev_info")
> > Signed-off-by: Filipe Manana <fdmanana@suse.com>
> > ---
> >
> > V4: Update stale changelog and fix a use-after-free on a device after
> >     removing it (both identified by Sashiko).
> >
> > V3: Fix some more RCU related issues pointed by Sashiko.
> >
> > V2: Fix other existing RCU issues pointed by Sashiko.
> >
> >
> >  fs/btrfs/dev-replace.c |  2 +-
> >  fs/btrfs/ioctl.c       |  2 +-
> >  fs/btrfs/volumes.c     | 93 +++++++++++++++++++++++++++++++-----------
> >  fs/btrfs/volumes.h     |  2 +
> >  4 files changed, 73 insertions(+), 26 deletions(-)
> >
> > diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
> > index 3c48cc714fef..6f04d0a49d86 100644
> > --- a/fs/btrfs/dev-replace.c
> > +++ b/fs/btrfs/dev-replace.c
> > @@ -319,7 +319,7 @@ static int btrfs_init_dev_replace_tgtdev(struct btr=
fs_fs_info *fs_info,
> >                 goto error;
> >
> >         mutex_lock(&fs_devices->device_list_mutex);
> > -       list_add(&device->dev_list, &fs_devices->devices);
> > +       list_add_rcu(&device->dev_list, &fs_devices->devices);
> >         fs_devices->num_devices++;
> >         fs_devices->open_devices++;
> >         mutex_unlock(&fs_devices->device_list_mutex);
> > diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> > index 651a780dd7b1..3fc30649d01a 100644
> > --- a/fs/btrfs/ioctl.c
> > +++ b/fs/btrfs/ioctl.c
> > @@ -2791,7 +2791,7 @@ static long btrfs_ioctl_dev_info(const struct btr=
fs_fs_info *fs_info,
> >                 args.uuid =3D di_args->uuid;
> >
> >         rcu_read_lock();
> > -       dev =3D btrfs_find_device(fs_info->fs_devices, &args);
> > +       dev =3D btrfs_find_device_rcu(fs_info->fs_devices, &args);
> >         if (!dev) {
> >                 ret =3D -ENODEV;
> >                 goto out;
> > diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> > index a494c913ad12..b9504b637068 100644
> > --- a/fs/btrfs/volumes.c
> > +++ b/fs/btrfs/volumes.c
> > @@ -2358,6 +2358,7 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info=
,
> >         struct btrfs_fs_devices *fs_devices =3D fs_info->fs_devices;
> >         u64 num_devices;
> >         int ret =3D 0;
> > +       bool free_cur_devices =3D false;
> >
> >         if (btrfs_fs_incompat(fs_info, EXTENT_TREE_V2)) {
> >                 btrfs_err(fs_info, "device remove not supported on exte=
nt tree v2 yet");
> > @@ -2483,8 +2484,25 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_inf=
o,
> >
> >         num_devices =3D btrfs_super_num_devices(fs_info->super_copy) - =
1;
> >         btrfs_set_super_num_devices(fs_info->super_copy, num_devices);
> > +
> > +       /*
> > +        * This can happen if cur_devices is the private seed devices l=
ist.  We
> > +        * cannot call close_fs_devices() here because it expects the u=
uid_mutex
> > +        * to be held, but in fact we don't need that for the private
> > +        * seed_devices, we can simply decrement cur_devices->opened an=
d then
> > +        * remove it from our list and free the fs_devices.
> > +        */
> > +       if (cur_devices->num_devices =3D=3D 0) {
> > +               list_del_rcu(&cur_devices->seed_list);
> > +               ASSERT(cur_devices->opened =3D=3D 1, "opened=3D%d", cur=
_devices->opened);
> > +               cur_devices->opened--;
> > +               free_cur_devices =3D true;
> > +       }
> > +
> >         mutex_unlock(&fs_devices->device_list_mutex);
> >
> > +       *bdev_file =3D device->bdev_file;
> > +
> >         /*
> >          * At this point, the device is zero sized and detached from th=
e
> >          * devices list.  All that's left is to zero out the old supers=
 and
> > @@ -2503,23 +2521,10 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_in=
fo,
> >                 }
> >         }
> >
> > -       *bdev_file =3D device->bdev_file;
> >         synchronize_rcu();
> >         btrfs_free_device(device);
> > -
> > -       /*
> > -        * This can happen if cur_devices is the private seed devices l=
ist.  We
> > -        * cannot call close_fs_devices() here because it expects the u=
uid_mutex
> > -        * to be held, but in fact we don't need that for the private
> > -        * seed_devices, we can simply decrement cur_devices->opened an=
d then
> > -        * remove it from our list and free the fs_devices.
> > -        */
> > -       if (cur_devices->num_devices =3D=3D 0) {
> > -               list_del_init(&cur_devices->seed_list);
> > -               ASSERT(cur_devices->opened =3D=3D 1, "opened=3D%d", cur=
_devices->opened);
> > -               cur_devices->opened--;
> > +       if (free_cur_devices)
> >                 free_fs_devices(cur_devices);
> > -       }
> >
> >         return btrfs_commit_transaction(trans);
> >
> > @@ -2799,7 +2804,7 @@ static void btrfs_setup_sprout(struct btrfs_fs_in=
fo *fs_info,
> >         fs_devices->open_devices =3D 0;
> >         fs_devices->missing_devices =3D 0;
> >         fs_devices->rotating =3D false;
> > -       list_add(&seed_devices->seed_list, &fs_devices->seed_list);
> > +       list_add_rcu(&seed_devices->seed_list, &fs_devices->seed_list);
> >
> >         generate_random_uuid(fs_devices->fsid);
> >         memcpy(fs_devices->metadata_uuid, fs_devices->fsid, BTRFS_FSID_=
SIZE);
> > @@ -2821,11 +2826,15 @@ static void btrfs_rollback_sprout(struct btrfs_=
fs_info *fs_info,
> >         lockdep_assert_held(&uuid_mutex);
> >         lockdep_assert_held(&fs_devices->device_list_mutex);
> >
> > -       list_del_init(&seed_devices->seed_list);
> > -       list_splice_init_rcu(&seed_devices->devices, &fs_devices->devic=
es, synchronize_rcu);
> > -       list_for_each_entry(device, &fs_devices->devices, dev_list) {
> > +       list_del_rcu(&seed_devices->seed_list);
> > +       /*
> > +        * Before splicing seed_devices, update the fs_devices of each =
seed
> > +        * device, otherwise a concurrent RCU reader could get a use-af=
ter-free
> > +        * on device->fs_devices still pointing to seed_devices.
> > +        */
> > +       list_for_each_entry(device, &seed_devices->devices, dev_list)
> >                 device->fs_devices =3D fs_devices;
> > -       }
> > +       list_splice_init_rcu(&seed_devices->devices, &fs_devices->devic=
es, synchronize_rcu);
> >
> >         fs_devices->seeding =3D true;
> >         fs_devices->num_devices =3D seed_devices->num_devices;
> > @@ -7549,23 +7558,47 @@ static bool dev_args_match_device(const struct =
btrfs_dev_lookup_args *args,
> >   * If devid and uuid are both specified, the match must be exact, othe=
rwise
> >   * only devid is used.
> >   */
> > -struct btrfs_device *btrfs_find_device(const struct btrfs_fs_devices *=
fs_devices,
> > -                                      const struct btrfs_dev_lookup_ar=
gs *args)
> > +static struct btrfs_device *btrfs_find_device_int(
> > +                                 const struct btrfs_fs_devices *fs_dev=
ices,
> > +                                 const struct btrfs_dev_lookup_args *a=
rgs,
> > +                                 bool in_rcu)
> >  {
> >         struct btrfs_device *device;
> >         struct btrfs_fs_devices *seed_devs;
> > +       /* If !CONFIG_PROVE_RCU_LIST we get variable unused warning. */
> > +       bool rcu_cond __maybe_unused;
> > +
> > +       /*
> > +        * We are called in several contextes, sometimes protected by t=
he
> > +        * device_list_mutex, by being in an exclusive operation, in a =
context
> > +        * where no concurrency can happen (so without any locking) or =
while
> > +        * under an RCU read section.
> > +        */
> > +       if (in_rcu) {
> > +               /*
> > +                * rcu_read_lock_held() always returns true when
> > +                * CONFIG_DEBUG_LOCK_ALLOC is not enabled.
> > +                */
> > +               ASSERT(rcu_read_lock_held());
> > +               rcu_cond =3D false;
> > +       } else {
> > +               rcu_cond =3D true;
>
> This is very wrong and dangerous! Hardwiring `true` is just bypassing
> the protection.
> This really needs to be
>
> rcu_cond =3D lock_is_held(&fs_devices->device_list_mutex) ||
> lock_is_held(&uuid_mutex);
>
> as I suggested before. The API is designed so that you have to
> annotate which locks protect the structure outside of RCU. And it's
> also a good documentation by itself.
>
> Moreover this monster is not exactly nice. The one-liner I suggested
> before looked much cleaner.

I have told you before, and it's noted in the comments - those locks
are not held in all contexts.


>
> --nX
>
> > +       }
> >
> >         if (dev_args_match_fs_devices(args, fs_devices)) {
> > -               list_for_each_entry(device, &fs_devices->devices, dev_l=
ist) {
> > +               list_for_each_entry_rcu(device, &fs_devices->devices, d=
ev_list,
> > +                                       rcu_cond) {
> >                         if (dev_args_match_device(args, device))
> >                                 return device;
> >                 }
> >         }
> >
> > -       list_for_each_entry(seed_devs, &fs_devices->seed_list, seed_lis=
t) {
> > +       list_for_each_entry_rcu(seed_devs, &fs_devices->seed_list, seed=
_list,
> > +                               rcu_cond) {
> >                 if (!dev_args_match_fs_devices(args, seed_devs))
> >                         continue;
> > -               list_for_each_entry(device, &seed_devs->devices, dev_li=
st) {
> > +               list_for_each_entry_rcu(device, &seed_devs->devices, de=
v_list,
> > +                                       rcu_cond) {
> >                         if (dev_args_match_device(args, device))
> >                                 return device;
> >                 }
> > @@ -7574,6 +7607,18 @@ struct btrfs_device *btrfs_find_device(const str=
uct btrfs_fs_devices *fs_devices
> >         return NULL;
> >  }
> >
> > +struct btrfs_device *btrfs_find_device(const struct btrfs_fs_devices *=
fs_devices,
> > +                                      const struct btrfs_dev_lookup_ar=
gs *args)
> > +{
> > +       return btrfs_find_device_int(fs_devices, args, false);
> > +}
> > +
> > +struct btrfs_device *btrfs_find_device_rcu(const struct btrfs_fs_devic=
es *fs_devices,
> > +                                          const struct btrfs_dev_looku=
p_args *args)
> > +{
> > +       return btrfs_find_device_int(fs_devices, args, true);
> > +}
> > +
> >  static struct btrfs_device *add_missing_dev(struct btrfs_fs_devices *f=
s_devices,
> >                                             u64 devid, u8 *dev_uuid)
> >  {
> > diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> > index 891bc2432870..2319789635a3 100644
> > --- a/fs/btrfs/volumes.h
> > +++ b/fs/btrfs/volumes.h
> > @@ -773,6 +773,8 @@ int btrfs_grow_device(struct btrfs_trans_handle *tr=
ans,
> >                       struct btrfs_device *device, u64 new_size);
> >  struct btrfs_device *btrfs_find_device(const struct btrfs_fs_devices *=
fs_devices,
> >                                        const struct btrfs_dev_lookup_ar=
gs *args);
> > +struct btrfs_device *btrfs_find_device_rcu(const struct btrfs_fs_devic=
es *fs_devices,
> > +                                          const struct btrfs_dev_looku=
p_args *args);
> >  int btrfs_shrink_device(struct btrfs_device *device, u64 new_size);
> >  int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *p=
ath);
> >  struct file *btrfs_open_device_deny_freeze(struct btrfs_fs_info *fs_in=
fo,
> > --
> > 2.53.0
> >
> >
