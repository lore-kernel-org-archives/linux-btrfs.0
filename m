Return-Path: <SRS0=zIgm=QV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A19B0C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Feb 2019 01:23:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5148A222C9
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Feb 2019 01:23:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iCe8xhLU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729935AbfBNBXD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 13 Feb 2019 20:23:03 -0500
Received: from mail-vs1-f65.google.com ([209.85.217.65]:32997 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729745AbfBNBXC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Feb 2019 20:23:02 -0500
Received: by mail-vs1-f65.google.com with SMTP id u13so1688914vsk.0
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Feb 2019 17:23:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=FUF+FEysERXbPOom7Aiv9nU2X3Q/WbdFq1rHTmjyNeI=;
        b=iCe8xhLULrcV4c/UhD7T+s7BVVSMGCIX7kNCRxwzfZHh3P7zGrtOBdQALhiav1UUZe
         N2H33jJoZ1EUat/QHmtpC5jNFthB/J//pGTXwRyAPmoPI+oiNNmmPlygB8ggqJU6ygjN
         mAZqrTp7sjI7MCqIrFXnnbShg+suO2ubA6Zh4/9eNFTLIO0+zzwtQckvdQ4dylMut81T
         DCDBpHZEmO7wYwlAZApTVnefmeJKdwezvqfBlen08/7XhAxq2t4FvyHng8/3mZY8Ri7I
         L8RzXDvw/yoJ3dHCSC4cM3klzawXQG31LMJ31I56kU5hOHUthm5nLV7HAALdbdshmSYr
         NoxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=FUF+FEysERXbPOom7Aiv9nU2X3Q/WbdFq1rHTmjyNeI=;
        b=QLSj1Ou3FYtjfS9ijxY0zUZz/uToDlPYXlEmMnkp2c4FPg28erM2SSl5/a7mFNjlnf
         Qzxt3Vo9WW8u2DftrpGIP3wDYGXvJAyFkwx6B93horqPZpveG+RtddyS7wfYqQbeoQS8
         gTYwELfU+I94wZLREBj/2xW/yg1ov6bmHEsoSaVa6veW0EMH1NGtb1CARHbwUTcO4U3o
         r72PDnTe8p4OPt+wcdXyjMXr8yYkrpEqb3VnIS7s53y++ZJgIapv0aKSRp/GrDBqpCpX
         yWEOnZ+d9kiudwj9uBxAojSMAsf9cMHP4DfHra58aAcm/A+i607me9ry1WGtnInbbeWm
         +aQQ==
X-Gm-Message-State: AHQUAub9+sBKuvWCxUyrLRSRFr879PEoHPvmRjzt/IQsgwP81xbVRw7B
        YNrX4ch6i7+MwokOaZnY2KD2ZShePgoSw0nqy0h4/+1g
X-Google-Smtp-Source: AHgI3IYl38ujaiOeu8f2LRPxv2692axBS+BAXix5N4ipE9Fx3MEXA2LIKTPyf5KCJsJr5cGQc9/bZYbjSQYR7xsiFiA=
X-Received: by 2002:a67:8106:: with SMTP id c6mr553276vsd.99.1550107380700;
 Wed, 13 Feb 2019 17:23:00 -0800 (PST)
MIME-Version: 1.0
References: <20180823031125.GE13528@hungrycats.org> <20190212030838.GB9995@hungrycats.org>
 <CAL3q7H7T_NX=D8qimRC55g8V-p0k-ygUiW-K5bxF02r-6XT6Rg@mail.gmail.com>
 <20190212165916.GA23918@hungrycats.org> <CAL3q7H6eTTw-iTHiQLcJHa5iRRspWxQpfyTQRU1SmcxBqXSppg@mail.gmail.com>
 <20190212181328.GB23918@hungrycats.org> <CAL3q7H4k=N=0Cv8hYAZkfTfaG8XJgG1KzT5mA_4XnutxGFc8DA@mail.gmail.com>
 <CAL3q7H6YShEBKDTDZ7_qBoLDMgihP_8NYee_60-LUqd6sF5xZQ@mail.gmail.com>
In-Reply-To: <CAL3q7H6YShEBKDTDZ7_qBoLDMgihP_8NYee_60-LUqd6sF5xZQ@mail.gmail.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Thu, 14 Feb 2019 01:22:49 +0000
Message-ID: <CAL3q7H6WSe_C7_+D0x1_Z+KdK=k+iM-t2J4pQSO32ZsY4AEZ=Q@mail.gmail.com>
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

On Wed, Feb 13, 2019 at 6:14 PM Filipe Manana <fdmanana@gmail.com> wrote:
>
> On Wed, Feb 13, 2019 at 5:36 PM Filipe Manana <fdmanana@gmail.com> wrote:
> >
> > On Tue, Feb 12, 2019 at 6:14 PM Zygo Blaxell
> > <ce3g8jdj@umail.furryterror.org> wrote:
> > >
> > > On Tue, Feb 12, 2019 at 05:56:24PM +0000, Filipe Manana wrote:
> > > > On Tue, Feb 12, 2019 at 5:01 PM Zygo Blaxell
> > > > <ce3g8jdj@umail.furryterror.org> wrote:
> > > > >
> > > > > On Tue, Feb 12, 2019 at 03:35:37PM +0000, Filipe Manana wrote:
> > > > > > On Tue, Feb 12, 2019 at 3:11 AM Zygo Blaxell
> > > > > > <ce3g8jdj@umail.furryterror.org> wrote:
> > > > > > >
> > > > > > > Still reproducible on 4.20.7.
> > > > > >
> > > > > > I tried your reproducer when you first reported it, on differen=
t
> > > > > > machines with different kernel versions.
> > > > >
> > > > > That would have been useful to know last August...  :-/
> > > > >
> > > > > > Never managed to reproduce it, nor see anything obviously wrong=
 in
> > > > > > relevant code paths.
> > > > >
> > > > > I built a fresh VM running Debian stretch and
> > > > > reproduced the issue immediately.  Mount options are
> > > > > "rw,noatime,compress=3Dzlib,space_cache,subvolid=3D5,subvol=3D/".=
  Kernel is
> > > > > Debian's "4.9.0-8-amd64" but the bug is old enough that kernel ve=
rsion
> > > > > probably doesn't matter.
> > > > >
> > > > > I don't have any configuration that can't reproduce this issue, s=
o I don't
> > > > > know how to help you.  I've tested AMD and Intel CPUs, VM, bareme=
tal,
> > > > > hardware ranging in age from 0 to 9 years.  Locally built kernels=
 from
> > > > > 4.1 to 4.20 and the stock Debian kernel (4.9).  SSDs and spinning=
 rust.
> > > > > All of these reproduce the issue immediately--wrong sha1sum appea=
rs in
> > > > > the first 10 loops.
> > > > >
> > > > > What is your test environment?  I can try that here.
> > > >
> > > > Debian unstable, all qemu vms, 4 cpus 4G to 8G ram iirc.
> > >
> > > I have several environments like that...
> > >
> > > > Always built from source kernels.
> > >
> > > ...that could be a relevant difference.  Have you tried a stock
> > > Debian kernel?
> > >
> > > > I have tested this when you reported it for 1 to 2 weeks in 2 or 3 =
vms
> > > > that kept running the test in an infinite loop during those weeks.
> > > > Don't recall what were the kernel versions (whatever was the latest=
 at
> > > > the time), but that shouldn't matter according to what you say.
> > >
> > > That's an extremely long time compared to the rate of occurrence
> > > of this bug.  It should appear in only a few seconds of testing.
> > > Some data-hole-data patterns reproduce much slower (change the positi=
on
> > > of "block 0" lines in the setup script), but "slower" is minutes,
> > > not machine-months.
> > >
> > > Is your filesystem compressed?  Does compsize show the test
> > > file 'am' is compressed during the test?  Is the sha1sum you get
> > > 6926a34e0ab3e0a023e8ea85a650f5b4217acab4?  Does the sha1sum change
> > > when a second process reads the file while the sha1sum/drop_caches lo=
op
> > > is running?
> >
> > Tried it today and I got it reproduced (different vm, but still debian
> > and kernel built from source).
> > Not sure what was different last time. Yes, I had compression enabled.
> >
> > I'll look into it.
>
> So the problem is caused by hole punching. The script can be reduced
> to the following:
>
> https://friendpaste.com/22t4OdktHQTl0aMGxckc86
>
> file size: 384K am
> digests after file creation:   7c8349cc657fbe61af53fbc5cfacae6e9a402e83  =
am
> digests after file creation 2: 7c8349cc657fbe61af53fbc5cfacae6e9a402e83  =
am
> 262144 total bytes deduped in this operation
> digests after dedupe:          7c8349cc657fbe61af53fbc5cfacae6e9a402e83  =
am
> digests after dedupe 2:        7c8349cc657fbe61af53fbc5cfacae6e9a402e83  =
am
> am: 24 KiB (24576 bytes) converted to sparse holes.
> digests after hole punching:   7c8349cc657fbe61af53fbc5cfacae6e9a402e83  =
am
> digests after hole punching 2: 5a357b64f4004ea38dbc7058c64a5678668420da  =
am
>
> So hole punching is screwing things, and only after dropping the page
> cache we can see the bug.
> I'll send a fix likely tomorrow.

So it turns out it's a problem in the read of compressed extents part,
a variant of a bug I found back in 2015:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3D005efedf2c7d0a270ffbe28d8997b03844f3e3e7

The following one liner fixes it:
https://friendpaste.com/22t4OdktHQTl0aMGxcWLj3

While you test it there (if you want/can), I'll write a change log and
a proper test case for fstests and submit them later.

Thanks!
>
> >
> > >
> > > > > > >
> > > > > > > The behavior is slightly different on current kernels (4.20.7=
, 4.14.96)
> > > > > > > which makes the problem a bit more difficult to detect.
> > > > > > >
> > > > > > >         # repro-hole-corruption-test
> > > > > > >         i: 91, status: 0, bytes_deduped: 131072
> > > > > > >         i: 92, status: 0, bytes_deduped: 131072
> > > > > > >         i: 93, status: 0, bytes_deduped: 131072
> > > > > > >         i: 94, status: 0, bytes_deduped: 131072
> > > > > > >         i: 95, status: 0, bytes_deduped: 131072
> > > > > > >         i: 96, status: 0, bytes_deduped: 131072
> > > > > > >         i: 97, status: 0, bytes_deduped: 131072
> > > > > > >         i: 98, status: 0, bytes_deduped: 131072
> > > > > > >         i: 99, status: 0, bytes_deduped: 131072
> > > > > > >         13107200 total bytes deduped in this operation
> > > > > > >         am: 4.8 MiB (4964352 bytes) converted to sparse holes=
.
> > > > > > >         94a8acd3e1f6e14272f3262a8aa73ab6b25c9ce8 am
> > > > > > >         6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > > > > >         6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > > > > >         6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > > > > >         6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > > > > >         6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > > > > >         6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > > > > >
> > > > > > > The sha1sum seems stable after the first drop_caches--until a=
 second
> > > > > > > process tries to read the test file:
> > > > > > >
> > > > > > >         6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > > > > >         6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > > > > >         # cat am > /dev/null              (in another shell)
> > > > > > >         19294e695272c42edb89ceee24bb08c13473140a am
> > > > > > >         6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > > > > >
> > > > > > > On Wed, Aug 22, 2018 at 11:11:25PM -0400, Zygo Blaxell wrote:
> > > > > > > > This is a repro script for a btrfs bug that causes corrupte=
d data reads
> > > > > > > > when reading a mix of compressed extents and holes.  The bu=
g is
> > > > > > > > reproducible on at least kernels v4.1..v4.18.
> > > > > > > >
> > > > > > > > Some more observations and background follow, but first her=
e is the
> > > > > > > > script and some sample output:
> > > > > > > >
> > > > > > > >       root@rescue:/test# cat repro-hole-corruption-test
> > > > > > > >       #!/bin/bash
> > > > > > > >
> > > > > > > >       # Write a 4096 byte block of something
> > > > > > > >       block () { head -c 4096 /dev/zero | tr '\0' "\\$1"; }
> > > > > > > >
> > > > > > > >       # Here is some test data with holes in it:
> > > > > > > >       for y in $(seq 0 100); do
> > > > > > > >               for x in 0 1; do
> > > > > > > >                       block 0;
> > > > > > > >                       block 21;
> > > > > > > >                       block 0;
> > > > > > > >                       block 22;
> > > > > > > >                       block 0;
> > > > > > > >                       block 0;
> > > > > > > >                       block 43;
> > > > > > > >                       block 44;
> > > > > > > >                       block 0;
> > > > > > > >                       block 0;
> > > > > > > >                       block 61;
> > > > > > > >                       block 62;
> > > > > > > >                       block 63;
> > > > > > > >                       block 64;
> > > > > > > >                       block 65;
> > > > > > > >                       block 66;
> > > > > > > >               done
> > > > > > > >       done > am
> > > > > > > >       sync
> > > > > > > >
> > > > > > > >       # Now replace those 101 distinct extents with 101 ref=
erences to the first extent
> > > > > > > >       btrfs-extent-same 131072 $(for x in $(seq 0 100); do =
echo am $((x * 131072)); done) 2>&1 | tail
> > > > > > > >
> > > > > > > >       # Punch holes into the extent refs
> > > > > > > >       fallocate -v -d am
> > > > > > > >
> > > > > > > >       # Do some other stuff on the machine while this runs,=
 and watch the sha1sums change!
> > > > > > > >       while :; do echo $(sha1sum am); sysctl -q vm.drop_cac=
hes=3D{1,2,3}; sleep 1; done
> > > > > > > >
> > > > > > > >       root@rescue:/test# ./repro-hole-corruption-test
> > > > > > > >       i: 91, status: 0, bytes_deduped: 131072
> > > > > > > >       i: 92, status: 0, bytes_deduped: 131072
> > > > > > > >       i: 93, status: 0, bytes_deduped: 131072
> > > > > > > >       i: 94, status: 0, bytes_deduped: 131072
> > > > > > > >       i: 95, status: 0, bytes_deduped: 131072
> > > > > > > >       i: 96, status: 0, bytes_deduped: 131072
> > > > > > > >       i: 97, status: 0, bytes_deduped: 131072
> > > > > > > >       i: 98, status: 0, bytes_deduped: 131072
> > > > > > > >       i: 99, status: 0, bytes_deduped: 131072
> > > > > > > >       13107200 total bytes deduped in this operation
> > > > > > > >       am: 4.8 MiB (4964352 bytes) converted to sparse holes=
.
> > > > > > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > > > > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > > > > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > > > > > >       072a152355788c767b97e4e4c0e4567720988b84 am
> > > > > > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > > > > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > > > > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > > > > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > > > > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > > > > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > > > > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > > > > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > > > > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > > > > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > > > > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > > > > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > > > > > >       bf00d862c6ad436a1be2be606a8ab88d22166b89 am
> > > > > > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > > > > > >       0d44cdf030fb149e103cfdc164da3da2b7474c17 am
> > > > > > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > > > > > >       60831f0e7ffe4b49722612c18685c09f4583b1df am
> > > > > > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > > > > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > > > > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > > > > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > > > > > >       a19662b294a3ccdf35dbb18fdd72c62018526d7d am
> > > > > > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > > > > > >       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > > > > > > >       ^C
> > > > > > > >
> > > > > > > > Corruption occurs most often when there is a sequence like =
this in a file:
> > > > > > > >
> > > > > > > >       ref 1: hole
> > > > > > > >       ref 2: extent A, offset 0
> > > > > > > >       ref 3: hole
> > > > > > > >       ref 4: extent A, offset 8192
> > > > > > > >
> > > > > > > > This scenario typically arises due to hole-punching or dedu=
plication.
> > > > > > > > Hole-punching replaces one extent ref with two references t=
o the same
> > > > > > > > extent with a hole between them, so:
> > > > > > > >
> > > > > > > >       ref 1:  extent A, offset 0, length 16384
> > > > > > > >
> > > > > > > > becomes:
> > > > > > > >
> > > > > > > >       ref 1:  extent A, offset 0, length 4096
> > > > > > > >       ref 2:  hole, length 8192
> > > > > > > >       ref 3:  extent A, offset 12288, length 4096
> > > > > > > >
> > > > > > > > Deduplication replaces two distinct extent refs surrounding=
 a hole with
> > > > > > > > two references to one of the duplicate extents, turning thi=
s:
> > > > > > > >
> > > > > > > >       ref 1:  extent A, offset 0, length 4096
> > > > > > > >       ref 2:  hole, length 8192
> > > > > > > >       ref 3:  extent B, offset 0, length 4096
> > > > > > > >
> > > > > > > > into this:
> > > > > > > >
> > > > > > > >       ref 1:  extent A, offset 0, length 4096
> > > > > > > >       ref 2:  hole, length 8192
> > > > > > > >       ref 3:  extent A, offset 0, length 4096
> > > > > > > >
> > > > > > > > Compression is required (zlib, zstd, or lzo) for corruption=
 to occur.
> > > > > > > > I am not able to reproduce the issue with an uncompressed e=
xtent nor
> > > > > > > > have I observed any such corruption in the wild.
> > > > > > > >
> > > > > > > > The presence or absence of the no-holes filesystem feature =
has no effect.
> > > > > > > >
> > > > > > > > Ordinary writes can lead to pairs of extent references to t=
he same extent
> > > > > > > > separated by a reference to a different extent; however, in=
 this case
> > > > > > > > there is data to be read from a real extent, instead of pag=
es that have
> > > > > > > > to be zero filled from a hole.  If ordinary non-hole writes=
 could trigger
> > > > > > > > this bug, every page-oriented database engine would be cras=
hing all the
> > > > > > > > time on btrfs with compression enabled, and it's unlikely t=
hat would not
> > > > > > > > have been noticed between 2015 and now.  An ordinary write =
that splits
> > > > > > > > an extent ref would look like this:
> > > > > > > >
> > > > > > > >       ref 1:  extent A, offset 0, length 4096
> > > > > > > >       ref 2:  extent C, offset 0, length 8192
> > > > > > > >       ref 3:  extent A, offset 12288, length 4096
> > > > > > > >
> > > > > > > > Sparse writes can lead to pairs of extent references surrou=
nding a hole;
> > > > > > > > however, in this case the extent references will point to d=
ifferent
> > > > > > > > extents, avoiding the bug.  If a sparse write could trigger=
 the bug,
> > > > > > > > the rsync -S option and qemu/kvm 'raw' disk image files (am=
ong many
> > > > > > > > other tools that produce sparse files) would be unusable, a=
nd it's
> > > > > > > > unlikely that would not have been noticed between 2015 and =
now either.
> > > > > > > > Sparse writes look like this:
> > > > > > > >
> > > > > > > >       ref 1:  extent A, offset 0, length 4096
> > > > > > > >       ref 2:  hole, length 8192
> > > > > > > >       ref 3:  extent B, offset 0, length 4096
> > > > > > > >
> > > > > > > > The pattern or timing of read() calls seems to be relevant.=
  It is very
> > > > > > > > hard to see the corruption when reading files with 'hd', bu=
t 'cat | hd'
> > > > > > > > will see the corruption just fine.  Similar problems exist =
with 'cmp'
> > > > > > > > but not 'sha1sum'.  Two processes reading the same file at =
the same time
> > > > > > > > seem to trigger the corruption very frequently.
> > > > > > > >
> > > > > > > > Some patterns of holes and data produce corruption faster t=
han others.
> > > > > > > > The pattern generated by the script above is based on insta=
nces of
> > > > > > > > corruption I've found in the wild, and has a much better re=
pro rate than
> > > > > > > > random holes.
> > > > > > > >
> > > > > > > > The corruption occurs during reads, after csum verification=
 and before
> > > > > > > > decompression, so btrfs detects no csum failures.  The data=
 on disk
> > > > > > > > seems to be OK and could be read correctly once the kernel =
bug is fixed.
> > > > > > > > Repeated reads do eventually return correct data, but there=
 is no way
> > > > > > > > for userspace to distinguish between corrupt and correct da=
ta reliably.
> > > > > > > >
> > > > > > > > The corrupted data is usually data replaced by a hole or a =
copy of other
> > > > > > > > blocks in the same extent.
> > > > > > > >
> > > > > > > > The behavior is similar to some earlier bugs related to hol=
es and
> > > > > > > > Compressed data in btrfs, but it's new and not fixed yet--h=
ence,
> > > > > > > > "2018 edition."
> > > > > > >
> > > > > > >
> > > > > >
> > > > > >
> > > > > > --
> > > > > > Filipe David Manana,
> > > > > >
> > > > > > =E2=80=9CWhether you think you can, or you think you can't =E2=
=80=94 you're right.=E2=80=9D
> > > > > >
> > > >
> > > >
> > > >
> > > > --
> > > > Filipe David Manana,
> > > >
> > > > =E2=80=9CWhether you think you can, or you think you can't =E2=80=
=94 you're right.=E2=80=9D
> > > >
> >
> >
> >
> > --
> > Filipe David Manana,
> >
> > =E2=80=9CWhether you think you can, or you think you can't =E2=80=94 yo=
u're right.=E2=80=9D
>
>
>
> --
> Filipe David Manana,
>
> =E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you'=
re right.=E2=80=9D



--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
