Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:36759 "EHLO
        mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751594AbcJKEXN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Oct 2016 00:23:13 -0400
Received: by mail-oi0-f50.google.com with SMTP id m72so11037228oik.3
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Oct 2016 21:23:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5ce201d22364$96702780$c3507680$@com>
References: <5cde01d2230f$fa1e3150$ee5a93f0$@com> <CAJCQCtQ0SCZi36RG32NiHVYJRz8gHCtfhWYEqM93y2twX4C4JA@mail.gmail.com>
 <5ce201d22364$96702780$c3507680$@com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 10 Oct 2016 22:23:11 -0600
Message-ID: <CAJCQCtR_zOd=1hVrKAD_kKfE_EKZQ2omfWQV556Rg=OSbvEd0w@mail.gmail.com>
Subject: Re: raid6 file system in a bad state
To: "Jason D. Michaelson" <jasondmichaelson@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

What do you get for

btrfs-find-root <dev>
btrfs rescue super-recover -v <dev>



It shouldn't matter which dev you pick, unless it face plants, then try another.
