Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794476239;
	b=pJTqc4hFkPZ8kSIdd9mlBjm8PJ9mPrq0lF4BQimfAX39aeenVytKAOb7CXR6cdycnIpF
	 xebRog7LzrbVzg6XzZISulVhOGGa5tlhuQSJTpy3aiU+ZnxM73yusMjk4RVIje4LvrbLZ
	 b+uh/uT8L6bJtCZAxq0jhZ/pBeBPQQzslXgG42PITenoWQUB/d1yFFaLtNcoz7nY2Y3L1
	 2EuIxrtavMMYokW2ti5hMLuPki7ffh2Yg+U1aZMCiSsGUKjgg0pJwbOIR3FcXBBAOH+XN
	 c6TkYMlwIZwVGCJjl5nY2fhyxf/iU+t0J9VrsTWvLjUIoIlen7nlTYngIxY5DvtpjOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794476239;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=nScCAVDCBgz07lkE7TH4Ru+N9RgTfl+c6lJLsNYax0k=;
	b=TZA6ySBPAEaxWcwdUonGttCHMnmsQ+LTXwvNh1QzLLzPdMj3FIU7ZycmsKTEouhukjqc
	 Ro1UsBR4KJ/hctaHCcJ1lJo6T155bzqVTNTv6/J9WxloeD/emPDjL4sSQHJKjW5yef8MR
	 Q75EsqtRTlhBGRQMp1voFcWz5YqySXiu2ij0pNctSTdykxlKk0SM0s2mEpSdss6b41aXN
	 +7/RfBPgmWbrTgHllcicUqIR0bYEblyaZARfXK01waRqnJxWDCC2hb7t56Ib/yCYotzfN
	 twbNX9YG0SzeC56MvgMkaOmfitW54XucablxtEBimhMPapU51Nn4YzKv3OgOurzof6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B2Q8HVtK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E63B6606A331
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2026 09:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B2Q8HVtK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C1E31F00A06
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2026 09:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794476238;
	bh=nScCAVDCBgz07lkE7TH4Ru+N9RgTfl+c6lJLsNYax0k=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=B2Q8HVtKB4mJSJSy/5i9ADAlxmT7vqypjt43z2V+9zHTQe8Y8Ki5slzCax34KdL4K
	 3tyCDQESiHzVjH+PuPbDWgP+E8Syt6BgyHcSWpDS3BtzXnpS7NhR+6Ylyz8Bp8cyZ+
	 siIy73nnevIkxhAFK/guWBUrZp4qYvsw+E4J29m/l3xeYJwo43kaSKAd7Vctn1zeP2
	 YqNeCJwr18V3VLaabwHqAqpr5j3MnwSJenb05Pj9WTIVP4XUBaauFCREsAp39OODqc
	 vi/gh/XuQK0rn4xddB9ywrdr2oRJWG2LRWnc3XhokK1/nYKEedxuzoERMgCdRBUlr4
	 ZfYRaofF54LnA==
Received: by mail-ua1-f46.google.com with SMTP id a1e0cc1a2514c-97ca72f2cd9so2249936241.2
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2026 01:37:18 -0800 (PST)
X-Gm-Message-State: APuU4Z/n+yTeDqzotNAZuCM1esuH2c3jtUjcbdSjhaiul40hkE3YKblM
	cz7XzFfy1YDx5fXUMsuah8h13+gXfkr+c3Yf4unS0lWouRp6DoJGvyVXJIaRno7kZQwLNTkjkPb
	0hs/0/cCAb9GSV0D1bZbUuRFQbb17s5s=
X-Received: by 2002:a05:6102:2926:b0:7cf:61e8:c508 with SMTP id
 ada2fe7eead31-7d506178e59mr2072734137.21.1794476237557; Thu, 12 Nov 2026
 01:37:17 -0800 (PST)
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
 <7523a44da9b8504e6cbc65b9f5388c07a7aaa645.1794426971.git.fdmanana@suse.com> <CAPjX3Ffhw3z0xqNRWwxDQg3n0qnuGY+rzSZAHZBZyOrKMrgmqw@mail.gmail.com>
In-Reply-To: <CAPjX3Ffhw3z0xqNRWwxDQg3n0qnuGY+rzSZAHZBZyOrKMrgmqw@mail.gmail.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Thu, 12 Nov 2026 09:36:40 +0000
X-Gmail-Original-Message-ID: <CAL3q7H5GJKBstUa94dDQuURZsxq9ks8AhJsCiDkK-57=h1-WKw@mail.gmail.com>
X-Gm-Features: AclHuK-JArDJPsRHSakioXD4PdEjyGblNHXzmiwDqW1itJQdC-sMrFGuq1yvoio
Message-ID: <CAL3q7H5GJKBstUa94dDQuURZsxq9ks8AhJsCiDkK-57=h1-WKw@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: fix RCU usage in btrfs_ioctl_dev_info()
To: Daniel Vacek <neelx@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 12, 2026 at 7:42=E2=80=AFAM Daniel Vacek <neelx@suse.com> wrote=
:
>
> On Wed, 11 Nov 2026 at 21:08, <fdmanana@kernel.org> wrote:
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
> > We can't just update btrfs_find_device() to use list_for_each_entry_rcu=
()
> > instead, because all other callers are not in a RCU read section and th=
ey
> > ensure protection from concurrent list changes by either holding the
> > device_list_mutex, uuid_mutex, under an exclusive operation or simply
> > being called in a context where concurrency can not happen (like during
>
> I guess you missed that list_for_each_entry_rcu() has an api where you
> can provide an optional lockdep condition in case it's being used
> outside the rcu_read section. Using that there is no need to clone the
> function.

I'm aware of that argument. But things are not that simple.
If you pay closer attention to the changelog and comments, there are
cases where no lock is held at all, either because the operation is
exclusive or because the context lacks concurrency, such as during
mount.
And no, passing a boolean argument to btrfs_find_device() is not
prettier in any way.

Anyway there are existing RCU related problems in several functions
regarding the device lists that Sashiko pointed out, so some things
will have to change.

>
> I'd say something like this is the clean way to use it:
>
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -2313,7 +2313,7 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info,
>   if (ret)
>   return ret;
>
> - device =3D btrfs_find_device(fs_info->fs_devices, args);
> + device =3D btrfs_find_device_rcu(fs_info->fs_devices, args, true);
>   if (!device) {
>   if (args->missing)
>   ret =3D BTRFS_ERROR_DEV_MISSING_NOT_FOUND;
> @@ -7307,23 +7307,26 @@ static bool dev_args_match_device(const struct
> btrfs_dev_lookup_args *args,
>   * If devid and uuid are both specified, the match must be exact, otherw=
ise
>   * only devid is used.
>   */
> -struct btrfs_device *btrfs_find_device(const struct btrfs_fs_devices
> *fs_devices,
> -       const struct btrfs_dev_lookup_args *args)
> +struct btrfs_device *btrfs_find_device_rcu(const struct
> btrfs_fs_devices *fs_devices,
> +   const struct btrfs_dev_lookup_args *args,
> +   bool cond)
>  {
>   struct btrfs_device *device;
>   struct btrfs_fs_devices *seed_devs;
>
> + cond ||=3D lock_is_held(&fs_devices->device_list_mutex) ||
> lock_is_held(&uuid_mutex);
> +
>   if (dev_args_match_fs_devices(args, fs_devices)) {
> - list_for_each_entry(device, &fs_devices->devices, dev_list) {
> + list_for_each_entry_rcu(device, &fs_devices->devices, dev_list, cond) {
>   if (dev_args_match_device(args, device))
>   return device;
>   }
>   }
>
> - list_for_each_entry(seed_devs, &fs_devices->seed_list, seed_list) {
> + list_for_each_entry_rcu(seed_devs, &fs_devices->seed_list, seed_list, c=
ond) {
>   if (!dev_args_match_fs_devices(args, seed_devs))
>   continue;
> - list_for_each_entry(device, &seed_devs->devices, dev_list) {
> + list_for_each_entry_rcu(device, &seed_devs->devices, dev_list, cond) {
>   if (dev_args_match_device(args, device))
>   return device;
>   }
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index 0082c166af91..c2a7b76343e5 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -764,8 +764,13 @@ void __exit btrfs_cleanup_fs_uuids(void);
>  int btrfs_num_copies(struct btrfs_fs_info *fs_info, u64 logical, u64 len=
);
>  int btrfs_grow_device(struct btrfs_trans_handle *trans,
>        struct btrfs_device *device, u64 new_size);
> -struct btrfs_device *btrfs_find_device(const struct btrfs_fs_devices
> *fs_devices,
> -       const struct btrfs_dev_lookup_args *args);
> +struct btrfs_device *btrfs_find_device_rcu(const struct
> btrfs_fs_devices *fs_devices,
> +   const struct btrfs_dev_lookup_args *args,
> +   bool cond);
> +static inline struct btrfs_device *btrfs_find_device(const struct
> btrfs_fs_devices *fs_devices,
> +     const struct btrfs_dev_lookup_args *args) {
> + btrfs_find_device_rcu(fs_devices, args, false);
> +}
>  int btrfs_shrink_device(struct btrfs_device *device, u64 new_size);
>  int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *pat=
h);
>  int btrfs_balance(struct btrfs_fs_info *fs_info,
>
> Note, explicit btrfs_find_device_rcu() is only used here in the case
> where no concurency protection is needed. All the other users keep
> using btrfs_find_device() as before.
>
> And sorry about the broken formatting (Gmail).
>
> --nX
>
> > mount). So use a macro to generate both a RCU and a non-RCU variant of
> > the function and make btrfs_ioctl_dev_info() use the RCU variant. We al=
so
> > have manipulation of the devices and seed_list lists that is not RCU
> > safe, in btrfs_init_dev_replace_tgtdev(), btrfs_rm_device(),
> > btrfs_setup_sprout() and btrfs_rollback_sprout(), so update those place=
s
> > to use RCU list manipulation variants instead and take the uuid_mutex
> > in btrfs_rm_device() before deleting from the seed_list list as well as
> > synchronizing RCU after unlocking.
> >
> > Link: https://sashiko.dev/#/bug/linux-96a9e36b-a712-491c-b210-91c8c4f60=
70f
> > Fixes: c5593ca3c8a8 ("btrfs: switch to RCU for device traversal in btrf=
s_ioctl_dev_info")
> > Signed-off-by: Filipe Manana <fdmanana@suse.com>
> > ---
> >
> > V2: Fix other existing RCU issues pointed by Sashiko.
> >
> >  fs/btrfs/dev-replace.c |  2 +-
> >  fs/btrfs/ioctl.c       |  2 +-
> >  fs/btrfs/volumes.c     | 67 +++++++++++++++++++++++++++---------------
> >  fs/btrfs/volumes.h     |  2 ++
> >  4 files changed, 47 insertions(+), 26 deletions(-)
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
> > index a494c913ad12..89951666d5fa 100644
> > --- a/fs/btrfs/volumes.c
> > +++ b/fs/btrfs/volumes.c
> > @@ -2515,9 +2515,12 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_inf=
o,
> >          * remove it from our list and free the fs_devices.
> >          */
> >         if (cur_devices->num_devices =3D=3D 0) {
> > -               list_del_init(&cur_devices->seed_list);
> > +               mutex_lock(&uuid_mutex);
> > +               list_del_rcu(&cur_devices->seed_list);
> >                 ASSERT(cur_devices->opened =3D=3D 1, "opened=3D%d", cur=
_devices->opened);
> >                 cur_devices->opened--;
> > +               mutex_unlock(&uuid_mutex);
> > +               synchronize_rcu();
> >                 free_fs_devices(cur_devices);
> >         }
> >
> > @@ -2799,7 +2802,7 @@ static void btrfs_setup_sprout(struct btrfs_fs_in=
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
> > @@ -2821,7 +2824,7 @@ static void btrfs_rollback_sprout(struct btrfs_fs=
_info *fs_info,
> >         lockdep_assert_held(&uuid_mutex);
> >         lockdep_assert_held(&fs_devices->device_list_mutex);
> >
> > -       list_del_init(&seed_devices->seed_list);
> > +       list_del_rcu(&seed_devices->seed_list);
> >         list_splice_init_rcu(&seed_devices->devices, &fs_devices->devic=
es, synchronize_rcu);
> >         list_for_each_entry(device, &fs_devices->devices, dev_list) {
> >                 device->fs_devices =3D fs_devices;
> > @@ -7549,30 +7552,46 @@ static bool dev_args_match_device(const struct =
btrfs_dev_lookup_args *args,
> >   * If devid and uuid are both specified, the match must be exact, othe=
rwise
> >   * only devid is used.
> >   */
> > -struct btrfs_device *btrfs_find_device(const struct btrfs_fs_devices *=
fs_devices,
> > -                                      const struct btrfs_dev_lookup_ar=
gs *args)
> > -{
> > -       struct btrfs_device *device;
> > -       struct btrfs_fs_devices *seed_devs;
> > +#define BTRFS_GENERATE_FIND_DEVICE(func_name, iter_macro)             =
         \
> > +struct btrfs_device *func_name(const struct btrfs_fs_devices *fs_devic=
es,      \
> > +                              const struct btrfs_dev_lookup_args *args=
)        \
> > +{                                                                     =
         \
> > +       struct btrfs_device *device;                                   =
         \
> > +       struct btrfs_fs_devices *seed_devs;                            =
         \
> > +                                                                      =
         \
> > +       if (dev_args_match_fs_devices(args, fs_devices)) {             =
         \
> > +               iter_macro(device, &fs_devices->devices, dev_list) {   =
         \
> > +                       if (dev_args_match_device(args, device))       =
         \
> > +                               return device;                         =
         \
> > +               }                                                      =
         \
> > +       }                                                              =
         \
> > +                                                                      =
         \
> > +       iter_macro(seed_devs, &fs_devices->seed_list, seed_list) {     =
         \
> > +               if (!dev_args_match_fs_devices(args, seed_devs))       =
         \
> > +                       continue;                                      =
         \
> > +               iter_macro(device, &seed_devs->devices, dev_list) {    =
         \
> > +                       if (dev_args_match_device(args, device))       =
         \
> > +                               return device;                         =
         \
> > +               }                                                      =
         \
> > +       }                                                              =
         \
> > +                                                                      =
         \
> > +       return NULL;                                                   =
         \
> > +}
> >
> > -       if (dev_args_match_fs_devices(args, fs_devices)) {
> > -               list_for_each_entry(device, &fs_devices->devices, dev_l=
ist) {
> > -                       if (dev_args_match_device(args, device))
> > -                               return device;
> > -               }
> > -       }
> > +/*
> > + * Instantiate the non-RCU version.
> > + * Callers must hold device_list_mutex, or uuid_mutex, under an exclus=
ive
> > + * operation or be in a context where the lists can not be changed con=
currently.
> > + */
> > +BTRFS_GENERATE_FIND_DEVICE(btrfs_find_device, list_for_each_entry)
> >
> > -       list_for_each_entry(seed_devs, &fs_devices->seed_list, seed_lis=
t) {
> > -               if (!dev_args_match_fs_devices(args, seed_devs))
> > -                       continue;
> > -               list_for_each_entry(device, &seed_devs->devices, dev_li=
st) {
> > -                       if (dev_args_match_device(args, device))
> > -                               return device;
> > -               }
> > -       }
> > +/*
> > + * Instantiate the RCU version.
> > + * Callers must hold rcu_read_lock().
> > + */
> > +BTRFS_GENERATE_FIND_DEVICE(btrfs_find_device_rcu, list_for_each_entry_=
rcu)
> >
> > -       return NULL;
> > -}
> > +#undef BTRFS_GENERATE_FIND_DEVICE
> >
> >  static struct btrfs_device *add_missing_dev(struct btrfs_fs_devices *f=
s_devices,
> >                                             u64 devid, u8 *dev_uuid)
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
