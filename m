Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from k4.imagmbh.de ([212.23.155.244]:57007 "EHLO k4.imagmbh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248AbbDFTIW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 Apr 2015 15:08:22 -0400
From: Martin <develop@imagmbh.de>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: recover corrupt BTRFS
Date: Mon, 06 Apr 2015 21:08:15 +0200
Message-ID: <2290805.G7iFbWqiA5@term0>
In-Reply-To: <CAJCQCtRLN8_Qe+0Hh0o-NCoc7KFWMu_wWbP8fObB3hq_xNgoFw@mail.gmail.com>
References: <10997785.A11jaNpIP8@malu-aspire-v3-771> <CAJCQCtRLN8_Qe+0Hh0o-NCoc7KFWMu_wWbP8fObB3hq_xNgoFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Montag, 6. April 2015, 09:45:10 schrieb Chris Murphy:
> On Mon, Apr 6, 2015 at 5:40 AM, Martin <develop@imagmbh.de> wrote:
> > Hello!
> > 
> > I have to recover a corrupt btrfs. The size is approx 4.5 TB. The fs
> > became
> > corrupt by failure of a hardware-raid.
> 
> What raid level? What kind of failure? What is the current raid
> status? What was the mkfs.btrfs command used to create the file system
> OR what is the current profile used for data and metadata?

Hello Chris,

it was a hardware-RAID (3ware-Controller), RAID-5. There was a failure of 2 of 
6 disks. Because only one disk was physically damaged, I could "dd" the RAID 
to a new big disk with the help of 3Ware/Avago.

The stack was: hardware-raid --- Linux LVM --- btrfs. The metadata-profile was 
the default for a single drive, so it should be "dup".

Martin

