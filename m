Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f179.google.com ([209.85.216.179]:35732 "EHLO
	mail-qt0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbcGUOCJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jul 2016 10:02:09 -0400
Received: by mail-qt0-f179.google.com with SMTP id x25so44314854qtx.2
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Jul 2016 07:02:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRGtax_ovqA8Xb3DzmeTp=pJkpS0J1hGpe2PongFhfSpg@mail.gmail.com>
References: <b2b863cf-214a-6774-27a4-c41208a578ff@friedels.name>
 <56C7BB16-91D2-42AB-B81A-33403CAFE0ED@gmail.com> <9d52a64a-eb5a-e626-2c62-2ff9bede2eef@friedels.name>
 <CAKinxcUBhsh_b6en_4B9cQ77UPMTtbYPusedPegucW3ZP0Fkuw@mail.gmail.com>
 <0e3dfcb6-c635-5904-9e97-1aa11a84dcd4@friedels.name> <CAJCQCtQNt6fBR85opSHfWuKCzH=-2-pF3ctsWsTF-Eb=JwezWQ@mail.gmail.com>
 <bf3f40ff-cb91-d0b3-e60d-27f4e14cbb37@gmail.com> <CAJCQCtRGtax_ovqA8Xb3DzmeTp=pJkpS0J1hGpe2PongFhfSpg@mail.gmail.com>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Date: Thu, 21 Jul 2016 17:02:08 +0300
Message-ID: <CAA91j0UL=zkwwqGRCD0F=zQJZFHDqAcAcm0BM9+ieWGPc56m4Q@mail.gmail.com>
Subject: Re: Status of SMR with BTRFS
To: Chris Murphy <lists@colorremedies.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Hendrik Friedel <hendrik@friedels.name>,
        Tomasz Kusmierz <tom.kusmierz@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>, dave@jikos.cz
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 21, 2016 at 4:34 PM, Chris Murphy <lists@colorremedies.com> wrote:

>
> Do programs have a way to communicate what portion of a data file is
> modified, so that only changed blocks are COW'd? When I change a
> single pixel in a 400MiB image and do a save (to overwrite the
> original file), it takes just as long to overwrite as to write it out
> as a new file. It'd be neat if that could be optimized but I don't see
> it being the case at the moment.
>

NetApp has an option to do it for CIFS connections. It literally
compares old and new files on renames and discards duplicates. It is
off by default. I am not aware of anyone using it :)
