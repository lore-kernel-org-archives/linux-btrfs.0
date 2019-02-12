Return-Path: <SRS0=Udpi=QT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEF82C282C4
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 15:35:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90E12217FA
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 15:35:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g/s6/O3N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729430AbfBLPfu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Feb 2019 10:35:50 -0500
Received: from mail-ua1-f66.google.com ([209.85.222.66]:40909 "EHLO
        mail-ua1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726238AbfBLPfu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Feb 2019 10:35:50 -0500
Received: by mail-ua1-f66.google.com with SMTP id n32so1004838uae.7
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Feb 2019 07:35:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=pNkdqXz/+3HVxzuMMJBFNm4+8mWfh/i/5Gecj3L2X4g=;
        b=g/s6/O3NdQ48IODtld7TwD8xVLH8rHnD91fMF5DKppozLpoUt5GIEYKBsNAIRETiJA
         24cWzHr2bEWrv01VIMfxmyUB/M8jLBKi9yZZNkgce5AOyqfyypUjpXM/l6w+/DOxxDau
         VKosX9sKqCcj3QnSj2THpAN/RKZ4A1Tte3JQfJDpRuH1GgHHtrAGOovV/GZDxy8b57Hb
         c8z5hO0xotyIqO+nA4WawEBq9eWgQs+B4E6MNL6aAyKPmk7wVx7cCsSAyv5UVw3z2lDq
         UEuMS6MRUXdWXnh2wJRA0KT/qqrrRzCdd+wblxoyHiSfzcTqm8eVB5UueenEMix8H0Or
         KA3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=pNkdqXz/+3HVxzuMMJBFNm4+8mWfh/i/5Gecj3L2X4g=;
        b=qzfGwosuNW+w/R+Kz2tdBVYZTIzR+1bBaFtcKwY7O+AVAWdbaj6MsAKdCOylY54SHz
         lTsx8jJMwqzXLGvj2Sr9T/mD7Sx49rZm0Em7kOf19zjHr8kHFf8gViojPGQpFFfiQh6S
         bMzGuwg5/GqXTOizmwdg2+1ftSQvzZuRUqitUmyfC6Bek+BFa8DVf6uRs4g7NUj1jfm6
         l6EF/aXJnsixK0nmQDDoWQHko1HCFXT/aGoNJ1B9X97zJm5nfxM8inCcWkJXOmuYSMr1
         fy8Vsdd7RM0tLptFsMhYGD/hZQqEewmofqH3W4vVOeay+9MsiY3XmxGAN0lzTQh8f3EA
         y/TQ==
X-Gm-Message-State: AHQUAuZueV4u5H8aODQpuCWvICjair30/cdVsgups8YB3HHYNLhk8dSk
        YaSe7bLKbAi0jedOzaNIV6KL08+chby2YyjDpX2jGg==
X-Google-Smtp-Source: AHgI3IYOE1VpbR6TdV8X4luqCkbW7QgJQezwFbyBS/ZHNm3seJnipWBSeMTSJTrjGi5aRwKlgMLQ9h2Z/+7sxqIOuqU=
X-Received: by 2002:ab0:621a:: with SMTP id m26mr1578271uao.36.1549985748434;
 Tue, 12 Feb 2019 07:35:48 -0800 (PST)
MIME-Version: 1.0
References: <20180823031125.GE13528@hungrycats.org> <20190212030838.GB9995@hungrycats.org>
In-Reply-To: <20190212030838.GB9995@hungrycats.org>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Tue, 12 Feb 2019 15:35:37 +0000
Message-ID: <CAL3q7H7T_NX=D8qimRC55g8V-p0k-ygUiW-K5bxF02r-6XT6Rg@mail.gmail.com>
Subject: Re: Reproducer for "compressed data + hole data corruption bug, 2018
 edition" still works on 4.20.7
To:     Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Feb 12, 2019 at 3:11 AM Zygo Blaxell
<ce3g8jdj@umail.furryterror.org> wrote:
>
> Still reproducible on 4.20.7.

I tried your reproducer when you first reported it, on different
machines with different kernel versions.
Never managed to reproduce it, nor see anything obviously wrong in
relevant code paths.

>
> The behavior is slightly different on current kernels (4.20.7, 4.14.96)
> which makes the problem a bit more difficult to detect.
>
>         # repro-hole-corruption-test
>         i: 91, status: 0, bytes_deduped: 131072
>         i: 92, status: 0, bytes_deduped: 131072
>         i: 93, status: 0, bytes_deduped: 131072
>         i: 94, status: 0, bytes_deduped: 131072
>         i: 95, status: 0, bytes_deduped: 131072
>         i: 96, status: 0, bytes_deduped: 131072
>         i: 97, status: 0, bytes_deduped: 131072
>         i: 98, status: 0, bytes_deduped: 131072
>         i: 99, status: 0, bytes_deduped: 131072
>         13107200 total bytes deduped in this operation
>         am: 4.8 MiB (4964352 bytes) converted to sparse holes.
>         94a8acd3e1f6e14272f3262a8aa73ab6b25c9ce8 am
>         6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>         6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>         6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>         6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>         6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>         6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>
> The sha1sum seems stable after the first drop_caches--until a second
> process tries to read the test file:
>
>         6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>         6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>         # cat am > /dev/null              (in another shell)
>         19294e695272c42edb89ceee24bb08c13473140a am
>         6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>
> On Wed, Aug 22, 2018 at 11:11:25PM -0400, Zygo Blaxell wrote:
> > This is a repro script for a btrfs bug that causes corrupted data reads
> > when reading a mix of compressed extents and holes.  The bug is
> > reproducible on at least kernels v4.1..v4.18.
> >
> > Some more observations and background follow, but first here is the
> > script and some sample output:
> >
> >       root@rescue:/test# cat repro-hole-corruption-test
> >       #!/bin/bash
> >
> >       # Write a 4096 byte block of something
> >       block () { head -c 4096 /dev/zero | tr '\0' "\\$1"; }
> >
> >       # Here is some test data with holes in it:
> >       for y in $(seq 0 100); do
> >               for x in 0 1; do
> >                       block 0;
> >                       block 21;
> >                       block 0;
> >                       block 22;
> >                       block 0;
> >                       block 0;
> >                       block 43;
> >                       block 44;
> >                       block 0;
> >                       block 0;
> >                       block 61;
> >                       block 62;
> >                       block 63;
> >                       block 64;
> >                       block 65;
> >                       block 66;
> >               done
> >       done > am
> >       sync
> >
> >       # Now replace those 101 distinct extents with 101 references to t=
he first extent
> >       btrfs-extent-same 131072 $(for x in $(seq 0 100); do echo am $((x=
 * 131072)); done) 2>&1 | tail
> >
> >       # Punch holes into the extent refs
> >       fallocate -v -d am
> >
> >       # Do some other stuff on the machine while this runs, and watch t=
he sha1sums change!
> >       while :; do echo $(sha1sum am); sysctl -q vm.drop_caches=3D{1,2,3=
}; sleep 1; done
> >
> >       root@rescue:/test# ./repro-hole-corruption-test
> >       i: 91, status: 0, bytes_deduped: 131072
> >       i: 92, status: 0, bytes_deduped: 131072
> >       i: 93, status: 0, bytes_deduped: 131072
> >       i: 94, status: 0, bytes_deduped: 131072
> >       i: 95, status: 0, bytes_deduped: 131072
> >       i: 96, status: 0, bytes_deduped: 131072
> >       i: 97, status: 0, bytes_deduped: 131072
> >       i: 98, status: 0, bytes_deduped: 131072
> >       i: 99, status: 0, bytes_deduped: 131072
> >       13107200 total bytes deduped in this operation
> >       am: 4.8 MiB (4964352 bytes) converted to sparse holes.
> >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> >       072a152355788c767b97e4e4c0e4567720988b84 am
> >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> >       bf00d862c6ad436a1be2be606a8ab88d22166b89 am
> >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> >       0d44cdf030fb149e103cfdc164da3da2b7474c17 am
> >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> >       60831f0e7ffe4b49722612c18685c09f4583b1df am
> >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> >       a19662b294a3ccdf35dbb18fdd72c62018526d7d am
> >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> >       ^C
> >
> > Corruption occurs most often when there is a sequence like this in a fi=
le:
> >
> >       ref 1: hole
> >       ref 2: extent A, offset 0
> >       ref 3: hole
> >       ref 4: extent A, offset 8192
> >
> > This scenario typically arises due to hole-punching or deduplication.
> > Hole-punching replaces one extent ref with two references to the same
> > extent with a hole between them, so:
> >
> >       ref 1:  extent A, offset 0, length 16384
> >
> > becomes:
> >
> >       ref 1:  extent A, offset 0, length 4096
> >       ref 2:  hole, length 8192
> >       ref 3:  extent A, offset 12288, length 4096
> >
> > Deduplication replaces two distinct extent refs surrounding a hole with
> > two references to one of the duplicate extents, turning this:
> >
> >       ref 1:  extent A, offset 0, length 4096
> >       ref 2:  hole, length 8192
> >       ref 3:  extent B, offset 0, length 4096
> >
> > into this:
> >
> >       ref 1:  extent A, offset 0, length 4096
> >       ref 2:  hole, length 8192
> >       ref 3:  extent A, offset 0, length 4096
> >
> > Compression is required (zlib, zstd, or lzo) for corruption to occur.
> > I am not able to reproduce the issue with an uncompressed extent nor
> > have I observed any such corruption in the wild.
> >
> > The presence or absence of the no-holes filesystem feature has no effec=
t.
> >
> > Ordinary writes can lead to pairs of extent references to the same exte=
nt
> > separated by a reference to a different extent; however, in this case
> > there is data to be read from a real extent, instead of pages that have
> > to be zero filled from a hole.  If ordinary non-hole writes could trigg=
er
> > this bug, every page-oriented database engine would be crashing all the
> > time on btrfs with compression enabled, and it's unlikely that would no=
t
> > have been noticed between 2015 and now.  An ordinary write that splits
> > an extent ref would look like this:
> >
> >       ref 1:  extent A, offset 0, length 4096
> >       ref 2:  extent C, offset 0, length 8192
> >       ref 3:  extent A, offset 12288, length 4096
> >
> > Sparse writes can lead to pairs of extent references surrounding a hole=
;
> > however, in this case the extent references will point to different
> > extents, avoiding the bug.  If a sparse write could trigger the bug,
> > the rsync -S option and qemu/kvm 'raw' disk image files (among many
> > other tools that produce sparse files) would be unusable, and it's
> > unlikely that would not have been noticed between 2015 and now either.
> > Sparse writes look like this:
> >
> >       ref 1:  extent A, offset 0, length 4096
> >       ref 2:  hole, length 8192
> >       ref 3:  extent B, offset 0, length 4096
> >
> > The pattern or timing of read() calls seems to be relevant.  It is very
> > hard to see the corruption when reading files with 'hd', but 'cat | hd'
> > will see the corruption just fine.  Similar problems exist with 'cmp'
> > but not 'sha1sum'.  Two processes reading the same file at the same tim=
e
> > seem to trigger the corruption very frequently.
> >
> > Some patterns of holes and data produce corruption faster than others.
> > The pattern generated by the script above is based on instances of
> > corruption I've found in the wild, and has a much better repro rate tha=
n
> > random holes.
> >
> > The corruption occurs during reads, after csum verification and before
> > decompression, so btrfs detects no csum failures.  The data on disk
> > seems to be OK and could be read correctly once the kernel bug is fixed=
.
> > Repeated reads do eventually return correct data, but there is no way
> > for userspace to distinguish between corrupt and correct data reliably.
> >
> > The corrupted data is usually data replaced by a hole or a copy of othe=
r
> > blocks in the same extent.
> >
> > The behavior is similar to some earlier bugs related to holes and
> > Compressed data in btrfs, but it's new and not fixed yet--hence,
> > "2018 edition."
>
>


--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
