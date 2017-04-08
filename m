Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:50433 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752151AbdDHVzu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 8 Apr 2017 17:55:50 -0400
Received: from ty.sabi.co.uk ([95.172.230.208]:55826)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.88)
        (envelope-from <pg@btrfs.list.sabi.co.uk>)
        id 1cwyKh-004DCA-9L
        for linux-btrfs@vger.kernel.org; Sat, 08 Apr 2017 22:55:47 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1cwyKY-0006Uq-C0
        for <linux-btrfs@vger.kernel.org>; Sat, 08 Apr 2017 22:55:38 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <22761.23640.216570.125948@tree.ty.sabi.co.uk>
Date: Sat, 8 Apr 2017 22:55:36 +0100
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: About free space fragmentation, metadata write amplification and (no)ssd
In-Reply-To: <5e11b988-05ea-c468-21ef-589c71058436@mendix.com>
References: <5e11b988-05ea-c468-21ef-589c71058436@mendix.com>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> [ ... ] This post is way too long [ ... ]

Many thanks for your report, it is really useful, especially the
details.

> [ ... ] using rsync with --link-dest to btrfs while still
> using rsync, but with btrfs subvolumes and snapshots [1]. [
> ... ]  Currently there's ~35TiB of data present on the example
> filesystem, with a total of just a bit more than 90000
> subvolumes, in groups of 32 snapshots per remote host (daily
> for 14 days, weekly for 3 months, montly for a year), so
> that's about 2800 'groups' of them. Inside are millions and
> millions and millions of files. And the best part is... it
> just works. [ ... ]

That kind of arrangement, with a single large pool and very many
many files and many subdirectories is a worst case scanario for
any filesystem type, so it is amazing-ish that it works well so
far, especially with 90,000 subvolumes. As I mentioned elsewhere
I would rather do a rotation of smaller volumes, to reduce risk,
like "Duncan" also on this mailing list likes to do (perhaps to
the opposite extreme).

As to the 'ssd'/'nossd' issue that is as described in 'man 5
btrfs' (and I wonder whether 'ssd_spread' was tried too) but it
is not at all obvious it should impact so much metadata
handling. I'll add a new item in the "gotcha" list. 

It is sad that 'ssd' is used by default in your case, and it is
quite perplexing that tghe "wandering trees" problem (that is
"write amplification") is so large with 64KiB write clusters for
metadata (and 'dup' profile for metadata).

* Probably the metadata and data cluster sizes should be create
  or mount parameters instead of being implicit in the 'ssd'
  option.
* A cluster size of 2MiB for metadata and/or data presumably
  has some downsides, otrherwise it would be the default. I
  wonder whether the downsides related to barriers...
