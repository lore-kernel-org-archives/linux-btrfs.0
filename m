Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:55681 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1752022AbdFLGMO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Jun 2017 02:12:14 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dKIa6-0000FX-Ne
        for linux-btrfs@vger.kernel.org; Mon, 12 Jun 2017 08:12:06 +0200
To: linux-btrfs@vger.kernel.org
From: Koen Kooi <koen@dominion.thruhere.net>
Subject: Re: Filesystem won't mount (open_ctree failed) or repair (BUG_ON)
Date: Mon, 12 Jun 2017 08:12:05 +0200
Message-ID: <ohlbbf$v35$1@blaine.gmane.org>
References: <oherub$g5a$1@blaine.gmane.org>
 <20170609195718.GC30723@carfax.org.uk>
 <CAJCQCtRdinWhYvNB8dVXGREhnaspYaSu8vbbNRsN4DjyTJw6GA@mail.gmail.com>
 <6BE7B702-122D-406B-B8D5-9DFAB78BA587@dominion.thruhere.net>
 <CAJCQCtS=S1jkcLtAyC18iNMQehsXMMFytvPz05YwMcs+JHLEag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAJCQCtS=S1jkcLtAyC18iNMQehsXMMFytvPz05YwMcs+JHLEag@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Op 12-06-17 om 00:58 schreef Chris Murphy:

[..]

> Also worth trying btrfs check --mode=lowmem. This doesn't repair but
> is a whole new implementation so it might find the source of the
> problem better than the current fsck.

I ran it under 'catchsegv' to give more data where it segfaults, here's the log:

https://dominion.thruhere.net/btrfsck-lowmem.txt.gz

It's 688K compressed and 16MiB uncompressed.

regards,

Koen


