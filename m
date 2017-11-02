Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:59710 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932433AbdKBAn0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 1 Nov 2017 20:43:26 -0400
Received: from 82-132-213-109.dab.02.net ([82.132.213.109]:34106 helo=ty.sabi.co.UK)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.89)
        (envelope-from <postmaster@root.t00.sabi.co.uk>)
        id 1eA3bR-0007tW-6c
        for linux-btrfs@vger.kernel.org; Thu, 02 Nov 2017 00:43:25 +0000
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1eA3bB-0008FN-9B
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Nov 2017 00:43:09 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <23034.27164.713002.595731@tree.ty.sabi.co.uk>
Date: Thu, 2 Nov 2017 00:43:08 +0000
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: defragmenting best practice?
In-Reply-To: <23034.2305.527872.772343@tree.ty.sabi.co.uk>
References: <20170831070558.GB5783@rus.uni-stuttgart.de>
        <20170912162843.GA32233@rus.uni-stuttgart.de>
        <20170914133824.5cf9b59c@jupiter.sol.kaishome.de>
        <CABB28CyM9wQuDgn1ONTw3hrXQrLHwk30dxPcF_qnvdCM+A0gxA@mail.gmail.com>
        <20170914172434.39eae89d@jupiter.sol.kaishome.de>
        <CABB28Cx13a4eP3nM7PVYknmug-jpyeKv1ai5DWT0jKt4Zi0Rgg@mail.gmail.com>
        <59BBB15E.8010002@sarach.com.pl>
        <CABB28CxYR35HQgvf5PvRpDkGvtBxMR1LBDQO60N6QZ1cBmZGjQ@mail.gmail.com>
        <59BBDFA6.4020500@sarach.com.pl>
        <20170915190826.1f0be8a9@jupiter.sol.kaishome.de>
        <CABB28Cw6A-xYnwkcaoc=1XJa=K8g-Bz6_KFT2Q33FUJhbXD8JQ@mail.gmail.com>
        <CAH=dxU7R2fZQY12mJnYigt2s4BqVrsALJjxgbpvo7hfEwMXt-Q@mail.gmail.com>
        <pan$a362c$5b92cac0$d2d78b7f$25ff3b3a@cox.net>
        <CAH=dxU6f_DunAsOqKQTXKp469bOaLCiqOMuSE0T3QYqc9CqFNQ@mail.gmail.com>
        <23033.512.820691.680916@tree.ty.sabi.co.uk>
        <CAH=dxU7aNg+VTeQFk-9Tk4yzPemsgL1E0iqSFXFQOxM8=ATDFQ@mail.gmail.com>
        <23034.2305.527872.772343@tree.ty.sabi.co.uk>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Another one is to find the most fragmented files first or all
> files of at least 1M with with at least say 100 fragments as in:

> find "$HOME" -xdev -type f -size +1M -print0 | xargs -0 filefrag \
> | perl -n -e 'print "$1\0" if (m/(.*): ([0-9]+) extents/ && $1 > 100)' \
> | xargs -0 btrfs fi defrag

That should have "&& $2 > 100".
