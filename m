Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f52.google.com ([209.85.192.52]:33022 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930AbbI1XLy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Sep 2015 19:11:54 -0400
Received: by qgev79 with SMTP id v79so134548942qge.0
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Sep 2015 16:11:53 -0700 (PDT)
Message-ID: <1443481911.12614.4.camel@kepstin.ca>
Subject: Re: btrfs: obtain block checksums from user space
From: Calvin Walton <calvin.walton@kepstin.ca>
To: "Matwey V. Kornilov" <matwey.kornilov@gmail.com>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Date: Mon, 28 Sep 2015 19:11:51 -0400
In-Reply-To: <CAJs94EbJV+VX16dnkFqH21OMV=uLYSCKnG9KNUCrs7B=rULYLg@mail.gmail.com>
References: <mu1e38$io1$1@ger.gmane.org> <5604427D.1000708@gmail.com>
	 <CAJs94EbJV+VX16dnkFqH21OMV=uLYSCKnG9KNUCrs7B=rULYLg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2015-09-24 at 21:48 +0300, Matwey V. Kornilov wrote:
> 2015-09-24 21:35 GMT+03:00 Austin S Hemmelgarn <ahferroin7@gmail.com>
> :
> > On 2015-09-24 14:06, Matwey V. Kornilov wrote:

> > It's worth noting that the way btrfs does checksums isn't per-file, 
> > it's
> > per-block. This means that:
[...]
> > All in all, this means that if you just want a checksum of the
> > contents of
> > the file, it's almost certainly better to just do it in userspace.
> > If you're trying to figure out what changed, using send/receive and
> > snapshots is more efficient (usually).
> 
> I want the checksums of the every block of the file to see which part
> has been changed.
> I cannot use send/receive because my other file replica is on the
> remote host but not on the same filesystem. Compare with how rsync
> works. It calculates checksums of the chunks of both versions of the
> file and then syncs different chunks over the network. I just want to
> utilize the fact that btrfs already has the data I need to calculate.

The problem with trying to use btrfs checksums to compare two different
files is that the blocks might not match up, if only due to
fragmentation. E.g., the same 1gb file might be stored like this on one
machine:

[ 256MB ][    512 MB    ][ 256MB ]

And like this on the other:
[     512MB     ][     512MB     ]

Since the checksums are per block, and the blocks can be different
arrangements on different machines, they're not really all that useful
for doing comparisons like you want.

-- 
Calvin Walton <calvin.walton@kepstin.ca>

