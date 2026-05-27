Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27210251795
	for <linux-btrfs@vger.kernel.org>; Wed, 27 May 2026 12:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779885294; cv=pass; b=dLPtdRDFRiH+o9GJ+bF6z1SKka3H7GzuahALP2e+/Z2JcnkXE8xEQBaJOzE4eoEC7RywlFvpNHN1l7t6fQMM+aBFaV1/yxh7sEAGA5YMo4nwtukKi+0t7+QdpT7qHt89j+e6bD/J2TE1C0nApCIV+QTXHD2LdoVQPldgeQ7AWok=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779885294; c=relaxed/simple;
	bh=ec75rWZvVkyelgMyy9tnIF/jM6gBLas1eMv4YqtK3DM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BV1jbdQnFtsGDy3jBvNmFfqKgJAiGOQASUUoMoVPIpi1+XLOJpfjokCAu44Ro7c3tybr4koFX4qSTE4AnfHZrnsHneVCtVJj9/leimKj46Wo2oHNrgorXdOtHzf0T2NPx2fHTYPOO9iL43ozdjANBNA1avq1HHqpFeja9u0rvWI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zadara.com; spf=pass smtp.mailfrom=zadarastorage.com; dkim=pass (2048-bit key) header.d=zadara.com header.i=@zadara.com header.b=YuPYR6u4; arc=pass smtp.client-ip=74.125.82.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zadara.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zadarastorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zadara.com header.i=@zadara.com header.b="YuPYR6u4"
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-3044857f09aso7231244eec.1
        for <linux-btrfs@vger.kernel.org>; Wed, 27 May 2026 05:34:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779885292; cv=none;
        d=google.com; s=arc-20240605;
        b=KKNy548SodlBFLTzeYfi3rNLzUneh/V8Icfqr+KRV2mYg3E1jk/cpBxiKTmUBxjhXI
         SrpsSCgFcs8HSJatf8z5dNH/3652HXPiJTOmTuGO+X5ZM95uVryPIpZ4R5eSdZNGLHvN
         +257QlUrAjhSpoGr7S8/CXpT/6tAEM/FHh9MIIQGmPzML1gBPOhvbauk2DdPurSHXlu7
         l4/3c5psvRO+mn8TXwW1EueKU2mHDQsbHsQXVb+utlT942HKUJGkaN8GMAnwkQ76rTYI
         AxiEIepE5wCGbe9rKFMQwwevRuXVk9hBSlGbP7Da6semj2JswZbUfRWpXrRHzSPhM3br
         frtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=jAZD1tLeHhLbxMNQFV1E2PYLrRVGkC2RtkcyW6I9V7g=;
        fh=UtmWHwiOMu0xqSct6OBq7WLYWDh3WI1B61Nth6pQVUE=;
        b=EuwL063h6N+bEHiKVc3U9rGV9eSX9aL9EPCVHfY9jgnbalsSxrx6yLuXknbF/BGpvs
         1lfmozYbd6hn45Exx4WXhF4P/57RSFpux3JR5bnoTR+A5RPCOy8P62zMEP/iheJtU1as
         VR97w55xOBXd/9fdVIqOlepJKaBNqwjun4O4orEWaiOI2JdEwqRBuPVKFomIu01HLEmy
         lQOqV3dXRyltdZKGtJBSHUwxA+tARKkwc/xMrU67ygp/DeluOp3JIZn8RxTNqtDmg+ya
         3xXb0QCi0ixwQTfNcM064C2ZXkk2lCDkA6XJhnG4e2/sMyt8L6Ul9W5KkZ3+WEpOBi6g
         7UMA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=zadara.com; s=google; t=1779885292; x=1780490092; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jAZD1tLeHhLbxMNQFV1E2PYLrRVGkC2RtkcyW6I9V7g=;
        b=YuPYR6u4E0QOdxPxEfp036vGcfMh5YqBJFqNxZBEOPSrIT+ruPq/rBCjQ9AvPBdukg
         CN3bGFaSQWwiqM5x1s09MKCSxOdr0L3BLYg2x8MzNdY+IouTdw470OMXeyphYL1I8iHm
         l+EZ08kIEZS2QZYdMm+NHUxkuSm7XHJ+f+qC2xdzsnMJpBU+RbgMjOhxuI7JzTdNRH3w
         2pJeiuhCKq6YbPZnsesbp5dhQLNM+UkhKgKHZRhDyyHim9GXKy0cW6SJgZoCnjAKaFJV
         xQSQBL+kf7sBCA+vvy1+sl/cmh2yMIcp7cBHE6X7gyMTnPZj7htomh0prlfIuroniinh
         FQrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779885292; x=1780490092;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jAZD1tLeHhLbxMNQFV1E2PYLrRVGkC2RtkcyW6I9V7g=;
        b=kyH4nPsBuhku9HVq21V4pBOC0Q4RRZjSuj7Eh7YJfKqbqQquH+JnHBUvfosMwFeIIC
         325c7MaLE4uJCZ17YuFXvRs8ydLbULr4yv+gfVBl9niQn5tBK0UbiafKyNRJNXdE+ASz
         gePyFJY3pUnPqzipw9GpeoOCmLPkhoUAA/745ydMzRUlkVI4MURqJ4Wzour9zUuP7NH7
         9bxqlqnqCkVfyMiBuk8I2zSg1mmUIJQrqv7EIa4zrGXBctFIBCkg3fH0kiqnzoJRdLAT
         GFmVREU7VcD2QFH+kqkc3O/iV0cQ5n1BMQ3uFdcINdeFeo5i66kQCiyxHQyVLFs2ttEl
         7Zhw==
X-Gm-Message-State: AOJu0YwryPDk585lEmMzFk4Z/7jeBSIoYV0my264+gqJf/XltKlUIKlA
	UjI3hIWVNULXQG/IOtazIMStZMcqHam+7zIClubQG+EJZT/Owa3BoTSGUjj+pbR4S6119npMupm
	RwroxuRlzxeenVKik4sT9JsYGqsH1b1DvIM+FTJ4jpw==
X-Gm-Gg: Acq92OFpAqHNtJC+XXt3cvy6s+XUs/VyuI02cqyPJsY28/Axt+iCVQREdgTvm7+TF8q
	F2dWWbIKM8mG8pYaVuHncielgljN0bygGAVemyWHThCZM6dM1dFuO2EIZOABudhDH2liFdMZdEz
	lIhnzVPneW/AkLIJ96trV8Se3fG/oMJh8sAr6H+VTrz0fNYn3YtU5Z3PnxsoWpoVSC2gy70KhoO
	pzWr6wwP+UGfRjVBqx2608Lt2zj3hz80L30JsOIL+gJx+AHKl6a37JbPZENXGv+DwCjufYHVTd9
	Z/xi8Q==
X-Received: by 2002:a05:7301:10c2:b0:2e1:e3e6:2909 with SMTP id
 5a478bee46e88-30448f4aaaemr9440287eec.9.1779885292210; Wed, 27 May 2026
 05:34:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230914-raid-stripe-tree-v9-0-15d423829637@wdc.com> <20230914-raid-stripe-tree-v9-3-15d423829637@wdc.com>
In-Reply-To: <20230914-raid-stripe-tree-v9-3-15d423829637@wdc.com>
From: Alex Lyakas <alex.lyakas@zadara.com>
Date: Wed, 27 May 2026 15:34:41 +0300
X-Gm-Features: AVHnY4Kq-JG21NEEqooffv3xWKCiVHUVLdEfRk3dYk9v7U1k-cwLPcu1JIOTN5Y
Message-ID: <CAOcd+r1PCM8t6zuVh1jxkQzEGr3_p+qhuoypE=6Cj=HWovQ_kg@mail.gmail.com>
Subject: Re: [PATCH v9 03/11] btrfs: add support for inserting raid stripe extents
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Johannes,

On Thu, Sep 14, 2023 at 7:08=E2=80=AFPM Johannes Thumshirn
<johannes.thumshirn@wdc.com> wrote:
>
> Add support for inserting stripe extents into the raid stripe tree on
> completion of every write that needs an extra logical-to-physical
> translation when using RAID.
>
> Inserting the stripe extents happens after the data I/O has completed,
> this is done to a) support zone-append and b) rule out the possibility of
> a RAID-write-hole.
>
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>  fs/btrfs/Makefile           |   2 +-
>  fs/btrfs/bio.c              |  23 +++++
>  fs/btrfs/extent-tree.c      |   1 +
>  fs/btrfs/inode.c            |   8 +-
>  fs/btrfs/ordered-data.c     |   1 +
>  fs/btrfs/ordered-data.h     |   2 +
>  fs/btrfs/raid-stripe-tree.c | 245 ++++++++++++++++++++++++++++++++++++++=
++++++
>  fs/btrfs/raid-stripe-tree.h |  34 ++++++
>  fs/btrfs/volumes.c          |   4 +-
>  fs/btrfs/volumes.h          |  15 +--
>  10 files changed, 326 insertions(+), 9 deletions(-)
>
> diff --git a/fs/btrfs/Makefile b/fs/btrfs/Makefile
> index c57d80729d4f..525af975f61c 100644
> --- a/fs/btrfs/Makefile
> +++ b/fs/btrfs/Makefile
> @@ -33,7 +33,7 @@ btrfs-y +=3D super.o ctree.o extent-tree.o print-tree.o=
 root-tree.o dir-item.o \
>            uuid-tree.o props.o free-space-tree.o tree-checker.o space-inf=
o.o \
>            block-rsv.o delalloc-space.o block-group.o discard.o reflink.o=
 \
>            subpage.o tree-mod-log.o extent-io-tree.o fs.o messages.o bio.=
o \
> -          lru_cache.o
> +          lru_cache.o raid-stripe-tree.o
>
>  btrfs-$(CONFIG_BTRFS_FS_POSIX_ACL) +=3D acl.o
>  btrfs-$(CONFIG_BTRFS_FS_REF_VERIFY) +=3D ref-verify.o
> diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
> index 31ff36990404..ddbe6f8d4ea2 100644
> --- a/fs/btrfs/bio.c
> +++ b/fs/btrfs/bio.c
> @@ -14,6 +14,7 @@
>  #include "rcu-string.h"
>  #include "zoned.h"
>  #include "file-item.h"
> +#include "raid-stripe-tree.h"
>
>  static struct bio_set btrfs_bioset;
>  static struct bio_set btrfs_clone_bioset;
> @@ -415,6 +416,9 @@ static void btrfs_orig_write_end_io(struct bio *bio)
>         else
>                 bio->bi_status =3D BLK_STS_OK;
>
> +       if (bio_op(bio) =3D=3D REQ_OP_ZONE_APPEND && !bio->bi_status)
> +               stripe->physical =3D bio->bi_iter.bi_sector << SECTOR_SHI=
FT;
> +
>         btrfs_orig_bbio_end_io(bbio);
>         btrfs_put_bioc(bioc);
>  }
> @@ -426,6 +430,8 @@ static void btrfs_clone_write_end_io(struct bio *bio)
>         if (bio->bi_status) {
>                 atomic_inc(&stripe->bioc->error);
>                 btrfs_log_dev_io_error(bio, stripe->dev);
> +       } else if (bio_op(bio) =3D=3D REQ_OP_ZONE_APPEND) {
> +               stripe->physical =3D bio->bi_iter.bi_sector << SECTOR_SHI=
FT;
>         }
>
>         /* Pass on control to the original bio this one was cloned from *=
/
> @@ -487,6 +493,7 @@ static void btrfs_submit_mirrored_bio(struct btrfs_io=
_context *bioc, int dev_nr)
>         bio->bi_private =3D &bioc->stripes[dev_nr];
>         bio->bi_iter.bi_sector =3D bioc->stripes[dev_nr].physical >> SECT=
OR_SHIFT;
>         bioc->stripes[dev_nr].bioc =3D bioc;
> +       bioc->size =3D bio->bi_iter.bi_size;
>         btrfs_submit_dev_bio(bioc->stripes[dev_nr].dev, bio);
>  }
>
> @@ -496,6 +503,8 @@ static void __btrfs_submit_bio(struct bio *bio, struc=
t btrfs_io_context *bioc,
>         if (!bioc) {
>                 /* Single mirror read/write fast path. */
>                 btrfs_bio(bio)->mirror_num =3D mirror_num;
> +               if (bio_op(bio) !=3D REQ_OP_READ)
> +                       btrfs_bio(bio)->orig_physical =3D smap->physical;
>                 bio->bi_iter.bi_sector =3D smap->physical >> SECTOR_SHIFT=
;
>                 if (bio_op(bio) !=3D REQ_OP_READ)
>                         btrfs_bio(bio)->orig_physical =3D smap->physical;

These two lines now appear twice. Is this fine?
At least in linux-stable 6.6 I have now:

        if (bio_op(bio) !=3D REQ_OP_READ)
            btrfs_bio(bio)->orig_physical =3D smap->physical;
        bio->bi_iter.bi_sector =3D smap->physical >> SECTOR_SHIFT;
        if (bio_op(bio) !=3D REQ_OP_READ)
            btrfs_bio(bio)->orig_physical =3D smap->physical;

Looks redundant.

Thanks,
Alex.
