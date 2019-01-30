Return-Path: <SRS0=cBAG=QG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEE71C282D8
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jan 2019 17:41:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A401220870
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jan 2019 17:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548870069;
	bh=kLeCMFkJDg9mVo+BtDArRIhUYwtH6Gc2iYyageuWe9M=;
	h=Date:From:To:Subject:References:In-Reply-To:List-ID:From;
	b=s1XaHaYoens5QURfqjcPnA5QMB4jaR1ETk1DsnHJxozf53V7i3pkKZ0J2FMAz+CmQ
	 1JU7QZBc5+npsDemzaUgnA+yJJxtRcxVxXwGB/kc4DQIxOYG3IJrjkv13GnCuZQ680
	 EqsfQQg6iEu8HhzQHqE0GsudDOpx3Xo2e/YLQL8k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732578AbfA3RlF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 30 Jan 2019 12:41:05 -0500
Received: from mail-yb1-f194.google.com ([209.85.219.194]:36749 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732435AbfA3RlE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Jan 2019 12:41:04 -0500
Received: by mail-yb1-f194.google.com with SMTP id 64so160719ybf.3;
        Wed, 30 Jan 2019 09:41:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=JThjyZDeCLp0R438GZcdflfLKEcxqLnVsc0bIb5lJrY=;
        b=MNwUxDHWf1oTlxoGBfmim743ET7wkjDqCJclrkeMzAy+2Y5YXr+nDwwzLgCrakZ2TJ
         zQAsKd2w/7w1rWxzKXfSTSqwqeft2Qgj1khH0i+Lk1X4RUNFBb0wiBhWQyaODxG9Rlao
         1hHNMGvAqOrTs/SbVZ6Ss0ACz9+fZ6IYTjt6/iTMOnaDTvBg78UxI9jdeQtHHOgXuSkx
         24nEdW4OdXaQING8zPGbEAQ089TDKsmGlWZDzBHgG6XrZtzx/miwVT0OurtbepZXAJTJ
         AFtHOe1f+aCfDhFlUd1Iw5MiFSsQULiyUAy2qCGu18/fS72gPZg1K+c2PXEkgra8iyT/
         yCUg==
X-Gm-Message-State: AHQUAub/YHoUS/sUdb2iaalLxSosyxzYY+ScxlNUaJ+zoK6fdRvPBbuu
        U2pHtj6yBzZuZA8wdiKXVySzwM2e7Gg=
X-Google-Smtp-Source: AHgI3IZDtbxVYdxCdrM6E8GlTPj0CpmrzxuIoBKqWkzyXDOCY/AV1l8ZIrxOkmukksfEsIJNnzt3lA==
X-Received: by 2002:a25:7284:: with SMTP id n126mr6981954ybc.504.1548870063238;
        Wed, 30 Jan 2019 09:41:03 -0800 (PST)
Received: from dennisz-mbp ([2620:10d:c091:200::5:f3d1])
        by smtp.gmail.com with ESMTPSA id l6sm651421ywf.61.2019.01.30.09.41.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 30 Jan 2019 09:41:02 -0800 (PST)
Date:   Wed, 30 Jan 2019 12:40:59 -0500
From:   Dennis Zhou <dennis@kernel.org>
To:     dsterba@suse.cz, Dennis Zhou <dennis@kernel.org>,
        David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/11] btrfs: add zstd compression level support
Message-ID: <20190130174059.GA18660@dennisz-mbp>
References: <20190128212437.11597-1-dennis@kernel.org>
 <20190129171830.GP2900@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190129171830.GP2900@twin.jikos.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi David,

On Tue, Jan 29, 2019 at 06:18:30PM +0100, David Sterba wrote:
> On Mon, Jan 28, 2019 at 04:24:26PM -0500, Dennis Zhou wrote:
> > As mentioned above, a requirement that differs zstd from zlib is that
> > higher levels of compression require more memory. To manage this, each
> > compression level has its own queue of workspaces. A global LRU is used
> > to help with reclaim. To guarantee forward progress, a max level
> > workspace is preallocated and hidden from the LRU.
> 
> Here I'd like to bring up what was mentioned in previous iteration, the
> workspace sizes.
> 
> Level   Compression Memory
> 1       0.8 MB
> 2       1.0 MB
> 3       1.3 MB
> 4       0.9 MB
> 5       1.4 MB
> 6       1.5 MB
> 7       1.4 MB
> 8       1.8 MB
> 9       1.8 MB
> 10      1.8 MB
> 11      1.8 MB
> 12      1.8 MB
> 13      2.3 MB
> 14      2.6 MB
> 15      2.6 MB
> 
> and decompression needs memory of level 1. The sizes can be grouped
> together to say 3 sizes, I'm not sure that we'd really need 15 distinct
> workspaces. The reclaim mechanism helps, but I'd rather keep a smaller
> number of workspaces that covers average use.
> 
> Default level is 3, that's 1.3 MiB, that also covers level 1, 2 and 4.
> For 5 to 12 it's 1.8 and the rest is 2.6 MiB.
> 

I realize the current implementation doesn't have a monotonic memory
requirement guarantee. I've added that, and below is updated memory
requirements per level. I've updated the commit to include this too.

Level     Memory (KB)
1            780 
2           1004
3           1260
4           1260
5           1388
6           1516
7           1516
8           1772
9           1772
10          1772
11          1772
12          1772
13          2284
14          2547
15          2547

> > btrfs filesystem 10 times and then read back after dropping the caches.
> > The btrfs filesystem was on an SSD.
> > 
> > Level   Ratio   Compression (MB/s)  Decompression (MB/s)
> > 1       2.658        438.47                910.51
> > 2       2.744        364.86                886.55
> > 3       2.801        336.33                828.41
> > 4       2.858        286.71                886.55
> > 5       2.916        212.77                556.84
> > 6       2.363        119.82                990.85
> > 7       3.000        154.06                849.30
> > 8       3.011        159.54                875.03
> > 9       3.025        100.51                940.15
> > 10      3.033        118.97                616.26
> > 11      3.036         94.19                802.11
> > 12      3.037         73.45                931.49
> > 13      3.041         55.17                835.26
> > 14      3.087         44.70                716.78
> > 15      3.126         37.30                878.84
> 
> From my casual user's perspective, I'd use the level 1 for speed, 7 for
> better ratio and 15 for the best compression. Anything else does not
> look good, though the results would vary based on the data set. I
> assume that the silesia corpus serves as a good approximation of the
> worst case average.
> 
> The levels 7-14 strike particularly obvious pattern: same ratio but the
> speed gets worse with each level. Taking the default level into account,
> (my) recommended levels would be 1, 3, 7, 15.
> 

I do see why we want to limit the number of levels as the memory
requirements do kind of bucket themselves. But, this means when zstd
gets updated, we'd have to reevaluate the compression levels btrfs
supports. I'm not sure it's a great idea to have that dependency.
I imagine we could offer some level of guidance, but it really would be
up to the user to figure out what works best for them.

The reclaim mechanism only keeps workspaces around if they are being
used by the appropriate level. So, the memory overhead is actively used
memory and if not, it is reclaimed after at most ~2 minutes later. I
also scan up before allocating a workspace, so that should help limit
the number of workspaces in circulation.

> I went through the patches, looks mostly ok, I don't like the
> indirections but at the moment it's an implementation detail as I'd like
> to agree on the overall approach first.
> 
> We might need a few revisions or cleanup rounds to converge to an
> efficient solution, the advantage here is that it's all in-memory and
> without compatibility concerns once the level support for zstd is in and
> works.
> 
> For that reason, I'm not opposed to the current version of the patchset.
> Given the time in development schedule, it's really close to code
> freeze, but the functionality has a narrow scope so I'm tentatively
> counting with it for 5.1.

Thanks,
Dennis
