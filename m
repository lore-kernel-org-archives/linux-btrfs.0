Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F324337417B
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Jul 2026 02:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783910771; cv=none; b=NsVwhCD7Z9+cuYWcEnpdElgm2c19uUYpGa+W/DBnnYPjwgimjHObdWEjhgOrOKe40MjcurR4s+Xmxb0YSSwHtIeADYC47cxmCdu2pWK64BU4S/q9xqy0eCPLfOEFh9XPPHg5rBiFHTRBOe3ibG6M+bY08v1w3YgkAfcAX6tEYjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783910771; c=relaxed/simple;
	bh=gSNzIs+/R9a2lUE/ofQKkpqwrPc8Y9NRK1g88URCIx8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jvj2JrnCoQMJUwtwoUsTpHC3ff6+wXjwOJUKsb6bIazBcdF0HAbk+4cj9JPtEna8+BljCN+9Q2/WKO1ItRcMLWKeUAp3msUJ04Fnjs3xU05Nuz+ZdjyAYNU0ohtXJFhZvdnxGO862iWiS1Zwmz+SyKt6vQRU9B0GANjb5+8c/LM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gompa.dev; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.160.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gompa.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-451d8064238so1187820fac.3
        for <linux-btrfs@vger.kernel.org>; Sun, 12 Jul 2026 19:46:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783910766; x=1784515566;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AQ6zbq45yQzMhb5arAv3r/dK1eobwpObzdoLOfAwDTo=;
        b=RtM96IKVLpadbNNP5rg4Kb1o8PeShL7UjQDMFu+J4bsEkZSYgFaIaze8mMxAOFitvm
         lL1fMT6Ozy2Ep3cjZ5NR1FIMDNeimruBCRwGWkZHQQm0e1n2/r4JUK+Ub+ym9IazePg1
         oJn+ADCj2KsMG1UmO/pMSLCR640Ix+Ok+Pov+yakL1gmSZA7WGDAUiiZkYInIF0qB06X
         RZsOVMR21LurlNWlRmoqHQojRzuVpY3EkKwlMSeC6HrxWCMGWEsiBIcPkosU0Bm7reWM
         g0y88Jn5RXtuaGM6vKbClC3X6oY4x1KFdEII15AdNsEv7afsNM7uuN+AySghWHQcjCw8
         nvLQ==
X-Forwarded-Encrypted: i=1; AFNElJ/t7oZ8T3TA2fkpCAyWr6GKFtx/7yOaEPnNe9CL7Udert1Q+TvHZX6QyYC26mgfuLgOnnIJgOKfTC9DGQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwDNJmr+Jmplq73R10oldtFBaqBqWCP9GEiDZWaNuCPurmJBU3A
	8BwewRC41EmSi5mIRY5SbnXh9UWc+SHGFDsIwb5ioJGY8iTIT2B9bXbkaNwBSw==
X-Gm-Gg: AfdE7clPlnYtMIPg0+gr2ET9fGyDkz4+9An7/+KJyTAWVNtEwik+8uhDG6ZaN8bI1BV
	oVinAP9jazZnCUYyPcKoM58HB0/omeSNq6/Clte0WbJEGH7iDqvmh8kFJf62GHBIQrGvYAbPzN+
	8gBfmBiHq+vGtsbLLXRzhhhMxw+9aTRoB/j3ez/O12+0zkwod1SU+dnEtJOuQNIRbhVZyOvW1g0
	88ZNHRQ/sF9lPwF3o6xpJU8u7W4kp9nOWyzcyaBt1FyYcstteZGIXBxP9r92YLyX1yhetgMUFwH
	Z+r/5rwxhCl4REJu2EyD45yVzYWd24B9TMvXlNMrIwHZoA8OV5fGmGvBso+z692c0rc5PoM1WcJ
	1JxwpO19ZDyT2sUhwRy46lopJ8xQnp11GnG0YCpOlQVI1gDhX4dgKRXU8FcGjFes5AsIr8RlfYa
	9LV5eU/9trGm/C2ngjBXBc8D8kWA1LkY6pR3yIx6znliN4H6qmk4iobQDk7Grt8b/3jqknDmWv9
	dDOHlpz092S6L+ekDeei+JRKqO4GkM1NbKnP/iFerRU+0s5TG7pDluexaWWkho=
X-Received: by 2002:a05:6871:5225:b0:440:e191:b095 with SMTP id 586e51a60fabf-451f0faf466mr4529680fac.3.1783910765656;
        Sun, 12 Jul 2026 19:46:05 -0700 (PDT)
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com. [209.85.210.51])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-455ad91df9esm3284381fac.9.2026.07.12.19.46.05
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Jul 2026 19:46:05 -0700 (PDT)
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-7ec1e9d3359so472289a34.0
        for <linux-btrfs@vger.kernel.org>; Sun, 12 Jul 2026 19:46:05 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8kNNS9KWpLtNPe4ynXlTbu2eAS4EgyEzWlhIq+ygIsH/4yu8aj+MSLrIitkZ1QcEAMAh/s4Z70fORKnQ==@vger.kernel.org
X-Received: by 2002:a05:6830:6519:b0:7e9:b537:102d with SMTP id
 46e09a7af769-7ec098288d6mr4552141a34.26.1783910764779; Sun, 12 Jul 2026
 19:46:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260712-reflink-into-nodatasum-v1-0-9f27ef836073@amutable.com>
 <CAEg-Je86cbtNvESfK5MeVXVezZfMFE8qVdX900F3ayQsC+yQNg@mail.gmail.com> <2490a56e-ad0b-43b7-8ef0-02dacbc10ecc@suse.com>
In-Reply-To: <2490a56e-ad0b-43b7-8ef0-02dacbc10ecc@suse.com>
From: Neal Gompa <neal@gompa.dev>
Date: Sun, 12 Jul 2026 22:45:28 -0400
X-Gmail-Original-Message-ID: <CAEg-Je-x_RGCrK7zBYRLh9N21iy5zon+FYMOoBs2Xvjuz0POEw@mail.gmail.com>
X-Gm-Features: AVVi8CdFLSTX_h06etq7oRlvfRQ8fF80Dk32Am0QUlcLK7rcx9jrTxkfyeD4nSs
Message-ID: <CAEg-Je-x_RGCrK7zBYRLh9N21iy5zon+FYMOoBs2Xvjuz0POEw@mail.gmail.com>
Subject: Re: [PATCH 0/2] btrfs: allow reflinks into NODATASUM files
To: Qu Wenruo <wqu@suse.com>
Cc: daan@amutable.com, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 12, 2026 at 6:19=E2=80=AFPM Qu Wenruo <wqu@suse.com> wrote:
>
>
>
> =E5=9C=A8 2026/7/13 00:36, Neal Gompa =E5=86=99=E9=81=93:
> > On Sun, Jul 12, 2026 at 10:25=E2=80=AFAM Daan De Meyer via B4 Relay
> > <devnull+daan.amutable.com@kernel.org> wrote:
> >>
> >> The primary use case for this series is building a NOCOW VM image from
> >> individual partition images that are COW and checksummed. Today those
> >> partitions cannot be cloned into the NODATACOW and NODATASUM destinati=
on,
> >> so tools fall back to a full copy. This makes provisioning slower and
> >> duplicates all of the image data up front.
> >>
> >> Allow cloning and deduplication from a checksummed file into a NODATAS=
UM
> >> file. The VM image can then share extents with the partition images.
> >> Existing checksummed extents are COWed once when modified, protecting =
the
> >> source checksums, while newly allocated extents use the destination's
> >> normal NOCOW behavior.
> >>
> >> The reverse direction remains rejected because the destination would
> >> expect checksums that do not exist.
> >>
> >> Patch 1 prevents swap activation from bypassing the COW protection whe=
n a
> >> NODATASUM file references checksummed extents. Patch 2 relaxes the ref=
link
> >> restriction in the safe direction.
> >>
> >> The xfstests branch is available at:
> >> https://github.com/kdave/xfstests/pull/6
> >>
> >> Signed-off-by: Daan De Meyer <daan@amutable.com>
> >> ---
> >> Daan De Meyer (2):
> >>        btrfs: reject swapfile activation if any extent has checksums
> >>        btrfs: allow reflinking from checksummed files into nodatasum f=
iles
> >>
> >>   fs/btrfs/inode.c   | 29 +++++++++++++++++++++++++++++
> >>   fs/btrfs/reflink.c | 18 ++++++++++++++----
> >>   2 files changed, 43 insertions(+), 4 deletions(-)
> >> ---
> >> base-commit: cab9e339cfbc1a4e075e53e281dfb00391e1a6bb
> >> change-id: 20260712-reflink-into-nodatasum-aff962f3794e
> >>
> >
> > The patch series looks good to me.
> >
> > Reviewed-by: Neal Gompa <neal@gompa.dev>
>
> I appreciate your feedback as an end user/sys admin, but I doubt if you
> really understand the requirement or tried the patch by yourself.
>
> I'd appreciate if you put more weight behind your reviewed-by tags.
>

I already don't review patches very often because of responses like
this. Please don't make me feel like I should pull out entirely.

> >
> > That said, I have a question: Is there no reason we couldn't reflink
> > into a checksummed area and generate *new* checksums for that purpose?
> > That would be useful for staging for regular backup.
>
> Because btrfs' NODATASUM/NODATACOW flag is per-inode, as that's the only
> way we can store that flag.
>
> If you really want proper per-extent NODATASUM/NODATACOW, there will
> need a huge change in the on-disk format, e.g. introducing new flags
> into btrfs_file_extent_item, and do the extra work handling corner cases
> like preallocation.
>
> It's definitely not as simple two small patches.
>

I wasn't implying that it was simple. I asked the question because the
patches themselves don't explain why it's not done, only that it's
"not safe". That is not a sufficient enough answer in my book. And
while I can intuit the reason from my own experience working on CoW
stuff before, I wanted to know why it was dismissed as "unsafe" when I
am aware of ways for it to be done.

> >
> > I can foresee that being useful for archiving OS trees or VM images as
> > snapshots by creating checksums for the newly created snapshots...
>
> Nope, one should not combine VM images with snapshots on btrfs.
>
> Even if we have fixed all the direct IO problems, the extent bookend
> will waste a lot of space.
>

In the real world, this combination happens *a lot*. In fact, multiple
businesses are built on this idea (though not using Btrfs
specifically). It is not out of the realm of possibility to me that
Btrfs would support it and that the weaknesses could be minimized.
Throwing the idea completely out is beyond silly because of how common
containers and virtual machines are. Both are used more and more, even
without people knowing it, so the idea that we shouldn't at least look
at making that pattern workable seems foolhardy.


--=20
=E7=9C=9F=E5=AE=9F=E3=81=AF=E3=81=84=E3=81=A4=E3=82=82=E4=B8=80=E3=81=A4=EF=
=BC=81/ Always, there's only one truth!
