Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:53876 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412Ab2LCQI4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 3 Dec 2012 11:08:56 -0500
Date: Mon, 3 Dec 2012 11:08:53 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Chris Murphy <lists@colorremedies.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: 64KB "boot sector" gap
Message-ID: <20121203160853.GI30633@shiny>
References: <B41E960E-A16B-4856-AFFE-FC5C99DDC7D5@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <B41E960E-A16B-4856-AFFE-FC5C99DDC7D5@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 03, 2012 at 12:34:06AM -0700, Chris Murphy wrote:
> When creating a btrfs volume with mkfs.btrfs, I'm noticing that the
> first 64KB are completely blank. Is this gap expressly intended for
> installing a boot manager/loader? e.g. GRUB 2 allows installation of
> boot.img + core.img into a btrfs formatted partition, without using
> block lists (the --force flag). It appears to produce a bootable
> system.
> 

Right, I wanted to leave room for bootloaders.  I actually would have
used a larger offset, but the other filesystem mkfs commands don't zero
very far into the drive.  I had to make sure that mkfs.foo would
overwrite the btrfs super, otherwise you might have a stale btrfs
filesystem recognized inside the new filesystem.

> However, the man page says -A, --alloc-start specifies the offset to
> the start of the file system, and that the default is zero. If the
> default is zero, the file system starts immediately, which implies
> those 64KB of zero aren't actually intended for a boot loader.

The alloc start doesn't change the location of the super, just the
preferred location for any blocks we allocate.  The idea was to test
huge drives without having to fill them with data.

-chris
