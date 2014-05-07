Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:37629 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932086AbaEGJBJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 May 2014 05:01:09 -0400
Date: Wed, 7 May 2014 02:01:01 -0700
From: Marc MERLIN <marc@merlins.org>
To: john terragon <jterragon@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs on software RAID0
Message-ID: <20140507090101.GC19238@merlins.org>
References: <CANg_oxxFKHioyWO0ct7vcT=aTbX11KbCKtGwvZo_59jirLDGow@mail.gmail.com>
 <20140505212513.GS10159@merlins.org>
 <CANg_oxw_qy154eiRw9zdsCUwR1JTOGsUEa=VWq-7RM=nsATU3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CANg_oxw_qy154eiRw9zdsCUwR1JTOGsUEa=VWq-7RM=nsATU3g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 06, 2014 at 09:02:46AM +0200, john terragon wrote:
> just one last doubt:
> 
> why do you use --align-payload=1024? (or 8912)
> Cryptsetup man says that the default for the payload alignment is 2048
> (512-byte sectors). So, it's already aligned by default to 4K-byte
> physical sectors (if that was your concern). Am I missing something?

With 4K sectors, I agree that 2048 would be better.

What I was trying to do there is avoid write amplification.

After reading 
http://wiki.drewhess.com/wiki/Creating_an_encrypted_filesystem_on_a_partition
I went with
mdadm --create /dev/md8 --level=5 --raid-devices=5 /dev/sd[abdef]1 --chunk=256 --bitmap=/boot/bitmap-md8
which I believe required me to use
cryptsetup luksFormat --align-payload=1024 -s 256 -c aes-xts-plain64  /dev/md8
(that was with 5 drives, or 4 drives with data).

Would agree with the math?

If so, for 4K sector sizes, if we have to use align-payload=1024, in
turn I'd have to use --chunk=512. 
Does that sound right?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
