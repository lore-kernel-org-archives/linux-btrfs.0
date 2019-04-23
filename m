Return-Path: <SRS0=kwY/=SZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DA85C10F03
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Apr 2019 14:50:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B74221738
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Apr 2019 14:50:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JYc8//1A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727762AbfDWOuR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 23 Apr 2019 10:50:17 -0400
Received: from mail-ua1-f66.google.com ([209.85.222.66]:39464 "EHLO
        mail-ua1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726421AbfDWOuQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Apr 2019 10:50:16 -0400
Received: by mail-ua1-f66.google.com with SMTP id d5so4851338uan.6
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Apr 2019 07:50:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=pVakqkzAHxALEHXan0R2RqF/m1CtwswKK8jMX649u+w=;
        b=JYc8//1An8YlAqIA4A2B3k0FUR3I/7GO5TvJVOmFNffsAA383uz6HSUXgpbNbsUvqx
         K/4si9Pc2zjZTpiBJ1/LSxwtlh97vvfzuasnZQ8yWhy59PmZi3QgWr99axtj2EyJ4bI4
         vnKiSiCNAenyQAtBxe353E3J2Jna/HDb1SlwCj8YPvtorxz4kjjn4t0fMb4bholLEbxu
         uKIEv2AYwtQd2q9M5Xf5zkPAVN/kk29TiBXNEPWwLJQRf5MAoC1yCcumwzxEi+84/zWL
         Of26WMFMyH9QZqMYfRibHcrBUSSbXRgx90e1trGdMMgD4y6JKbPrbR/+5c4qPqtPbzDS
         8kvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=pVakqkzAHxALEHXan0R2RqF/m1CtwswKK8jMX649u+w=;
        b=tYIErU8h1lK3ViqWhuoaTna0cUmxsfXDEJPz7ZAkBAtDoX3Y3+ufbIFJnBV+NJ6Cnc
         cb+ty1+Z6JiGmB7Kip1xzDN6SU/LryHnbrMmr7agUcKLTVVrVEX1Ezjq+oIh/QSHWIw4
         QgrRzwyDJ9tBrX430smh1T+o/34NLpBKCvJYpHM0vNhO5ZFmvdS61fSV/xGzRnQoBfYU
         bnC0ptjm7IWbIuOyNHfAdPN3XhXC9gZgHDi5AgksFhBaNCUoJPT0chCFOlCZlnU6ai4r
         tg+rUheU0h7wTCFr81OpKJbVN6fG93BWK0JqKTsnkfocYDht9jTQJcEIGzFI6k1kycyg
         lg2A==
X-Gm-Message-State: APjAAAWVIgYVDTFKhBdPJKe9PMtfrp+XDNvGS/u4HkpJZGNKrO/nSWNT
        dML124NXimhr+hPGWv1Kw0E6P1Aws9iycCAWm0iDhPr2
X-Google-Smtp-Source: APXvYqwLZ1nZdoBLcpaJu+cM8o/OXsTfOHJBLdlHZfhirvyosRlYwwg4DWnyuCXqFN3lKN9hebD44JgLP2+NvGtoarA=
X-Received: by 2002:ab0:7003:: with SMTP id k3mr13167602ual.0.1556031015157;
 Tue, 23 Apr 2019 07:50:15 -0700 (PDT)
MIME-Version: 1.0
References: <CAPv9Zmk46As_P9Gyf_icET53xRda63h7iC1meES9xbdDEt9qow@mail.gmail.com>
 <f64c6b65-5f21-48eb-6e1e-db30cbe57545@gmx.com> <20190423113302.GS20156@twin.jikos.cz>
 <a82d7cdb-206e-d141-e53b-4836b4b150de@gmx.com>
In-Reply-To: <a82d7cdb-206e-d141-e53b-4836b4b150de@gmx.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Tue, 23 Apr 2019 15:50:03 +0100
Message-ID: <CAL3q7H7dzVQFRcTzBNNhCU69i5Yi4xStT14XjRw_vivH6QWnRw@mail.gmail.com>
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

On Tue, Apr 23, 2019 at 1:14 PM Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
>
> On 2019/4/23 =E4=B8=8B=E5=8D=887:33, David Sterba wrote:
> > On Tue, Apr 23, 2019 at 10:16:32AM +0800, Qu Wenruo wrote:
> >> On 2019/4/23 =E4=B8=8A=E5=8D=885:09, Jakob Unterwurzacher wrote:
> >>> I have a user who is reporting ENOSPC errors when running gocryptfs o=
n
> >>> top of btrfs (ticket: https://github.com/rfjakob/gocryptfs/issues/395=
 ).
> >>>
> >>> What is interesting is that the error gets thrown at write time. This
> >>> is not supposed to happen, because gocryptfs does
> >>>
> >>>     fallocate(..., FALLOC_FL_KEEP_SIZE, ...)
> >>>
> >>> before writing.
> >>>
> >>> I wrote a minimal reproducer in C: https://github.com/rfjakob/falloca=
te_write
> >>> This is what it looks like on ext4:
> >>>
> >>>     $ ../fallocate_write/fallocate_write
> >>>     reading from /dev/urandom
> >>>     writing to ./blob.379Q8P
> >>>     writing blocks of 132096 bytes each
> >>>     [...]
> >>>     fallocate failed: No space left on device
> >>>
> >>> On btrfs, it will instead look like this:
> >>>
> >>>     [...]
> >>>     pwrite failed: No space left on device
> >>>
> >>> Is this a bug in btrfs' fallocate implementation or am I reading the
> >>> guarantees that fallocate gives me wrong?
> >>
> >> Since v4.7, this commit changed the how btrfs do NodataCOW check:
> >> c6887cd11149 ("Btrfs: don't do nocow check unless we have to").
> >>
> >> Before that commit, btrfs always check if they need to reserve space f=
or
> >> COW, while after that patch, btrfs never checks unless we have no spac=
e.
> >>
> >> However this screws up other nodatacow space check.
> >> And due to its age and deep changeset, it's pretty hard to fix it.
> >> I have tried several times, but it will only cause more problems.
> >
> > What if the commit is reverted, if the problem is otherwise hard to fix=
?
>
> Tried reverted, but all other problems came up.

I haven't seen an explanation on why that patch causes ENOSPC or what
nodatacow space check screw ups it causes.

It seems fine to me, and what we currently do:

1) For any buffered write, check if there's enough free data space;
2) If not try to allocate a new data chunk;
3) If that fails check if the file has the "have prealloc extents"
flag or has the nodatacow flag set
4) If any of those conditions is true, check if we can write to the
existing extent - if it's not shared or no checksums exist in its
range, meaning it's an unwritten (prealloc) extent, return success to
userspace

So what's wrong with it? And how does it cause the ENOSPC?

Trying the reproducer, at least on a 5.0 kernel, does never fail on a
pwrite for me, but always on fallocate:

$ mkfs.btrfs -f -b $((4 * 1024 * 1024 * 1024)) /dev/sdi
$ mount /dev/sdi /mnt/sdi
$ cd /mnt/sdi
$ /path/to/reproducer
reading from /dev/urandom
writing to ./blob.IIa6tH
writing blocks of 132096 bytes each
total    125 MiB,  65.52 MiB/s
total    251 MiB,  44.59 MiB/s
total    377 MiB,  55.23 MiB/s
total    503 MiB,  66.21 MiB/s
total    629 MiB,  59.97 MiB/s
total    755 MiB,   3.70 MiB/s
total    881 MiB,  50.24 MiB/s
total   1007 MiB,  64.51 MiB/s
total   1133 MiB,  50.70 MiB/s
total   1259 MiB,  49.29 MiB/s
total   1385 MiB,  47.93 MiB/s
total   1511 MiB,   4.00 MiB/s
total   1637 MiB,  49.85 MiB/s
total   1763 MiB,  48.11 MiB/s
total   1889 MiB,  66.62 MiB/s
total   2015 MiB,   5.60 MiB/s
total   2141 MiB,  19.58 MiB/s
total   2267 MiB,  64.80 MiB/s
total   2393 MiB,  13.23 MiB/s
total   2519 MiB,  14.95 MiB/s
fallocate failed: No space left on device

So either that was tested on a rather old kernel or:

1) we had snapshotting happening between a fallocate and a pwrite (or
at the same time as the pwrite)
2) before the pwrite (or during) the unwritten/prealloc extent was
reflinked (cp --reflink, clone or dedupe ioctls)

What did I miss here?

Thanks.

>
> E.g. reserved space underflow.
>
> I'll find the old thread and retry again.
>
> Thanks,
> Qu
>
> > This seems to break the semantics of fallocate so the performance shoul=
d
> > not the main concern here.
> >
>


--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
