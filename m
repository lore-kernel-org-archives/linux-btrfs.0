Return-Path: <SRS0=91MX=QF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA592C169C4
	for <linux-btrfs@archiver.kernel.org>; Tue, 29 Jan 2019 17:19:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8258C2087E
	for <linux-btrfs@archiver.kernel.org>; Tue, 29 Jan 2019 17:19:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729012AbfA2RTL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 29 Jan 2019 12:19:11 -0500
Received: from mx2.suse.de ([195.135.220.15]:37006 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727100AbfA2RTL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Jan 2019 12:19:11 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 41DB4B033;
        Tue, 29 Jan 2019 17:19:09 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 07124DA78C; Tue, 29 Jan 2019 18:18:31 +0100 (CET)
Date:   Tue, 29 Jan 2019 18:18:30 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Dennis Zhou <dennis@kernel.org>
Cc:     David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/11] btrfs: add zstd compression level support
Message-ID: <20190129171830.GP2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Dennis Zhou <dennis@kernel.org>,
        David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>,
        Chris Mason <clm@fb.com>, Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190128212437.11597-1-dennis@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190128212437.11597-1-dennis@kernel.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Jan 28, 2019 at 04:24:26PM -0500, Dennis Zhou wrote:
> As mentioned above, a requirement that differs zstd from zlib is that
> higher levels of compression require more memory. To manage this, each
> compression level has its own queue of workspaces. A global LRU is used
> to help with reclaim. To guarantee forward progress, a max level
> workspace is preallocated and hidden from the LRU.

Here I'd like to bring up what was mentioned in previous iteration, the
workspace sizes.

Level   Compression Memory
1       0.8 MB
2       1.0 MB
3       1.3 MB
4       0.9 MB
5       1.4 MB
6       1.5 MB
7       1.4 MB
8       1.8 MB
9       1.8 MB
10      1.8 MB
11      1.8 MB
12      1.8 MB
13      2.3 MB
14      2.6 MB
15      2.6 MB

and decompression needs memory of level 1. The sizes can be grouped
together to say 3 sizes, I'm not sure that we'd really need 15 distinct
workspaces. The reclaim mechanism helps, but I'd rather keep a smaller
number of workspaces that covers average use.

Default level is 3, that's 1.3 MiB, that also covers level 1, 2 and 4.
For 5 to 12 it's 1.8 and the rest is 2.6 MiB.

> btrfs filesystem 10 times and then read back after dropping the caches.
> The btrfs filesystem was on an SSD.
> 
> Level   Ratio   Compression (MB/s)  Decompression (MB/s)
> 1       2.658        438.47                910.51
> 2       2.744        364.86                886.55
> 3       2.801        336.33                828.41
> 4       2.858        286.71                886.55
> 5       2.916        212.77                556.84
> 6       2.363        119.82                990.85
> 7       3.000        154.06                849.30
> 8       3.011        159.54                875.03
> 9       3.025        100.51                940.15
> 10      3.033        118.97                616.26
> 11      3.036         94.19                802.11
> 12      3.037         73.45                931.49
> 13      3.041         55.17                835.26
> 14      3.087         44.70                716.78
> 15      3.126         37.30                878.84

From my casual user's perspective, I'd use the level 1 for speed, 7 for
better ratio and 15 for the best compression. Anything else does not
look good, though the results would vary based on the data set. I
assume that the silesia corpus serves as a good approximation of the
worst case average.

The levels 7-14 strike particularly obvious pattern: same ratio but the
speed gets worse with each level. Taking the default level into account,
(my) recommended levels would be 1, 3, 7, 15.

I went through the patches, looks mostly ok, I don't like the
indirections but at the moment it's an implementation detail as I'd like
to agree on the overall approach first.

We might need a few revisions or cleanup rounds to converge to an
efficient solution, the advantage here is that it's all in-memory and
without compatibility concerns once the level support for zstd is in and
works.

For that reason, I'm not opposed to the current version of the patchset.
Given the time in development schedule, it's really close to code
freeze, but the functionality has a narrow scope so I'm tentatively
counting with it for 5.1.
