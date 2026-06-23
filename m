Received: from mail-qk2-f1.google.com (unknown [74.125.230.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8719C1EB5E3
	for <linux-btrfs@vger.kernel.org>; Tue, 23 Jun 2026 10:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.230.193
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782211278; cv=pass; b=u2UbiSvlni5d5VPYGXGoAqxae2BwxA+FZr4rYr2Aw87EbcaHbw3qmfwR7Odt4F6YyVpMIrXKflo+zrQOrXwZD698WZ35f1USDQqueteBgpgLCVQLubI7la9QOzwUizDiTe71GLjTzE27wUYGnSk0h1406vYtUsxLKWLY5AoN5Xk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782211278; c=relaxed/simple;
	bh=IrMQJmhOhAMtHplWqnKJr5JUIoFUOcZXUT+HDK1olDo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=c9V7HHWWLKOrVtW8LGU6srLyWSWEDyiZ9nr887lF4/viU2oRhKFekUYdz9qAC+YtrQNP7TUCVDLZBPxz7h0U+mBJt2U3glaBgJZMBwaDNuPW7/smf2oLhD36qsFF4y/tYbOkTdAGnejMKqTPPuoHNXncw4x7gEtwePMFrmekpss=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lusQxCTW; arc=pass smtp.client-ip=74.125.230.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lusQxCTW"
Received: by mail-qk2-f1.google.com with SMTP id af79cd13be357-91d44d3639eso6384585a.1
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Jun 2026 03:41:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782211276; cv=none;
        d=google.com; s=arc-20240605;
        b=kDNrUMisnuM+EGL9MCnw/cSkP0MFL9iBRqjWrPu8YuTD8+NkLZ7GNc8dUcCguxgNS/
         b/9VPGSdfYWuhYJIKKaYWzuQxDhWmipl+3YD6z8jmD2u0p48LVrl33JW8PUy/q0HIKBe
         a3EYK8pLHzXZCpyDSe8SMb5UHTn0wruSSaWCBT3HOIdZ7dMzagn+nk8MIWR5bGdFX1xK
         iPSkthw0Xo1KqSNduiueFggws18FkVCQY/yLjyu1+BC9ywgrx7aZ3VJ6DI1WJGuTH0Gj
         YAh5EImmqp49QQ9IhirDJ46sIYD+l/yiFrEUilbsZg0LYA1GJVQFMlb/O1a//DkE/lSO
         7Y4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pt8iL3veCjnJ4Tado/Y8385D92B5zl6PxJxxTB98JTY=;
        fh=XgyVQL63bakpFfKqPxJJiY5NdZTbMYsxaBXyIXgyd7w=;
        b=Zi/9D72xExcz3W/i0Ud6djQN1QxZLrMTiQp0D2eMH3/B/5eCTvS8CZXKcqZKTCMoWg
         F+lGXq2gzCf8CYoh/MI8xDRYxYbrUIc/c9y+lw5ZLKc9DEf5BIyoYkQ7hGc9pf4YLdQR
         Sud03vAUi4lwd7NMjKS8mp6FRbT1joRL7n8Eu1nCkp7ndupVK51H47gQSsG2l4Bsequa
         PlDqnychs+sCSJDS6T++PMwfMueB0jO501foYWjKYtj8cFxSciiholWqXsjxccqNkOuV
         V/sPFSdc5Rugrx0KYCcTBex+L1QqQEqGbLkb0TY955pjR/0ILEpomry6guthqIk7RbT1
         zC4g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782211276; x=1782816076; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pt8iL3veCjnJ4Tado/Y8385D92B5zl6PxJxxTB98JTY=;
        b=lusQxCTWAhR1WkMs2xsJmTgEap/vpTfao/V6QWrhWa8bn02fznl7YVtnkszVVRqwTQ
         hKDmzfxDGIrImE5A8WJVsXnqSxb3Bu4IfCVbje0jcdt8WHflGcO/Efjj01Ov5gUexpDP
         6NIvVVUme8oZs79CdvBWRU4TV1KrJi5/E1VS2pbGFBbjRta2uXAt0vUfepmcohLHOes8
         OFxRTdAP2ix9utdi7VGcFJpoJPKY0emf5bUXUv8GA2WfZ2FOjJX3JPA7upGaXibvh1DX
         t+QOKOhFbCT8/STioXq36b6B5uoYdQ+OQ0F0DAdEepi1njunaT4rEeKwKvCi0Pm5nws4
         SphQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782211276; x=1782816076;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pt8iL3veCjnJ4Tado/Y8385D92B5zl6PxJxxTB98JTY=;
        b=ZBwdG0EibazCL5cAdZAoG7K4CP9rwcoMmhaPEnBva7W2ABVMe/TkCQHhOIgoSZtIxp
         c++A51qJY7H/dCQqzkDrNvznlu0eZ57Fyh5J8jDaFn9aXpVlDvZ1L33ryTfff1E/SgH3
         JC/OFPrrevMt4RDXWY4Ct1Wc80EQVYsFJShYZcyMZ8Hx2v1YSsJ11JXyGCFJCSF0HrO5
         Q1qj/XtBkKvZ0zzFELLQAwyI1rTJZdkhU/oBFqKwFM73/26qin6102owZrwHlCuWX0E9
         /RVFyROj9y6Ycb8H/8q09TvwSeaT4GBeZ6z8QKMS6GXuqkxw+wW0UVOhOSueJPZ4dyng
         Kmdw==
X-Gm-Message-State: AOJu0Yxc5KPgyBNiMyE8J1siJmixXm76P/ob4O+aEf9jINqh52jCfvap
	zg+iPKP2VCdYXTKAh4ESVcZq+kWDigRLnCpKOSZaR1qdu2+kOCfpvIrQcn5Q7LlXs2N85chj+tm
	cyZ2zYcTfJqLk+xpW+F9iv0PBsb+s+7o=
X-Gm-Gg: AfdE7cmxE6VD1wTDqm/b0EGVdRfaiGqo6tOmX9tW1fIWhkoTdUFTyUGC2v5naFL7CGc
	VSmsTfU3u1MYh2DFvI9Guf3HJds/BrpzaT0IXmaSs1lW3fhZJ8dT78fgVZjfYL68DJmaePBe8kB
	WTDo2MnOIxSIiQrnYJydkoyjXPHDhNOc2M03SBHDntA9LWQvEoPrqvQ075tH09rd0pJnbrVBqp6
	wOh6+9VRHxtytuvx3LMZGh4R3wRfgCIhVws5tFtn6lrhq2807zwTIoddLkxARMNDoYFGHNeSXrv
	oBDKY9NTLLjCtWYRhtFD6T6+bsbX
X-Received: by 2002:a05:622a:554:b0:519:51a9:ff67 with SMTP id
 d75a77b69052e-519fe8a92cfmr146953011cf.0.1782211276000; Tue, 23 Jun 2026
 03:41:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260619090211.497100-1-johannes.thumshirn@wdc.com>
 <CAAuSuOqD+=nHVZu3czFe5JfQ3m1RDt0sWibVjPZdh4HeOom=Fw@mail.gmail.com> <b436c427-1d87-4c36-a159-0f5c03619771@wdc.com>
In-Reply-To: <b436c427-1d87-4c36-a159-0f5c03619771@wdc.com>
From: sun k <sunk67188@gmail.com>
Date: Tue, 23 Jun 2026 18:39:39 +0800
X-Gm-Features: AVVi8CfPPivGCmKHICxsk2rtJS1WCHfKjyX1q_ZREATqtLS38JD5RJnq_xZaQI4
Message-ID: <CAAuSuOpZkGX-mCYPKiD_Fni=0XdB2etgGrEkJJqBj4dSRqCZYQ@mail.gmail.com>
Subject: Re: [RFC 00/15] btrfs: RAID5 with RAID stripe-tree (zoned + non-zoned)
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I've just noticed that I'm not sure about your mindset of this raid5/6
rst feature.
So I want to know do you think the raid5/6 rst is extent layer raid or
block layer raid?
Because they are quite different and I need to align it with you
before further discussion.

For extent layer raid5/6, it's more like what zfs is doing now: we do
the "raid" thing on each
file extent, split big extent into stripes, and write them on
different disks with parity. The issue
of this is that the performance and efficiency on small extents is
bad, but we can always
do full stripe write, avoiding write hole issues.

For block layer raid5/6, which is like what we currently have without
rst, we need to deal with the
write hole issue, possibly by
1. totally avoid read-modify-write for a partial stripe update. We
always write into a new stripe
  append only instead of modifying an existing stripe, like writing a
zoned device even on non-zoned device.
2. or we allow read-modify-write for a partial stripe update, but
write the D and P elsewhere
  instead of in-place.

Option 2 will cause another free space management issue I've mentioned befo=
re:
let's take a 4 disk raid 5 as example.
before the partial stripe update, logical address LA is mapped to
physical address PA0(D0), PA1(D1), PA2(D2), PA3(P);
after updating D2, LA is mapped to address PA0(D0), PA1(D1), PA2'(D2'), PA3=
'(P')
then we need to allocate PA2' and PA3' , and free PA2 and PA3 on disk 2 and=
 3.
Since currently btrfs manage freespace based on logical address, how
to manage the allocation and manage physical free space?


On Mon, Jun 22, 2026 at 6:23=E2=80=AFPM Johannes Thumshirn
<johannes.thumshirn@wdc.com> wrote:
>
> On 6/19/26 3:28 PM, sun k wrote:
> > Hi Johannes,
> >
> > Glad to know that you're working on btrfs's raid56 and raid stripe tree=
.
> > This really a big change and it will really take me quite some time to
> > dive into the code implementation.
> >
> > Before going into code details, I take a glance on the total design and
> > it seems nice for me. But there's still some details that I'm currently
> > not sure so please correct me if I got anything wrong.
> >
> > First is about partial update. With this RFC they'll not updated
> > in-place(overwrite) anymore, but use a cow method instead, which means
> > ... we'll write that data elsewhere on disk, but still share the
> > previous logical address? This will change address mapping for a
> > blockgroup while current existing blockgroup profiles will not change
> > the address mapping in their entire lifetime IIRC so I have no idea if
> > current free space management things can works with this.
>
> I'm not sure I follow here. This is how the RAID stripe tree works, it
> maps logical to device physical addresses.
>
> >
> > Second is about the new key type in raid stripe tree. It makes the tree
> > search more complex as we've discussed before. So I wonder if it will
> > work just putting the parity stripe into RAID_STRIPE_KEY item, and usin=
g
> > the last 1 stripe for parity on raid5, the last 2 on raid6.
>
> Theoretically yes, but who's guaranteeing the order of IO completions
> that trigger the tree item insert? So that means we have to build the
> stripe extent upfront, then submit the IO and then update and send the
> stripe extent once all data and parity writes are done. Otherwise we
> can't use zone append on a zoned FS.
>
>
> > Third is about the partial tail. If we have 4 disks for raid 5 setup,
> > and the extent only fills one and a half stripe, how will things work i=
n
> > this RFC? And why use file size to decide it is a genuine tail? I have
> > no idea why it makes sense.
>
>
> The file size is purely an optimization. If we complete an OE and we're
> at isize, we know it's the last extent regardless if it's partial or not.
>
> > BTW, this might be a little off-topic but I've just read closure.h
> > recently and I wonder if we could use that to make bio related things
> > more readable and easier to work with in btrfs.
> I'd need to look into this, its been a long time since I've looked into i=
t.
