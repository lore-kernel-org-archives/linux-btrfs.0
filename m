Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB0F63A7F68
	for <linux-btrfs@vger.kernel.org>; Tue,  8 Sep 2026 16:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788886063; cv=pass; b=bg/lcUJsWHmHnqeYF/hKemPSBJPbu6ZUcptrAZscOPs8OPiaapjZf/eTNE8WiNJmu5S+XZMJP6+pmXxob3gHHMuZe0ZRz7xZJPaPyEA8zLeruzJJzk5HSJicxa2PAcN3D33UuRov3zHN2uo6w3ujHiaEx7CnQskQowt0W7IbtOE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788886063; c=relaxed/simple;
	bh=mwAxvZMzHRoyoS5SlFNnDSEx6Xh8O3uTGsYLqZ4P580=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rfCWTz7G0gvYGOpalboBsPbBLhlMIUUFsyZLPQV8mIqMUMmrP08h6+a35V5Cpx3ObsiQ00v+1DM/0m9H9YaIWMBbqv3nBp9Ec7sbqh8gnJEvOno6iKEbtUhIXsTSykYSQQJAvl9RhS21yxl7kUCF1afl7PeJDrKVbLGgF8BChbo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ZeWDij5q; arc=pass smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ZeWDij5q"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-482e4998d28so3900627f8f.2
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Sep 2026 09:47:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788886058; cv=none;
        d=google.com; s=arc-20260327;
        b=KxLG8BINBSL5TpthjNE0rmiD34XpliTFx0Z2QvUYnNI2b4WF7kk/JbqmsXoxRzsgWz
         PA0enKf/YaS7Wtca7/suMk27OqhWOK8t4f8H/lUPXKuB9kZDbjzmpczBJ4GP3cHe4DVN
         X5Y6QMDVuXekqmFMyfbAAPaCtmvC+615+/tq0dtSaNRs22MQRsSpp7gj43e7/KwgzCL8
         mzJJ6dQS5XX5PZzfI8UXP22IhQKg7NKsQZMK0BGMg1/lEHFEFAet2W9oqV9BDEm7YaNf
         v5Q8rgQieO6aP3BYgGHnKindtwvms5YIezRVKY1enUks9i/eJDR3CEGVkC0Tvu6Viqrc
         c2pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=lQTr2U76uYl3nor0tns8i6gi/m+LsiVvyKvG51LqGmw=;
        fh=TwoDPJ03w60MFtopI0TLuXp9sVo3pjoH/3FXVvG0pzc=;
        b=e4WLoIoUgxnSoNA7guwGIV6LT+JivmsLMOmkO8MXmFWH7Xh1YFB+8cKLOancmFgIet
         rPwzlGV5Y1L4khtxk88ZqSG8JdWhmJbCBv5/P2QApvGyHA+fyUai5It4V+xA/I+6uvJO
         rGcAU1yYackBV+t+esdRKD+nsTKCBVAinJmYc0VO+3zj4ya1pVC8hq65lPAroLZcjqdA
         V3wGArEPTx0aYpXbVYgFBzK8RK1V0K2SnQ1bSD4e3yEC2Z77B6l2ptxV/hp9O+KRa2ux
         LNqqGSo8vpr0CF5Bq4pQDFDL98b4KsPjewqg+Ltt6nXWMOzPeGxAr0r9KbkTNT7G619A
         w+lA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788886058; x=1789490858; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lQTr2U76uYl3nor0tns8i6gi/m+LsiVvyKvG51LqGmw=;
        b=ZeWDij5qCX58pjNIOWqP5T0WwTbCTYmg9/C3jusLKLwjD09DWYEnX0tdae7ZguME6H
         lhfsqRR1a1twNwVjmiRA+E0Z25HLxcD1pvX4jHJ31YZQGRC/53qQgUw+lJo4NKHkLrRl
         425BHkFkIpOduF245QPbwxdQXdoQCVsk2ydZWdL7imUQtEWxlBpTYbCjPYw5HoDIPFwR
         ZN8SdF1WQAaYoiNp1EhGISVBI/RZ/M1e08APN4/r16Oo98wmnJsQKDSWMv72NL/0O7s2
         HmqaXM808bFk/ir0x0a7IPVbtg5GVCAvwUnHyidWwkWCBDD35wxITvIYgKUSz0wVWUgw
         DuJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788886058; x=1789490858;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=lQTr2U76uYl3nor0tns8i6gi/m+LsiVvyKvG51LqGmw=;
        b=iP2cNnVImMt6QcQyhR0LX2WINTj9Q8hQIim/u9b9TRZuMsevWmMuP7LPR/ar/70du2
         Ie5zb3++dtlUpnN0hgBb2YhyRShVna76Kn1D/gVnWrbk9Pz2Nx27CM9C7XP7xoHwhMKR
         awf8f4FL3wjF6Ig/WgCLkHtrjTvM/P9iFq6T1b7wab9jKFwR6f8/TnbqOdPaRppNCNhG
         T+MAwVnfwUPJKzdKtbuXNrd33TSKl8vU5MKYsTuSBfOuUhb2O3ShUyFqTrmnDmVD9PA+
         T5FHU9/L3NytrOv0u1sj2p4pq5ilms+RlTE7PgkNphnoYXnY96hCMFaXw9fUNIb2O6AN
         D/bw==
X-Forwarded-Encrypted: i=1; AKwUvBzTi6CHY5BulBSBFoQLp613eeFfqJ6AfBtej+aUeb6uotwDPriZPoHvHM9hbloWNciPH5p+lEvmdulEOQ==@vger.kernel.org
X-Gm-Message-State: AFuF++mCbuVic4cvaCICmYBkmHVNVSeCm5IaLSVVAB8O1HgV+j6+qP5s
	DFcY/dbVOOHnjuwx3/DMQ59oIkVW+kkxvEJ87aQHmuTnDMPnQa4og+gjLMZzhSOisPMAEcALIJt
	jVRMU0alrZAp4ftJWZDVbPYIDnij+1onnIFQ5dLjWEQ==
X-Gm-Gg: AYBFou1Byd/Sizk4s42pRYKT6lERd0fEJuY9luyqzHWTJDvLUu25LaEJSwMYHqK155L
	8iYx2q/3WD65sG6sn8iec2F/UWgj6tUEwehG6m5guWz9NRFY8CPM/t8NryFUgIuU4jwtPmjpfn6
	NwympR2i29uFWXhH80cZx0XDjFbHM2H0oXMwO3IBVgoqRmbCN229AE8R1KcWn8sEfVh/hH9mfwT
	OhP3ys7Z6VB59E5podOsKIe52uzKZzzaMWet/OkTJFOZb4OSYuUwgyYyZXETfwfxSeGycx/Ib2C
	/1RhoNyKiB42Uein4iVlRpftjC8yOACBYQuh5pRNxEkFZeJLYGHKk7vGNNy+lhl0Kcc4BMpUGJG
	KbqF2gJdUHJN/pCyQR0PtzsvM0jnlhSUvZOJ/I/szTg==
X-Received: by 2002:a05:600c:138e:b0:49d:daa:af6e with SMTP id
 5b1f17b1804b1-49d1c7b732amr46339715e9.16.1788886058021; Tue, 08 Sep 2026
 09:47:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260513085340.3673127-1-neelx@suse.com> <20260513085340.3673127-10-neelx@suse.com>
 <20260602025436.GF2295@sol>
In-Reply-To: <20260602025436.GF2295@sol>
From: Daniel Vacek <neelx@suse.com>
Date: Tue, 8 Sep 2026 18:47:27 +0200
X-Gm-Features: AcwNN1WHoSNszmavv4wORasY461K9gsH-mc9zR1O6zdN1S5pOlfHSeHNoKmuOnY
Message-ID: <CAPjX3Fd-YEgnzhMryAJi44tZNs_YsHRAAwsxaKbO_jpgvp=qQg@mail.gmail.com>
Subject: Re: [PATCH v7 09/43] btrfs: add infrastructure for safe em freeing
To: Eric Biggers <ebiggers@kernel.org>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, Jens Axboe <axboe@kernel.dk>, David Sterba <dsterba@suse.com>, 
	linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Boris Burkov <boris@bur.io>
Content-Type: text/plain; charset="UTF-8"

On Tue, 2 Jun 2026 at 04:56, Eric Biggers <ebiggers@kernel.org> wrote:
> On Wed, May 13, 2026 at 10:52:43AM +0200, Daniel Vacek wrote:
> > +/*
> > + * Drop a ref for the extent map in the given tree.
> > + *
> > + * @tree:    tree that the em is a part of.
> > + * @em:              the em to drop the reference to.
> > + *
> > + * Drop the reference count on @em by one, if the reference count hits 0 and
> > + * there is an object on the em that can't be safely freed in the current
> > + * context (if we are holding the extent_map_tree->lock for example), then add
> > + * it to the freed_extents list on the extent_map_tree for later processing.
> > + *
> > + * This must be followed by a btrfs_free_pending_extent_maps() to clear
> > + * the pending frees.
> > + */
> > +void btrfs_free_extent_map_safe(struct extent_map_tree *tree,
> > +                             struct extent_map *em)
>
> The "unsafe" btrfs_free_extent_map() still exists.  Assuming both
> variants will continue to be needed, shouldn't the comment above the
> "unsafe" variant be updated to document the preconditions for using it?

Actually this could be cleaned up and unified into a single function
with optional argument.

> > diff --git a/fs/btrfs/extent_map.h b/fs/btrfs/extent_map.h
> > index 6f685f3c9327..a962012be1c3 100644
> > --- a/fs/btrfs/extent_map.h
> > +++ b/fs/btrfs/extent_map.h
> > @@ -97,11 +97,18 @@ struct extent_map {
> >       u32 flags;
> >       refcount_t refs;
> >       struct list_head list;
> > +     struct list_head free_list;
> > +};
>
> The comment above this struct says "Keep this structure as compact as
> possible, as we can have really large amounts of allocated extent maps
> at any time."  Is there any way to avoid adding a whole list_head?

Good catch. In fact we can reuse the old list member. No need for a new one.

--nX

> - Eric
