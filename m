Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:39886 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbbCPLzV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Mar 2015 07:55:21 -0400
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: peer.loz@gmx.net
Subject: Re: Is it safe or useful to use NOCOW flag and autodefrag mount option at same time?
Date: Mon, 16 Mar 2015 22:46:11 +1100
Cc: linux-btrfs@vger.kernel.org
References: <trinity-2997a6a9-13e0-4df6-ae13-0d944bd2f0b1-1426358188246@3capp-gmx-bs46>
In-Reply-To: <trinity-2997a6a9-13e0-4df6-ae13-0d944bd2f0b1-1426358188246@3capp-gmx-bs46>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201503162246.12052.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 15 Mar 2015, peer.loz@gmx.net wrote:
> Following common recommendations [1], I use these mount options on my
> main developing machine: noatime,autodefrag. This is desktop machine and
> it works well so far. Now, I'm also going to install several KVM virtual
> machines on this system. I want to use qcow2 files stored on SSD with a
> btrfs on it. In order to avoid bad performance with the VMs, I want to
> disable the Copy-On-Write mechanism on the storage directory of my VM
> images as for example described in [2].

Why do you expect a great performance benefit from that?

As there is no real seek time SSDs probably won't give you much benefit from 
defragmenting.  As for disabling CoW, that will reduce the number of writes 
(as you don't need to write the metadata all the way up the tree) and improve 
performance, but not as much as on spinning media where you need to do seeks 
for all that.

Finally having checksums on everything to give the possibility of recognising 
corrupt data is a really good feature and something that you want on your VM 
images.

So far I have never even tried disabling CoW or using auto defragment.  All of 
my BTRFS filesystems have either low performance or run on SSD.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
