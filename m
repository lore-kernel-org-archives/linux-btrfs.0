Return-Path: <SRS0=IMPl=S2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02F1CC10F11
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Apr 2019 09:29:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD29F20449
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Apr 2019 09:29:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XDXIjleF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727314AbfDXJ3I (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Apr 2019 05:29:08 -0400
Received: from mail-ua1-f65.google.com ([209.85.222.65]:45661 "EHLO
        mail-ua1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726176AbfDXJ3I (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Apr 2019 05:29:08 -0400
Received: by mail-ua1-f65.google.com with SMTP id o33so585504uae.12
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Apr 2019 02:29:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=L32iPJfkwBm1CJbnyVibqxxJ2oHQOI91Nmm0vJOFLxc=;
        b=XDXIjleFn2DmVYve5tC35Ze0jClphyzXvi38SaUJKZjAwF8PgJY7eV0zY5j5EvDUke
         uJy3FV7qape7t4OspLVFLSC3puaqTT/xb1cifvqsk9ZX7byztf80Ip3G1k7U4R5kwNQo
         NBsdA9+tNrkKPS4FmPo0MFO49iSVkI7cSXEHua2q2SR1tdVCX6utGXFnxWHM4EMjtGws
         4JDcW+tmYUbFWqWYBGap8QAJ/iWh4Kts9sLmXev6XYLLZox649CEBWvMvRki6WN7/GwS
         H2LUa4zgniA3BVchjmuT0aXZLHCEMZ5enMJKOUzHR2ndJgV7foJB4KC+rnunmSPqni1m
         Rwmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=L32iPJfkwBm1CJbnyVibqxxJ2oHQOI91Nmm0vJOFLxc=;
        b=FvMINIuPet7g9rdabypZs9SPuukC3ImelZiaNJjC8sbO4lI8VdwgsVzhVQRLtNPfIs
         R3TGcLjeXOu3gsNmzOS35mpQqr8mnMyHNXqhpnnlJEKtvV/vBKoVA0NW30b0zeHo1MWq
         oZ5P5YFI0EsroOJ7UdIscf1vPSHGoHOP3nBTc+e3AI/SrlN93ou9iDevX5ADfqWsB9Bb
         UOir7qMz99hxAHUkzNJhKG4RBdfihjZE4XRAVHenTVhXmY51ekKrDGbmRhf+8+IXHdDy
         G/qvgxVcOnWhIfIszoi6PUMep+wf0y6YqvOekvJ1jBln94aKqbalqtvEIY2uRfXCY7m4
         kkng==
X-Gm-Message-State: APjAAAU+z5YK+3lIqEL9dk9c5zEIirjv9rVasdBnqcns4kr2SdLM0Ebj
        sxVPo6TnbQZ0beLZij7RdxnevpJWrbH07HEen70/4A==
X-Google-Smtp-Source: APXvYqy+cSRBm6ESVRWtEJ2Qm+ucm81yWoTditJ4d1w+tzKiTY1ITGKikyfIfU0iQ152e91mAxdsq5C22i5VtirX8TM=
X-Received: by 2002:ab0:77d3:: with SMTP id y19mr5642480uar.123.1556098146814;
 Wed, 24 Apr 2019 02:29:06 -0700 (PDT)
MIME-Version: 1.0
References: <CAPv9Zmk46As_P9Gyf_icET53xRda63h7iC1meES9xbdDEt9qow@mail.gmail.com>
 <f64c6b65-5f21-48eb-6e1e-db30cbe57545@gmx.com> <20190423113302.GS20156@twin.jikos.cz>
 <a82d7cdb-206e-d141-e53b-4836b4b150de@gmx.com> <CAL3q7H7dzVQFRcTzBNNhCU69i5Yi4xStT14XjRw_vivH6QWnRw@mail.gmail.com>
 <8a3b5e64-1df7-447d-3b07-e276b8d65b40@gmx.com>
In-Reply-To: <8a3b5e64-1df7-447d-3b07-e276b8d65b40@gmx.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Wed, 24 Apr 2019 10:28:55 +0100
Message-ID: <CAL3q7H4cjWJgoNg5C4+KsKFHg66KFmj7CDJiTMM9yBGU-fnjzA@mail.gmail.com>
Subject: Re: fallocate does not prevent ENOSPC on write
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     dsterba@suse.cz, Jakob Unterwurzacher <jakobunt@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Apr 24, 2019 at 12:49 AM Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
>
> On 2019/4/23 =E4=B8=8B=E5=8D=8810:50, Filipe Manana wrote:
> > On Tue, Apr 23, 2019 at 1:14 PM Qu Wenruo <quwenruo.btrfs@gmx.com> wrot=
e:
> >>
> >>
> >>
> >> On 2019/4/23 =E4=B8=8B=E5=8D=887:33, David Sterba wrote:
> >>> On Tue, Apr 23, 2019 at 10:16:32AM +0800, Qu Wenruo wrote:
> >>>> On 2019/4/23 =E4=B8=8A=E5=8D=885:09, Jakob Unterwurzacher wrote:
> >>>>> I have a user who is reporting ENOSPC errors when running gocryptfs=
 on
> >>>>> top of btrfs (ticket: https://github.com/rfjakob/gocryptfs/issues/3=
95 ).
> >>>>>
> >>>>> What is interesting is that the error gets thrown at write time. Th=
is
> >>>>> is not supposed to happen, because gocryptfs does
> >>>>>
> >>>>>     fallocate(..., FALLOC_FL_KEEP_SIZE, ...)
> >>>>>
> >>>>> before writing.
> >>>>>
> >>>>> I wrote a minimal reproducer in C: https://github.com/rfjakob/fallo=
cate_write
> >>>>> This is what it looks like on ext4:
> >>>>>
> >>>>>     $ ../fallocate_write/fallocate_write
> >>>>>     reading from /dev/urandom
> >>>>>     writing to ./blob.379Q8P
> >>>>>     writing blocks of 132096 bytes each
> >>>>>     [...]
> >>>>>     fallocate failed: No space left on device
> >>>>>
> >>>>> On btrfs, it will instead look like this:
> >>>>>
> >>>>>     [...]
> >>>>>     pwrite failed: No space left on device
> >>>>>
> >>>>> Is this a bug in btrfs' fallocate implementation or am I reading th=
e
> >>>>> guarantees that fallocate gives me wrong?
> >>>>
> >>>> Since v4.7, this commit changed the how btrfs do NodataCOW check:
> >>>> c6887cd11149 ("Btrfs: don't do nocow check unless we have to").
> >>>>
> >>>> Before that commit, btrfs always check if they need to reserve space=
 for
> >>>> COW, while after that patch, btrfs never checks unless we have no sp=
ace.
> >>>>
> >>>> However this screws up other nodatacow space check.
> >>>> And due to its age and deep changeset, it's pretty hard to fix it.
> >>>> I have tried several times, but it will only cause more problems.
> >>>
> >>> What if the commit is reverted, if the problem is otherwise hard to f=
ix?
> >>
> >> Tried reverted, but all other problems came up.
> >
> > I haven't seen an explanation on why that patch causes ENOSPC or what
> > nodatacow space check screw ups it causes.
> >
> > It seems fine to me, and what we currently do:
> >
> > 1) For any buffered write, check if there's enough free data space;
> > 2) If not try to allocate a new data chunk;
> > 3) If that fails check if the file has the "have prealloc extents"
> > flag or has the nodatacow flag set
> > 4) If any of those conditions is true, check if we can write to the
> > existing extent - if it's not shared or no checksums exist in its
> > range, meaning it's an unwritten (prealloc) extent, return success to
> > userspace
> >
> > So what's wrong with it? And how does it cause the ENOSPC?
>
> E.g.
>
> We have a 128Mb preallocated file extent.
> And assume the fs only have 128M free data space, meaning 0 remaining
> space at all.

That's a contradicting sentence...

>
> Then we try to buffer write, which means buffered will just fail as it
> will need data space.
>
> The idea is always here for fallocate/pwrite, just the timing where the
> ENOSPC happens.

Can't make sense of that sentence as well.

So I suppose what you are trying to say is that a write into an
unwritten extent causes space allocation,
and that can prevent some other write (which is not into an unwritten
extent) from being able to allocate space and therefore fail.

That's a valid problem that should be temporary.

However when allocating space for a write into an unwritten extent (or
any nodatacow write) we increment the data space info's bytes_may_use
counter,
but then if when writeback starts if we don't need to fallback into
CoW, we end up never decrementing the bytes_may_use counter (even
after writeback completes), leaking it.
Not sure if this is the problem you were mentioning or just causing
other writes to temporarily fail.

thanks


>
>
> We have btrfs/153 for the same reason to fail for a long time, although
> it's from quota, but the reason the completely the same.
>
> Thanks,
> Qu
>
> >
> > Trying the reproducer, at least on a 5.0 kernel, does never fail on a
> > pwrite for me, but always on fallocate:
> >
> > $ mkfs.btrfs -f -b $((4 * 1024 * 1024 * 1024)) /dev/sdi
> > $ mount /dev/sdi /mnt/sdi
> > $ cd /mnt/sdi
> > $ /path/to/reproducer
> > reading from /dev/urandom
> > writing to ./blob.IIa6tH
> > writing blocks of 132096 bytes each
> > total    125 MiB,  65.52 MiB/s
> > total    251 MiB,  44.59 MiB/s
> > total    377 MiB,  55.23 MiB/s
> > total    503 MiB,  66.21 MiB/s
> > total    629 MiB,  59.97 MiB/s
> > total    755 MiB,   3.70 MiB/s
> > total    881 MiB,  50.24 MiB/s
> > total   1007 MiB,  64.51 MiB/s
> > total   1133 MiB,  50.70 MiB/s
> > total   1259 MiB,  49.29 MiB/s
> > total   1385 MiB,  47.93 MiB/s
> > total   1511 MiB,   4.00 MiB/s
> > total   1637 MiB,  49.85 MiB/s
> > total   1763 MiB,  48.11 MiB/s
> > total   1889 MiB,  66.62 MiB/s
> > total   2015 MiB,   5.60 MiB/s
> > total   2141 MiB,  19.58 MiB/s
> > total   2267 MiB,  64.80 MiB/s
> > total   2393 MiB,  13.23 MiB/s
> > total   2519 MiB,  14.95 MiB/s
> > fallocate failed: No space left on device
> >
> > So either that was tested on a rather old kernel or:
> >
> > 1) we had snapshotting happening between a fallocate and a pwrite (or
> > at the same time as the pwrite)
> > 2) before the pwrite (or during) the unwritten/prealloc extent was
> > reflinked (cp --reflink, clone or dedupe ioctls)
> >
> > What did I miss here?
> >
> > Thanks.
> >
> >>
> >> E.g. reserved space underflow.
> >>
> >> I'll find the old thread and retry again.
> >>
> >> Thanks,
> >> Qu
> >>
> >>> This seems to break the semantics of fallocate so the performance sho=
uld
> >>> not the main concern here.
> >>>
> >>
> >
> >
>


--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
