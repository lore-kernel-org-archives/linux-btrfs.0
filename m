Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27584 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbaKYK2O (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Nov 2014 05:28:14 -0500
Date: Tue, 25 Nov 2014 18:28:07 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH] Btrfs: add sha256 checksum option
Message-ID: <20141125102806.GB23574@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1416806586-18050-1-git-send-email-bo.li.liu@oracle.com>
 <pan.2014.11.24.08.23.25@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <pan.2014.11.24.08.23.25@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 24, 2014 at 08:23:25AM +0000, Holger Hoffstätte wrote:
> On Mon, 24 Nov 2014 13:23:05 +0800, Liu Bo wrote:
> 
> > This brings a strong-but-slow checksum algorithm, sha256.
> > 
> > Actually btrfs used sha256 at the early time, but then moved to crc32c for
> > performance purposes.
> > 
> > As crc32c is sort of weak due to its hash collision issue, we need a stronger
> > algorithm as an alternative.
> 
> I'm curious - did you see actual cases where this happened, i.e. a corrupt
> block that would pass crc32 validation? I know some high-integrity use
> cases require a stronger algorithm - just wondering.

Haven't see that so far, but here is a link for crc32c hash collision in
btrfs, http://lwn.net/Articles/529077/, it's not data checksum though,
btrfs's DIR_ITEM also use crc32c hash, if those happen to be data blocks,
something interesting will happen.

> 
> Would there be room for a compromise with e.g. 128 bits?

Yeah, we're good if it's not larger than 256 bits.

> 
> > Users can choose sha256 from mkfs.btrfs via
> > 
> > $ mkfs.btrfs -C 256 /device
> 
> Not sure how others feel about this, but it's probably easier for
> sysadmins to specify the algorithm by name from the set of supported
> ones, similar to how ssh does it ("ssh -C arcfour256").

Urr, my bad, I've made it locally but didn't 'git add' them.

thanks,
-liubo
