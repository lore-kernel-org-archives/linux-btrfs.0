Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:60245 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752976AbdBIU2h (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Feb 2017 15:28:37 -0500
Date: Thu, 9 Feb 2017 21:28:17 +0100
From: Adam Borowski <kilobyte@angband.pl>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PULL] Fix ioctls on 32bit/64bit userspace/kernel, for 4.10
Message-ID: <20170209202817.dp7owh3gxjg7fqcd@angband.pl>
References: <cover.1486571660.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cover.1486571660.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 08, 2017 at 05:51:28PM +0100, David Sterba wrote:
> could you please merge this single-patch pull request, for 4.10 still?  There
> are quite a few patches on top of v4.10-rc7 so this IMHO does not look like
> look too bad even late in the release cycle. Though it's a fix for an uncommon
> usecase of 32bit userspace on 64bit kernel, it fixes basically operation of the
> ioctls. Thanks.

It's not uncommon.  Pretty much every 32-on-64 combination was broken, and
some archs (like mips, both endians) use 32-on-64 on all non-museal hardware.

I've tested that your patch fixes at least:
* x32 on amd64
* armhf on arm64

So big thanks for this fix!


There are other broken ioctls, for example:
/mnt/vol1/b: fiemap error 25: Inappropriate ioctl for device
/mnt/vol1/a: fiemap error 25: Inappropriate ioctl for device
but the last I checked, fiemap doesn't live in fs/btrfs/

Meow!
-- 
Autotools hint: to do a zx-spectrum build on a pdp11 host, type:
  ./configure --host=zx-spectrum --build=pdp11
