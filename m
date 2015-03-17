Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:58004 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbbCQWAE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Mar 2015 18:00:04 -0400
Message-ID: <1426629600.26870.15.camel@ayida>
Subject: Re: Is it safe or useful to use NOCOW flag and autodefrag mount
 option at same time?
From: Jean-Peer Lorenz <peer.loz@gmx.net>
To: russell@coker.com.au
Cc: linux-btrfs@vger.kernel.org
Date: Tue, 17 Mar 2015 23:00:00 +0100
In-Reply-To: <201503162246.12052.russell@coker.com.au>
References: <trinity-2997a6a9-13e0-4df6-ae13-0d944bd2f0b1-1426358188246@3capp-gmx-bs46>
	 <201503162246.12052.russell@coker.com.au>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Montag, den 16.03.2015, 22:46 +1100 schrieb Russell Coker:
> On Sun, 15 Mar 2015, peer.loz@gmx.net wrote:
> > Following common recommendations [1], I use these mount options on my
> > main developing machine: noatime,autodefrag. This is desktop machine and
> > it works well so far. Now, I'm also going to install several KVM virtual
> > machines on this system. I want to use qcow2 files stored on SSD with a
> > btrfs on it. In order to avoid bad performance with the VMs, I want to
> > disable the Copy-On-Write mechanism on the storage directory of my VM
> > images as for example described in [2].
> 
> Why do you expect a great performance benefit from that?
> 
> As there is no real seek time SSDs probably won't give you much benefit from 
> defragmenting.  As for disabling CoW, that will reduce the number of writes 
> (as you don't need to write the metadata all the way up the tree) and improve 
> performance, but not as much as on spinning media where you need to do seeks 
> for all that.
> 
> Finally having checksums on everything to give the possibility of recognising 
> corrupt data is a really good feature and something that you want on your VM 
> images.
> 
> So far I have never even tried disabling CoW or using auto defragment.  All of 
> my BTRFS filesystems have either low performance or run on SSD.
> 
Thanks for your reply.

Maybe performance wasn't the right wording. My concern is not only about
speed. Rather, my impression is that even on SSDs fragmentation can
cause problems due to limitations in IOPs and CPU, as for example stated
here [1] (... causing ... excessive multi-second spikes of CPU load on
systems with an SSD ...) and here [2]. This is in particular true for
vm images with several GiB of size ([3], [4]). Since vm images (qcow2?)
do their own checksumming it is considered ok to turn CoW of to reduce
the problems with these files.

As you see, I'm still a bit lost what the best setup would be?
Thanks.


[1] https://btrfs.wiki.kernel.org/index.php/Gotchas 
[2] http://www.spinics.net/lists/linux-btrfs/msg41833.html
[3] http://www.spinics.net/lists/linux-btrfs/msg41049.html
[4] https://bugzilla.redhat.com/show_bug.cgi?id=689127



