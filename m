Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f41.google.com ([209.85.214.41]:34421 "EHLO
        mail-it0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727559AbeH1PJM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Aug 2018 11:09:12 -0400
Received: by mail-it0-f41.google.com with SMTP id x79-v6so1912048ita.1
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Aug 2018 04:18:02 -0700 (PDT)
Subject: Re: corruption_errs
To: John Petrini <jpetrini@coredial.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAD4AmV76WPVQLEfef1xZ8hmM6n3F0O9Oa9bA4m-RH86iu7u-sg@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <16e8a484-c271-cabe-e7ba-d9175cf9f96a@gmail.com>
Date: Tue, 28 Aug 2018 07:17:59 -0400
MIME-Version: 1.0
In-Reply-To: <CAD4AmV76WPVQLEfef1xZ8hmM6n3F0O9Oa9bA4m-RH86iu7u-sg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-08-27 18:53, John Petrini wrote:
> Hi List,
> 
> I'm seeing corruption errors when running btrfs device stats but I'm
> not sure what that means exactly. I've just completed a full scrub and
> it reported no errors. I'm hoping someone here can enlighten me.
> Thanks!

The first thing to understand here is that the error counters reported 
by `btrfs device stats` are cumulative.  In other words, they count 
errors since the last time they were reset (which means that if you've 
never run `btrfs device stats -z` on this filesystem, then they will 
count errors since the filesystem was created).  As a result, seeing a 
non-zero value there just means that errors of that type happened at 
some point in time since they were reset.

Building on this a bit further, corruption errors are checksum 
mismatches.  Each time a block is read and it's checksum does not match 
the stored checksum for it, a corruption error is recorded.  The thing 
is though, if you are using a profile which can rebuild that block (dup, 
raid1, raid10, or one of the parity profiles), the error gets corrected 
automatically by the filesystem (it will attempt to rebuild that block, 
then write out the correct block).  If that fix succeeds, there will be 
no errors there anymore, but the record of the error stays around 
(because there _was_ an error).

Given this, my guess is that you _had_ checksum mismatches somewhere, 
but they were fixed before you ran scrub.
