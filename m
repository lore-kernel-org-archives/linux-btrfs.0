Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:38993 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830Ab3BUAtv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Feb 2013 19:49:51 -0500
Received: by mail-qc0-f174.google.com with SMTP id z24so3326889qcq.19
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Feb 2013 16:49:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130220164605.GA13504@uflip.org>
References: <20130220164605.GA13504@uflip.org>
Date: Thu, 21 Feb 2013 11:49:50 +1100
Message-ID: <CA+WRLO8ESSq6NrHOvUTQ3Sm+4RyBmSoU+PZ1wnqxwQBgG04=Tw@mail.gmail.com>
Subject: Re: Hybrid Storage proposal
From: Gareth Pye <gareth@cerberos.id.au>
To: Matias Bjorling <mabj@itu.dk>
Cc: jmad@itu.dk, linux-btrfs <linux-btrfs@vger.kernel.org>,
        Chris Mason <chris.mason@fusionio.com>, dsterba@suse.cz
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 21, 2013 at 3:46 AM, Matias Bjorling <mabj@itu.dk> wrote:
> Recent development in Linux SSD caches, uses a block IO approach to solve
> caching. The approach assumes that data is stable on disk and evicts data based
> on LRU, temparature, etc. This is great for read only IO patterns and in-place
> writes. However, btrfs uses a copy on write approach, that reduces the benefits
> of block IO caching. The block caches are unable to track updates (require
> extensive hints forth and back between the cache layer). Additionally, data and
> metadata is the same to the block layer.


Another great reason for this to be implemented in btrfs is that
knowledge of redundancy can be applied. Chunks that are mirrored
should be unlikely to need both copies on SSD devices unless they are
very highly used (probably true for some of the meta data but not for
data).

Conversely there is little benefit to putting one stripe of a
raid0/5/6 into the SSD device without the rest of that data reaching
the same level.

Not that additional reasons to do this work in btrfs were needed it
does need to be thought about how this implementation interacts with
those features.

-- 
Gareth Pye
Level 2 Judge, Melbourne, Australia
Australian MTG Forum: mtgau.com
gareth@cerberos.id.au - www.rockpaperdynamite.wordpress.com
"Dear God, I would like to file a bug report"
