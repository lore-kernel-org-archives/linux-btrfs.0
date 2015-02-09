Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from asuka.romanrm.net ([128.199.122.184]:44925 "EHLO
	asuka.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759454AbbBIGrE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Feb 2015 01:47:04 -0500
Date: Mon, 9 Feb 2015 11:40:23 +0500
From: Roman Mamedov <rm@romanrm.net>
To: "Devon B." <devon.b@virtualcomplete.com>, linux-btrfs@vger.kernel.org
Subject: Re: Accepting discard to free space from disk images
Message-ID: <20150209114023.137402bf@natsu>
In-Reply-To: <54D842FD.1010806@virtualcomplete.com>
References: <54D842FD.1010806@virtualcomplete.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 09 Feb 2015 00:17:49 -0500
"Devon B." <devon.b@virtualcomplete.com> wrote:

> Looking to use btrfs with disk images that contain ext4, xfs, and other
> possible filesystems.  One of my main concerns is reclaiming disk space
> when files are deleted on the disk image's filesystem.  Using fstrim on
> the mount point of the disk image or mounting the disk image (loop) with
> discard doesn't appear to pass the freed blocks to btrfs.
> 
> The image file on the btrfs filesystem just keeps growing in size.  When
> hosting images on ext4, using fstrim or discard frees up the space on
> the host filesystem (ext4).
> 
> I see discard is pretty well supported for btrfs to the underlying block
> devices but is there any way to properly free space on the btrfs host
> filesystem from overlying filesystems while they are online?

I use KVM (QEMU) with discard pass-through from the VM guest ("discard=unmap"
option), with the VM images stored on Btrfs. It works just fine, the disk
space used for the image file does shrink when the guest OS issues discards on
its FS. Maybe there is a difference in how KVM and the 'loop' module submit
discards to Btrfs?

-- 
With respect,
Roman
