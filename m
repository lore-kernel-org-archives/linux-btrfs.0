Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f48.google.com ([209.85.160.48]:62865 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757453Ab3E2AiS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 May 2013 20:38:18 -0400
Received: by mail-pb0-f48.google.com with SMTP id md12so8493445pbc.35
        for <linux-btrfs@vger.kernel.org>; Tue, 28 May 2013 17:38:17 -0700 (PDT)
Date: Tue, 28 May 2013 17:38:15 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH v1 0/5] BTRFS hot relocation support
Message-ID: <20130529003815.GE2291@google.com>
References: <1369062687-23544-1-git-send-email-zwu.kernel@gmail.com>
 <pan$d5913$460afe14$f9be182d$7f8dbe54@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$d5913$460afe14$f9be182d$7f8dbe54@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 21, 2013 at 02:22:34AM +0000, Duncan wrote:
> zwu.kernel posted on Mon, 20 May 2013 23:11:22 +0800 as excerpted:
> 
> > The patchset is trying to introduce hot relocation support
> > for BTRFS. In hybrid storage environment, when the data in rotating disk
> > get hot, it can be relocated to nonrotating disk by BTRFS hot relocation
> > support automatically; also, if nonrotating disk ratio exceed its upper
> > threshold, the data which get cold can be looked up and relocated to
> > rotating disk to make more space in nonrotating disk at first, and then
> > the data which get hot will be relocated to nonrotating disk
> > automatically.
> 
> One advantage of a filesystem implementation, as opposed to bcache or 
> dmcache, is arguably a corner-case, but it's /my/ corner-case, so...
> 
> I run an intr*-less (I guess technically, empty initramfs) monolithic-
> kernel boot, using the kernel commandline root= and (formerly) md= and 
> related logic to choose/assemble/mount root directly from the kernel 
> command line via bootloader (grub2).  Thus, any user-space-required-to-
> mount-root is out, since I don't have an initr* and thus no early 
> userspace.  That means both lvm2 and dmcache (AFAIK) are out.  I'm not 
> sure about bcache, but it has other negatives, particularly against btrfs-
> raid-1 and I'd guess md/raid-1 as well.
> 
> Much like md before it, btrfs, while normally requiring the user-space-
> required device-scan to properly handle multiple devices, has kernel-
> command-line options that allow direct kernel multi-device assembly 
> without the help of early-userspace/initr*.

I wouldn't be averse to adding such functionality to bcache, provided it
could be done reasonably cleanly/sensibly. It's not high on my list but
I'd accept patches :)
