Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta11.emeryville.ca.mail.comcast.net ([76.96.27.211]:41684
	"EHLO qmta11.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755911Ab3AKWe2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Jan 2013 17:34:28 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: partition question
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <50F06639.6030409@home.nl>
Date: Fri, 11 Jan 2013 15:34:25 -0700
Message-Id: <818D716E-CEFF-4170-B470-574D6E98375E@colorremedies.com>
References: <50F06639.6030409@home.nl>
To: linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 11, 2013, at 12:21 PM, Roelof Wobben <r.wobben@home.nl> wrote:

> Hello,
> 
> I have one thing I think I don't really understand about btrfs,
> 
> Normally if I use ext4 I make a  3 partitions for my distro.
> 
> one for boot about 1G
> one for home about 30G
> one for root for the rest of my 100G.
> 
> Now I wonder if I want to do the same with btrfs.
> 
> Can I do the same so make 3 partitions with btrfs or can I better make 1 partiton of 100G and make the /boot /home and  / subvolumes of the big partitiion.
> 
> Can one of you btfrs gurus shine a light of this matter ?

You can make one Btrfs volume with /boot, /home, and / as subvolumes. GRUB2 2.00 can boot this arrangement, and that's the first caveat which is that many distributions are using older versions of GRUB2. It even works with Btrfs data/metadata profiles single, dup; and multiple device raid 0, 1, 10; and compression zlib, and lzo.

Swap still needs to be on a separate partition, as I don't think Btrfs is supporting swapfiles yet still, but maybe someone else can comment on the status of that.

While GRUB2 has LUKS support, its easier to have /boot on a separate partition for such purposes.

The limiting factor is an installer that doesn't offer the unified option, and also won't install to a pre-configured Btrfs volume.  I can vouch for Fedora 18, which can do both. That is, it will install to an existing Btrfs volume either reusing or creating subvols for home, boot, usr, var; and it will compel you to create a new subvol for root. Further, it can create new Btrfs volumes. By default with the non-custom partition path, it will put /boot on ext4. If you choose BTRFS in Installation Options > Partition scheme configuration *before* you get to custom partitioning (the screen labeled Manual Partitioning), you will be able to add a Boot mountpoint and change it from ext4 to Btrfs, and set the size however large you want. Any additional mount points other than swap will be created as subvolumes.

Chris Murphy