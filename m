Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794492036;
	b=35/FKicHCZ27OIAUjT5KxltRG1YRBKxJHRG2phQXADKxWpBEblIE0QytRkKGP29dDgV3
	 H05lSttUddTE9CsJtxXavFSPUXdmIpLjIK26uqAbUnEQsVX5OVpovCjeDr7z8sY3duR5h
	 6/kxf/LYNfBxVzI/zCU17YwsY4TM+7d13bPFMXxTZlUUYENlwnpoGCUSap4lNjvM3rIPb
	 vFI40FN3cqwbqcj8h8M+eMkWEMBBNYU294Lhz/RkxiFhMVX8boxQx5aNQepZPXOc/Mo05
	 Pgujj8xPvMvRqJTJ2w/06u0kECk272DKxpThVh5VKKV+lnV7e66fnLtIWsyRho9MZGA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794492036;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=DgUldzMrmK7itL4YbsqZadYyFLv/tnNpmty/G2tqkXA=;
	b=JKzWxoqiT5hUps16zWfY6j64lhPr5lhNNQuSUv0d0NorfCuVJTvuWNHbhrMIQ85sxEkh
	 RO/WC1Oi2DnYY77qpjPqj2Hln5MtyKgX8mvD6WwZZezoQLQOOYovN/yGueDvJs02ttnvs
	 KTPhIc4LoBLMGYwcYvAq3n+xnBNHCdWSxjGAza2dCePQEFXWB4wkigoSE8ZNgOMq9O5M/
	 haSRUnir9zKWj7vCDrtVGcYbhhks2QzFa4duIaJrFuy6RUN0DWpJA9r2nc58FtkEQhxnr
	 6Sk/tl0bINQc00tmVMxwL+TKplOyPSgO7wvHBDk4jPRYW3Dt8NPVFsJDwfdoHOEdtdw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=MxEelXsi;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.42
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B78606A88D
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2026 14:00:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 17B78606A88D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=MxEelXsi
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a59100fa83so38211845e9.0
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2026 06:00:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794492034; cv=none;
        d=google.com; s=arc-20260327;
        b=cA8n8wdzBdCM/RjnNWMQ0SVe9DFP689kkHj2TCZyYz36qWQlGCF65mYGNPtdlnjibf
         KQLjMlBKmt9+Y+NosNQZbOPHk+z60lSscgCFjJtOKHbKX/mTxcxd60wTp3uJsvrUypSx
         4StSAyMIh9Dk0BKBH3tnamS9yQZP0fT1U0qr2yr5vn6rtA1ApGn94ag0297ZI0fzkpCb
         tQHL3cRx50bxczYQTkIikp472GjOaNBhTs/CkUIhg14qzmAQkvUCuV6LPygOGjoWyCP0
         APU/dZLR/G/+xusPgV1TtifdaNeC5n2V0Jlb7oNx70/qMJxMa3BqrLheDstI2IX1OWHT
         Rmsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DgUldzMrmK7itL4YbsqZadYyFLv/tnNpmty/G2tqkXA=;
        fh=v5SypDb7dwdS4FGwcK5CeDhaQb47iUab0gtYlsnNpvI=;
        b=VK7SRt1IknR1B9inAgXF6+PhqTtxDREO5Z7lemnK+7aGpf3PB5GmYDbxvkm/Jn8Kzd
         iy6TRIbX+QBBWsWbpHI141qJmRZ9NWnHzvwI6wiu/cdwwz9cBtIhr2K2Cn7cdNLrcV34
         JliX/ulqnKMSNhI8sWgfRA0pJqfc1bgWhdQE8GvnWpfgMw5hRBzB3FRrGUPqASRksTwL
         5au+GMe37xDPMa7Mn9cIstkIOflCDhu2ZDvAutWakwVrW7SU9Sas4LN6YR93DtdiuoS+
         whdVtNwanP8jTAs9QGZvV5lGPQLYj5DHT4WMIzomc/HdUYVIhE1VdARKq3/Cu9lReS5w
         ZeNg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1794492034; x=1795096834; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DgUldzMrmK7itL4YbsqZadYyFLv/tnNpmty/G2tqkXA=;
        b=MxEelXsiK3Utv10qc3HBC1NsML2I0BZamxu8yL6DeCtuGBp2wCBD71MGS87U8jpAd2
         oKY/oYsAMAPgD0TS8KrUq2B8tZL+UhYDVijGoFLn3I/cqCwvb1LrnF/qyjBci7hpxQM9
         AlpofjT+wBfNmhHQWFV2BkFC7dtw7yhSabywNRCkEBciFXPICS5tX7GDRGKqkYZlBrdJ
         vQjQC8LaJvZ2gnCRgWfGRQw4pdvfpLaz8Y70KXuDj4pgOSc687Rho4sc7APISH5/P+HJ
         tshP4YskGvd8hACAk49uQ4YXp0UdDsB6rDXJX95bpT4P+pdZXzQyOwojt1ZENjF3hTn9
         AKsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794492034; x=1795096834;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DgUldzMrmK7itL4YbsqZadYyFLv/tnNpmty/G2tqkXA=;
        b=FrhRGekymlknwKxk/lqMXYZRope374zj2L1nQDcTM81Np8PVLn/v9uLP3NeI+LB1mt
         l/t2MHFwpB1Hr/oLdyPvjg4sQQgO3gbrzExL/H5cXiFxoZJzqejlZeItoE9lA+hZ9geA
         XgmnCW5YfqKP6Cf6ClQW5uwhAvBj2aduD49e/Y7mkYsEGPgf+Ot6OqEKtR5K/0FRu/fa
         I30YdcjnCVq5PErK8fQOXs4GHmMhtPt2dhHPeaKLMZT20nmDBDbo+pIoJ1GvwA6m2Qno
         liXH3HVlfr5WkKVzECBkwHOkwkSA64P7vUZrk0RkhHYcPt7GmeobQpz+VK8Jr9Wi4ThT
         Ll6A==
X-Gm-Message-State: APuU4Z86eaSS9muNd69+6juejJqJXSCXGYnQ5Z9d5UmLUC9d7mnN+NMj
	n+CelgragAG1ESa51CaAlt99lP3I2L++jX/8Jjkfz/DWLQ6Cnnap6HqpLsFhFqS3q8ezWQHyE8g
	sFC+2RCAqywRdaHSunypx/w4J8Nl7M1PCPEYTDa9yfQaq6Rjurq8driuoMw==
X-Gm-Gg: AYBFou0P44XYcjVkfSYL3hOgA81jiNhmA+u2U8aOjs9mZlJ+MnASf3rmWjQD61sh4tz
	gMA+EWoK4XkJLV3IEiQYVHzlzpECfVR2pPHEcwOE+EApztO1n7jDco/4vD8i/jj7xvZl9fUgglt
	4Ww3m5nBH3gtwjFskT8FOcQiWt9oscsKLdZcyAln7VapzdvFSI6NbUAEOYgr6gzmxbqbMDc67yg
	gb/uZH+CodLWKgZ+rWW8rFVWdXk3vyxuLIWZfvbcsj1cpGFZf4NX1zn2qiwdcBrzT6MOTLieV+/
	zAmtUfJehCc3wWqrTYlXF/xEbYyapkg3sG3QDuB4WUiBXLLhIZ8XL7v+qDmx2FG2Bjkz2pEFMl0
	HrL0JJs2KNJa70PItE02rEVhuekZ/PU+TVxuw8AvsbYlQzuhZAqqbaAgcVNMq/OCLNbvudNKmC1
	alNX45WR+1KAm5P48l63JqiKXEz4N8099NCg==
X-Received: by 2002:a05:600c:5488:b0:4a2:e0c:2b0a with SMTP id
 5b1f17b1804b1-4ba09376ebdmr109524925e9.16.1794492033587; Thu, 12 Nov 2026
 06:00:33 -0800 (PST)
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
 <7523a44da9b8504e6cbc65b9f5388c07a7aaa645.1794426971.git.fdmanana@suse.com>
 <CAPjX3Ffhw3z0xqNRWwxDQg3n0qnuGY+rzSZAHZBZyOrKMrgmqw@mail.gmail.com> <CAL3q7H5GJKBstUa94dDQuURZsxq9ks8AhJsCiDkK-57=h1-WKw@mail.gmail.com>
In-Reply-To: <CAL3q7H5GJKBstUa94dDQuURZsxq9ks8AhJsCiDkK-57=h1-WKw@mail.gmail.com>
From: Daniel Vacek <neelx@suse.com>
Date: Thu, 12 Nov 2026 15:00:21 +0100
X-Gm-Features: AclHuK8KnCOxzbMdTMg9SiDDegA77oYPdg1QK2PVqyo7swCf7j28FswqgG08gcM
Message-ID: <CAPjX3Ff7PYFd9Gbfe+2=RXrVYhv7QP1CfcWW__CbdvAFmui+4g@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: fix RCU usage in btrfs_ioctl_dev_info()
To: Filipe Manana <fdmanana@kernel.org>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 12 Nov 2026 at 10:37, Filipe Manana <fdmanana@kernel.org> wrote:
> On Thu, Nov 12, 2026 at 7:42=E2=80=AFAM Daniel Vacek <neelx@suse.com> wro=
te:
> > On Wed, 11 Nov 2026 at 21:08, <fdmanana@kernel.org> wrote:
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
> > > We can't just update btrfs_find_device() to use list_for_each_entry_r=
cu()
> > > instead, because all other callers are not in a RCU read section and =
they
> > > ensure protection from concurrent list changes by either holding the
> > > device_list_mutex, uuid_mutex, under an exclusive operation or simply
> > > being called in a context where concurrency can not happen (like duri=
ng
> >
> > I guess you missed that list_for_each_entry_rcu() has an api where you
> > can provide an optional lockdep condition in case it's being used
> > outside the rcu_read section. Using that there is no need to clone the
> > function.
>
> I'm aware of that argument. But things are not that simple.
> If you pay closer attention to the changelog and comments, there are
> cases where no lock is held at all, either because the operation is
> exclusive or because the context lacks concurrency, such as during
> mount.

That is exactly what the lockdep argument is for. And it's precisely
why I added it to btrfs_find_device() as well.

> And no, passing a boolean argument to btrfs_find_device() is not
> prettier in any way.

Ain't it? Well, I was thinking about another helper for that but then
I forgot to implement it before sending the email. Please, see below.

> Anyway there are existing RCU related problems in several functions
> regarding the device lists that Sashiko pointed out, so some things
> will have to change.

Definitely the rest of the patch is a solid bugfix and needs to stay.
No questions there.

> >
> > I'd say something like this is the clean way to use it:
> >
> > --- a/fs/btrfs/volumes.c
> > +++ b/fs/btrfs/volumes.c
> > @@ -2313,7 +2313,7 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info=
,
> >   if (ret)
> >   return ret;
> >
> > - device =3D btrfs_find_device(fs_info->fs_devices, args);
> > + device =3D btrfs_find_device_rcu(fs_info->fs_devices, args, true);

- device =3D btrfs_find_device(fs_info->fs_devices, args);
+ device =3D btrfs_find_device_nolockdep(fs_info->fs_devices, args);

This is for one example. There may be more. I was not looking for all
of them. This was meant to be just a hint, not a complete solution.

Those callers which don't need any protection should switch to
_nolockdep(), the rest stays as they were. The change in the header
file adds the lockdep annotation for free.

> >   if (!device) {
> >   if (args->missing)
> >   ret =3D BTRFS_ERROR_DEV_MISSING_NOT_FOUND;
> > @@ -7307,23 +7307,26 @@ static bool dev_args_match_device(const struct
> > btrfs_dev_lookup_args *args,
> >   * If devid and uuid are both specified, the match must be exact, othe=
rwise
> >   * only devid is used.
> >   */
> > -struct btrfs_device *btrfs_find_device(const struct btrfs_fs_devices
> > *fs_devices,
> > -       const struct btrfs_dev_lookup_args *args)
> > +struct btrfs_device *btrfs_find_device_rcu(const struct
> > btrfs_fs_devices *fs_devices,
> > +   const struct btrfs_dev_lookup_args *args,
> > +   bool cond)
> >  {
> >   struct btrfs_device *device;
> >   struct btrfs_fs_devices *seed_devs;
> >
> > + cond ||=3D lock_is_held(&fs_devices->device_list_mutex) || lock_is_he=
ld(&uuid_mutex);
> > +
> >   if (dev_args_match_fs_devices(args, fs_devices)) {
> > - list_for_each_entry(device, &fs_devices->devices, dev_list) {
> > + list_for_each_entry_rcu(device, &fs_devices->devices, dev_list, cond)=
 {
> >   if (dev_args_match_device(args, device))
> >   return device;
> >   }
> >   }
> >
> > - list_for_each_entry(seed_devs, &fs_devices->seed_list, seed_list) {
> > + list_for_each_entry_rcu(seed_devs, &fs_devices->seed_list, seed_list,=
 cond) {
> >   if (!dev_args_match_fs_devices(args, seed_devs))
> >   continue;
> > - list_for_each_entry(device, &seed_devs->devices, dev_list) {
> > + list_for_each_entry_rcu(device, &seed_devs->devices, dev_list, cond) =
{
> >   if (dev_args_match_device(args, device))
> >   return device;
> >   }
> > diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> > index 0082c166af91..c2a7b76343e5 100644
> > --- a/fs/btrfs/volumes.h
> > +++ b/fs/btrfs/volumes.h
> > @@ -764,8 +764,13 @@ void __exit btrfs_cleanup_fs_uuids(void);
> >  int btrfs_num_copies(struct btrfs_fs_info *fs_info, u64 logical, u64 l=
en);
> >  int btrfs_grow_device(struct btrfs_trans_handle *trans,
> >        struct btrfs_device *device, u64 new_size);
> > -struct btrfs_device *btrfs_find_device(const struct btrfs_fs_devices
> > *fs_devices,
> > -       const struct btrfs_dev_lookup_args *args);
> > +struct btrfs_device *btrfs_find_device_rcu(const struct btrfs_fs_devic=
es *fs_devices,
> > +   const struct btrfs_dev_lookup_args *args,
> > +   bool cond);
> > +static inline struct btrfs_device *btrfs_find_device(const struct btrf=
s_fs_devices *fs_devices,
> > +     const struct btrfs_dev_lookup_args *args) {
> > + btrfs_find_device_rcu(fs_devices, args, false);
> > +}

+static inline struct btrfs_device *btrfs_find_device_nolockdep(const
struct btrfs_fs_devices *fs_devices,
+     const struct btrfs_dev_lookup_args *args) {
+ btrfs_find_device_rcu(fs_devices, args, true);
+}

And on top of that, perhaps I'd do
s/btrfs_find_device_rcu/__btrfs_find_device/. Or not, it's not a big
deal.

--nX

> >  int btrfs_shrink_device(struct btrfs_device *device, u64 new_size);
> >  int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *p=
ath);
> >  int btrfs_balance(struct btrfs_fs_info *fs_info,
> >
> > Note, explicit btrfs_find_device_rcu() is only used here in the case
> > where no concurency protection is needed. All the other users keep
> > using btrfs_find_device() as before.
> >
> > And sorry about the broken formatting (Gmail).
> >
> > --nX
> >
> > > mount). So use a macro to generate both a RCU and a non-RCU variant o=
f
> > > the function and make btrfs_ioctl_dev_info() use the RCU variant. We =
also
> > > have manipulation of the devices and seed_list lists that is not RCU
> > > safe, in btrfs_init_dev_replace_tgtdev(), btrfs_rm_device(),
> > > btrfs_setup_sprout() and btrfs_rollback_sprout(), so update those pla=
ces
> > > to use RCU list manipulation variants instead and take the uuid_mutex
> > > in btrfs_rm_device() before deleting from the seed_list list as well =
as
> > > synchronizing RCU after unlocking.
> > >
> > > Link: https://sashiko.dev/#/bug/linux-96a9e36b-a712-491c-b210-91c8c4f=
6070f
> > > Fixes: c5593ca3c8a8 ("btrfs: switch to RCU for device traversal in bt=
rfs_ioctl_dev_info")
> > > Signed-off-by: Filipe Manana <fdmanana@suse.com>
> > > ---
> > >
> > > V2: Fix other existing RCU issues pointed by Sashiko.
> > >
> > >  fs/btrfs/dev-replace.c |  2 +-
> > >  fs/btrfs/ioctl.c       |  2 +-
> > >  fs/btrfs/volumes.c     | 67 +++++++++++++++++++++++++++-------------=
--
> > >  fs/btrfs/volumes.h     |  2 ++
> > >  4 files changed, 47 insertions(+), 26 deletions(-)
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
> > > index a494c913ad12..89951666d5fa 100644
> > > --- a/fs/btrfs/volumes.c
> > > +++ b/fs/btrfs/volumes.c
> > > @@ -2515,9 +2515,12 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_i=
nfo,
> > >          * remove it from our list and free the fs_devices.
> > >          */
> > >         if (cur_devices->num_devices =3D=3D 0) {
> > > -               list_del_init(&cur_devices->seed_list);
> > > +               mutex_lock(&uuid_mutex);
> > > +               list_del_rcu(&cur_devices->seed_list);
> > >                 ASSERT(cur_devices->opened =3D=3D 1, "opened=3D%d", c=
ur_devices->opened);
> > >                 cur_devices->opened--;
> > > +               mutex_unlock(&uuid_mutex);
> > > +               synchronize_rcu();
> > >                 free_fs_devices(cur_devices);
> > >         }
> > >
> > > @@ -2799,7 +2802,7 @@ static void btrfs_setup_sprout(struct btrfs_fs_=
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
> > > @@ -2821,7 +2824,7 @@ static void btrfs_rollback_sprout(struct btrfs_=
fs_info *fs_info,
> > >         lockdep_assert_held(&uuid_mutex);
> > >         lockdep_assert_held(&fs_devices->device_list_mutex);
> > >
> > > -       list_del_init(&seed_devices->seed_list);
> > > +       list_del_rcu(&seed_devices->seed_list);
> > >         list_splice_init_rcu(&seed_devices->devices, &fs_devices->dev=
ices, synchronize_rcu);
> > >         list_for_each_entry(device, &fs_devices->devices, dev_list) {
> > >                 device->fs_devices =3D fs_devices;
> > > @@ -7549,30 +7552,46 @@ static bool dev_args_match_device(const struc=
t btrfs_dev_lookup_args *args,
> > >   * If devid and uuid are both specified, the match must be exact, ot=
herwise
> > >   * only devid is used.
> > >   */
> > > -struct btrfs_device *btrfs_find_device(const struct btrfs_fs_devices=
 *fs_devices,
> > > -                                      const struct btrfs_dev_lookup_=
args *args)
> > > -{
> > > -       struct btrfs_device *device;
> > > -       struct btrfs_fs_devices *seed_devs;
> > > +#define BTRFS_GENERATE_FIND_DEVICE(func_name, iter_macro)           =
           \
> > > +struct btrfs_device *func_name(const struct btrfs_fs_devices *fs_dev=
ices,      \
> > > +                              const struct btrfs_dev_lookup_args *ar=
gs)        \
> > > +{                                                                   =
           \
> > > +       struct btrfs_device *device;                                 =
           \
> > > +       struct btrfs_fs_devices *seed_devs;                          =
           \
> > > +                                                                    =
           \
> > > +       if (dev_args_match_fs_devices(args, fs_devices)) {           =
           \
> > > +               iter_macro(device, &fs_devices->devices, dev_list) { =
           \
> > > +                       if (dev_args_match_device(args, device))     =
           \
> > > +                               return device;                       =
           \
> > > +               }                                                    =
           \
> > > +       }                                                            =
           \
> > > +                                                                    =
           \
> > > +       iter_macro(seed_devs, &fs_devices->seed_list, seed_list) {   =
           \
> > > +               if (!dev_args_match_fs_devices(args, seed_devs))     =
           \
> > > +                       continue;                                    =
           \
> > > +               iter_macro(device, &seed_devs->devices, dev_list) {  =
           \
> > > +                       if (dev_args_match_device(args, device))     =
           \
> > > +                               return device;                       =
           \
> > > +               }                                                    =
           \
> > > +       }                                                            =
           \
> > > +                                                                    =
           \
> > > +       return NULL;                                                 =
           \
> > > +}
> > >
> > > -       if (dev_args_match_fs_devices(args, fs_devices)) {
> > > -               list_for_each_entry(device, &fs_devices->devices, dev=
_list) {
> > > -                       if (dev_args_match_device(args, device))
> > > -                               return device;
> > > -               }
> > > -       }
> > > +/*
> > > + * Instantiate the non-RCU version.
> > > + * Callers must hold device_list_mutex, or uuid_mutex, under an excl=
usive
> > > + * operation or be in a context where the lists can not be changed c=
oncurrently.
> > > + */
> > > +BTRFS_GENERATE_FIND_DEVICE(btrfs_find_device, list_for_each_entry)
> > >
> > > -       list_for_each_entry(seed_devs, &fs_devices->seed_list, seed_l=
ist) {
> > > -               if (!dev_args_match_fs_devices(args, seed_devs))
> > > -                       continue;
> > > -               list_for_each_entry(device, &seed_devs->devices, dev_=
list) {
> > > -                       if (dev_args_match_device(args, device))
> > > -                               return device;
> > > -               }
> > > -       }
> > > +/*
> > > + * Instantiate the RCU version.
> > > + * Callers must hold rcu_read_lock().
> > > + */
> > > +BTRFS_GENERATE_FIND_DEVICE(btrfs_find_device_rcu, list_for_each_entr=
y_rcu)
> > >
> > > -       return NULL;
> > > -}
> > > +#undef BTRFS_GENERATE_FIND_DEVICE
> > >
> > >  static struct btrfs_device *add_missing_dev(struct btrfs_fs_devices =
*fs_devices,
> > >                                             u64 devid, u8 *dev_uuid)
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
