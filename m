Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:60442 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753556AbaACAK7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Jan 2014 19:10:59 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Managing large volumes
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAAKzf7kB90qOG8yNuLUyfd2w61kVeeo+d+vs=ecURYqm=rjxgg@mail.gmail.com>
Date: Thu, 2 Jan 2014 17:10:58 -0700
Cc: linux-btrfs@vger.kernel.org
Message-Id: <4B68831B-80BA-4CBA-96D9-DD617D673777@colorremedies.com>
References: <CAAKzf7kB90qOG8yNuLUyfd2w61kVeeo+d+vs=ecURYqm=rjxgg@mail.gmail.com>
To: Tim Cuthbertson <ratcheer@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 2, 2014, at 3:28 PM, Tim Cuthbertson <ratcheer@gmail.com> wrote:
> 
> Am am at a point where I would like to do a fresh install of my OS
> without losing my home and data contents. And I do not think separate
> btrfs subvolumes will help me on that. Is that correct? Is there a way
> to prevent an OS installation from formatting the /home and /data
> subvolumes while completely replacing the root subvolume? Or do I need
> to completely repartition my drives so I don't get into this
> situation, again?

That's up to the installer. e.g. the Fedora installer requires a new subvolume for rootfs which can be either a new or existing Btrfs volume. Existing subvolumes for /home or /data can simply be assigned mountpoints, and behind the scene all that's really happening is an entry is made for them in fstab. So at least in the case of Fedora, it's even possible to install onto an existing Btrfs volume without replacing the prior rootfs until later if you wish. You aren't required to delete it, you only required to make a new one. I'm uncertain how Debian implements this in their installer.


Chris Murphy