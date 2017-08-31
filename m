Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([91.121.75.85]:59342 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751359AbdHaLg6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 Aug 2017 07:36:58 -0400
Date: Thu, 31 Aug 2017 16:36:56 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Marco Lorenzo Crociani <marcoc@prismatelecomtesting.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: mount time for big filesystems
Message-ID: <20170831163656.6be88191@natsu>
In-Reply-To: <556e7650-8556-d5ca-273e-6c158c1d032e@prismatelecomtesting.com>
References: <556e7650-8556-d5ca-273e-6c158c1d032e@prismatelecomtesting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 31 Aug 2017 12:43:19 +0200
Marco Lorenzo Crociani <marcoc@prismatelecomtesting.com> wrote:

> Hi,
> this 37T filesystem took some times to mount. It has 47 
> subvolumes/snapshots and is mounted with 
> noatime,compress=zlib,space_cache. Is it normal, due to its size?

If you could implement SSD caching in front of your FS (such as lvmcache or
bcache), that would work wonders for performance in general, and especially
for mount times. I have seen amazing results with lvmcache (of just 32 GB) for
a 14 TB FS.

As for in general, with your FS size perhaps you should be using
"space_cache=v2" for better performance, but I'm not sure if that will have
any effect on mount time (aside from slowing down the first mount with that).

-- 
With respect,
Roman
