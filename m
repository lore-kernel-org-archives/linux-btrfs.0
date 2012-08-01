Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:44566 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332Ab2HAGIr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Aug 2012 02:08:47 -0400
Received: by qcro28 with SMTP id o28so4298508qcr.19
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Jul 2012 23:08:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120801060135.GH12695@merlins.org>
References: <20120202124241.GW16796@shiny>
	<20120718220446.GB3888@merlins.org>
	<20120722185848.GA10089@merlins.org>
	<201207222135.11159.Martin@lichtvoll.de>
	<20120722204428.GC3925@merlins.org>
	<20120722224145.GC12951@merlins.org>
	<20120723064202.GB6931@merlins.org>
	<20120727110835.GA6933@shiny>
	<20120801053042.GG12695@merlins.org>
	<20120727184238.GA6713@merlins.org>
	<20120801060135.GH12695@merlins.org>
Date: Wed, 1 Aug 2012 13:08:46 +0700
Message-ID: <CAG1y0sdnyv4O8zab+WwLxZ6qUJTcVryrAgnDfv5eiAw+eZh-Gg@mail.gmail.com>
Subject: Re: How can btrfs take 23sec to stat 23K files from an SSD?
From: "Fajar A. Nugraha" <list@fajar.net>
To: Marc MERLIN <marc@merlins.org>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 1, 2012 at 1:01 PM, Marc MERLIN <marc@merlins.org> wrote:

> So, clearly, there is something wrong with the samsung 830 SSD with linux


> It it were a random crappy SSD from a random vendor, I'd blame the SSD, but
> I have a hard time believing that samsung is selling SSDs that are slower
> than hard drives at random IO and 'seeks'.

You'd be surprised on how badly some vendors can screw up :)


> First: btrfs is the slowest:

> gandalfthegreat:/mnt/ssd/var/local# grep /mnt/ssd/var /proc/mounts
> /dev/mapper/ssd /mnt/ssd/var btrfs rw,noatime,compress=lzo,ssd,discard,space_cache 0 0

Just checking, did you explicitly activate "discard"? Cause on my
setup (with corsair SSD) it made things MUCH slower. Also, try adding
"noatime" (just in case the slow down was because "du" cause many
access time updates)

-- 
Fajar
