Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f173.google.com ([209.85.217.173]:35726 "EHLO
        mail-ua0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751886AbdBGTbD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Feb 2017 14:31:03 -0500
Received: by mail-ua0-f173.google.com with SMTP id y9so92879210uae.2
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Feb 2017 11:31:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170207140058.GA4249@carfax.org.uk>
References: <CA+RUij3aW1ZYyJPNRLzckwOCCmoWa15Eu4h142jB_-qKc49hBw@mail.gmail.com>
 <20170207140058.GA4249@carfax.org.uk>
From: Peter Zaitsev <pz@percona.com>
Date: Tue, 7 Feb 2017 14:31:02 -0500
Message-ID: <CA+RUij3LJeFR1pz9QDOkMEVbh1cws5Rv2KPep3ghVAimJy7aLA@mail.gmail.com>
Subject: Re: BTRFS for OLTP Databases
To: Hugo Mills <hugo@carfax.org.uk>, Peter Zaitsev <pz@percona.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Hugo,

As I re-read it closely (and also other comments in the thread) I know
understand there is a difference how nodatacow works even if snapshot are
in place.

On autodefrag I wonder is there some more detailed documentation about how
autodefrag works.

The manual  https://btrfs.wiki.kernel.org/index.php/Mount_options    has
very general statement.

What does "detect random IO" really means  ? It also talks about
 defragmenting the file - is i really about the whole file which is
triggered for defrag or is defrag locally ?      Ie I would understand what
as writes happen the  1MB block is checked and if it is more than X
fragments it is defragmented or something like that.

Also does autodefrag works with nodatacow (ie with snapshot)  or are these
exclusive ?


>
>    There's another approach which might be worth testing, which is to
> use autodefrag. This will increase data write I/O, because where you
> have one or more small writes in a region, it will also read and write
> the data in a small neghbourhood around those writes, so the
> fragmentation is reduced. This will improve subsequent read
> performance.
>
>    I could also suggest getting the latest kernel you can -- 16.04 is
> already getting on for a year old, and there may be performance
> improvements in upstream kernels which affect your workload. There's
> an Ubuntu kernel PPA you can use to get the new kernels without too
> much pain.
>
>
>
