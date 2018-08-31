Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lj1-f180.google.com ([209.85.208.180]:35590 "EHLO
        mail-lj1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726704AbeHaXLH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Aug 2018 19:11:07 -0400
Received: by mail-lj1-f180.google.com with SMTP id p10-v6so10901912ljg.2
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Aug 2018 12:02:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQso9Lvw-33DmLDuOxnMcsRPzq6Ya9oo_n2_LvsvFVYqA@mail.gmail.com>
References: <83a74213-e66c-238c-43e4-8333c678e588@couderc.eu> <CAJCQCtQso9Lvw-33DmLDuOxnMcsRPzq6Ya9oo_n2_LvsvFVYqA@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 31 Aug 2018 13:02:16 -0600
Message-ID: <CAJCQCtTPieXg=8T_s78f2eQCHGknQ1+gQxCLqXr0CgEC6ub_9Q@mail.gmail.com>
Subject: Re: IO errors when building RAID1.... ?
To: Chris Murphy <lists@colorremedies.com>
Cc: Pierre Couderc <pierre@couderc.eu>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If you want you can post the output from 'sudo smartctl -x /dev/sda'
which will contain more information... but this is in some sense
superfluous. The problem is very clearly a bad drive, the drive
explicitly report to libata a write error, and included the sector LBA
affected, and only the drive firmware would know that. It's not likely
a cable problem or something like. And that the write error is
reported at all means it's persistent, not transient.


Chris Murphy
