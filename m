Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:48980 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753522AbaA3Vv0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Jan 2014 16:51:26 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Stop using btrfs
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20140130214333.GA18327@carfax.org.uk>
Date: Thu, 30 Jan 2014 14:51:24 -0700
Cc: "Maziarz, Jeremy M." <jmaziarz@mitre.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-Id: <0808BEA2-5BED-467B-B3F4-53EBBB7CD1DC@colorremedies.com>
References: <CC0E5F0A-26F9-46B9-9C24-1DDD1FF72004@mitre.org> <20140130214333.GA18327@carfax.org.uk>
To: Hugo Mills <hugo@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 30, 2014, at 2:43 PM, Hugo Mills <hugo@carfax.org.uk> wrote:

> On Thu, Jan 30, 2014 at 09:27:55PM +0000, Maziarz, Jeremy M. wrote:
>> Everyone, here is a noob question: how do completely delete a btrfs filesystem (RAID10)?
> 
>   wipefs, on each device, is the precision approach -- it will very
> carefully damage the magic number in the first superblock on each
> device, which is enough to make most tools ignore the filesystem.
> 
>   Alternatively, the nuclear approach is simply to overwrite the
> first megabyte or so of the filesystem with zeros, with something like:
> 
> dd count=1k bs=1k if=/dev/zero of=/dev/sda

Yes with the older btrfs-progs, it indicates maybe equally old linux-utils so wipefs -a might not be up to date to delete all of the super block magics. It's worth knowing especially because mkfs.ext4 resurrects the latent btrfs back to life if the wipefs -a doesn't remove all super blocks.

Also fwiw, it's possible to use wipefs -a /dev/sd[abcd] in a single command for all drives.


Chris Murphy

