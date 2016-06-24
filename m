Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:36610 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbcFXQw4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jun 2016 12:52:56 -0400
Received: by mail-oi0-f53.google.com with SMTP id f189so123046220oig.3
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Jun 2016 09:52:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160624085014.GH3325@carfax.org.uk>
References: <CAJCQCtR9uAn58KJKEjCsbyLYJTQVqMx-ghsVp_MjLBF-aiikcg@mail.gmail.com>
 <20160620204049.GA1986@hungrycats.org> <CAJCQCtR5pV53mFyGWxRxm69zwF5_sEvNRRRvOSgnZ1t8KZdc3g@mail.gmail.com>
 <20160621015559.GM15597@hungrycats.org> <CAJCQCtRUUd+moK25N3704ZG54cFrCw1-Uxm2QO-XF9g0=mHazw@mail.gmail.com>
 <20160622203504.GQ15597@hungrycats.org> <5790aea9-0976-1742-7d1b-79dbe44008c3@inwind.it>
 <CAJCQCtRXqSCFZTca+Vwraa0vS-MzLQKEkr=s41Vypc-O0ZDdxQ@mail.gmail.com>
 <20160624014752.GB14667@hungrycats.org> <576CB0DA.6030409@gmail.com> <20160624085014.GH3325@carfax.org.uk>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 24 Jun 2016 10:52:53 -0600
Message-ID: <CAJCQCtR1Bbh4atCu+oo7VpKwN4H14M6-mZrKcCSvszRa=cC13g@mail.gmail.com>
Subject: Re: Adventures in btrfs raid5 disk recovery
To: Hugo Mills <hugo@carfax.org.uk>, Andrei Borzenkov <arvidjaar@gmail.com>,
        Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        Chris Murphy <lists@colorremedies.com>, kreijack@inwind.it,
        Roman Mamedov <rm@romanrm.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 24, 2016 at 2:50 AM, Hugo Mills <hugo@carfax.org.uk> wrote:

>    Checksums are not parity, correct. However, every data block
> (including, I think, the parity) is checksummed and put into the csum
> tree.

I don't see how parity is checksummed. It definitely is not in the
csum tree. Two file systems, one raid5, one single, each with a single
identical file:

raid5
    item 0 key (EXTENT_CSUM EXTENT_CSUM 12009865216) itemoff 16155 itemsize 128
        extent csum item

single

    item 0 key (EXTENT_CSUM EXTENT_CSUM 2168717312) itemoff 16155 itemsize 128
        extent csum item

That's the only entry in the csum tree. The raid5 one is not 33.33%
bigger to account for the extra parity being checksummed.

Now, if parity is used to reconstruction of data, that data *is*
checksummed so if it fails checksum after reconstruction the
information is available to determine it was incorrectly
reconstructed. The notes in btrfs/raid56.c recognize the possibility
of parity corruption and how to handle it. But I think that corruption
is inferred. Maybe the parity csums are in some other metadata item,
but I don't see how it's in the csum tree.


-- 
Chris Murphy
