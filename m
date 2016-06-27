Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:36550 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940AbcF0UyK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jun 2016 16:54:10 -0400
Received: by mail-oi0-f53.google.com with SMTP id f189so217598511oig.3
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Jun 2016 13:54:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQugDoR6fnPeion37FLS3LarjfP6dt+-Z3jPgLG0Xkmwg@mail.gmail.com>
References: <CAJCQCtR9uAn58KJKEjCsbyLYJTQVqMx-ghsVp_MjLBF-aiikcg@mail.gmail.com>
 <20160620204049.GA1986@hungrycats.org> <CAJCQCtR5pV53mFyGWxRxm69zwF5_sEvNRRRvOSgnZ1t8KZdc3g@mail.gmail.com>
 <20160621015559.GM15597@hungrycats.org> <CAJCQCtRUUd+moK25N3704ZG54cFrCw1-Uxm2QO-XF9g0=mHazw@mail.gmail.com>
 <20160622203504.GQ15597@hungrycats.org> <5790aea9-0976-1742-7d1b-79dbe44008c3@inwind.it>
 <CAJCQCtRXqSCFZTca+Vwraa0vS-MzLQKEkr=s41Vypc-O0ZDdxQ@mail.gmail.com>
 <20160624014752.GB14667@hungrycats.org> <576CB0DA.6030409@gmail.com>
 <20160624085014.GH3325@carfax.org.uk> <CAA91j0Uqg0FafFTG3NhQt=p8KkYRhTeMU5Bd+JuUxDntP6g8Ng@mail.gmail.com>
 <CAJCQCtQBQAng5_mNJZev+64Z15BSkBkG9f2qmz=ckPRqXRbbWA@mail.gmail.com>
 <576D6C0A.7070502@gmail.com> <CAJCQCtSskA4PC_a8tgQopHFNO83NQ=Gkx406haB7G0nBi5e=2A@mail.gmail.com>
 <c2a320a6-261b-723d-ab83-58f883e6315b@gmail.com> <CAJCQCtSqO4GNm8kBDuzUXEXYx+54zFgsD6=ARNsRgVUb53LQZw@mail.gmail.com>
 <fd7d250c-0a5a-ea3e-9ea2-ec6e50e14169@gmail.com> <CAJCQCtQugDoR6fnPeion37FLS3LarjfP6dt+-Z3jPgLG0Xkmwg@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 27 Jun 2016 14:54:07 -0600
Message-ID: <CAJCQCtSJuE3MAAgLAEU2akhKQiFSu8Oag+=GdSt-4S=BnLSQoA@mail.gmail.com>
Subject: Re: Adventures in btrfs raid5 disk recovery
To: Chris Murphy <lists@colorremedies.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Andrei Borzenkov <arvidjaar@gmail.com>,
        Hugo Mills <hugo@carfax.org.uk>,
        Zygo Blaxell <ce3g8jdj@umail.furryterror.org>, kreijack@inwind.it,
        Roman Mamedov <rm@romanrm.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For what it's worth I found btrfs-map-logical can produce mapping for
raid5 (didn't test raid6) by specifying the extent block length. If
that's omitted it only shows the device+mapping for the first strip.

This example is a 3 disk raid5, with a 128KiB file all in a single extent.

[root@f24s ~]# btrfs-map-logical -l 14157742080 /dev/VG/a
mirror 1 logical 14157742080 physical 1109327872 device /dev/mapper/VG-a
mirror 2 logical 14157742080 physical 2183069696 device /dev/mapper/VG-c

[root@f24s ~]# btrfs-map-logical -l 14157742080 -b 131072 /dev/VG/a
mirror 1 logical 14157742080 physical 1109327872 device /dev/mapper/VG-a
mirror 1 logical 14157807616 physical 1075773440 device /dev/mapper/VG-b
mirror 2 logical 14157742080 physical 2183069696 device /dev/mapper/VG-c
mirror 2 logical 14157807616 physical 2183069696 device /dev/mapper/VG-c

It's also possible to use -c and -o to copy the extent to a file and
more easily diff it with a control file, rather than using dd.

Chris Murphy
