Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:43283 "EHLO
        mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727199AbeH1Cl5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Aug 2018 22:41:57 -0400
Received: by mail-io0-f182.google.com with SMTP id y10-v6so498436ioa.10
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Aug 2018 15:53:17 -0700 (PDT)
MIME-Version: 1.0
From: John Petrini <jpetrini@coredial.com>
Date: Mon, 27 Aug 2018 18:53:15 -0400
Message-ID: <CAD4AmV76WPVQLEfef1xZ8hmM6n3F0O9Oa9bA4m-RH86iu7u-sg@mail.gmail.com>
Subject: corruption_errs
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi List,

I'm seeing corruption errors when running btrfs device stats but I'm
not sure what that means exactly. I've just completed a full scrub and
it reported no errors. I'm hoping someone here can enlighten me.
Thanks!

[/dev/sdd].write_io_errs   0
[/dev/sdd].read_io_errs    0
[/dev/sdd].flush_io_errs   0
[/dev/sdd].corruption_errs 331
[/dev/sdd].generation_errs 0
[/dev/sde].write_io_errs   0
[/dev/sde].read_io_errs    0
[/dev/sde].flush_io_errs   0
[/dev/sde].corruption_errs 324
[/dev/sde].generation_errs 0
[/dev/sdi].write_io_errs   0
[/dev/sdi].read_io_errs    0
[/dev/sdi].flush_io_errs   0
[/dev/sdi].corruption_errs 381
[/dev/sdi].generation_errs 0
[/dev/sdk].write_io_errs   0
[/dev/sdk].read_io_errs    0
[/dev/sdk].flush_io_errs   0
[/dev/sdk].corruption_errs 492
[/dev/sdk].generation_errs 0
[/dev/sdl].write_io_errs   0
[/dev/sdl].read_io_errs    0
[/dev/sdl].flush_io_errs   0
[/dev/sdl].corruption_errs 449
[/dev/sdl].generation_errs 0
[/dev/sdj].write_io_errs   0
[/dev/sdj].read_io_errs    0
[/dev/sdj].flush_io_errs   0
[/dev/sdj].corruption_errs 391
[/dev/sdj].generation_errs 0
[/dev/sdg].write_io_errs   0
[/dev/sdg].read_io_errs    0
[/dev/sdg].flush_io_errs   0
[/dev/sdg].corruption_errs 485
[/dev/sdg].generation_errs 0
[/dev/sdh].write_io_errs   0
[/dev/sdh].read_io_errs    0
[/dev/sdh].flush_io_errs   0
[/dev/sdh].corruption_errs 444
[/dev/sdh].generation_errs 0
[/dev/sdb].write_io_errs   0
[/dev/sdb].read_io_errs    0
[/dev/sdb].flush_io_errs   0
[/dev/sdb].corruption_errs 398
[/dev/sdb].generation_errs 0
[/dev/sdc].write_io_errs   0
[/dev/sdc].read_io_errs    0
[/dev/sdc].flush_io_errs   0
[/dev/sdc].corruption_errs 400
[/dev/sdc].generation_errs 0
