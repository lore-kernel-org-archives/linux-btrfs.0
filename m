Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cc-smtpout2.netcologne.de ([89.1.8.212]:46916 "EHLO
	cc-smtpout2.netcologne.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbaDZSSc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Apr 2014 14:18:32 -0400
Date: Sat, 26 Apr 2014 20:18:27 +0200
From: Stefan Malte Schumacher <s.schumacher@netcologne.de>
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: Confusing output of btrfs fi df
Message-ID: <20140426181827.GA14687@mars>
References: <20140426140915.GA12958@mars>
 <20140426143023.GK2391@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140426143023.GK2391@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> 
>    They're harmless -- it's a side-effect of the way that mkfs works.
> They'll go away if you balance them:
> 
>    btrfs balance start -dprofiles=single -mprofiles=single -sprofiles=single /mountpoint

btrfs refused this command, I had to pass --force to execute it.
It exited with this:Done, had to relocate 2 out of 2710 chunks.

After that btrfs fi df shows the following:

 Data, RAID1: total=2.64TiB, used=2.22TiB
 System, RAID1: total=8.00MiB, used=380.00KiB
>System, single: total=4.00MiB, used=0.00<
 Metadata, RAID1: total=4.00GiB, used=2.94GiB

 
>    btrfs fi label should do this.

I was mainly asking because of this:
https://btrfs.wiki.kernel.org/index.php/UseCases: You can also use
btrfs command.There are currently few limitations: the filesystem has
to be unmounted the filesystem should not have more than one device 

Is this information outdated?

> You might want to look at upgrading to 3.13 or 3.14 kernel, which
> has 6 months or so extra bug fixes in it.

Thanks, going to have a look if openSUSE has anything more recent in
their repositories.

Bye
Stefan

