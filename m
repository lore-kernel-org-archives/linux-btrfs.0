Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39681 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752065AbbJLNGE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Oct 2015 09:06:04 -0400
Date: Mon, 12 Oct 2015 15:04:54 +0200
From: David Sterba <dsterba@suse.cz>
To: "Wang, Zhiye" <Zhiye.Wang@Arcserve.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Questions about FIEMAP
Message-ID: <20151012130454.GD27761@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CY1PR10MB04283CC6BA7D9AE8F3F0B984E4310@CY1PR10MB0428.namprd10.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CY1PR10MB04283CC6BA7D9AE8F3F0B984E4310@CY1PR10MB0428.namprd10.prod.outlook.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 12, 2015 at 04:37:55AM +0000, Wang, Zhiye wrote:
> After googled a bit, I got information that btrfs supports FIEMAP (as
> "cp" needs it), but it's not valid for "write" operation.

The FIEMAP output is informative, there's no guarantee that the extent
information does not change before it reaches the caller.

> I guess we cannot write to block device directly after get block list
> using FIEMAP.

Beware that there's another layer of translation that maps the logical
offsets to physical offsets, basically the RAID layer. So even if you
get 'physical offset' from FIEMAP, it's still the 'logical' offset from
the POV of the filesytem and has no correspondence to the block device
offset.

> This is because:
> 
> 1. COW feature of btrfs (but this can be disabled using NOCOW)
> 2. File system rebalance
> 3. Defragmentation

This always reflects the 'logical' offset from the filesystem POV.
