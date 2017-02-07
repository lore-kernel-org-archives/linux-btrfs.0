Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f174.google.com ([209.85.217.174]:35369 "EHLO
        mail-ua0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753893AbdBGON1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Feb 2017 09:13:27 -0500
Received: by mail-ua0-f174.google.com with SMTP id y9so85520097uae.2
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Feb 2017 06:13:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170207140058.GA4249@carfax.org.uk>
References: <CA+RUij3aW1ZYyJPNRLzckwOCCmoWa15Eu4h142jB_-qKc49hBw@mail.gmail.com>
 <20170207140058.GA4249@carfax.org.uk>
From: Peter Zaitsev <pz@percona.com>
Date: Tue, 7 Feb 2017 09:13:25 -0500
Message-ID: <CA+RUij02VMTa-L59AD9B3G+g_dS3HO7-Ttsz-qWgJtMyf58sPQ@mail.gmail.com>
Subject: Re: BTRFS for OLTP Databases
To: Hugo Mills <hugo@carfax.org.uk>, Peter Zaitsev <pz@percona.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Hugo,

For the use case I'm looking for I'm interested in having snapshot(s)
open at all time.  Imagine  for example snapshot being created every
hour and several of these snapshots  kept at all time providing quick
recovery points to the state of 1,2,3 hours ago.  In  such case (as I
think you also describe)  nodatacow  does not provide any advantage.

I have not seen autodefrag helping much but I will try again.     Is
there any autodefrag documentation available about how is it expected
to work and if it can be tuned in any way

I noticed remounting already fragmented filesystem with autodefrag
and putting workload  which does more fragmentation does not seem to
improve over time



>    Well, nodatacow will still allow snapshots to work, but it also
> allows the data to fragment. Each snapshot made will cause subsequent
> writes to shared areas to be CoWed once (and then it reverts to
> unshared and nodatacow again).
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







-- 
Peter Zaitsev, CEO, Percona
Tel: +1 888 401 3401 ext 7360   Skype:  peter_zaitsev
