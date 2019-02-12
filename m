Return-Path: <SRS0=Udpi=QT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0665DC282C4
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 17:56:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B52F9222BB
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 17:56:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G59Ml639"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728683AbfBLR4h (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Feb 2019 12:56:37 -0500
Received: from mail-ua1-f65.google.com ([209.85.222.65]:42392 "EHLO
        mail-ua1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727915AbfBLR4h (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Feb 2019 12:56:37 -0500
Received: by mail-ua1-f65.google.com with SMTP id d21so1178033uap.9
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Feb 2019 09:56:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=F4nm/Xag4EZpx9gkvvdCxccGlic9jbeUEDN+duZiROQ=;
        b=G59Ml639BpnFTwivzaWJArIgD+cNuaT8hCYGOgNfRNzM3M9F1UvbyPkneVwMMsbnpo
         5ssk4gZWByMg8ax2FQeXEvVZ5n8vkfhwUYF0RydwveAA9Tk602bvx1efxOu6PVJPWY++
         cEtDPo3DHpeBcqOK4nr0hxG4L7SKQ6f9bU5X8MrBhN0mPseuiIKAOqdcDiAKT/JKzhPK
         dxN2IFP4hk0+SNF9CIK0+ua04779nigP3PqoA7kpSVS3cN6J0upVgWhVhMrsj4Nzv7Dc
         B4etXY/632LB9TLhWJ6uOT3glB3W1AeT/h3sVmyWjpU89K1jGZoDaBx83P0IKuaVKkxo
         sqjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=F4nm/Xag4EZpx9gkvvdCxccGlic9jbeUEDN+duZiROQ=;
        b=efbiDD0j21RZeCHeOaqENDolTmKyIu8+AuWavZebAywdJn3ntXKuzRh9Gm29qAfhJh
         qEsx4+uShm4XNkTiwFED8tw2+dgXgQfbdxf67BSWGkKjKgQAktbPfJqQbpp6o97Ukm2K
         GmNnj6JL7RIR1/r/chNjLcGagfHgq9239NKzPe+8eifwzg/iPYnfVXtmzCIv1qm++GNn
         TqHJWpNUo0SgeMolfZnhbO5SFO5w4kaVgUZpHSjsKtJ0w4wqOgaCVfrnZSLnEaxTTrU1
         MZ/pZRGf49CpqGigJhBsfE4kI9aXFNhxmQJHq8CWMSkc0yF5jcsNTYX+LjEiFty6YavS
         arjg==
X-Gm-Message-State: AHQUAua+RnXe9Opqag8OwGlo9heEaMqp6+rC3pxVIi1hgcy/oulZ3SpF
        9domUfCs7EVuaqgYEZ5MjiMB2KByf1xZ5tIfjw3uEQ==
X-Google-Smtp-Source: AHgI3IbFc7W8MKIS0T7JJSsZVDdbnbLyEME3sPIpxj/JlV476gsR4cmXNRpFu4uMXYPXW3gFlEjovzibjwMGJsiYfTk=
X-Received: by 2002:ab0:30ba:: with SMTP id b26mr1965243uam.137.1549994195347;
 Tue, 12 Feb 2019 09:56:35 -0800 (PST)
MIME-Version: 1.0
References: <20180823031125.GE13528@hungrycats.org> <20190212030838.GB9995@hungrycats.org>
 <CAL3q7H7T_NX=D8qimRC55g8V-p0k-ygUiW-K5bxF02r-6XT6Rg@mail.gmail.com> <20190212165916.GA23918@hungrycats.org>
In-Reply-To: <20190212165916.GA23918@hungrycats.org>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Tue, 12 Feb 2019 17:56:24 +0000
Message-ID: <CAL3q7H6eTTw-iTHiQLcJHa5iRRspWxQpfyTQRU1SmcxBqXSppg@mail.gmail.com>
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

On Tue, Feb 12, 2019 at 5:01 PM Zygo Blaxell
<ce3g8jdj@umail.furryterror.org> wrote:
>
> On Tue, Feb 12, 2019 at 03:35:37PM +0000, Filipe Manana wrote:
> > On Tue, Feb 12, 2019 at 3:11 AM Zygo Blaxell
> > <ce3g8jdj@umail.furryterror.org> wrote:
> > >
> > > Still reproducible on 4.20.7.
> >
> > I tried your reproducer when you first reported it, on different
> > machines with different kernel versions.
>
> That would have been useful to know last August...  :-/
>
> > Never managed to reproduce it, nor see anything obviously wrong in
> > relevant code paths.
>
> I built a fresh VM running Debian stretch and
> reproduced the issue immediately.  Mount options are
> "rw,noatime,compress=3Dzlib,space_cache,subvolid=3D5,subvol=3D/".  Kernel=
 is
> Debian's "4.9.0-8-amd64" but the bug is old enough that kernel version
> probably doesn't matter.
>
> I don't have any configuration that can't reproduce this issue, so I don'=
t
> know how to help you.  I've tested AMD and Intel CPUs, VM, baremetal,
> hardware ranging in age from 0 to 9 years.  Locally built kernels from
> 4.1 to 4.20 and the stock Debian kernel (4.9).  SSDs and spinning rust.
> All of these reproduce the issue immediately--wrong sha1sum appears in
> the first 10 loops.
>
> What is your test environment?  I can try that here.

Debian unstable, all qemu vms, 4 cpus 4G to 8G ram iirc. Always built
from source kernels.
I have tested this when you reported it for 1 to 2 weeks in 2 or 3 vms
that kept running the test in an infinite loop during those weeks.
Don't recall what were the kernel versions (whatever was the latest at
the time), but that shouldn't matter according to what you say.

>
> > >
> > > The behavior is slightly different on current kernels (4.20.7, 4.14.9=
6)
> > > which makes the problem a bit more difficult to detect.
> > >
> > >         # repro-hole-corruption-test
> > >         i: 91, status: 0, bytes_deduped: 131072
> > >         i: 92, status: 0, bytes_deduped: 131072
> > >         i: 93, status: 0, bytes_deduped: 131072
> > >         i: 94, status: 0, bytes_deduped: 131072
> > >         i: 95, status: 0, bytes_deduped: 131072
> > >         i: 96, status: 0, bytes_deduped: 131072
> > >         i: 97, status: 0, bytes_deduped: 131072
> > >         i: 98, status: 0, bytes_deduped: 131072
> > >         i: 99, status: 0, bytes_deduped: 131072
> > >         13107200 total bytes deduped in this operation
> > >         am: 4.8 MiB (4964352 bytes) converted to sparse holes.
> > >         94a8acd3e1f6e14272f3262a8aa73ab6b25c9ce8 am
> > >         6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > >         6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > >         6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > >         6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > >         6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > >         6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > >
> > > The sha1sum seems stable after the first drop_caches--until a second
> > > process tries to read the test file:
> > >
> > >         6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > >         6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > >         # cat am > /dev/null              (in another shell)
> > >         19294e695272c42edb89ceee24bb08c13473140a am
> > >         6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > >
> > > On Wed, Aug 22, 2018 at 11:11:25PM -0400, Zygo Blaxell wrote:
> > > > This is a repro script for a btrfs bug that causes corrupted data r=
eads
> > > > when reading a mix of compressed extents and holes.  The bug is
> > > > reproducible on at least kernels v4.1..v4.18.
> > > >
> > > > Some more observations and background follow, but first here is the
> > > > script and some sample output:
> > > >
> > > >       root@rescue:/test# cat repro-hole-corruption-test
> > > >       #!/bin/bash
> > > >
> > > >       # Write a 4096 byte block of something
> > > >       block () { head -c 4096 /dev/zero | tr '\0' "\\$1"; }
> > > >
> > > >       # Here is some test data with holes in it:
> > > >       for y in $(seq 0 100); do
> > > >               for x in 0 1; do
> > > >                       block 0;
> > > >                       block 21;
> > > >                       block 0;
> > > >                       block 22;
> > > >                       block 0;
> > > >                       block 0;
> > > >                       block 43;
> > > >                       block 44;
> > > >                       block 0;
> > > >                       block 0;
> > > >                       block 61;
> > > >                       block 62;
> > > >                       block 63;
> > > >                       block 64;
> > > >                       block 65;
> > > >                       block 66;
> > > >               done
> > > >       done > am
> > > >       sync
> > > >
> > > >       # Now replace those 101 distinct extents with 101 references =
to the first extent
> > > >       btrfs-extent-same 131072 $(for x in $(seq 0 100); do echo am =
$((x * 131072)); done) 2>&1 | tail
> > > >
> > > >       # Punch holes into the extent refs
> > > >       fallocate -v -d am
> > > >
> > > >       # Do some other stuff on the machine while this runs, and wat=
ch the sha1sums change!
> > > >       while :; do echo $(sha1sum am); sysctl -q vm.drop_caches=3D{1=
,2,3}; sleep 1; done
> > > >
> > > >       root@rescue:/test# ./repro-hole-corruption-test
> > > >       i: 91, status: 0, bytes_deduped: 131072
> > > >       i: 92, status: 0, bytes_deduped: 131072
> > > >       i: 93, status: 0, bytes_deduped: 131072
> > > >       i: 94, status: 0, bytes_deduped: 131072
> > > >       i: 95, status: 0, bytes_deduped: 131072
> > > >       i: 96, status: 0, bytes_deduped: 131072
> > > >       i: 97, status: 0, bytes_deduped: 131072
> > > >       i: 98, status: 0, bytes_deduped: 131072
> > > >       i: 99, status: 0, bytes_deduped: 131072
> > > >       13107200 total bytes deduped in this operation
> > > >       am: 4.8 MiB (4964352 bytes) converted to sparse holes.
> > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > >       072a152355788c767b97e4e4c0e4567720988b84 am
> > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > >       bf00d862c6ad436a1be2be606a8ab88d22166b89 am
> > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > >       0d44cdf030fb149e103cfdc164da3da2b7474c17 am
> > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > >       60831f0e7ffe4b49722612c18685c09f4583b1df am
> > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > >       a19662b294a3ccdf35dbb18fdd72c62018526d7d am
> > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > >       ^C
> > > >
> > > > Corruption occurs most often when there is a sequence like this in =
a file:
> > > >
> > > >       ref 1: hole
> > > >       ref 2: extent A, offset 0
> > > >       ref 3: hole
> > > >       ref 4: extent A, offset 8192
> > > >
> > > > This scenario typically arises due to hole-punching or deduplicatio=
n.
> > > > Hole-punching replaces one extent ref with two references to the sa=
me
> > > > extent with a hole between them, so:
> > > >
> > > >       ref 1:  extent A, offset 0, length 16384
> > > >
> > > > becomes:
> > > >
> > > >       ref 1:  extent A, offset 0, length 4096
> > > >       ref 2:  hole, length 8192
> > > >       ref 3:  extent A, offset 12288, length 4096
> > > >
> > > > Deduplication replaces two distinct extent refs surrounding a hole =
with
> > > > two references to one of the duplicate extents, turning this:
> > > >
> > > >       ref 1:  extent A, offset 0, length 4096
> > > >       ref 2:  hole, length 8192
> > > >       ref 3:  extent B, offset 0, length 4096
> > > >
> > > > into this:
> > > >
> > > >       ref 1:  extent A, offset 0, length 4096
> > > >       ref 2:  hole, length 8192
> > > >       ref 3:  extent A, offset 0, length 4096
> > > >
> > > > Compression is required (zlib, zstd, or lzo) for corruption to occu=
r.
> > > > I am not able to reproduce the issue with an uncompressed extent no=
r
> > > > have I observed any such corruption in the wild.
> > > >
> > > > The presence or absence of the no-holes filesystem feature has no e=
ffect.
> > > >
> > > > Ordinary writes can lead to pairs of extent references to the same =
extent
> > > > separated by a reference to a different extent; however, in this ca=
se
> > > > there is data to be read from a real extent, instead of pages that =
have
> > > > to be zero filled from a hole.  If ordinary non-hole writes could t=
rigger
> > > > this bug, every page-oriented database engine would be crashing all=
 the
> > > > time on btrfs with compression enabled, and it's unlikely that woul=
d not
> > > > have been noticed between 2015 and now.  An ordinary write that spl=
its
> > > > an extent ref would look like this:
> > > >
> > > >       ref 1:  extent A, offset 0, length 4096
> > > >       ref 2:  extent C, offset 0, length 8192
> > > >       ref 3:  extent A, offset 12288, length 4096
> > > >
> > > > Sparse writes can lead to pairs of extent references surrounding a =
hole;
> > > > however, in this case the extent references will point to different
> > > > extents, avoiding the bug.  If a sparse write could trigger the bug=
,
> > > > the rsync -S option and qemu/kvm 'raw' disk image files (among many
> > > > other tools that produce sparse files) would be unusable, and it's
> > > > unlikely that would not have been noticed between 2015 and now eith=
er.
> > > > Sparse writes look like this:
> > > >
> > > >       ref 1:  extent A, offset 0, length 4096
> > > >       ref 2:  hole, length 8192
> > > >       ref 3:  extent B, offset 0, length 4096
> > > >
> > > > The pattern or timing of read() calls seems to be relevant.  It is =
very
> > > > hard to see the corruption when reading files with 'hd', but 'cat |=
 hd'
> > > > will see the corruption just fine.  Similar problems exist with 'cm=
p'
> > > > but not 'sha1sum'.  Two processes reading the same file at the same=
 time
> > > > seem to trigger the corruption very frequently.
> > > >
> > > > Some patterns of holes and data produce corruption faster than othe=
rs.
> > > > The pattern generated by the script above is based on instances of
> > > > corruption I've found in the wild, and has a much better repro rate=
 than
> > > > random holes.
> > > >
> > > > The corruption occurs during reads, after csum verification and bef=
ore
> > > > decompression, so btrfs detects no csum failures.  The data on disk
> > > > seems to be OK and could be read correctly once the kernel bug is f=
ixed.
> > > > Repeated reads do eventually return correct data, but there is no w=
ay
> > > > for userspace to distinguish between corrupt and correct data relia=
bly.
> > > >
> > > > The corrupted data is usually data replaced by a hole or a copy of =
other
> > > > blocks in the same extent.
> > > >
> > > > The behavior is similar to some earlier bugs related to holes and
> > > > Compressed data in btrfs, but it's new and not fixed yet--hence,
> > > > "2018 edition."
> > >
> > >
> >
> >
> > --
> > Filipe David Manana,
> >
> > =E2=80=9CWhether you think you can, or you think you can't =E2=80=94 yo=
u're right.=E2=80=9D
> >



--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
