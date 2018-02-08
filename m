Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f174.google.com ([74.125.82.174]:37641 "EHLO
        mail-ot0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751986AbeBHDIo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Feb 2018 22:08:44 -0500
Received: by mail-ot0-f174.google.com with SMTP id e64so2868798ote.4
        for <linux-btrfs@vger.kernel.org>; Wed, 07 Feb 2018 19:08:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtT9=Bgnjqdxx8Vi7-k_xF7oQHxsc98VXxuk5D78iY9xoA@mail.gmail.com>
References: <CAA3ktqnd8_kmiVNq_7L6G0ekiqGzSrfVbzTTc_5aUU9AygE02A@mail.gmail.com>
 <CAJCQCtT9=Bgnjqdxx8Vi7-k_xF7oQHxsc98VXxuk5D78iY9xoA@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 7 Feb 2018 20:08:43 -0700
Message-ID: <CAJCQCtT=mFeiAmnOHsqwYRp1P1NSBZLS37wM7q=9XV9J5tDS9w@mail.gmail.com>
Subject: Re: Crash when unraring large archives on btrfs-filesystem
To: Chris Murphy <lists@colorremedies.com>
Cc: Stefan Malte Schumacher <s.schumacher@netcologne.de>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Another way to test for this problem is one of the responses in that
lkml thread by Btrfs list regular Duncan, about tweaking the knobs
that handle dirty write caching. So you could try those suggested
tweaks first, rather than changing kernels.


https://lkml.org/lkml/2016/12/13/753


Chris Murphy
