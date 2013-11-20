Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:55750 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020Ab3KTKWV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Nov 2013 05:22:21 -0500
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: Chris Murphy <lists@colorremedies.com>
Subject: Re: Actual effect of mkfs.btrfs -m raid10 </dev/sdX> ... -d raid10 </dev/sdX> ...
Date: Wed, 20 Nov 2013 21:22:18 +1100
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAEWPe=pwpxdYUDk7BzfjR8h-Jq9wtQE+gxxQChjOZzsXJO4vHQ@mail.gmail.com> <l6hl6b$i5h$1@ger.gmane.org> <29AD6F50-2D7B-416C-AA69-0EC8D46E8BB8@colorremedies.com>
In-Reply-To: <29AD6F50-2D7B-416C-AA69-0EC8D46E8BB8@colorremedies.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201311202122.18712.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 20 Nov 2013, Chris Murphy <lists@colorremedies.com> wrote:
> Hot spares are worse than useless. Especially for raid10. The drive takes
> up space doing nothing but suck power, rather than adding space or
> performance. Somehow this idea comes from cheap companies who seem to
> think their data is so valuable they need hot spares, yet they don't have
> 24/7 staff on hand to do a hot swap. (As if the only problem that can
> occur is a dead drive.) So I think those companies can develop this
> otherwise unneeded feature.
> 
> n-copies raid1 is a good idea and I think it's being worked on.

N copies RAID-1 is definitely more useful than RAID-1 with a hot-spare.

But for RAID-5/RAID-6 a hot spare can provide real value.  Not having to pay 
someone to make a special rushed visit to replace a disk is a definite 
benefit.

Also when a disk isn't being used it doesn't draw much power.  Last time I 
tested such things I found an IDE disk to use about 7W while spinning and no 
measurable difference to overall system power use when spun-down.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
